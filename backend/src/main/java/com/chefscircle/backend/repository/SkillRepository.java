package com.chefscircle.backend.repository;

import com.chefscircle.backend.model.Skill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SkillRepository extends JpaRepository<Skill, Long> {
    List<Skill> findByCuisineIdOrderByOrderIndex(Long cuisineId);
} 