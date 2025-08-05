package com.chefscircle.backend.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chefscircle.backend.model.Lesson;
import com.chefscircle.backend.model.Skill;
import com.chefscircle.backend.model.User;
import com.chefscircle.backend.model.UserAchievement;
import com.chefscircle.backend.model.UserAchievementId;
import com.chefscircle.backend.model.UserProgress;
import com.chefscircle.backend.repository.LessonRepository;
import com.chefscircle.backend.repository.SkillRepository;
import com.chefscircle.backend.repository.UserAchievementRepository;
import com.chefscircle.backend.repository.UserProgressRepository;
import com.chefscircle.backend.repository.UserRepository;


@RestController
@RequestMapping("/api/user-progress")
@CrossOrigin(origins = "*")
public class UserProgressController {

    private final UserProgressRepository userProgressRepository;
    private final UserAchievementRepository userAchievementRepository;
    private final LessonRepository lessonRepository;
    private final SkillRepository skillRepository;
    private final UserRepository userRepository;

    public UserProgressController(UserProgressRepository userProgressRepository,
                                  UserAchievementRepository userAchievementRepository,
                                  LessonRepository lessonRepository,
                                  SkillRepository skillRepository,
                                  UserRepository userRepository) {
        this.userProgressRepository = userProgressRepository;
        this.userAchievementRepository = userAchievementRepository;
        this.lessonRepository = lessonRepository;
        this.skillRepository = skillRepository;
        this.userRepository = userRepository;
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
    @Transactional
    public ResponseEntity<UserProgress> updateProgress(@RequestBody UserProgress userProgress) {
        // Check if progress for this user and lesson already exists.
        Optional<UserProgress> existingProgressOpt = userProgressRepository.findByUserIdAndLessonId(
            userProgress.getUserId(), userProgress.getLessonId());
        
        boolean justCompleted = false;

        if (existingProgressOpt.isPresent()) {
            // If it exists, update the existing record.
            UserProgress existing = existingProgressOpt.get();
            String oldStatus = existing.getStatus();
            existing.setStatus(userProgress.getStatus());
            existing.setScore(userProgress.getScore());
            if ("completed".equals(userProgress.getStatus())) {
                existing.setCompletedAt(LocalDateTime.now());
                if (!"completed".equals(oldStatus)) {
                    justCompleted = true;
                }
            }
            UserProgress savedProgress = userProgressRepository.save(existing);
            if (justCompleted) {
                awardXpForLessonCompletion(savedProgress.getUserId(), savedProgress.getLessonId());
                checkAndAwardAchievements(savedProgress.getUserId());
            }
            return ResponseEntity.ok(savedProgress);
        } else {
            // Otherwise, create a new progress record.
            userProgress.setCreatedAt(LocalDateTime.now());
            if ("completed".equals(userProgress.getStatus())) {
                userProgress.setCompletedAt(LocalDateTime.now());
                justCompleted = true;
            }
            UserProgress savedProgress = userProgressRepository.save(userProgress);
            if (justCompleted) {
                awardXpForLessonCompletion(savedProgress.getUserId(), savedProgress.getLessonId());
                checkAndAwardAchievements(savedProgress.getUserId());
            }
            return ResponseEntity.ok(savedProgress);
        }
    }

    private void awardXpForLessonCompletion(Long userId, Long lessonId) {
        Optional<User> userOpt = userRepository.findById(userId);
        Optional<Lesson> lessonOpt = lessonRepository.findById(lessonId);

        if (userOpt.isPresent() && lessonOpt.isPresent()) {
            User user = userOpt.get();
            Lesson lesson = lessonOpt.get();
            user.setXp(user.getXp() + lesson.getXpReward());
            userRepository.save(user);
        }
    }

    private void checkAndAwardAchievements(Long userId) {
        long italianCuisineId = 1L; // HACK: Assuming Italian cuisine ID is 1
        long italianBeginnerAchievementId = 1L; // HACK: Assuming Italian Beginner achievement ID is 1
        long italianNoviceAchievementId = 2L; // HACK: Assuming Italian Novice achievement ID is 2

        // 1. Get user's existing achievements
        Set<Long> existingAchievementIds = userAchievementRepository.findByIdUserId(userId)
                .stream()
                .map(ach -> ach.getId().getAchievementId())
                .collect(Collectors.toSet());

        // 2. Get user's completed lessons and map to cuisines
        List<UserProgress> completedProgress = userProgressRepository.findByUserIdAndStatus(userId, "completed");
        List<Long> lessonIds = completedProgress.stream().map(UserProgress::getLessonId).collect(Collectors.toList());
        
        if (lessonIds.isEmpty()) {
            return;
        }

        List<Lesson> lessons = lessonRepository.findAllById(lessonIds);
        List<Long> skillIds = lessons.stream().map(Lesson::getSkillId).distinct().collect(Collectors.toList());
        Map<Long, Long> skillToCuisineMap = skillRepository.findAllById(skillIds)
                .stream()
                .collect(Collectors.toMap(Skill::getId, Skill::getCuisineId));

        Map<Long, Long> lessonToCuisineMap = lessons.stream()
                .filter(l -> skillToCuisineMap.containsKey(l.getSkillId()))
                .collect(Collectors.toMap(Lesson::getId, l -> skillToCuisineMap.get(l.getSkillId())));
        
        // 3. Count completed lessons for Italian cuisine
        long italianLessonsCompleted = completedProgress.stream()
                .map(UserProgress::getLessonId)
                .map(lessonToCuisineMap::get)
                .filter(cId -> cId != null && cId.equals(italianCuisineId))
                .count();

        // 4. Check and award "Italian Beginner"
        if (italianLessonsCompleted >= 1 && !existingAchievementIds.contains(italianBeginnerAchievementId)) {
            UserAchievement newAchievement = new UserAchievement();
            newAchievement.setId(new UserAchievementId(userId, italianBeginnerAchievementId));
            userAchievementRepository.save(newAchievement);
        }

        // 5. Check and award "Italian Novice"
        if (italianLessonsCompleted >= 3 && !existingAchievementIds.contains(italianNoviceAchievementId)) {
            UserAchievement newAchievement = new UserAchievement();
            newAchievement.setId(new UserAchievementId(userId, italianNoviceAchievementId));
            userAchievementRepository.save(newAchievement);
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
