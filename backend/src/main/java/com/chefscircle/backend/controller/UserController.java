package com.chefscircle.backend.controller;

import com.chefscircle.backend.model.User;
import com.chefscircle.backend.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * REST Controller for user-related HTTP endpoints.
 * Handles authentication, user management, and profile operations.
 * Delegates business logic to UserService layer.
 */
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    // Constructor injection for dependency management
    public UserController(UserService userService) {
        this.userService = userService;
    }

    /**
     * GET endpoint to retrieve all users.
     * 
     * @return List of all users in the system
     */
    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    /**
     * POST endpoint for user authentication.
     * 
     * @param credentials Map containing email and password
     * @return ResponseEntity with user data on success or error message
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String email = credentials.get("email");
        String password = credentials.get("password");

        // Validate input parameters
        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Email is required");
        }
        
        if (password == null || password.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Password is required");
        }

        // Delegate authentication to service layer
        Optional<User> authenticatedUser = userService.authenticateUser(email, password);

        if (authenticatedUser.isPresent()) {
            return ResponseEntity.ok(authenticatedUser.get());
        } else {
            return ResponseEntity.status(401).body("Invalid email or password");
        }
    }

    /**
     * POST endpoint for user registration.
     * 
     * @param newUser User data for account creation
     * @return ResponseEntity with created user data or error message
     */
    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody User newUser) {
        // Delegate user creation to service layer
        return userService.createUser(newUser);
    }

    /**
     * PUT endpoint for updating user information.
     * 
     * @param id User ID to update
     * @param updatedUser New user data
     * @return ResponseEntity with updated user data or error message
     */
    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody User updatedUser) {
        // Delegate user update to service layer
        return userService.updateUser(id, updatedUser);
    }

    /**
     * GET endpoint to retrieve a specific user by ID.
     * 
     * @param id User ID to retrieve
     * @return ResponseEntity with user data or error message
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Long id) {
        Optional<User> user = userService.findUserById(id);
        
        if (user.isPresent()) {
            return ResponseEntity.ok(user.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * GET endpoint to retrieve a user by email address.
     * 
     * @param email Email address to search for
     * @return ResponseEntity with user data or error message
     */
    @GetMapping("/email/{email}")
    public ResponseEntity<?> getUserByEmail(@PathVariable String email) {
        Optional<User> user = userService.findUserByEmail(email);
        
        if (user.isPresent()) {
            return ResponseEntity.ok(user.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * GET endpoint to retrieve a user by username.
     * 
     * @param username Username to search for
     * @return ResponseEntity with user data or error message
     */
    @GetMapping("/username/{username}")
    public ResponseEntity<?> getUserByUsername(@PathVariable String username) {
        Optional<User> user = userService.findUserByUsername(username);
        
        if (user.isPresent()) {
            return ResponseEntity.ok(user.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}