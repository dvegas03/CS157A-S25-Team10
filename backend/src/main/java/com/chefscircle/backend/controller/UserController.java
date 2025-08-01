package com.chefscircle.backend.controller;

import com.chefscircle.backend.model.User;
import com.chefscircle.backend.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String email = credentials.get("email");
        String password = credentials.get("password");

        Optional<User> userOptional = userRepository.findByEmail(email);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (password.equals(user.getPwd())) {
                return ResponseEntity.ok(user);
            }
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
    }

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody User newUser) {
        if (userRepository.findByUsername(newUser.getUsername()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Username is already taken");
        }

        if (userRepository.findByEmail(newUser.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email is already in use");
        }
        
        User savedUser = userRepository.save(newUser);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedUser);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody User updatedUser) {
        Optional<User> existingUser = userRepository.findById(id);
        
        if (!existingUser.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        User user = existingUser.get();
        
        // Check if username is being changed and if it's already taken
        if (!user.getUsername().equals(updatedUser.getUsername()) && 
            userRepository.findByUsername(updatedUser.getUsername()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Username is already taken");
        }
        
        // Check if email is being changed and if it's already taken
        if (!user.getEmail().equals(updatedUser.getEmail()) && 
            userRepository.findByEmail(updatedUser.getEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email is already in use");
        }
        
        user.setName(updatedUser.getName());
        user.setUsername(updatedUser.getUsername());
        user.setEmail(updatedUser.getEmail());
        
        User savedUser = userRepository.save(user);
        return ResponseEntity.ok(savedUser);
    }
}
