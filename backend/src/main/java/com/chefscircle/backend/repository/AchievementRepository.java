package com.chefscircle.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.chefscircle.backend.model.Achievement;

public interface AchievementRepository extends JpaRepository<Achievement, Long> {
}
