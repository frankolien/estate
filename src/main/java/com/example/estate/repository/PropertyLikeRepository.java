package com.example.estate.repository;

import com.example.estate.model.PropertyLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PropertyLikeRepository extends JpaRepository<PropertyLike, Long> {
    
    List<PropertyLike> findByUser_Id(Long userId);
    
    List<PropertyLike> findByProperty_Id(Long propertyId);
    
    Optional<PropertyLike> findByUser_IdAndProperty_Id(Long userId, Long propertyId);
    
    @Query("SELECT COUNT(pl) FROM PropertyLike pl WHERE pl.property.id = :propertyId")
    Long countByPropertyId(@Param("propertyId") Long propertyId);
    
    @Query("SELECT COUNT(pl) FROM PropertyLike pl WHERE pl.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);
    
    @Query("SELECT pl.property.id FROM PropertyLike pl WHERE pl.user.id = :userId")
    List<Long> findPropertyIdsByUserId(@Param("userId") Long userId);
    
    @Query("SELECT pl.user.id FROM PropertyLike pl WHERE pl.property.id = :propertyId")
    List<Long> findUserIdsByPropertyId(@Param("propertyId") Long propertyId);
    
    boolean existsByUser_IdAndProperty_Id(Long userId, Long propertyId);
    
    void deleteByUser_IdAndProperty_Id(Long userId, Long propertyId);
}
