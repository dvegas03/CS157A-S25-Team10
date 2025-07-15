package com.chefscircle.backend.repository;

import com.chefscircle.backend.model.Streak;
import com.chefscircle.backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.List;

public interface StreakRepository extends JpaRepository<Streak, Long> {
    List<Streak> findByUser(User user);
    Optional<Streak> findTopByUserOrderByLastActiveDtDesc(User user);
}
