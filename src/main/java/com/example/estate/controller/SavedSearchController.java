package com.example.estate.controller;

import com.example.estate.dto.SavedSearchDto;
import com.example.estate.service.SavedSearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/saved-searches")
@CrossOrigin(origins = "*")
public class SavedSearchController {
    
    @Autowired
    private SavedSearchService savedSearchService;
    
    @PostMapping
    public ResponseEntity<SavedSearchDto> createSavedSearch(@RequestParam Long userId,
                                                           @RequestBody SavedSearchDto savedSearchDto) {
        try {
            SavedSearchDto createdSearch = savedSearchService.createSavedSearch(savedSearchDto, userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdSearch);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<SavedSearchDto>> getSavedSearchesByUser(@PathVariable Long userId) {
        List<SavedSearchDto> searches = savedSearchService.getSavedSearchesByUser(userId);
        return ResponseEntity.ok(searches);
    }
    
    @GetMapping("/user/{userId}/active")
    public ResponseEntity<List<SavedSearchDto>> getActiveSavedSearchesByUser(@PathVariable Long userId) {
        List<SavedSearchDto> searches = savedSearchService.getActiveSavedSearchesByUser(userId);
        return ResponseEntity.ok(searches);
    }
    
    @GetMapping("/notifications")
    public ResponseEntity<List<SavedSearchDto>> getNotificationEnabledSearches() {
        List<SavedSearchDto> searches = savedSearchService.getNotificationEnabledSearches();
        return ResponseEntity.ok(searches);
    }
    
    @PutMapping("/{searchId}")
    public ResponseEntity<SavedSearchDto> updateSavedSearch(@PathVariable Long searchId,
                                                           @RequestParam Long userId,
                                                           @RequestBody SavedSearchDto savedSearchDto) {
        try {
            SavedSearchDto updatedSearch = savedSearchService.updateSavedSearch(searchId, savedSearchDto, userId);
            return ResponseEntity.ok(updatedSearch);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @DeleteMapping("/{searchId}")
    public ResponseEntity<Void> deleteSavedSearch(@PathVariable Long searchId,
                                                 @RequestParam Long userId) {
        try {
            savedSearchService.deleteSavedSearch(searchId, userId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PutMapping("/{searchId}/activate")
    public ResponseEntity<Boolean> activateSavedSearch(@PathVariable Long searchId,
                                                      @RequestParam Long userId) {
        try {
            boolean activated = savedSearchService.activateSavedSearch(searchId, userId);
            return ResponseEntity.ok(activated);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PutMapping("/{searchId}/deactivate")
    public ResponseEntity<Boolean> deactivateSavedSearch(@PathVariable Long searchId,
                                                        @RequestParam Long userId) {
        try {
            boolean deactivated = savedSearchService.deactivateSavedSearch(searchId, userId);
            return ResponseEntity.ok(deactivated);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping("/user/{userId}/count")
    public ResponseEntity<Long> getSavedSearchCountByUser(@PathVariable Long userId) {
        Long count = savedSearchService.getSavedSearchCountByUser(userId);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/user/{userId}/active-count")
    public ResponseEntity<Long> getActiveSavedSearchCountByUser(@PathVariable Long userId) {
        Long count = savedSearchService.getActiveSavedSearchCountByUser(userId);
        return ResponseEntity.ok(count);
    }
}
