package com.chefscircle.backend.controller;

import com.chefscircle.backend.model.UserProgress;
import com.chefscircle.backend.repository.UserProgressRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/user-progress")
@CrossOrigin(origins = "*")
public class UserProgressController {

    private final UserProgressRepository userProgressRepository;

    public UserProgressController(UserProgressRepository userProgressRepository) {
        this.userProgressRepository = userProgressRepository;
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<UserProgress>> getUserProgress(@PathVariable Long userId) {
        List<UserProgress> progress = userProgressRepository.findByUserId(userId);
        return ResponseEntity.ok(progress);
    }
    
    /**
     * Creates or updates a user's progress for a specific lesson.
     * This allows tracking partial progress, scores, or completion status.
     */
    @PostMapping("/update")
    public ResponseEntity<UserProgress> updateProgress(@RequestBody UserProgress userProgress) {
        // Check if progress for this user and lesson already exists.
        Optional<UserProgress> existingProgressOpt = userProgressRepository.findByUserIdAndLessonId(
            userProgress.getUserId(), userProgress.getLessonId());
        
        if (existingProgressOpt.isPresent()) {
            // If it exists, update the existing record.
            UserProgress existing = existingProgressOpt.get();
            existing.setStatus(userProgress.getStatus());
            existing.setScore(userProgress.getScore());
            if ("completed".equals(userProgress.getStatus())) {
                existing.setCompletedAt(LocalDateTime.now());
            }
            UserProgress savedProgress = userProgressRepository.save(existing);
            return ResponseEntity.ok(savedProgress);
        } else {
            // Otherwise, create a new progress record.
            userProgress.setCreatedAt(LocalDateTime.now());
            if ("completed".equals(userProgress.getStatus())) {
                userProgress.setCompletedAt(LocalDateTime.now());
            }
            UserProgress savedProgress = userProgressRepository.save(userProgress);
            return ResponseEntity.ok(savedProgress);
        }
    }

    // Other methods remain the same...

    @GetMapping("/user/{userId}/lesson/{lessonId}")
    public ResponseEntity<UserProgress> getUserLessonProgress(@PathVariable Long userId, @PathVariable Long lessonId) {
        Optional<UserProgress> progress = userProgressRepository.findByUserIdAndLessonId(userId, lessonId);
        return progress.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/complete")
    public ResponseEntity<UserProgress> completeLesson(@RequestBody UserProgress userProgress) {
        userProgress.setCompletedAt(LocalDateTime.now());
        userProgress.setStatus("completed");
        
        UserProgress savedProgress = userProgressRepository.save(userProgress);
        return ResponseEntity.ok(savedProgress);
    }

    @GetMapping("/user/{userId}/completed")
    public ResponseEntity<List<UserProgress>> getCompletedLessons(@PathVariable Long userId) {
        List<UserProgress> completedProgress = userProgressRepository.findByUserIdAndStatus(userId, "completed");
        return ResponseEntity.ok(completedProgress);
    }
}