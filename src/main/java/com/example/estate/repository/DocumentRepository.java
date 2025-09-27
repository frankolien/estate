package com.example.estate.repository;

import com.example.estate.model.Document;
import com.example.estate.model.DocumentType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DocumentRepository extends JpaRepository<Document, Long> {
    
    List<Document> findByProperty_Id(Long propertyId);
    
    List<Document> findByUser_Id(Long userId);
    
    List<Document> findByDocumentType(DocumentType documentType);
    
    List<Document> findByIsVerified(Boolean isVerified);
    
    List<Document> findByIsPublic(Boolean isPublic);
    
    @Query("SELECT d FROM Document d WHERE d.property.id = :propertyId AND d.documentType = :documentType")
    List<Document> findByPropertyIdAndDocumentType(@Param("propertyId") Long propertyId, 
                                                   @Param("documentType") DocumentType documentType);
    
    @Query("SELECT d FROM Document d WHERE d.user.id = :userId AND d.documentType = :documentType")
    List<Document> findByUserIdAndDocumentType(@Param("userId") Long userId, 
                                              @Param("documentType") DocumentType documentType);
    
    @Query("SELECT d FROM Document d WHERE d.property.id = :propertyId AND d.isVerified = true")
    List<Document> findVerifiedDocumentsByPropertyId(@Param("propertyId") Long propertyId);
    
    @Query("SELECT d FROM Document d WHERE d.isPublic = true ORDER BY d.createdAt DESC")
    Page<Document> findPublicDocuments(Pageable pageable);
    
    @Query("SELECT d FROM Document d WHERE d.property.id = :propertyId ORDER BY d.createdAt DESC")
    Page<Document> findByPropertyIdOrderByCreatedAtDesc(@Param("propertyId") Long propertyId, Pageable pageable);
    
    @Query("SELECT d FROM Document d WHERE d.user.id = :userId ORDER BY d.createdAt DESC")
    Page<Document> findByUserIdOrderByCreatedAtDesc(@Param("userId") Long userId, Pageable pageable);
    
    @Query("SELECT COUNT(d) FROM Document d WHERE d.property.id = :propertyId")
    Long countByPropertyId(@Param("propertyId") Long propertyId);
    
    @Query("SELECT COUNT(d) FROM Document d WHERE d.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);
    
    @Query("SELECT COUNT(d) FROM Document d WHERE d.documentType = :documentType")
    Long countByDocumentType(@Param("documentType") DocumentType documentType);
    
    @Query("SELECT COUNT(d) FROM Document d WHERE d.isVerified = true")
    Long countVerifiedDocuments();
}
