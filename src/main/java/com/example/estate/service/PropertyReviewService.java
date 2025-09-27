package com.example.estate.service;

import com.example.estate.dto.PropertyReviewDto;
import com.example.estate.dto.UserDto;
import com.example.estate.model.Property;
import com.example.estate.model.PropertyReview;
import com.example.estate.model.User;
import com.example.estate.repository.PropertyReviewRepository;
import com.example.estate.repository.PropertyRepository;
import com.example.estate.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class PropertyReviewService {
    
    @Autowired
    private PropertyReviewRepository propertyReviewRepository;
    
    @Autowired
    private PropertyRepository propertyRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public PropertyReviewDto createReview(PropertyReviewDto reviewDto, Long propertyId, Long userId) {
        Optional<Property> propertyOpt = propertyRepository.findById(propertyId);
        Optional<User> userOpt = userRepository.findById(userId);
        
        if (propertyOpt.isPresent() && userOpt.isPresent()) {
            Property property = propertyOpt.get();
            User user = userOpt.get();
            
            // Check if user already reviewed this property
            List<PropertyReview> existingReviews = propertyReviewRepository
                    .findByProperty_IdAndUser_Id(propertyId, userId);
            
            if (!existingReviews.isEmpty()) {
                throw new RuntimeException("User has already reviewed this property");
            }
            
            PropertyReview review = new PropertyReview();
            review.setComment(reviewDto.getComment());
            review.setRating(reviewDto.getRating());
            review.setProperty(property);
            review.setUser(user);
            
            PropertyReview savedReview = propertyReviewRepository.save(review);
            return convertToDto(savedReview);
        }
        
        throw new RuntimeException("Property or user not found");
    }
    
    public List<PropertyReviewDto> getReviewsByProperty(Long propertyId) {
        return propertyReviewRepository.findByProperty_Id(propertyId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public Page<PropertyReviewDto> getReviewsByPropertyPaginated(Long propertyId, Pageable pageable) {
        return propertyReviewRepository.findByPropertyIdOrderByCreatedAtDesc(propertyId, pageable)
                .map(this::convertToDto);
    }
    
    public List<PropertyReviewDto> getReviewsByUser(Long userId) {
        return propertyReviewRepository.findByUser_Id(userId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public PropertyReviewDto updateReview(Long reviewId, PropertyReviewDto reviewDto, Long userId) {
        Optional<PropertyReview> reviewOpt = propertyReviewRepository.findById(reviewId);
        
        if (reviewOpt.isPresent()) {
            PropertyReview review = reviewOpt.get();
            
            // Check if user owns this review
            if (!review.getUser().getId().equals(userId)) {
                throw new RuntimeException("User can only update their own reviews");
            }
            
            review.setComment(reviewDto.getComment());
            review.setRating(reviewDto.getRating());
            review.setIsEdited(true);
            
            PropertyReview updatedReview = propertyReviewRepository.save(review);
            return convertToDto(updatedReview);
        }
        
        throw new RuntimeException("Review not found");
    }
    
    public void deleteReview(Long reviewId, Long userId) {
        Optional<PropertyReview> reviewOpt = propertyReviewRepository.findById(reviewId);
        
        if (reviewOpt.isPresent()) {
            PropertyReview review = reviewOpt.get();
            
            // Check if user owns this review
            if (!review.getUser().getId().equals(userId)) {
                throw new RuntimeException("User can only delete their own reviews");
            }
            
            propertyReviewRepository.delete(review);
        } else {
            throw new RuntimeException("Review not found");
        }
    }
    
    public Double getAverageRating(Long propertyId) {
        return propertyReviewRepository.findAverageRatingByPropertyId(propertyId);
    }
    
    public Long getReviewCount(Long propertyId) {
        return propertyReviewRepository.countByPropertyId(propertyId);
    }
    
    public List<PropertyReviewDto> getReviewsByRating(Long propertyId, Integer minRating) {
        return propertyReviewRepository.findByPropertyIdAndMinRating(propertyId, minRating).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public boolean verifyReview(Long reviewId) {
        Optional<PropertyReview> reviewOpt = propertyReviewRepository.findById(reviewId);
        
        if (reviewOpt.isPresent()) {
            PropertyReview review = reviewOpt.get();
            review.setIsVerified(true);
            propertyReviewRepository.save(review);
            return true;
        }
        
        return false;
    }
    
    private PropertyReviewDto convertToDto(PropertyReview review) {
        PropertyReviewDto dto = new PropertyReviewDto();
        dto.setId(review.getId());
        dto.setComment(review.getComment());
        dto.setRating(review.getRating());
        dto.setIsVerified(review.getIsVerified());
        dto.setCreatedAt(review.getCreatedAt());
        dto.setUpdatedAt(review.getUpdatedAt());
        
        // Set user details
        if (review.getUser() != null) {
            UserDto userDto = new UserDto();
            userDto.setId(review.getUser().getId());
            userDto.setFirstName(review.getUser().getFirstName());
            userDto.setLastName(review.getUser().getLastName());
            userDto.setUserType(review.getUser().getUserType());
            userDto.setIsVerified(review.getUser().getIsVerified());
            dto.setUser(userDto);
        }
        
        return dto;
    }
}
