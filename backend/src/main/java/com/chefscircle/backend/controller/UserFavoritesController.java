package com.chefscircle.backend.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chefscircle.backend.model.Cuisine;
import com.chefscircle.backend.model.UserFavoriteCuisine;
import com.chefscircle.backend.model.UserFavoriteCuisineId;
import com.chefscircle.backend.repository.CuisineRepository;
import com.chefscircle.backend.repository.UserFavoriteCuisineRepository;

@RestController
@RequestMapping("/api/users/{userId}/favorites")
@CrossOrigin(origins = "*")
public class UserFavoritesController {

    private final UserFavoriteCuisineRepository favoritesRepository;
    private final CuisineRepository cuisineRepository;

    public UserFavoritesController(UserFavoriteCuisineRepository favoritesRepository,
                                   CuisineRepository cuisineRepository) {
        this.favoritesRepository = favoritesRepository;
        this.cuisineRepository = cuisineRepository;
    }

    @GetMapping("/cuisines")
    public ResponseEntity<List<Cuisine>> listFavoriteCuisines(@PathVariable Long userId) {
        List<Long> cuisineIds = favoritesRepository.findByIdUserId(userId)
            .stream()
            .map(f -> f.getId().getCuisineId())
            .toList();

        List<Cuisine> cuisines = cuisineRepository.findAllById(cuisineIds);
        return ResponseEntity.ok(cuisines);
    }

    @PostMapping("/cuisines/{cuisineId}")
    public ResponseEntity<?> addFavoriteCuisine(@PathVariable Long userId, @PathVariable Long cuisineId) {
        if (favoritesRepository.existsByIdUserIdAndIdCuisineId(userId, cuisineId)) {
            return ResponseEntity.ok().build();
        }
        UserFavoriteCuisine favorite = new UserFavoriteCuisine();
        favorite.setId(new UserFavoriteCuisineId(userId, cuisineId));
        favoritesRepository.save(favorite);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/cuisines/{cuisineId}")
    @Transactional
    public ResponseEntity<?> removeFavoriteCuisine(@PathVariable Long userId, @PathVariable Long cuisineId) {
        UserFavoriteCuisineId id = new UserFavoriteCuisineId(userId, cuisineId);
        if (favoritesRepository.existsById(id)) {
            favoritesRepository.deleteById(id);
        }
        return ResponseEntity.noContent().build();
    }
}


