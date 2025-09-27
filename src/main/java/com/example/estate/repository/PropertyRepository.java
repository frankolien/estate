package com.example.estate.repository;

import com.example.estate.model.ListingType;
import com.example.estate.model.Property;
import com.example.estate.model.PropertyStatus;
import com.example.estate.model.PropertyType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface PropertyRepository extends JpaRepository<Property, Long> {
    
    List<Property> findByUser_Id(Long userId);
    
    List<Property> findByPropertyType(PropertyType propertyType);
    
    List<Property> findByListingType(ListingType listingType);
    
    List<Property> findByPropertyStatus(PropertyStatus propertyStatus);
    
    List<Property> findByCity(String city);
    
    List<Property> findByState(String state);
    
    List<Property> findByIsVerified(Boolean isVerified);
    
    List<Property> findByIsFeatured(Boolean isFeatured);
    
    @Query("SELECT p FROM Property p WHERE p.price BETWEEN :minPrice AND :maxPrice")
    List<Property> findByPriceRange(@Param("minPrice") BigDecimal minPrice, @Param("maxPrice") BigDecimal maxPrice);
    
    @Query("SELECT p FROM Property p WHERE p.bedrooms >= :minBedrooms AND p.bedrooms <= :maxBedrooms")
    List<Property> findByBedroomRange(@Param("minBedrooms") Integer minBedrooms, @Param("maxBedrooms") Integer maxBedrooms);
    
    @Query("SELECT p FROM Property p WHERE p.bathrooms >= :minBathrooms AND p.bathrooms <= :maxBathrooms")
    List<Property> findByBathroomRange(@Param("minBathrooms") Integer minBathrooms, @Param("maxBathrooms") Integer maxBathrooms);
    
    @Query("SELECT p FROM Property p WHERE p.squareFeet >= :minSquareFeet AND p.squareFeet <= :maxSquareFeet")
    List<Property> findBySquareFeetRange(@Param("minSquareFeet") Integer minSquareFeet, @Param("maxSquareFeet") Integer maxSquareFeet);
    
    @Query("SELECT p FROM Property p WHERE p.city = :city AND p.state = :state")
    List<Property> findByCityAndState(@Param("city") String city, @Param("state") String state);
    
    @Query("SELECT p FROM Property p WHERE p.propertyType = :propertyType AND p.listingType = :listingType")
    List<Property> findByPropertyTypeAndListingType(@Param("propertyType") PropertyType propertyType, @Param("listingType") ListingType listingType);
    
    @Query("SELECT p FROM Property p WHERE p.isVerified = true AND p.propertyStatus = 'AVAILABLE'")
    Page<Property> findAvailableVerifiedProperties(Pageable pageable);
    
    @Query("SELECT p FROM Property p WHERE p.isFeatured = true AND p.propertyStatus = 'AVAILABLE'")
    List<Property> findFeaturedAvailableProperties();
    
    @Query("SELECT p FROM Property p WHERE p.title LIKE %:keyword% OR p.description LIKE %:keyword% OR p.address LIKE %:keyword%")
    List<Property> findByKeyword(@Param("keyword") String keyword);
    
    @Query("SELECT p FROM Property p WHERE p.user.id = :userId AND p.propertyStatus = :status")
    List<Property> findByUserAndStatus(@Param("userId") Long userId, @Param("status") PropertyStatus status);
    
    @Query("SELECT p FROM Property p WHERE p.propertyStatus = 'AVAILABLE' ORDER BY p.createdAt DESC")
    Page<Property> findLatestAvailableProperties(Pageable pageable);
    
    @Query("SELECT p FROM Property p WHERE p.propertyStatus = 'AVAILABLE' ORDER BY p.viewCount DESC")
    Page<Property> findMostViewedProperties(Pageable pageable);
    
    @Query("SELECT p FROM Property p WHERE p.propertyStatus = 'AVAILABLE' ORDER BY p.likeCount DESC")
    Page<Property> findMostLikedProperties(Pageable pageable);
    
    @Query("SELECT p FROM Property p WHERE p.propertyStatus = 'AVAILABLE' AND p.price BETWEEN :minPrice AND :maxPrice AND p.city = :city ORDER BY p.createdAt DESC")
    Page<Property> findPropertiesWithFilters(@Param("minPrice") BigDecimal minPrice, 
                                           @Param("maxPrice") BigDecimal maxPrice, 
                                           @Param("city") String city, 
                                           Pageable pageable);
    
    @Query("SELECT COUNT(p) FROM Property p WHERE p.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);
    
    @Query("SELECT COUNT(p) FROM Property p WHERE p.propertyStatus = 'AVAILABLE'")
    Long countAvailableProperties();
    
    @Query("SELECT COUNT(p) FROM Property p WHERE p.isVerified = true")
    Long countVerifiedProperties();
    
    @Query("SELECT p.city, COUNT(p) FROM Property p WHERE p.propertyStatus = 'AVAILABLE' GROUP BY p.city ORDER BY COUNT(p) DESC")
    List<Object[]> findPropertyCountByCity();
}
