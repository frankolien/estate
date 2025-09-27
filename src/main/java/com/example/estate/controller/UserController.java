package com.example.estate.controller;

import com.example.estate.dto.UserDto;
import com.example.estate.model.UserType;
import com.example.estate.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping
    public ResponseEntity<List<UserDto>> getAllUsers() {
        List<UserDto> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<UserDto> getUserById(@PathVariable Long id) {
        return userService.getUserById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/email/{email}")
    public ResponseEntity<UserDto> getUserByEmail(@PathVariable String email) {
        return userService.getUserByEmail(email)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/type/{userType}")
    public ResponseEntity<Page<UserDto>> getUsersByType(
            @PathVariable UserType userType,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<UserDto> users = userService.getUsersByType(userType, pageable);
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/city/{city}/type/{userType}")
    public ResponseEntity<List<UserDto>> getUsersByCityAndType(
            @PathVariable String city,
            @PathVariable UserType userType) {
        
        List<UserDto> users = userService.getUsersByCityAndType(city, userType);
        return ResponseEntity.ok(users);
    }
    
    @PostMapping
    public ResponseEntity<UserDto> createUser(@RequestBody UserDto userDto) {
        UserDto createdUser = userService.createUser(userDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdUser);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<UserDto> updateUser(@PathVariable Long id, @RequestBody UserDto userDto) {
        UserDto updatedUser = userService.updateUser(id, userDto);
        return ResponseEntity.ok(updatedUser);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
    
    @PutMapping("/verify/{token}")
    public ResponseEntity<Boolean> verifyUser(@PathVariable String token) {
        boolean verified = userService.verifyUser(token);
        return ResponseEntity.ok(verified);
    }
    
    @PostMapping("/reset-password")
    public ResponseEntity<Boolean> resetPassword(@RequestParam String email, 
                                                @RequestParam String newPassword) {
        boolean reset = userService.resetPassword(email, newPassword);
        return ResponseEntity.ok(reset);
    }
    
    @PostMapping("/generate-reset-token")
    public ResponseEntity<Void> generateResetPasswordToken(@RequestParam String email) {
        userService.generateResetPasswordToken(email);
        return ResponseEntity.ok().build();
    }
    
    @PutMapping("/{id}/activate")
    public ResponseEntity<Boolean> activateUser(@PathVariable Long id) {
        boolean activated = userService.activateUser(id);
        return ResponseEntity.ok(activated);
    }
    
    @PutMapping("/{id}/deactivate")
    public ResponseEntity<Boolean> deactivateUser(@PathVariable Long id) {
        boolean deactivated = userService.deactivateUser(id);
        return ResponseEntity.ok(deactivated);
    }
    
    @GetMapping("/stats/count/{userType}")
    public ResponseEntity<Long> getUserCountByType(@PathVariable UserType userType) {
        Long count = userService.getUserCountByType(userType);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/stats/verified-count")
    public ResponseEntity<Long> getVerifiedUserCount() {
        Long count = userService.getVerifiedUserCount();
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/exists/{email}")
    public ResponseEntity<Boolean> checkEmailExists(@PathVariable String email) {
        boolean exists = userService.existsByEmail(email);
        return ResponseEntity.ok(exists);
    }
}
