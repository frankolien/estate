package com.example.estate.repository;

import com.example.estate.model.PropertyComment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PropertyCommentRepository extends JpaRepository<PropertyComment, Long> {
    
    List<PropertyComment> findByProperty_Id(Long propertyId);
    
    List<PropertyComment> findByUser_Id(Long userId);
    
    List<PropertyComment> findByParentComment_Id(Long parentCommentId);
    
    @Query("SELECT pc FROM PropertyComment pc WHERE pc.property.id = :propertyId AND pc.parentComment IS NULL ORDER BY pc.createdAt ASC")
    List<PropertyComment> findTopLevelCommentsByPropertyId(@Param("propertyId") Long propertyId);
    
    @Query("SELECT pc FROM PropertyComment pc WHERE pc.property.id = :propertyId ORDER BY pc.createdAt DESC")
    Page<PropertyComment> findByPropertyIdOrderByCreatedAtDesc(@Param("propertyId") Long propertyId, Pageable pageable);
    
    @Query("SELECT pc FROM PropertyComment pc WHERE pc.parentComment.id = :parentCommentId ORDER BY pc.createdAt ASC")
    List<PropertyComment> findRepliesByParentCommentId(@Param("parentCommentId") Long parentCommentId);
    
    @Query("SELECT COUNT(pc) FROM PropertyComment pc WHERE pc.property.id = :propertyId")
    Long countByPropertyId(@Param("propertyId") Long propertyId);
    
    @Query("SELECT COUNT(pc) FROM PropertyComment pc WHERE pc.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);
    
    @Query("SELECT COUNT(pc) FROM PropertyComment pc WHERE pc.parentComment.id = :parentCommentId")
    Long countRepliesByParentCommentId(@Param("parentCommentId") Long parentCommentId);
}
