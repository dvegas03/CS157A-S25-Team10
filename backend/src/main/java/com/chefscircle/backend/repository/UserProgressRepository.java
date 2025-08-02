package com.chefscircle.backend.repository;

import com.chefscircle.backend.model.UserProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserProgressRepository extends JpaRepository<UserProgress, Long> {
    List<UserProgress> findByUserId(Long userId);
    Optional<UserProgress> findByUserIdAndLessonId(Long userId, Long lessonId);
    List<UserProgress> findByUserIdAndStatus(Long userId, String status);
} 