package com.example.estate.service;

import com.example.estate.dto.LegalTemplateDto;
import com.example.estate.model.LegalTemplate;
import com.example.estate.model.ListingType;
import com.example.estate.model.PropertyType;
import com.example.estate.model.TemplateType;
import com.example.estate.repository.LegalTemplateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class LegalTemplateService {
    
    @Autowired
    private LegalTemplateRepository legalTemplateRepository;
    
    public LegalTemplateDto createTemplate(LegalTemplateDto templateDto) {
        LegalTemplate template = new LegalTemplate();
        template.setName(templateDto.getName());
        template.setDescription(templateDto.getDescription());
        template.setTemplateType(templateDto.getTemplateType());
        template.setPropertyType(templateDto.getPropertyType());
        template.setListingType(templateDto.getListingType());
        template.setTemplateContent(templateDto.getTemplateContent());
        template.setIsActive(templateDto.getIsActive() != null ? templateDto.getIsActive() : true);
        template.setVersion(templateDto.getVersion() != null ? templateDto.getVersion() : "1.0");
        
        LegalTemplate savedTemplate = legalTemplateRepository.save(template);
        return convertToDto(savedTemplate);
    }
    
    public List<LegalTemplateDto> getAllTemplates() {
        return legalTemplateRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public Optional<LegalTemplateDto> getTemplateById(Long id) {
        return legalTemplateRepository.findById(id)
                .map(this::convertToDto);
    }
    
    public List<LegalTemplateDto> getTemplatesByType(TemplateType templateType) {
        return legalTemplateRepository.findByTemplateType(templateType).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<LegalTemplateDto> getTemplatesByPropertyType(PropertyType propertyType) {
        return legalTemplateRepository.findByPropertyType(propertyType).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<LegalTemplateDto> getTemplatesByListingType(ListingType listingType) {
        return legalTemplateRepository.findByListingType(listingType).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<LegalTemplateDto> getActiveTemplates() {
        return legalTemplateRepository.findByIsActive(true).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<LegalTemplateDto> getVerifiedTemplates() {
        return legalTemplateRepository.findByIsVerified(true).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<LegalTemplateDto> getActiveAndVerifiedTemplates() {
        return legalTemplateRepository.findActiveAndVerifiedTemplates().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<LegalTemplateDto> getTemplatesByTypeAndPropertyAndListing(
            TemplateType templateType, PropertyType propertyType, ListingType listingType) {
        return legalTemplateRepository.findByTemplateTypeAndPropertyTypeAndListingType(
                templateType, propertyType, listingType).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public LegalTemplateDto updateTemplate(Long id, LegalTemplateDto templateDto) {
        LegalTemplate template = legalTemplateRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Template not found with id: " + id));
        
        template.setName(templateDto.getName());
        template.setDescription(templateDto.getDescription());
        template.setTemplateType(templateDto.getTemplateType());
        template.setPropertyType(templateDto.getPropertyType());
        template.setListingType(templateDto.getListingType());
        template.setTemplateContent(templateDto.getTemplateContent());
        template.setIsActive(templateDto.getIsActive());
        template.setVersion(templateDto.getVersion());
        
        LegalTemplate updatedTemplate = legalTemplateRepository.save(template);
        return convertToDto(updatedTemplate);
    }
    
    public void deleteTemplate(Long id) {
        legalTemplateRepository.deleteById(id);
    }
    
    public boolean activateTemplate(Long id) {
        Optional<LegalTemplate> templateOpt = legalTemplateRepository.findById(id);
        if (templateOpt.isPresent()) {
            LegalTemplate template = templateOpt.get();
            template.setIsActive(true);
            legalTemplateRepository.save(template);
            return true;
        }
        return false;
    }
    
    public boolean deactivateTemplate(Long id) {
        Optional<LegalTemplate> templateOpt = legalTemplateRepository.findById(id);
        if (templateOpt.isPresent()) {
            LegalTemplate template = templateOpt.get();
            template.setIsActive(false);
            legalTemplateRepository.save(template);
            return true;
        }
        return false;
    }
    
    public boolean verifyTemplate(Long id) {
        Optional<LegalTemplate> templateOpt = legalTemplateRepository.findById(id);
        if (templateOpt.isPresent()) {
            LegalTemplate template = templateOpt.get();
            template.setIsVerified(true);
            legalTemplateRepository.save(template);
            return true;
        }
        return false;
    }
    
    public Long getTemplateCountByType(TemplateType templateType) {
        return legalTemplateRepository.countByTemplateType(templateType);
    }
    
    public Long getActiveTemplateCount() {
        return legalTemplateRepository.countActiveTemplates();
    }
    
    public Long getVerifiedTemplateCount() {
        return legalTemplateRepository.countVerifiedTemplates();
    }
    
    private LegalTemplateDto convertToDto(LegalTemplate template) {
        LegalTemplateDto dto = new LegalTemplateDto();
        dto.setId(template.getId());
        dto.setName(template.getName());
        dto.setDescription(template.getDescription());
        dto.setTemplateType(template.getTemplateType());
        dto.setPropertyType(template.getPropertyType());
        dto.setListingType(template.getListingType());
        dto.setTemplateContent(template.getTemplateContent());
        dto.setIsActive(template.getIsActive());
        dto.setVersion(template.getVersion());
        dto.setIsVerified(template.getIsVerified());
        dto.setCreatedAt(template.getCreatedAt());
        dto.setUpdatedAt(template.getUpdatedAt());
        return dto;
    }
}
