package com.chefscircle.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.chefscircle.backend.model.UserFavoriteCuisine;
import com.chefscircle.backend.model.UserFavoriteCuisineId;

public interface UserFavoriteCuisineRepository extends JpaRepository<UserFavoriteCuisine, UserFavoriteCuisineId> {
    List<UserFavoriteCuisine> findByIdUserId(Long userId);
    void deleteByIdUserIdAndIdCuisineId(Long userId, Long cuisineId);
    boolean existsByIdUserIdAndIdCuisineId(Long userId, Long cuisineId);
}