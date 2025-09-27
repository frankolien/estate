package com.example.estate.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "saved_searches")
public class SavedSearch {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank
    @Size(max = 100)
    private String name;
    
    @Size(max = 500)
    private String description;
    
    @Column(name = "search_criteria", columnDefinition = "TEXT")
    private String searchCriteria; // JSON string containing search filters
    
    @Column(name = "is_active")
    private Boolean isActive = true;
    
    @Column(name = "notification_enabled")
    private Boolean notificationEnabled = true;
    
    @Column(name = "min_price")
    private BigDecimal minPrice;
    
    @Column(name = "max_price")
    private BigDecimal maxPrice;
    
    @Column(name = "city")
    private String city;
    
    @Column(name = "state")
    private String state;
    
    @Column(name = "property_type")
    private String propertyType;
    
    @Column(name = "listing_type")
    private String listingType;
    
    @Column(name = "min_bedrooms")
    private Integer minBedrooms;
    
    @Column(name = "max_bedrooms")
    private Integer maxBedrooms;
    
    @Column(name = "min_bathrooms")
    private Integer minBathrooms;
    
    @Column(name = "max_bathrooms")
    private Integer maxBathrooms;
    
    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    // Constructors
    public SavedSearch() {}
    
    public SavedSearch(String name, String searchCriteria, User user) {
        this.name = name;
        this.searchCriteria = searchCriteria;
        this.user = user;
    }
    
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
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
}
