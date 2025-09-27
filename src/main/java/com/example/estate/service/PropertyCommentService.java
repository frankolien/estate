package com.example.estate.service;

import com.example.estate.dto.PropertyCommentDto;
import com.example.estate.dto.UserDto;
import com.example.estate.model.Property;
import com.example.estate.model.PropertyComment;
import com.example.estate.model.User;
import com.example.estate.repository.PropertyCommentRepository;
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
public class PropertyCommentService {
    
    @Autowired
    private PropertyCommentRepository propertyCommentRepository;
    
    @Autowired
    private PropertyRepository propertyRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public PropertyCommentDto createComment(PropertyCommentDto commentDto, Long propertyId, Long userId) {
        Optional<Property> propertyOpt = propertyRepository.findById(propertyId);
        Optional<User> userOpt = userRepository.findById(userId);
        
        if (propertyOpt.isPresent() && userOpt.isPresent()) {
            Property property = propertyOpt.get();
            User user = userOpt.get();
            
            PropertyComment comment = new PropertyComment();
            comment.setContent(commentDto.getContent());
            comment.setProperty(property);
            comment.setUser(user);
            
            // Set parent comment if provided
            if (commentDto.getParentCommentId() != null) {
                Optional<PropertyComment> parentCommentOpt = propertyCommentRepository.findById(commentDto.getParentCommentId());
                if (parentCommentOpt.isPresent()) {
                    comment.setParentComment(parentCommentOpt.get());
                }
            }
            
            PropertyComment savedComment = propertyCommentRepository.save(comment);
            return convertToDto(savedComment);
        }
        
        throw new RuntimeException("Property or user not found");
    }
    
    public List<PropertyCommentDto> getCommentsByProperty(Long propertyId) {
        return propertyCommentRepository.findByProperty_Id(propertyId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyCommentDto> getTopLevelCommentsByProperty(Long propertyId) {
        return propertyCommentRepository.findTopLevelCommentsByPropertyId(propertyId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public Page<PropertyCommentDto> getCommentsByPropertyPaginated(Long propertyId, Pageable pageable) {
        return propertyCommentRepository.findByPropertyIdOrderByCreatedAtDesc(propertyId, pageable)
                .map(this::convertToDto);
    }
    
    public List<PropertyCommentDto> getRepliesByComment(Long parentCommentId) {
        return propertyCommentRepository.findRepliesByParentCommentId(parentCommentId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<PropertyCommentDto> getCommentsByUser(Long userId) {
        return propertyCommentRepository.findByUser_Id(userId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public PropertyCommentDto updateComment(Long commentId, PropertyCommentDto commentDto, Long userId) {
        Optional<PropertyComment> commentOpt = propertyCommentRepository.findById(commentId);
        
        if (commentOpt.isPresent()) {
            PropertyComment comment = commentOpt.get();
            
            // Check if user owns this comment
            if (!comment.getUser().getId().equals(userId)) {
                throw new RuntimeException("User can only update their own comments");
            }
            
            comment.setContent(commentDto.getContent());
            comment.setIsEdited(true);
            
            PropertyComment updatedComment = propertyCommentRepository.save(comment);
            return convertToDto(updatedComment);
        }
        
        throw new RuntimeException("Comment not found");
    }
    
    public void deleteComment(Long commentId, Long userId) {
        Optional<PropertyComment> commentOpt = propertyCommentRepository.findById(commentId);
        
        if (commentOpt.isPresent()) {
            PropertyComment comment = commentOpt.get();
            
            // Check if user owns this comment
            if (!comment.getUser().getId().equals(userId)) {
                throw new RuntimeException("User can only delete their own comments");
            }
            
            propertyCommentRepository.delete(comment);
        } else {
            throw new RuntimeException("Comment not found");
        }
    }
    
    public Long getCommentCount(Long propertyId) {
        return propertyCommentRepository.countByPropertyId(propertyId);
    }
    
    public Long getReplyCount(Long parentCommentId) {
        return propertyCommentRepository.countRepliesByParentCommentId(parentCommentId);
    }
    
    private PropertyCommentDto convertToDto(PropertyComment comment) {
        PropertyCommentDto dto = new PropertyCommentDto();
        dto.setId(comment.getId());
        dto.setContent(comment.getContent());
        dto.setIsEdited(comment.getIsEdited());
        dto.setCreatedAt(comment.getCreatedAt());
        dto.setUpdatedAt(comment.getUpdatedAt());
        
        // Set parent comment ID if exists
        if (comment.getParentComment() != null) {
            dto.setParentCommentId(comment.getParentComment().getId());
        }
        
        // Set user details
        if (comment.getUser() != null) {
            UserDto userDto = new UserDto();
            userDto.setId(comment.getUser().getId());
            userDto.setFirstName(comment.getUser().getFirstName());
            userDto.setLastName(comment.getUser().getLastName());
            userDto.setUserType(comment.getUser().getUserType());
            userDto.setIsVerified(comment.getUser().getIsVerified());
            dto.setUser(userDto);
        }
        
        return dto;
    }
}
