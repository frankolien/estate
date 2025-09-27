package com.example.estate.controller;

import com.example.estate.dto.PropertyDto;
import com.example.estate.model.ListingType;
import com.example.estate.model.PropertyType;
import com.example.estate.service.PropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/properties")
@CrossOrigin(origins = "*")
public class PropertyController {
    
    @Autowired
    private PropertyService propertyService;
    
    @GetMapping
    public ResponseEntity<Page<PropertyDto>> getAllProperties(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {
        
        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
                Sort.by(sortBy).descending() : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);
        
        Page<PropertyDto> properties = propertyService.getAllProperties(pageable);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<PropertyDto> getPropertyById(@PathVariable Long id) {
        return propertyService.getPropertyById(id)
                .map(property -> {
                    propertyService.incrementViewCount(id);
                    return ResponseEntity.ok(property);
                })
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<PropertyDto>> getPropertiesByUser(@PathVariable Long userId) {
        List<PropertyDto> properties = propertyService.getPropertiesByUser(userId);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/type/{propertyType}")
    public ResponseEntity<List<PropertyDto>> getPropertiesByType(@PathVariable PropertyType propertyType) {
        List<PropertyDto> properties = propertyService.getPropertiesByType(propertyType);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/listing/{listingType}")
    public ResponseEntity<List<PropertyDto>> getPropertiesByListingType(@PathVariable ListingType listingType) {
        List<PropertyDto> properties = propertyService.getPropertiesByListingType(listingType);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/city/{city}")
    public ResponseEntity<List<PropertyDto>> getPropertiesByCity(@PathVariable String city) {
        List<PropertyDto> properties = propertyService.getPropertiesByCity(city);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/state/{state}")
    public ResponseEntity<List<PropertyDto>> getPropertiesByState(@PathVariable String state) {
        List<PropertyDto> properties = propertyService.getPropertiesByState(state);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/featured")
    public ResponseEntity<List<PropertyDto>> getFeaturedProperties() {
        List<PropertyDto> properties = propertyService.getFeaturedProperties();
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<PropertyDto>> searchProperties(@RequestParam String keyword) {
        List<PropertyDto> properties = propertyService.searchProperties(keyword);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/filter")
    public ResponseEntity<Page<PropertyDto>> searchPropertiesWithFilters(
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) PropertyType propertyType,
            @RequestParam(required = false) ListingType listingType,
            @RequestParam(required = false) Integer minBedrooms,
            @RequestParam(required = false) Integer maxBedrooms,
            @RequestParam(required = false) Integer minBathrooms,
            @RequestParam(required = false) Integer maxBathrooms,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        
        Page<PropertyDto> properties = propertyService.searchPropertiesWithFilters(
                minPrice, maxPrice, city, state, propertyType, listingType,
                minBedrooms, maxBedrooms, minBathrooms, maxBathrooms, pageable);
        
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/latest")
    public ResponseEntity<Page<PropertyDto>> getLatestProperties(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<PropertyDto> properties = propertyService.getLatestProperties(pageable);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/most-viewed")
    public ResponseEntity<Page<PropertyDto>> getMostViewedProperties(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("viewCount").descending());
        Page<PropertyDto> properties = propertyService.getMostViewedProperties(pageable);
        return ResponseEntity.ok(properties);
    }
    
    @GetMapping("/most-liked")
    public ResponseEntity<Page<PropertyDto>> getMostLikedProperties(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("likeCount").descending());
        Page<PropertyDto> properties = propertyService.getMostLikedProperties(pageable);
        return ResponseEntity.ok(properties);
    }
    
    @PostMapping
    public ResponseEntity<PropertyDto> createProperty(@RequestBody PropertyDto propertyDto,
                                                     @RequestParam Long userId) {
        PropertyDto createdProperty = propertyService.createProperty(propertyDto, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdProperty);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<PropertyDto> updateProperty(@PathVariable Long id, 
                                                     @RequestBody PropertyDto propertyDto) {
        PropertyDto updatedProperty = propertyService.updateProperty(id, propertyDto);
        return ResponseEntity.ok(updatedProperty);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProperty(@PathVariable Long id) {
        propertyService.deleteProperty(id);
        return ResponseEntity.noContent().build();
    }
    
    @PutMapping("/{id}/verify")
    public ResponseEntity<Boolean> verifyProperty(@PathVariable Long id) {
        boolean verified = propertyService.verifyProperty(id);
        return ResponseEntity.ok(verified);
    }
    
    @PutMapping("/{id}/feature")
    public ResponseEntity<Boolean> featureProperty(@PathVariable Long id) {
        boolean featured = propertyService.featureProperty(id);
        return ResponseEntity.ok(featured);
    }
    
    @GetMapping("/stats/count")
    public ResponseEntity<Long> getPropertyCount() {
        Long count = propertyService.getAvailablePropertyCount();
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/stats/verified-count")
    public ResponseEntity<Long> getVerifiedPropertyCount() {
        Long count = propertyService.getVerifiedPropertyCount();
        return ResponseEntity.ok(count);
    }
    
    @PostMapping("/verify-all")
    public ResponseEntity<String> verifyAllUnverifiedProperties() {
        int verifiedCount = propertyService.verifyAllUnverifiedProperties();
        return ResponseEntity.ok("Verified " + verifiedCount + " properties");
    }
}
