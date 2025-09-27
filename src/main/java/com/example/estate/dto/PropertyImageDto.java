package com.example.estate.dto;

import jakarta.validation.constraints.NotBlank;

import java.time.LocalDateTime;

public class PropertyImageDto {
    
    private Long id;
    
    @NotBlank
    private String imageUrl;
    
    private String imageCaption;
    
    private Boolean isPrimary;
    
    private Integer sortOrder;
    
    private LocalDateTime createdAt;
    
    // Constructors
    public PropertyImageDto() {}
    
    public PropertyImageDto(Long id, String imageUrl, String imageCaption, Boolean isPrimary, 
                           Integer sortOrder, LocalDateTime createdAt) {
        this.id = id;
        this.imageUrl = imageUrl;
        this.imageCaption = imageCaption;
        this.isPrimary = isPrimary;
        this.sortOrder = sortOrder;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getImageCaption() {
        return imageCaption;
    }
    
    public void setImageCaption(String imageCaption) {
        this.imageCaption = imageCaption;
    }
    
    public Boolean getIsPrimary() {
        return isPrimary;
    }
    
    public void setIsPrimary(Boolean isPrimary) {
        this.isPrimary = isPrimary;
    }
    
    public Integer getSortOrder() {
        return sortOrder;
    }
    
    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
