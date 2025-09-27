package com.example.estate.controller;

import com.example.estate.service.PropertyLikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/properties/{propertyId}/likes")
@CrossOrigin(origins = "*")
public class PropertyLikeController {
    
    @Autowired
    private PropertyLikeService propertyLikeService;
    
    @PostMapping
    public ResponseEntity<Boolean> likeProperty(@PathVariable Long propertyId, 
                                               @RequestParam Long userId) {
        boolean liked = propertyLikeService.likeProperty(propertyId, userId);
        return ResponseEntity.ok(liked);
    }
    
    @DeleteMapping
    public ResponseEntity<Boolean> unlikeProperty(@PathVariable Long propertyId, 
                                                 @RequestParam Long userId) {
        boolean unliked = propertyLikeService.unlikeProperty(propertyId, userId);
        return ResponseEntity.ok(unliked);
    }
    
    @GetMapping("/check")
    public ResponseEntity<Boolean> isPropertyLiked(@PathVariable Long propertyId, 
                                                  @RequestParam Long userId) {
        boolean isLiked = propertyLikeService.isPropertyLikedByUser(propertyId, userId);
        return ResponseEntity.ok(isLiked);
    }
    
    @GetMapping("/count")
    public ResponseEntity<Long> getLikeCount(@PathVariable Long propertyId) {
        Long count = propertyLikeService.getPropertyLikeCount(propertyId);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/users")
    public ResponseEntity<List<Long>> getUsersWhoLiked(@PathVariable Long propertyId) {
        List<Long> userIds = propertyLikeService.getUserIdsWhoLikedProperty(propertyId);
        return ResponseEntity.ok(userIds);
    }
}
