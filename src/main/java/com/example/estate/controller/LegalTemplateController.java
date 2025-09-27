package com.example.estate.controller;

import com.example.estate.dto.LegalTemplateDto;
import com.example.estate.model.ListingType;
import com.example.estate.model.PropertyType;
import com.example.estate.model.TemplateType;
import com.example.estate.service.LegalTemplateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/legal-templates")
@CrossOrigin(origins = "*")
public class LegalTemplateController {
    
    @Autowired
    private LegalTemplateService legalTemplateService;
    
    @GetMapping
    public ResponseEntity<List<LegalTemplateDto>> getAllTemplates() {
        List<LegalTemplateDto> templates = legalTemplateService.getAllTemplates();
        return ResponseEntity.ok(templates);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<LegalTemplateDto> getTemplateById(@PathVariable Long id) {
        return legalTemplateService.getTemplateById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/type/{templateType}")
    public ResponseEntity<List<LegalTemplateDto>> getTemplatesByType(@PathVariable TemplateType templateType) {
        List<LegalTemplateDto> templates = legalTemplateService.getTemplatesByType(templateType);
        return ResponseEntity.ok(templates);
    }
    
    @GetMapping("/property-type/{propertyType}")
    public ResponseEntity<List<LegalTemplateDto>> getTemplatesByPropertyType(@PathVariable PropertyType propertyType) {
        List<LegalTemplateDto> templates = legalTemplateService.getTemplatesByPropertyType(propertyType);
        return ResponseEntity.ok(templates);
    }
    
    @GetMapping("/listing-type/{listingType}")
    public ResponseEntity<List<LegalTemplateDto>> getTemplatesByListingType(@PathVariable ListingType listingType) {
        List<LegalTemplateDto> templates = legalTemplateService.getTemplatesByListingType(listingType);
        return ResponseEntity.ok(templates);
    }
    
    @GetMapping("/active")
    public ResponseEntity<List<LegalTemplateDto>> getActiveTemplates() {
        List<LegalTemplateDto> templates = legalTemplateService.getActiveTemplates();
        return ResponseEntity.ok(templates);
    }
    
    @GetMapping("/verified")
    public ResponseEntity<List<LegalTemplateDto>> getVerifiedTemplates() {
        List<LegalTemplateDto> templates = legalTemplateService.getVerifiedTemplates();
        return ResponseEntity.ok(templates);
    }
    
    @GetMapping("/active-verified")
    public ResponseEntity<List<LegalTemplateDto>> getActiveAndVerifiedTemplates() {
        List<LegalTemplateDto> templates = legalTemplateService.getActiveAndVerifiedTemplates();
        return ResponseEntity.ok(templates);
    }
    
    @GetMapping("/filter")
    public ResponseEntity<List<LegalTemplateDto>> getTemplatesByFilter(
            @RequestParam(required = false) TemplateType templateType,
            @RequestParam(required = false) PropertyType propertyType,
            @RequestParam(required = false) ListingType listingType) {
        
        List<LegalTemplateDto> templates;
        
        if (templateType != null && propertyType != null && listingType != null) {
            templates = legalTemplateService.getTemplatesByTypeAndPropertyAndListing(
                    templateType, propertyType, listingType);
        } else if (templateType != null) {
            templates = legalTemplateService.getTemplatesByType(templateType);
        } else if (propertyType != null) {
            templates = legalTemplateService.getTemplatesByPropertyType(propertyType);
        } else if (listingType != null) {
            templates = legalTemplateService.getTemplatesByListingType(listingType);
        } else {
            templates = legalTemplateService.getActiveAndVerifiedTemplates();
        }
        
        return ResponseEntity.ok(templates);
    }
    
    @PostMapping
    public ResponseEntity<LegalTemplateDto> createTemplate(@RequestBody LegalTemplateDto templateDto) {
        LegalTemplateDto createdTemplate = legalTemplateService.createTemplate(templateDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdTemplate);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<LegalTemplateDto> updateTemplate(@PathVariable Long id, 
                                                          @RequestBody LegalTemplateDto templateDto) {
        LegalTemplateDto updatedTemplate = legalTemplateService.updateTemplate(id, templateDto);
        return ResponseEntity.ok(updatedTemplate);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTemplate(@PathVariable Long id) {
        legalTemplateService.deleteTemplate(id);
        return ResponseEntity.noContent().build();
    }
    
    @PutMapping("/{id}/activate")
    public ResponseEntity<Boolean> activateTemplate(@PathVariable Long id) {
        boolean activated = legalTemplateService.activateTemplate(id);
        return ResponseEntity.ok(activated);
    }
    
    @PutMapping("/{id}/deactivate")
    public ResponseEntity<Boolean> deactivateTemplate(@PathVariable Long id) {
        boolean deactivated = legalTemplateService.deactivateTemplate(id);
        return ResponseEntity.ok(deactivated);
    }
    
    @PutMapping("/{id}/verify")
    public ResponseEntity<Boolean> verifyTemplate(@PathVariable Long id) {
        boolean verified = legalTemplateService.verifyTemplate(id);
        return ResponseEntity.ok(verified);
    }
    
    @GetMapping("/stats/count/{templateType}")
    public ResponseEntity<Long> getTemplateCountByType(@PathVariable TemplateType templateType) {
        Long count = legalTemplateService.getTemplateCountByType(templateType);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/stats/active-count")
    public ResponseEntity<Long> getActiveTemplateCount() {
        Long count = legalTemplateService.getActiveTemplateCount();
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/stats/verified-count")
    public ResponseEntity<Long> getVerifiedTemplateCount() {
        Long count = legalTemplateService.getVerifiedTemplateCount();
        return ResponseEntity.ok(count);
    }
}
