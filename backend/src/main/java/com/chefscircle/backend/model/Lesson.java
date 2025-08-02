package com.chefscircle.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "lessons")
public class Lesson {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "skill_id")
    private Long skillId;
    
    @Column(name = "name")
    private String name;
    
    @Column(name = "description")
    private String description;
    
    @Column(name = "order_index")
    private Integer orderIndex;
    
    @Column(name = "xp_reward")
    private Integer xpReward;
    
    @Column(name = "icon")
    private String icon;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // Constructors
    public Lesson() {}
    
    public Lesson(Long skillId, String name, String description, Integer orderIndex, Integer xpReward, String icon) {
        this.skillId = skillId;
        this.name = name;
        this.description = description;
        this.orderIndex = orderIndex;
        this.xpReward = xpReward;
        this.icon = icon;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getSkillId() {
        return skillId;
    }
    
    public void setSkillId(Long skillId) {
        this.skillId = skillId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Integer getOrderIndex() {
        return orderIndex;
    }
    
    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }
    
    public Integer getXpReward() {
        return xpReward;
    }
    
    public void setXpReward(Integer xpReward) {
        this.xpReward = xpReward;
    }
    
    public String getIcon() {
        return icon;
    }
    
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
} 