package com.example.estate.service;

import com.example.estate.dto.SavedSearchDto;
import com.example.estate.model.SavedSearch;
import com.example.estate.model.User;
import com.example.estate.repository.SavedSearchRepository;
import com.example.estate.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class SavedSearchService {
    
    @Autowired
    private SavedSearchRepository savedSearchRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public SavedSearchDto createSavedSearch(SavedSearchDto savedSearchDto, Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            SavedSearch savedSearch = new SavedSearch();
            savedSearch.setName(savedSearchDto.getName());
            savedSearch.setDescription(savedSearchDto.getDescription());
            savedSearch.setSearchCriteria(savedSearchDto.getSearchCriteria());
            savedSearch.setIsActive(savedSearchDto.getIsActive() != null ? savedSearchDto.getIsActive() : true);
            savedSearch.setNotificationEnabled(savedSearchDto.getNotificationEnabled() != null ? savedSearchDto.getNotificationEnabled() : true);
            savedSearch.setMinPrice(savedSearchDto.getMinPrice());
            savedSearch.setMaxPrice(savedSearchDto.getMaxPrice());
            savedSearch.setCity(savedSearchDto.getCity());
            savedSearch.setState(savedSearchDto.getState());
            savedSearch.setPropertyType(savedSearchDto.getPropertyType());
            savedSearch.setListingType(savedSearchDto.getListingType());
            savedSearch.setMinBedrooms(savedSearchDto.getMinBedrooms());
            savedSearch.setMaxBedrooms(savedSearchDto.getMaxBedrooms());
            savedSearch.setMinBathrooms(savedSearchDto.getMinBathrooms());
            savedSearch.setMaxBathrooms(savedSearchDto.getMaxBathrooms());
            savedSearch.setUser(user);
            
            SavedSearch saved = savedSearchRepository.save(savedSearch);
            return convertToDto(saved);
        }
        
        throw new RuntimeException("User not found");
    }
    
    public List<SavedSearchDto> getSavedSearchesByUser(Long userId) {
        return savedSearchRepository.findByUser_Id(userId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<SavedSearchDto> getActiveSavedSearchesByUser(Long userId) {
        return savedSearchRepository.findActiveSearchesByUserId(userId).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<SavedSearchDto> getNotificationEnabledSearches() {
        return savedSearchRepository.findActiveNotificationSearches().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public SavedSearchDto updateSavedSearch(Long searchId, SavedSearchDto savedSearchDto, Long userId) {
        Optional<SavedSearch> searchOpt = savedSearchRepository.findById(searchId);
        
        if (searchOpt.isPresent()) {
            SavedSearch savedSearch = searchOpt.get();
            
            // Check if user owns this search
            if (!savedSearch.getUser().getId().equals(userId)) {
                throw new RuntimeException("User can only update their own saved searches");
            }
            
            savedSearch.setName(savedSearchDto.getName());
            savedSearch.setDescription(savedSearchDto.getDescription());
            savedSearch.setSearchCriteria(savedSearchDto.getSearchCriteria());
            savedSearch.setIsActive(savedSearchDto.getIsActive());
            savedSearch.setNotificationEnabled(savedSearchDto.getNotificationEnabled());
            savedSearch.setMinPrice(savedSearchDto.getMinPrice());
            savedSearch.setMaxPrice(savedSearchDto.getMaxPrice());
            savedSearch.setCity(savedSearchDto.getCity());
            savedSearch.setState(savedSearchDto.getState());
            savedSearch.setPropertyType(savedSearchDto.getPropertyType());
            savedSearch.setListingType(savedSearchDto.getListingType());
            savedSearch.setMinBedrooms(savedSearchDto.getMinBedrooms());
            savedSearch.setMaxBedrooms(savedSearchDto.getMaxBedrooms());
            savedSearch.setMinBathrooms(savedSearchDto.getMinBathrooms());
            savedSearch.setMaxBathrooms(savedSearchDto.getMaxBathrooms());
            
            SavedSearch updated = savedSearchRepository.save(savedSearch);
            return convertToDto(updated);
        }
        
        throw new RuntimeException("Saved search not found");
    }
    
    public void deleteSavedSearch(Long searchId, Long userId) {
        Optional<SavedSearch> searchOpt = savedSearchRepository.findById(searchId);
        
        if (searchOpt.isPresent()) {
            SavedSearch savedSearch = searchOpt.get();
            
            // Check if user owns this search
            if (!savedSearch.getUser().getId().equals(userId)) {
                throw new RuntimeException("User can only delete their own saved searches");
            }
            
            savedSearchRepository.delete(savedSearch);
        } else {
            throw new RuntimeException("Saved search not found");
        }
    }
    
    public boolean activateSavedSearch(Long searchId, Long userId) {
        Optional<SavedSearch> searchOpt = savedSearchRepository.findById(searchId);
        
        if (searchOpt.isPresent()) {
            SavedSearch savedSearch = searchOpt.get();
            
            if (!savedSearch.getUser().getId().equals(userId)) {
                throw new RuntimeException("User can only activate their own saved searches");
            }
            
            savedSearch.setIsActive(true);
            savedSearchRepository.save(savedSearch);
            return true;
        }
        
        return false;
    }
    
    public boolean deactivateSavedSearch(Long searchId, Long userId) {
        Optional<SavedSearch> searchOpt = savedSearchRepository.findById(searchId);
        
        if (searchOpt.isPresent()) {
            SavedSearch savedSearch = searchOpt.get();
            
            if (!savedSearch.getUser().getId().equals(userId)) {
                throw new RuntimeException("User can only deactivate their own saved searches");
            }
            
            savedSearch.setIsActive(false);
            savedSearchRepository.save(savedSearch);
            return true;
        }
        
        return false;
    }
    
    public Long getSavedSearchCountByUser(Long userId) {
        return savedSearchRepository.countByUserId(userId);
    }
    
    public Long getActiveSavedSearchCountByUser(Long userId) {
        return savedSearchRepository.countActiveSearchesByUserId(userId);
    }
    
    private SavedSearchDto convertToDto(SavedSearch savedSearch) {
        SavedSearchDto dto = new SavedSearchDto();
        dto.setId(savedSearch.getId());
        dto.setName(savedSearch.getName());
        dto.setDescription(savedSearch.getDescription());
        dto.setSearchCriteria(savedSearch.getSearchCriteria());
        dto.setIsActive(savedSearch.getIsActive());
        dto.setNotificationEnabled(savedSearch.getNotificationEnabled());
        dto.setMinPrice(savedSearch.getMinPrice());
        dto.setMaxPrice(savedSearch.getMaxPrice());
        dto.setCity(savedSearch.getCity());
        dto.setState(savedSearch.getState());
        dto.setPropertyType(savedSearch.getPropertyType());
        dto.setListingType(savedSearch.getListingType());
        dto.setMinBedrooms(savedSearch.getMinBedrooms());
        dto.setMaxBedrooms(savedSearch.getMaxBedrooms());
        dto.setMinBathrooms(savedSearch.getMinBathrooms());
        dto.setMaxBathrooms(savedSearch.getMaxBathrooms());
        dto.setCreatedAt(savedSearch.getCreatedAt());
        dto.setUpdatedAt(savedSearch.getUpdatedAt());
        dto.setUserId(savedSearch.getUser().getId());
        return dto;
    }
}
