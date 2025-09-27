package com.example.estate.repository;

import com.example.estate.model.LegalTemplate;
import com.example.estate.model.ListingType;
import com.example.estate.model.PropertyType;
import com.example.estate.model.TemplateType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LegalTemplateRepository extends JpaRepository<LegalTemplate, Long> {
    
    List<LegalTemplate> findByTemplateType(TemplateType templateType);
    
    List<LegalTemplate> findByPropertyType(PropertyType propertyType);
    
    List<LegalTemplate> findByListingType(ListingType listingType);
    
    List<LegalTemplate> findByIsActive(Boolean isActive);
    
    List<LegalTemplate> findByIsVerified(Boolean isVerified);
    
    @Query("SELECT lt FROM LegalTemplate lt WHERE lt.templateType = :templateType AND lt.propertyType = :propertyType AND lt.listingType = :listingType")
    List<LegalTemplate> findByTemplateTypeAndPropertyTypeAndListingType(
            @Param("templateType") TemplateType templateType,
            @Param("propertyType") PropertyType propertyType,
            @Param("listingType") ListingType listingType);
    
    @Query("SELECT lt FROM LegalTemplate lt WHERE lt.isActive = true AND lt.isVerified = true")
    List<LegalTemplate> findActiveAndVerifiedTemplates();
    
    @Query("SELECT lt FROM LegalTemplate lt WHERE lt.templateType = :templateType AND lt.isActive = true")
    List<LegalTemplate> findActiveTemplatesByType(@Param("templateType") TemplateType templateType);
    
    @Query("SELECT COUNT(lt) FROM LegalTemplate lt WHERE lt.templateType = :templateType")
    Long countByTemplateType(@Param("templateType") TemplateType templateType);
    
    @Query("SELECT COUNT(lt) FROM LegalTemplate lt WHERE lt.isActive = true")
    Long countActiveTemplates();
    
    @Query("SELECT COUNT(lt) FROM LegalTemplate lt WHERE lt.isVerified = true")
    Long countVerifiedTemplates();
}
