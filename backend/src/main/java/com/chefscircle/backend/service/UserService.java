package com.chefscircle.backend.service;

import com.chefscircle.backend.model.User;
import com.chefscircle.backend.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for user-related business logic.
 * Handles authentication, user management, and validation.
 */
@Service
public class UserService {

    private final UserRepository userRepository;

    // Constructor injection for dependency management
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Authenticates a user with email and password.
     * 
     * @param email User's email address
     * @param password User's password
     * @return Optional containing the user if authentication succeeds, empty otherwise
     */
    public Optional<User> authenticateUser(String email, String password) {
        Optional<User> userOptional = userRepository.findByEmail(email);
        
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            // TODO: In production, use BCrypt or similar password encoder
            // For educational purposes only - plain text comparison
            if (password.equals(user.getPwd())) {
                return Optional.of(user);
            }
        }
        
        return Optional.empty();
    }

    /**
     * Creates a new user account with validation.
     * 
     * @param newUser User data to create
     * @return ResponseEntity with success/error status and message
     */
    public ResponseEntity<?> createUser(User newUser) {
        // Validate required fields
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

        // Check if username is already taken
        if (userRepository.findByUsername(newUser.getUsername()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Username is already taken");
        }

        // Check if email is already in use
        if (userRepository.findByEmail(newUser.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email is already in use");
        }

        // Save the new user
        User savedUser = userRepository.save(newUser);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedUser);
    }

    /**
     * Updates an existing user's information.
     * 
     * @param id User ID to update
     * @param updatedUser New user data
     * @return ResponseEntity with success/error status and message
     */
    public ResponseEntity<?> updateUser(Long id, User updatedUser) {
        Optional<User> existingUserOptional = userRepository.findById(id);
        
        if (existingUserOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        User userToUpdate = existingUserOptional.get();
        
        // Validate that username is not being changed to one that's already taken
        boolean isUsernameChanged = !userToUpdate.getUsername().equals(updatedUser.getUsername());
        if (isUsernameChanged && userRepository.findByUsername(updatedUser.getUsername()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Username is already taken");
        }
        
        // Validate that email is not being changed to one that already exists
        boolean isEmailChanged = !userToUpdate.getEmail().equals(updatedUser.getEmail());
        if (isEmailChanged && userRepository.findByEmail(updatedUser.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email is already in use");
        }
        
        // Update user fields
        userToUpdate.setName(updatedUser.getName());
        userToUpdate.setUsername(updatedUser.getUsername());
        userToUpdate.setEmail(updatedUser.getEmail());
        
        // TODO: Add password update functionality with proper hashing
        // For now, only update password if provided
        if (updatedUser.getPwd() != null && !updatedUser.getPwd().trim().isEmpty()) {
            userToUpdate.setPwd(updatedUser.getPwd());
        }
        
        User savedUser = userRepository.save(userToUpdate);
        return ResponseEntity.ok(savedUser);
    }

    /**
     * Retrieves all users from the database.
     * 
     * @return List of all users
     */
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    /**
     * Finds a user by their ID.
     * 
     * @param id User ID to find
     * @return Optional containing the user if found
     */
    public Optional<User> findUserById(Long id) {
        return userRepository.findById(id);
    }

    /**
     * Finds a user by their email address.
     * 
     * @param email Email address to search for
     * @return Optional containing the user if found
     */
    public Optional<User> findUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Finds a user by their username.
     * 
     * @param username Username to search for
     * @return Optional containing the user if found
     */
    public Optional<User> findUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }
} 