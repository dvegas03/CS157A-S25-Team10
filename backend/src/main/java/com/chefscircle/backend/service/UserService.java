package com.chefscircle.backend.service;

import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.chefscircle.backend.model.User;
import com.chefscircle.backend.repository.UserRepository;

// Business logic around users intentionally concise here to avoid over commenting
@Service
public class UserService {

    private final UserRepository userRepository;

    // Constructor injection for dependency management (preferred in new code)
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public Optional<User> authenticateUser(String email, String password) {
        Optional<User> userOptional = userRepository.findByEmail(email);
        
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            // FIXME plain text password check replace with hashing later
            // System.out.println("User authenticated: " + user.getEmail()) // left from a debug session
            if (password.equals(user.getPwd())) {
                return Optional.of(user);
            }
        }
        
        return Optional.empty();
    }

    public ResponseEntity<?> createUser(User newUser) {
        // Basic validation
        if (newUser.getName() == null || newUser.getName().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Name is required");
        }
        
        if (newUser.getEmail() == null || newUser.getEmail().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Email is required");
        }
        
        if (newUser.getUsername() == null || newUser.getUsername().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Username is required");
        }
        
        if (newUser.getPwd() == null || newUser.getPwd().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Password is required");
        }

        if (userRepository.findByUsername(newUser.getUsername()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Username is already taken");
        }

        if (userRepository.findByEmail(newUser.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email is already in use");
        }

        User savedUser = userRepository.save(newUser);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedUser);
    }

    public ResponseEntity<?> updateUser(Long id, User updatedUser) {
        Optional<User> existingUserOptional = userRepository.findById(id);
        
        if (existingUserOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        User userToUpdate = existingUserOptional.get();
        
        boolean isUsernameChanged = !userToUpdate.getUsername().equals(updatedUser.getUsername());
        if (isUsernameChanged && userRepository.findByUsername(updatedUser.getUsername()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Username is already taken");
        }
        
        boolean isEmailChanged = !userToUpdate.getEmail().equals(updatedUser.getEmail());
        if (isEmailChanged && userRepository.findByEmail(updatedUser.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email is already in use");
        }
        
        userToUpdate.setName(updatedUser.getName());
        userToUpdate.setUsername(updatedUser.getUsername());
        userToUpdate.setEmail(updatedUser.getEmail());

        // Update is_admin if present (keep optional to avoid unintended resets)
        if (updatedUser.getIsAdmin() != null) {
            userToUpdate.setIsAdmin(updatedUser.getIsAdmin());
        }
        
        if (updatedUser.getPwd() != null && !updatedUser.getPwd().trim().isEmpty()) {
            userToUpdate.setPwd(updatedUser.getPwd());
        }
        
        User savedUser = userRepository.save(userToUpdate);
        return ResponseEntity.ok(savedUser);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> findUserById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> findUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Optional<User> findUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public ResponseEntity<?> updateProfileImage(Long id, String profileImage) {
        Optional<User> existingUserOptional = userRepository.findById(id);

        if (existingUserOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        User userToUpdate = existingUserOptional.get();
        userToUpdate.setProfileImage(profileImage);

        User savedUser = userRepository.save(userToUpdate);
        return ResponseEntity.ok(savedUser);
    }

    public boolean deleteUserById(Long id) {
        if (userRepository.existsById(id)) {
            userRepository.deleteById(id);
            return true; // HACK: hard delete
        }
        return false;
    }
} 