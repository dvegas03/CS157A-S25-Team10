package com.chefscircle.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "quizzes")
public class Quiz {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "lesson_id")
    private Long lessonId;
    
    @Column(name = "question_text")
    private String questionText;
    
    @Column(name = "correct_answer")
    private String correctAnswer;
    
    @Column(name = "wrong_answer_1")
    private String wrongAnswer1;
    
    @Column(name = "wrong_answer_2")
    private String wrongAnswer2;
    
    @Column(name = "wrong_answer_3")
    private String wrongAnswer3;
    
    @Column(name = "explanation")
    private String explanation;
    
    @Column(name = "order_index")
    private Integer orderIndex;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // Constructors
    public Quiz() {}
    
    public Quiz(Long lessonId, String questionText, String correctAnswer, String wrongAnswer1, 
                String wrongAnswer2, String wrongAnswer3, String explanation, Integer orderIndex) {
        this.lessonId = lessonId;
        this.questionText = questionText;
        this.correctAnswer = correctAnswer;
        this.wrongAnswer1 = wrongAnswer1;
        this.wrongAnswer2 = wrongAnswer2;
        this.wrongAnswer3 = wrongAnswer3;
        this.explanation = explanation;
        this.orderIndex = orderIndex;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getLessonId() {
        return lessonId;
    }
    
    public void setLessonId(Long lessonId) {
        this.lessonId = lessonId;
    }
    
    public String getQuestionText() {
        return questionText;
    }
    
    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }
    
    public String getCorrectAnswer() {
        return correctAnswer;
    }
    
    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }
    
    public String getWrongAnswer1() {
        return wrongAnswer1;
    }
    
    public void setWrongAnswer1(String wrongAnswer1) {
        this.wrongAnswer1 = wrongAnswer1;
    }
    
    public String getWrongAnswer2() {
        return wrongAnswer2;
    }
    
    public void setWrongAnswer2(String wrongAnswer2) {
        this.wrongAnswer2 = wrongAnswer2;
    }
    
    public String getWrongAnswer3() {
        return wrongAnswer3;
    }
    
    public void setWrongAnswer3(String wrongAnswer3) {
        this.wrongAnswer3 = wrongAnswer3;
    }
    
    public String getExplanation() {
        return explanation;
    }
    
    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }
    
    public Integer getOrderIndex() {
        return orderIndex;
    }
    
    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
} 