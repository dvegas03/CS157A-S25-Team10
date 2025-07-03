package com.chefscircle.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.chefscircle.backend.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
}
