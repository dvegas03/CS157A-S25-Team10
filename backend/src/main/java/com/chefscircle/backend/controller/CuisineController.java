package com.chefscircle.backend.controller;

import com.chefscircle.backend.model.Cuisine;
import com.chefscircle.backend.repository.CuisineRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * Handles API requests related to culinary cuisines.
 */
@RestController
@RequestMapping("/api/cuisines")
@CrossOrigin(origins = "*")
public class CuisineController {

    private final CuisineRepository cuisineRepository;

    public CuisineController(CuisineRepository cuisineRepository) {
        this.cuisineRepository = cuisineRepository;
    }

    @GetMapping
    public ResponseEntity<List<Cuisine>> getAllCuisines() {
        List<Cuisine> cuisines = cuisineRepository.findAll();
        return ResponseEntity.ok(cuisines);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Cuisine> getCuisineById(@PathVariable Long id) {
        Optional<Cuisine> cuisine = cuisineRepository.findById(id);
        
        return cuisine.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}