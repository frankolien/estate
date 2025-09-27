package com.example.estate.dto;

import com.example.estate.model.DocumentType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;

public class DocumentDto {
    
    private Long id;
    
    @NotBlank
    @Size(max = 200)
    private String fileName;
    
    @NotBlank
    @Size(max = 500)
    private String filePath;
    
    @Size(max = 100)
    private String originalFileName;
    
    @Size(max = 50)
    private String fileType;
    
    private Long fileSize;
    
    private DocumentType documentType;
    
    private Boolean isVerified;
    
    private Boolean isPublic;
    
    @Size(max = 1000)
    private String description;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    private Long propertyId;
    
    private Long userId;
    
    private Long templateId;
    
    // Constructors
    public DocumentDto() {}
    
    public DocumentDto(Long id, String fileName, String filePath, String originalFileName,
                      String fileType, Long fileSize, DocumentType documentType,
                      Boolean isVerified, Boolean isPublic, String description,
                      LocalDateTime createdAt, LocalDateTime updatedAt,
                      Long propertyId, Long userId, Long templateId) {
        this.id = id;
        this.fileName = fileName;
        this.filePath = filePath;
        this.originalFileName = originalFileName;
        this.fileType = fileType;
        this.fileSize = fileSize;
        this.documentType = documentType;
        this.isVerified = isVerified;
        this.isPublic = isPublic;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.propertyId = propertyId;
        this.userId = userId;
        this.templateId = templateId;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getFileName() {
        return fileName;
    }
    
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
    
    public String getFilePath() {
        return filePath;
    }
    
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    
    public String getOriginalFileName() {
        return originalFileName;
    }
    
    public void setOriginalFileName(String originalFileName) {
        this.originalFileName = originalFileName;
    }
    
    public String getFileType() {
        return fileType;
    }
    
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
    
    public Long getFileSize() {
        return fileSize;
    }
    
    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }
    
    public DocumentType getDocumentType() {
        return documentType;
    }
    
    public void setDocumentType(DocumentType documentType) {
        this.documentType = documentType;
    }
    
    public Boolean getIsVerified() {
        return isVerified;
    }
    
    public void setIsVerified(Boolean isVerified) {
        this.isVerified = isVerified;
    }
    
    public Boolean getIsPublic() {
        return isPublic;
    }
    
    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Long getPropertyId() {
        return propertyId;
    }
    
    public void setPropertyId(Long propertyId) {
        this.propertyId = propertyId;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public Long getTemplateId() {
        return templateId;
    }
    
    public void setTemplateId(Long templateId) {
        this.templateId = templateId;
    }
}
