package com.example.estate.repository;

import com.example.estate.model.PropertyImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PropertyImageRepository extends JpaRepository<PropertyImage, Long> {
    
    List<PropertyImage> findByProperty_Id(Long propertyId);
    
    List<PropertyImage> findByProperty_IdOrderBySortOrderAsc(Long propertyId);
    
    @Query("SELECT pi FROM PropertyImage pi WHERE pi.property.id = :propertyId AND pi.isPrimary = true")
    PropertyImage findPrimaryImageByPropertyId(@Param("propertyId") Long propertyId);
    
    @Query("SELECT pi FROM PropertyImage pi WHERE pi.property.id = :propertyId ORDER BY pi.sortOrder ASC, pi.createdAt ASC")
    List<PropertyImage> findByPropertyIdOrdered(@Param("propertyId") Long propertyId);
    
    void deleteByProperty_Id(Long propertyId);
    
    @Query("SELECT COUNT(pi) FROM PropertyImage pi WHERE pi.property.id = :propertyId")
    Long countByPropertyId(@Param("propertyId") Long propertyId);
}
