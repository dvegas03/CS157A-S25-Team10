package com.chefscircle.backend.repository;

import com.chefscircle.backend.model.Lesson;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {
    List<Lesson> findBySkillIdOrderByOrderIndex(Long skillId);
} 