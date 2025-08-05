package com.chefscircle.backend.service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chefscircle.backend.model.Achievement;
import com.chefscircle.backend.model.AchievementDTO;
import com.chefscircle.backend.model.UserAchievement;
import com.chefscircle.backend.repository.AchievementRepository;
import com.chefscircle.backend.repository.UserAchievementRepository;

@Service
public class AchievementService {

    @Autowired
    private AchievementRepository achievementRepository;

    @Autowired
    private UserAchievementRepository userAchievementRepository;

    public List<AchievementDTO> getAchievementsForUser(Long userId) {
        List<Achievement> allAchievements = achievementRepository.findAll();
        List<UserAchievement> userAchievements = userAchievementRepository.findByIdUserId(userId);

        Set<Long> unlockedAchievementIds = userAchievements.stream()
                .map(ua -> ua.getId().getAchievementId())
                .collect(Collectors.toSet());

        return allAchievements.stream()
                .map(achievement -> new AchievementDTO(
                        achievement.getId(),
                        achievement.getTitle(),
                        achievement.getDescription(),
                        achievement.getIcon(),
                        unlockedAchievementIds.contains(achievement.getId())
                ))
                .collect(Collectors.toList());
    }
}
