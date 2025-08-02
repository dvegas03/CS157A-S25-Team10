import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useLessonData } from '../hooks/useLessonData';

/**
 * LessonContentPage component that displays the full lesson content.
 * Shows lesson sections and provides navigation to quiz.
 */
const LessonContentPage = () => {
  const navigate = useNavigate();
  const { lessonId } = useParams();
  const { lessonData, loading, error } = useLessonData(lessonId);

  const handleStartQuiz = () => {
    navigate(`/lesson/${lessonId}/quiz`);
  };

  const handleBackToLesson = () => {
    navigate(`/lesson/${lessonId}`);
  };

  // Show loading state while fetching data
  if (loading) {
    return (
      <main className="app-main">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Loading lesson content...</p>
        </div>
      </main>
    );
  }

  // Show error state if there's an error
  if (error) {
    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={handleBackToLesson} className="back-btn">
            ← Back to Lesson
          </button>
          <h2>Error</h2>
        </div>
        <div className="error-message">
          <h3>❌ Error Loading Content</h3>
          <p>{error}</p>
          <button onClick={handleBackToLesson} className="retry-btn">
            Back to Lesson
          </button>
        </div>
      </main>
    );
  }

  const { lesson, content } = lessonData;

  return (
    <main className="app-main">
      <div className="page-header">
        <button onClick={handleBackToLesson} className="back-btn">
          ← Back to Lesson
        </button>
        <h2>{lesson?.icon || '📚'} {lesson?.name || 'Lesson Content'}</h2>
      </div>
      
      <div className="lesson-content-section">
        <div className="content-container">
          {content.length > 0 ? (
            content.map((section, index) => (
              <div key={index} className="content-section">
                <h3 className="section-title">{section.sectionTitle}</h3>
                <p className="section-text">{section.contentText}</p>
              </div>
            ))
          ) : (
            <div className="content-section">
              <h3 className="section-title">Coming Soon</h3>
              <p className="section-text">
                This lesson content is being prepared. In the meantime, you can take the quiz to test your knowledge!
              </p>
            </div>
          )}
        </div>
        
        <div className="quiz-section">
          <div className="quiz-intro">
            <h3>Ready to test your knowledge?</h3>
            <p>Take the quiz to complete this lesson and unlock the next one!</p>
          </div>
          <button onClick={handleStartQuiz} className="start-quiz-btn">
            🧠 Start Quiz
          </button>
        </div>
      </div>
    </main>
  );
};

export default LessonContentPage; 