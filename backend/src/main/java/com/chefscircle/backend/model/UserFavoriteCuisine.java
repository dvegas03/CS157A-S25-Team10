package com.chefscircle.backend.model;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "user_favorite_cuisines")
public class UserFavoriteCuisine {

    @EmbeddedId
    private UserFavoriteCuisineId id;

    public UserFavoriteCuisineId getId() {
        return id;
    }

    public void setId(UserFavoriteCuisineId id) {
        this.id = id;
    }
}


