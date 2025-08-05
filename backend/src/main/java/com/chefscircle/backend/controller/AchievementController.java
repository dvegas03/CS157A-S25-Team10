package com.chefscircle.backend.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chefscircle.backend.model.AchievementDTO;
import com.chefscircle.backend.service.AchievementService;

@RestController
@RequestMapping("/api/achievements")
public class AchievementController {

    @Autowired
    private AchievementService achievementService;

    @GetMapping("/user/{userId}")
    public List<AchievementDTO> getUserAchievements(@PathVariable Long userId) {
        return achievementService.getAchievementsForUser(userId);
    }
}
