package com.example.estate.repository;

import com.example.estate.model.PropertyReview;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PropertyReviewRepository extends JpaRepository<PropertyReview, Long> {
    
    List<PropertyReview> findByProperty_Id(Long propertyId);
    
    List<PropertyReview> findByUser_Id(Long userId);
    
    List<PropertyReview> findByProperty_IdAndUser_Id(Long propertyId, Long userId);
    
    @Query("SELECT pr FROM PropertyReview pr WHERE pr.property.id = :propertyId ORDER BY pr.createdAt DESC")
    Page<PropertyReview> findByPropertyIdOrderByCreatedAtDesc(@Param("propertyId") Long propertyId, Pageable pageable);
    
    @Query("SELECT pr FROM PropertyReview pr WHERE pr.property.id = :propertyId AND pr.rating >= :minRating ORDER BY pr.createdAt DESC")
    List<PropertyReview> findByPropertyIdAndMinRating(@Param("propertyId") Long propertyId, @Param("minRating") Integer minRating);
    
    @Query("SELECT AVG(pr.rating) FROM PropertyReview pr WHERE pr.property.id = :propertyId")
    Double findAverageRatingByPropertyId(@Param("propertyId") Long propertyId);
    
    @Query("SELECT COUNT(pr) FROM PropertyReview pr WHERE pr.property.id = :propertyId")
    Long countByPropertyId(@Param("propertyId") Long propertyId);
    
    @Query("SELECT COUNT(pr) FROM PropertyReview pr WHERE pr.property.id = :propertyId AND pr.rating = :rating")
    Long countByPropertyIdAndRating(@Param("propertyId") Long propertyId, @Param("rating") Integer rating);
    
    @Query("SELECT pr FROM PropertyReview pr WHERE pr.isVerified = true ORDER BY pr.createdAt DESC")
    Page<PropertyReview> findVerifiedReviewsOrderByCreatedAtDesc(Pageable pageable);
    
    @Query("SELECT pr FROM PropertyReview pr WHERE pr.property.id = :propertyId AND pr.isVerified = true ORDER BY pr.createdAt DESC")
    List<PropertyReview> findVerifiedReviewsByPropertyId(@Param("propertyId") Long propertyId);
}
