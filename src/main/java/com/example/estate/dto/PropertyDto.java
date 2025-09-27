package com.example.estate.dto;

import com.example.estate.model.ListingType;
import com.example.estate.model.PropertyStatus;
import com.example.estate.model.PropertyType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class PropertyDto {
    
    private Long id;
    
    @NotBlank
    @Size(max = 200)
    private String title;
    
    @NotBlank
    @Size(max = 2000)
    private String description;
    
    @NotNull
    @DecimalMin(value = "0.0", inclusive = false)
    private BigDecimal price;
    
    private PropertyType propertyType;
    
    private ListingType listingType;
    
    private PropertyStatus propertyStatus;
    
    @NotBlank
    @Size(max = 100)
    private String address;
    
    @NotBlank
    @Size(max = 50)
    private String city;
    
    @NotBlank
    @Size(max = 50)
    private String state;
    
    @NotBlank
    @Size(max = 10)
    private String postalCode;
    
    private Double latitude;
    
    private Double longitude;
    
    private Integer bedrooms;
    
    private Integer bathrooms;
    
    private Integer squareFeet;
    
    private Integer lotSize;
    
    private Integer yearBuilt;
    
    private Integer parkingSpaces;
    
    private Boolean isFurnished;
    
    private Boolean isPetFriendly;
    
    private Boolean hasPool;
    
    private Boolean hasGarden;
    
    private Boolean hasGym;
    
    private Boolean hasSecurity;
    
    private Boolean isVerified;
    
    private Boolean isFeatured;
    
    private Long viewCount;
    
    private Long likeCount;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    private UserDto user;
    
    private List<PropertyImageDto> images;
    
    private List<PropertyReviewDto> reviews;
    
    private Double averageRating;
    
    private Long reviewCount;
    
    // Constructors
    public PropertyDto() {}
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public PropertyType getPropertyType() {
        return propertyType;
    }
    
    public void setPropertyType(PropertyType propertyType) {
        this.propertyType = propertyType;
    }
    
    public ListingType getListingType() {
        return listingType;
    }
    
    public void setListingType(ListingType listingType) {
        this.listingType = listingType;
    }
    
    public PropertyStatus getPropertyStatus() {
        return propertyStatus;
    }
    
    public void setPropertyStatus(PropertyStatus propertyStatus) {
        this.propertyStatus = propertyStatus;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
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
    
    public String getPostalCode() {
        return postalCode;
    }
    
    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }
    
    public Double getLatitude() {
        return latitude;
    }
    
    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }
    
    public Double getLongitude() {
        return longitude;
    }
    
    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }
    
    public Integer getBedrooms() {
        return bedrooms;
    }
    
    public void setBedrooms(Integer bedrooms) {
        this.bedrooms = bedrooms;
    }
    
    public Integer getBathrooms() {
        return bathrooms;
    }
    
    public void setBathrooms(Integer bathrooms) {
        this.bathrooms = bathrooms;
    }
    
    public Integer getSquareFeet() {
        return squareFeet;
    }
    
    public void setSquareFeet(Integer squareFeet) {
        this.squareFeet = squareFeet;
    }
    
    public Integer getLotSize() {
        return lotSize;
    }
    
    public void setLotSize(Integer lotSize) {
        this.lotSize = lotSize;
    }
    
    public Integer getYearBuilt() {
        return yearBuilt;
    }
    
    public void setYearBuilt(Integer yearBuilt) {
        this.yearBuilt = yearBuilt;
    }
    
    public Integer getParkingSpaces() {
        return parkingSpaces;
    }
    
    public void setParkingSpaces(Integer parkingSpaces) {
        this.parkingSpaces = parkingSpaces;
    }
    
    public Boolean getIsFurnished() {
        return isFurnished;
    }
    
    public void setIsFurnished(Boolean isFurnished) {
        this.isFurnished = isFurnished;
    }
    
    public Boolean getIsPetFriendly() {
        return isPetFriendly;
    }
    
    public void setIsPetFriendly(Boolean isPetFriendly) {
        this.isPetFriendly = isPetFriendly;
    }
    
    public Boolean getHasPool() {
        return hasPool;
    }
    
    public void setHasPool(Boolean hasPool) {
        this.hasPool = hasPool;
    }
    
    public Boolean getHasGarden() {
        return hasGarden;
    }
    
    public void setHasGarden(Boolean hasGarden) {
        this.hasGarden = hasGarden;
    }
    
    public Boolean getHasGym() {
        return hasGym;
    }
    
    public void setHasGym(Boolean hasGym) {
        this.hasGym = hasGym;
    }
    
    public Boolean getHasSecurity() {
        return hasSecurity;
    }
    
    public void setHasSecurity(Boolean hasSecurity) {
        this.hasSecurity = hasSecurity;
    }
    
    public Boolean getIsVerified() {
        return isVerified;
    }
    
    public void setIsVerified(Boolean isVerified) {
        this.isVerified = isVerified;
    }
    
    public Boolean getIsFeatured() {
        return isFeatured;
    }
    
    public void setIsFeatured(Boolean isFeatured) {
        this.isFeatured = isFeatured;
    }
    
    public Long getViewCount() {
        return viewCount;
    }
    
    public void setViewCount(Long viewCount) {
        this.viewCount = viewCount;
    }
    
    public Long getLikeCount() {
        return likeCount;
    }
    
    public void setLikeCount(Long likeCount) {
        this.likeCount = likeCount;
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
    
    public UserDto getUser() {
        return user;
    }
    
    public void setUser(UserDto user) {
        this.user = user;
    }
    
    public List<PropertyImageDto> getImages() {
        return images;
    }
    
    public void setImages(List<PropertyImageDto> images) {
        this.images = images;
    }
    
    public List<PropertyReviewDto> getReviews() {
        return reviews;
    }
    
    public void setReviews(List<PropertyReviewDto> reviews) {
        this.reviews = reviews;
    }
    
    public Double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }
    
    public Long getReviewCount() {
        return reviewCount;
    }
    
    public void setReviewCount(Long reviewCount) {
        this.reviewCount = reviewCount;
    }
    
    // Helper methods
    public String getFullAddress() {
        return address + ", " + city + ", " + state + " " + postalCode;
    }
}
