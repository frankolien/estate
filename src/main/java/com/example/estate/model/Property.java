package com.example.estate.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "properties")
public class Property {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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
    
    @Enumerated(EnumType.STRING)
    @Column(name = "property_type")
    private PropertyType propertyType;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "listing_type")
    private ListingType listingType;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "property_status")
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
    @Column(name = "postal_code")
    private String postalCode;
    
    @Column(name = "latitude")
    private Double latitude;
    
    @Column(name = "longitude")
    private Double longitude;
    
    @Column(name = "bedrooms")
    private Integer bedrooms;
    
    @Column(name = "bathrooms")
    private Integer bathrooms;
    
    @Column(name = "square_feet")
    private Integer squareFeet;
    
    @Column(name = "lot_size")
    private Integer lotSize;
    
    @Column(name = "year_built")
    private Integer yearBuilt;
    
    @Column(name = "parking_spaces")
    private Integer parkingSpaces;
    
    @Column(name = "is_furnished")
    private Boolean isFurnished = false;
    
    @Column(name = "is_pet_friendly")
    private Boolean isPetFriendly = false;
    
    @Column(name = "has_pool")
    private Boolean hasPool = false;
    
    @Column(name = "has_garden")
    private Boolean hasGarden = false;
    
    @Column(name = "has_gym")
    private Boolean hasGym = false;
    
    @Column(name = "has_security")
    private Boolean hasSecurity = false;
    
    @Column(name = "is_verified")
    private Boolean isVerified = false;
    
    @Column(name = "is_featured")
    private Boolean isFeatured = false;
    
    @Column(name = "view_count")
    private Long viewCount = 0L;
    
    @Column(name = "like_count")
    private Long likeCount = 0L;
    
    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @OneToMany(mappedBy = "property", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<PropertyImage> images = new HashSet<>();
    
    @OneToMany(mappedBy = "property", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<PropertyReview> reviews = new HashSet<>();
    
    @OneToMany(mappedBy = "property", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<PropertyLike> likes = new HashSet<>();
    
    @OneToMany(mappedBy = "property", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<PropertyComment> comments = new HashSet<>();
    
    // Constructors
    public Property() {}
    
    public Property(String title, String description, BigDecimal price, PropertyType propertyType, 
                   ListingType listingType, String address, String city, String state, User user) {
        this.title = title;
        this.description = description;
        this.price = price;
        this.propertyType = propertyType;
        this.listingType = listingType;
        this.address = address;
        this.city = city;
        this.state = state;
        this.user = user;
    }
    
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
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public Set<PropertyImage> getImages() {
        return images;
    }
    
    public void setImages(Set<PropertyImage> images) {
        this.images = images;
    }
    
    public Set<PropertyReview> getReviews() {
        return reviews;
    }
    
    public void setReviews(Set<PropertyReview> reviews) {
        this.reviews = reviews;
    }
    
    public Set<PropertyLike> getLikes() {
        return likes;
    }
    
    public void setLikes(Set<PropertyLike> likes) {
        this.likes = likes;
    }
    
    public Set<PropertyComment> getComments() {
        return comments;
    }
    
    public void setComments(Set<PropertyComment> comments) {
        this.comments = comments;
    }
    
    // Helper methods
    public String getFullAddress() {
        return address + ", " + city + ", " + state + " " + postalCode;
    }
    
    public void incrementViewCount() {
        this.viewCount = (this.viewCount == null) ? 1L : this.viewCount + 1;
    }
    
    public void incrementLikeCount() {
        this.likeCount = (this.likeCount == null) ? 1L : this.likeCount + 1;
    }
    
    public void decrementLikeCount() {
        this.likeCount = (this.likeCount == null || this.likeCount <= 0) ? 0L : this.likeCount - 1;
    }
}
