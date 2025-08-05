package com.chefscircle.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.chefscircle.backend.model.UserAchievement;
import com.chefscircle.backend.model.UserAchievementId;

public interface UserAchievementRepository extends JpaRepository<UserAchievement, UserAchievementId> {
    List<UserAchievement> findByIdUserId(Long userId);
}
