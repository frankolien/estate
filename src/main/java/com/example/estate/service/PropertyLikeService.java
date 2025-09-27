package com.example.estate.service;

import com.example.estate.model.Property;
import com.example.estate.model.PropertyLike;
import com.example.estate.model.User;
import com.example.estate.repository.PropertyLikeRepository;
import com.example.estate.repository.PropertyRepository;
import com.example.estate.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class PropertyLikeService {
    
    @Autowired
    private PropertyLikeRepository propertyLikeRepository;
    
    @Autowired
    private PropertyRepository propertyRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public boolean likeProperty(Long propertyId, Long userId) {
        // Check if already liked
        if (propertyLikeRepository.existsByUser_IdAndProperty_Id(userId, propertyId)) {
            return false; // Already liked
        }
        
        // Get property and user
        Optional<Property> propertyOpt = propertyRepository.findById(propertyId);
        Optional<User> userOpt = userRepository.findById(userId);
        
        if (propertyOpt.isPresent() && userOpt.isPresent()) {
            Property property = propertyOpt.get();
            User user = userOpt.get();
            
            // Create like
            PropertyLike like = new PropertyLike(user, property);
            propertyLikeRepository.save(like);
            
            // Update property like count
            property.incrementLikeCount();
            propertyRepository.save(property);
            
            return true;
        }
        
        return false;
    }
    
    public boolean unlikeProperty(Long propertyId, Long userId) {
        Optional<PropertyLike> likeOpt = propertyLikeRepository.findByUser_IdAndProperty_Id(userId, propertyId);
        
        if (likeOpt.isPresent()) {
            PropertyLike like = likeOpt.get();
            propertyLikeRepository.delete(like);
            
            // Update property like count
            Optional<Property> propertyOpt = propertyRepository.findById(propertyId);
            if (propertyOpt.isPresent()) {
                Property property = propertyOpt.get();
                property.decrementLikeCount();
                propertyRepository.save(property);
            }
            
            return true;
        }
        
        return false;
    }
    
    public boolean isPropertyLikedByUser(Long propertyId, Long userId) {
        return propertyLikeRepository.existsByUser_IdAndProperty_Id(userId, propertyId);
    }
    
    public Long getPropertyLikeCount(Long propertyId) {
        return propertyLikeRepository.countByPropertyId(propertyId);
    }
    
    public List<Long> getLikedPropertyIdsByUser(Long userId) {
        return propertyLikeRepository.findPropertyIdsByUserId(userId);
    }
    
    public List<Long> getUserIdsWhoLikedProperty(Long propertyId) {
        return propertyLikeRepository.findUserIdsByPropertyId(propertyId);
    }
}
