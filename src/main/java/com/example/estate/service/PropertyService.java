package com.example.estate.service;

import com.example.estate.dto.PropertyDto;
import com.example.estate.dto.PropertyImageDto;
import com.example.estate.dto.PropertyReviewDto;
import com.example.estate.dto.UserDto;
import com.example.estate.model.*;
import com.example.estate.repository.PropertyRepository;
import com.example.estate.repository.PropertyImageRepository;
import com.example.estate.repository.PropertyReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class PropertyService {
    
    @Autowired
    private PropertyRepository propertyRepository;
    
    @Autowired
    private PropertyImageRepository propertyImageRepository;
    
    @Autowired
    private PropertyReviewRepository propertyReviewRepository;
    
    @Autowired
    private UserService userService;
    
    public PropertyDto createProperty(PropertyDto propertyDto, Long userId) {
        Property property = new Property();
        property.setTitle(propertyDto.getTitle());
        property.setDescription(propertyDto.getDescription());
        property.setPrice(propertyDto.getPrice());
        property.setPropertyType(propertyDto.getPropertyType());
        property.setListingType(propertyDto.getListingType());
        property.setPropertyStatus(PropertyStatus.AVAILABLE);
        property.setAddress(propertyDto.getAddress());
        property.setCity(propertyDto.getCity());
        property.setState(propertyDto.getState());
        property.setPostalCode(propertyDto.getPostalCode());
        property.setLatitude(propertyDto.getLatitude());
        property.setLongitude(propertyDto.getLongitude());
        property.setBedrooms(propertyDto.getBedrooms());
        property.setBathrooms(propertyDto.getBathrooms());
        property.setSquareFeet(propertyDto.getSquareFeet());
        property.setLotSize(propertyDto.getLotSize());
        property.setYearBuilt(propertyDto.getYearBuilt());
        property.setParkingSpaces(propertyDto.getParkingSpaces());
        property.setIsFurnished(propertyDto.getIsFurnished());
        property.setIsPetFriendly(propertyDto.getIsPetFriendly());
        property.setHasPool(propertyDto.getHasPool());
        property.setHasGarden(propertyDto.getHasGarden());
        property.setHasGym(propertyDto.getHasGym());
        property.setHasSecurity(propertyDto.getHasSecurity());
        
        // Set verification status - new properties are verified by default
        property.setIsVerified(true);
        
        // Set user
        User user = new User();
        user.setId(userId);
        property.setUser(user);
        
        Property savedProperty = propertyRepository.save(property);
        
        // Handle images if provided
        if (propertyDto.getImages() != null && !propertyDto.getImages().isEmpty()) {
            for (PropertyImageDto imageDto : propertyDto.getImages()) {
                PropertyImage propertyImage = new PropertyImage();
                propertyImage.setImageUrl(imageDto.getImageUrl());
                propertyImage.setImageCaption(imageDto.getImageCaption());
                propertyImage.setIsPrimary(imageDto.getIsPrimary());
                propertyImage.setSortOrder(imageDto.getSortOrder());
                propertyImage.setProperty(savedProperty);
                propertyImageRepository.save(propertyImage);
            }
        }
        
        return convertToDto(savedProperty);
    }
    
    public Optional<PropertyDto> getPropertyById(Long id) {
        return propertyRepository.findById(id)
                .map(this::convertToDto);
    }
    
    public Page<PropertyDto> getAllProperties(Pageable pageable) {
        return propertyRepository.findAvailableVerifiedProperties(pageable)
                .map(this::convertToDto);
    }
    
    public List<PropertyDto> getPropertiesByUser(Long userId) {
        return propertyRepository.findByUser_Id(userId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyDto> getPropertiesByType(PropertyType propertyType) {
        return propertyRepository.findByPropertyType(propertyType).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyDto> getPropertiesByListingType(ListingType listingType) {
        return propertyRepository.findByListingType(listingType).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyDto> getPropertiesByCity(String city) {
        return propertyRepository.findByCity(city).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyDto> getPropertiesByState(String state) {
        return propertyRepository.findByState(state).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyDto> getFeaturedProperties() {
        return propertyRepository.findFeaturedAvailableProperties().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyDto> searchProperties(String keyword) {
        return propertyRepository.findByKeyword(keyword).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public Page<PropertyDto> searchPropertiesWithFilters(BigDecimal minPrice, BigDecimal maxPrice, 
                                                        String city, String state, 
                                                        PropertyType propertyType, ListingType listingType,
                                                        Integer minBedrooms, Integer maxBedrooms,
                                                        Integer minBathrooms, Integer maxBathrooms,
                                                        Pageable pageable) {
        return propertyRepository.findPropertiesWithFilters(minPrice, maxPrice, city, pageable)
                .map(this::convertToDto);
    }
    
    public Page<PropertyDto> getLatestProperties(Pageable pageable) {
        return propertyRepository.findLatestAvailableProperties(pageable)
                .map(this::convertToDto);
    }
    
    public Page<PropertyDto> getMostViewedProperties(Pageable pageable) {
        return propertyRepository.findMostViewedProperties(pageable)
                .map(this::convertToDto);
    }
    
    public Page<PropertyDto> getMostLikedProperties(Pageable pageable) {
        return propertyRepository.findMostLikedProperties(pageable)
                .map(this::convertToDto);
    }
    
    public PropertyDto updateProperty(Long id, PropertyDto propertyDto) {
        Property property = propertyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Property not found with id: " + id));
        
        property.setTitle(propertyDto.getTitle());
        property.setDescription(propertyDto.getDescription());
        property.setPrice(propertyDto.getPrice());
        property.setPropertyType(propertyDto.getPropertyType());
        property.setListingType(propertyDto.getListingType());
        property.setAddress(propertyDto.getAddress());
        property.setCity(propertyDto.getCity());
        property.setState(propertyDto.getState());
        property.setPostalCode(propertyDto.getPostalCode());
        property.setLatitude(propertyDto.getLatitude());
        property.setLongitude(propertyDto.getLongitude());
        property.setBedrooms(propertyDto.getBedrooms());
        property.setBathrooms(propertyDto.getBathrooms());
        property.setSquareFeet(propertyDto.getSquareFeet());
        property.setLotSize(propertyDto.getLotSize());
        property.setYearBuilt(propertyDto.getYearBuilt());
        property.setParkingSpaces(propertyDto.getParkingSpaces());
        property.setIsFurnished(propertyDto.getIsFurnished());
        property.setIsPetFriendly(propertyDto.getIsPetFriendly());
        property.setHasPool(propertyDto.getHasPool());
        property.setHasGarden(propertyDto.getHasGarden());
        property.setHasGym(propertyDto.getHasGym());
        property.setHasSecurity(propertyDto.getHasSecurity());
        
        Property updatedProperty = propertyRepository.save(property);
        return convertToDto(updatedProperty);
    }
    
    public void deleteProperty(Long id) {
        propertyRepository.deleteById(id);
    }
    
    public boolean verifyProperty(Long id) {
        Optional<Property> propertyOpt = propertyRepository.findById(id);
        if (propertyOpt.isPresent()) {
            Property property = propertyOpt.get();
            property.setIsVerified(true);
            propertyRepository.save(property);
            return true;
        }
        return false;
    }
    
    public int verifyAllUnverifiedProperties() {
        List<Property> unverifiedProperties = propertyRepository.findByIsVerified(false);
        for (Property property : unverifiedProperties) {
            property.setIsVerified(true);
            propertyRepository.save(property);
        }
        return unverifiedProperties.size();
    }
    
    public boolean featureProperty(Long id) {
        Optional<Property> propertyOpt = propertyRepository.findById(id);
        if (propertyOpt.isPresent()) {
            Property property = propertyOpt.get();
            property.setIsFeatured(true);
            propertyRepository.save(property);
            return true;
        }
        return false;
    }
    
    public void incrementViewCount(Long id) {
        Optional<Property> propertyOpt = propertyRepository.findById(id);
        if (propertyOpt.isPresent()) {
            Property property = propertyOpt.get();
            property.incrementViewCount();
            propertyRepository.save(property);
        }
    }
    
    public Long getPropertyCountByUser(Long userId) {
        return propertyRepository.countByUserId(userId);
    }
    
    public Long getAvailablePropertyCount() {
        return propertyRepository.countAvailableProperties();
    }
    
    public Long getVerifiedPropertyCount() {
        return propertyRepository.countVerifiedProperties();
    }
    
    private PropertyDto convertToDto(Property property) {
        PropertyDto dto = new PropertyDto();
        dto.setId(property.getId());
        dto.setTitle(property.getTitle());
        dto.setDescription(property.getDescription());
        dto.setPrice(property.getPrice());
        dto.setPropertyType(property.getPropertyType());
        dto.setListingType(property.getListingType());
        dto.setPropertyStatus(property.getPropertyStatus());
        dto.setAddress(property.getAddress());
        dto.setCity(property.getCity());
        dto.setState(property.getState());
        dto.setPostalCode(property.getPostalCode());
        dto.setLatitude(property.getLatitude());
        dto.setLongitude(property.getLongitude());
        dto.setBedrooms(property.getBedrooms());
        dto.setBathrooms(property.getBathrooms());
        dto.setSquareFeet(property.getSquareFeet());
        dto.setLotSize(property.getLotSize());
        dto.setYearBuilt(property.getYearBuilt());
        dto.setParkingSpaces(property.getParkingSpaces());
        dto.setIsFurnished(property.getIsFurnished());
        dto.setIsPetFriendly(property.getIsPetFriendly());
        dto.setHasPool(property.getHasPool());
        dto.setHasGarden(property.getHasGarden());
        dto.setHasGym(property.getHasGym());
        dto.setHasSecurity(property.getHasSecurity());
        dto.setIsVerified(property.getIsVerified());
        dto.setIsFeatured(property.getIsFeatured());
        dto.setViewCount(property.getViewCount());
        dto.setLikeCount(property.getLikeCount());
        dto.setCreatedAt(property.getCreatedAt());
        dto.setUpdatedAt(property.getUpdatedAt());
        
        // Set user
        if (property.getUser() != null) {
            UserDto userDto = new UserDto();
            userDto.setId(property.getUser().getId());
            userDto.setFirstName(property.getUser().getFirstName());
            userDto.setLastName(property.getUser().getLastName());
            userDto.setEmail(property.getUser().getEmail());
            userDto.setUserType(property.getUser().getUserType());
            userDto.setIsVerified(property.getUser().getIsVerified());
            dto.setUser(userDto);
        }
        
        // Set images
        if (property.getImages() != null) {
            List<PropertyImageDto> imageDtos = property.getImages().stream()
                    .map(this::convertImageToDto)
                    .collect(Collectors.toList());
            dto.setImages(imageDtos);
        }
        
        // Set reviews and calculate average rating
        if (property.getReviews() != null) {
            List<PropertyReviewDto> reviewDtos = property.getReviews().stream()
                    .map(this::convertReviewToDto)
                    .collect(Collectors.toList());
            dto.setReviews(reviewDtos);
            
            // Calculate average rating
            Double averageRating = propertyReviewRepository.findAverageRatingByPropertyId(property.getId());
            dto.setAverageRating(averageRating);
            dto.setReviewCount((long) reviewDtos.size());
        }
        
        return dto;
    }
    
    private PropertyImageDto convertImageToDto(PropertyImage image) {
        PropertyImageDto dto = new PropertyImageDto();
        dto.setId(image.getId());
        dto.setImageUrl(image.getImageUrl());
        dto.setImageCaption(image.getImageCaption());
        dto.setIsPrimary(image.getIsPrimary());
        dto.setSortOrder(image.getSortOrder());
        dto.setCreatedAt(image.getCreatedAt());
        return dto;
    }
    
    private PropertyReviewDto convertReviewToDto(PropertyReview review) {
        PropertyReviewDto dto = new PropertyReviewDto();
        dto.setId(review.getId());
        dto.setComment(review.getComment());
        dto.setRating(review.getRating());
        dto.setIsVerified(review.getIsVerified());
        dto.setCreatedAt(review.getCreatedAt());
        dto.setUpdatedAt(review.getUpdatedAt());
        
        if (review.getUser() != null) {
            UserDto userDto = new UserDto();
            userDto.setId(review.getUser().getId());
            userDto.setFirstName(review.getUser().getFirstName());
            userDto.setLastName(review.getUser().getLastName());
            userDto.setUserType(review.getUser().getUserType());
            dto.setUser(userDto);
        }
        
        return dto;
    }
}
