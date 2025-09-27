package com.example.estate.controller;

import com.example.estate.dto.PropertyReviewDto;
import com.example.estate.service.PropertyReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/properties/{propertyId}/reviews")
@CrossOrigin(origins = "*")
public class PropertyReviewController {
    
    @Autowired
    private PropertyReviewService propertyReviewService;
    
    @PostMapping
    public ResponseEntity<PropertyReviewDto> createReview(@PathVariable Long propertyId,
                                                         @RequestParam Long userId,
                                                         @RequestBody PropertyReviewDto reviewDto) {
        try {
            PropertyReviewDto createdReview = propertyReviewService.createReview(reviewDto, propertyId, userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdReview);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping
    public ResponseEntity<List<PropertyReviewDto>> getReviewsByProperty(@PathVariable Long propertyId) {
        List<PropertyReviewDto> reviews = propertyReviewService.getReviewsByProperty(propertyId);
        return ResponseEntity.ok(reviews);
    }
    
    @GetMapping("/paginated")
    public ResponseEntity<Page<PropertyReviewDto>> getReviewsByPropertyPaginated(
            @PathVariable Long propertyId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<PropertyReviewDto> reviews = propertyReviewService.getReviewsByPropertyPaginated(propertyId, pageable);
        return ResponseEntity.ok(reviews);
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<PropertyReviewDto>> getReviewsByUser(@PathVariable Long userId) {
        List<PropertyReviewDto> reviews = propertyReviewService.getReviewsByUser(userId);
        return ResponseEntity.ok(reviews);
    }
    
    @PutMapping("/{reviewId}")
    public ResponseEntity<PropertyReviewDto> updateReview(@PathVariable Long reviewId,
                                                         @RequestParam Long userId,
                                                         @RequestBody PropertyReviewDto reviewDto) {
        try {
            PropertyReviewDto updatedReview = propertyReviewService.updateReview(reviewId, reviewDto, userId);
            return ResponseEntity.ok(updatedReview);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @DeleteMapping("/{reviewId}")
    public ResponseEntity<Void> deleteReview(@PathVariable Long reviewId,
                                            @RequestParam Long userId) {
        try {
            propertyReviewService.deleteReview(reviewId, userId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping("/average-rating")
    public ResponseEntity<Double> getAverageRating(@PathVariable Long propertyId) {
        Double averageRating = propertyReviewService.getAverageRating(propertyId);
        return ResponseEntity.ok(averageRating);
    }
    
    @GetMapping("/count")
    public ResponseEntity<Long> getReviewCount(@PathVariable Long propertyId) {
        Long count = propertyReviewService.getReviewCount(propertyId);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/filter")
    public ResponseEntity<List<PropertyReviewDto>> getReviewsByRating(@PathVariable Long propertyId,
                                                                     @RequestParam Integer minRating) {
        List<PropertyReviewDto> reviews = propertyReviewService.getReviewsByRating(propertyId, minRating);
        return ResponseEntity.ok(reviews);
    }
    
    @PutMapping("/{reviewId}/verify")
    public ResponseEntity<Boolean> verifyReview(@PathVariable Long reviewId) {
        boolean verified = propertyReviewService.verifyReview(reviewId);
        return ResponseEntity.ok(verified);
    }
}
