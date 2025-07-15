package com.chefscircle.backend.controller;

import com.chefscircle.backend.model.Streak;
import com.chefscircle.backend.model.User;
import com.chefscircle.backend.repository.StreakRepository;
import com.chefscircle.backend.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/streaks")
public class StreakController {

    private final StreakRepository streakRepository;
    private final UserRepository userRepository;

    public StreakController(StreakRepository streakRepository, UserRepository userRepository) {
        this.streakRepository = streakRepository;
        this.userRepository = userRepository;
    }

    @GetMapping
    public List<Streak> getAllStreaks() {
        return streakRepository.findAll();
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getStreaksByUser(@PathVariable Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        List<Streak> streaks = streakRepository.findByUser(userOpt.get());
        return ResponseEntity.ok(streaks);
    }

    @PostMapping("/user/{userId}")
    public ResponseEntity<?> addOrUpdateStreak(
            @PathVariable Long userId,
            @RequestBody Streak streakData
    ) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        streakData.setUser(userOpt.get());
        Streak savedStreak = streakRepository.save(streakData);
        return ResponseEntity.ok(savedStreak);
    }
}
