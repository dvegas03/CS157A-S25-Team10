package com.chefscircle.backend.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "streak")
public class Streak {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "usr_id", nullable = false)
    private User user;

    private int currStreak;
    private int longestStreak;
    private LocalDate lastActiveDt;

    public Long getId() { return id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public int getCurrStreak() { return currStreak; }
    public void setCurrStreak(int currStreak) { this.currStreak = currStreak; }
    public int getLongestStreak() { return longestStreak; }
    public void setLongestStreak(int longestStreak) { this.longestStreak = longestStreak; }
    public LocalDate getLastActiveDt() { return lastActiveDt; }
    public void setLastActiveDt(LocalDate lastActiveDt) { this.lastActiveDt = lastActiveDt; }
}
