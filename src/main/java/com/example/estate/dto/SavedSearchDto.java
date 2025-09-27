package com.example.estate.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class SavedSearchDto {
    
    private Long id;
    
    @NotBlank
    @Size(max = 100)
    private String name;
    
    @Size(max = 500)
    private String description;
    
    private String searchCriteria;
    
    private Boolean isActive;
    
    private Boolean notificationEnabled;
    
    private BigDecimal minPrice;
    
    private BigDecimal maxPrice;
    
    private String city;
    
    private String state;
    
    private String propertyType;
    
    private String listingType;
    
    private Integer minBedrooms;
    
    private Integer maxBedrooms;
    
    private Integer minBathrooms;
    
    private Integer maxBathrooms;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    private Long userId;
    
    // Constructors
    public SavedSearchDto() {}
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getSearchCriteria() {
        return searchCriteria;
    }
    
    public void setSearchCriteria(String searchCriteria) {
        this.searchCriteria = searchCriteria;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public Boolean getNotificationEnabled() {
        return notificationEnabled;
    }
    
    public void setNotificationEnabled(Boolean notificationEnabled) {
        this.notificationEnabled = notificationEnabled;
    }
    
    public BigDecimal getMinPrice() {
        return minPrice;
    }
    
    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }
    
    public BigDecimal getMaxPrice() {
        return maxPrice;
    }
    
    public void setMaxPrice(BigDecimal maxPrice) {
        this.maxPrice = maxPrice;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getState() {
        return state;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    
    public String getPropertyType() {
        return propertyType;
    }
    
    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }
    
    public String getListingType() {
        return listingType;
    }
    
    public void setListingType(String listingType) {
        this.listingType = listingType;
    }
    
    public Integer getMinBedrooms() {
        return minBedrooms;
    }
    
    public void setMinBedrooms(Integer minBedrooms) {
        this.minBedrooms = minBedrooms;
    }
    
    public Integer getMaxBedrooms() {
        return maxBedrooms;
    }
    
    public void setMaxBedrooms(Integer maxBedrooms) {
        this.maxBedrooms = maxBedrooms;
    }
    
    public Integer getMinBathrooms() {
        return minBathrooms;
    }
    
    public void setMinBathrooms(Integer minBathrooms) {
        this.minBathrooms = minBathrooms;
    }
    
    public Integer getMaxBathrooms() {
        return maxBathrooms;
    }
    
    public void setMaxBathrooms(Integer maxBathrooms) {
        this.maxBathrooms = maxBathrooms;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
