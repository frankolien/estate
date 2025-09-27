package com.example.estate.controller;

import com.example.estate.dto.PropertyCommentDto;
import com.example.estate.service.PropertyCommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/properties/{propertyId}/comments")
@CrossOrigin(origins = "*")
public class PropertyCommentController {
    
    @Autowired
    private PropertyCommentService propertyCommentService;
    
    @PostMapping
    public ResponseEntity<PropertyCommentDto> createComment(@PathVariable Long propertyId,
                                                           @RequestParam Long userId,
                                                           @RequestBody PropertyCommentDto commentDto) {
        try {
            PropertyCommentDto createdComment = propertyCommentService.createComment(commentDto, propertyId, userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdComment);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping
    public ResponseEntity<List<PropertyCommentDto>> getCommentsByProperty(@PathVariable Long propertyId) {
        List<PropertyCommentDto> comments = propertyCommentService.getCommentsByProperty(propertyId);
        return ResponseEntity.ok(comments);
    }
    
    @GetMapping("/top-level")
    public ResponseEntity<List<PropertyCommentDto>> getTopLevelComments(@PathVariable Long propertyId) {
        List<PropertyCommentDto> comments = propertyCommentService.getTopLevelCommentsByProperty(propertyId);
        return ResponseEntity.ok(comments);
    }
    
    @GetMapping("/paginated")
    public ResponseEntity<Page<PropertyCommentDto>> getCommentsByPropertyPaginated(
            @PathVariable Long propertyId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<PropertyCommentDto> comments = propertyCommentService.getCommentsByPropertyPaginated(propertyId, pageable);
        return ResponseEntity.ok(comments);
    }
    
    @GetMapping("/{parentCommentId}/replies")
    public ResponseEntity<List<PropertyCommentDto>> getRepliesByComment(@PathVariable Long parentCommentId) {
        List<PropertyCommentDto> replies = propertyCommentService.getRepliesByComment(parentCommentId);
        return ResponseEntity.ok(replies);
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<PropertyCommentDto>> getCommentsByUser(@PathVariable Long userId) {
        List<PropertyCommentDto> comments = propertyCommentService.getCommentsByUser(userId);
        return ResponseEntity.ok(comments);
    }
    
    @PutMapping("/{commentId}")
    public ResponseEntity<PropertyCommentDto> updateComment(@PathVariable Long commentId,
                                                           @RequestParam Long userId,
                                                           @RequestBody PropertyCommentDto commentDto) {
        try {
            PropertyCommentDto updatedComment = propertyCommentService.updateComment(commentId, commentDto, userId);
            return ResponseEntity.ok(updatedComment);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @DeleteMapping("/{commentId}")
    public ResponseEntity<Void> deleteComment(@PathVariable Long commentId,
                                             @RequestParam Long userId) {
        try {
            propertyCommentService.deleteComment(commentId, userId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping("/count")
    public ResponseEntity<Long> getCommentCount(@PathVariable Long propertyId) {
        Long count = propertyCommentService.getCommentCount(propertyId);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/{parentCommentId}/replies/count")
    public ResponseEntity<Long> getReplyCount(@PathVariable Long parentCommentId) {
        Long count = propertyCommentService.getReplyCount(parentCommentId);
        return ResponseEntity.ok(count);
    }
}
