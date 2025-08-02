package com.chefscircle.backend.controller;

import com.chefscircle.backend.model.Lesson;
import com.chefscircle.backend.model.LessonContent;
import com.chefscircle.backend.model.Quiz;
import com.chefscircle.backend.repository.LessonRepository;
import com.chefscircle.backend.repository.LessonContentRepository;
import com.chefscircle.backend.repository.QuizRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/lessons")
@CrossOrigin(origins = "*")
public class LessonController {

    private final LessonRepository lessonRepository;
    private final LessonContentRepository lessonContentRepository;
    private final QuizRepository quizRepository;

    public LessonController(LessonRepository lessonRepository, 
                            LessonContentRepository lessonContentRepository, 
                            QuizRepository quizRepository) {
        this.lessonRepository = lessonRepository;
        this.lessonContentRepository = lessonContentRepository;
        this.quizRepository = quizRepository;
    }

    @GetMapping
    public ResponseEntity<List<Lesson>> getAllLessons() {
        List<Lesson> lessons = lessonRepository.findAll();
        return ResponseEntity.ok(lessons);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Lesson> getLessonById(@PathVariable Long id) {
        return lessonRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    // This convenience endpoint aggregates the lesson, its content, and its quizzes 
    // into a single API call to improve client-side performance.
    @GetMapping("/{id}/full")
    public ResponseEntity<Map<String, Object>> getFullLesson(@PathVariable Long id) {
        return lessonRepository.findById(id)
                .map(lesson -> {
                    List<LessonContent> content = lessonContentRepository.findByLessonIdOrderByOrderIndex(id);
                    List<Quiz> quizzes = quizRepository.findByLessonIdOrderByOrderIndex(id);
                    
                    Map<String, Object> fullLesson = Map.of(
                        "lesson", lesson,
                        "content", content,
                        "quizzes", quizzes
                    );
                    
                    return ResponseEntity.ok(fullLesson);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/content")
    public ResponseEntity<List<LessonContent>> getLessonContent(@PathVariable Long id) {
        List<LessonContent> content = lessonContentRepository.findByLessonIdOrderByOrderIndex(id);
        return ResponseEntity.ok(content);
    }

    @GetMapping("/{id}/quizzes")
    public ResponseEntity<List<Quiz>> getLessonQuizzes(@PathVariable Long id) {
        List<Quiz> quizzes = quizRepository.findByLessonIdOrderByOrderIndex(id);
        return ResponseEntity.ok(quizzes);
    }

    @GetMapping("/skill/{skillId}")
    public ResponseEntity<List<Lesson>> getLessonsBySkill(@PathVariable Long skillId) {
        List<Lesson> lessons = lessonRepository.findBySkillIdOrderByOrderIndex(skillId);
        return ResponseEntity.ok(lessons);
    }
}