package com.example.estate.repository;

import com.example.estate.model.SavedSearch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SavedSearchRepository extends JpaRepository<SavedSearch, Long> {
    
    List<SavedSearch> findByUser_Id(Long userId);
    
    List<SavedSearch> findByUser_IdAndIsActive(Long userId, Boolean isActive);
    
    List<SavedSearch> findByUser_IdAndNotificationEnabled(Long userId, Boolean notificationEnabled);
    
    @Query("SELECT ss FROM SavedSearch ss WHERE ss.user.id = :userId AND ss.isActive = true ORDER BY ss.createdAt DESC")
    List<SavedSearch> findActiveSearchesByUserId(@Param("userId") Long userId);
    
    @Query("SELECT ss FROM SavedSearch ss WHERE ss.notificationEnabled = true AND ss.isActive = true")
    List<SavedSearch> findActiveNotificationSearches();
    
    @Query("SELECT COUNT(ss) FROM SavedSearch ss WHERE ss.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);
    
    @Query("SELECT COUNT(ss) FROM SavedSearch ss WHERE ss.user.id = :userId AND ss.isActive = true")
    Long countActiveSearchesByUserId(@Param("userId") Long userId);
}
