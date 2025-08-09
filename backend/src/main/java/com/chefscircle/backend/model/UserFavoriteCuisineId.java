package com.chefscircle.backend.model;

import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

@Embeddable
public class UserFavoriteCuisineId implements Serializable {
    private static final long serialVersionUID = 1L;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "cuisine_id")
    private Long cuisineId;

    public UserFavoriteCuisineId() {}

    public UserFavoriteCuisineId(Long userId, Long cuisineId) {
        this.userId = userId;
        this.cuisineId = cuisineId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getCuisineId() {
        return cuisineId;
    }

    public void setCuisineId(Long cuisineId) {
        this.cuisineId = cuisineId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserFavoriteCuisineId that = (UserFavoriteCuisineId) o;
        return Objects.equals(userId, that.userId) && Objects.equals(cuisineId, that.cuisineId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, cuisineId);
    }
}


