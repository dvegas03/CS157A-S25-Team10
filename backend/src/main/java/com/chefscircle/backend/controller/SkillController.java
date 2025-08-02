package com.chefscircle.backend.controller;

import com.chefscircle.backend.model.Skill;
import com.chefscircle.backend.repository.SkillRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/skills")
@CrossOrigin(origins = "*")
public class SkillController {

    @Autowired
    private SkillRepository skillRepository;

    @GetMapping
    public ResponseEntity<List<Skill>> getAllSkills() {
        List<Skill> skills = skillRepository.findAll();
        return ResponseEntity.ok(skills);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Skill> getSkillById(@PathVariable Long id) {
        return skillRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/cuisine/{cuisineId}")
    public ResponseEntity<List<Skill>> getSkillsByCuisine(@PathVariable Long cuisineId) {
        List<Skill> skills = skillRepository.findByCuisineIdOrderByOrderIndex(cuisineId);
        return ResponseEntity.ok(skills);
    }
} 