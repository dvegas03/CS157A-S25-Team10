import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useLessonData } from '../hooks/useLessonData';

/**
 * LessonPage component that displays lesson information and content directly.
 * Shows lesson content inline and provides access to quiz.
 */
const LessonPage = () => {
  const navigate = useNavigate();
  const { lessonId } = useParams();
  const { lessonData, loading, error } = useLessonData(lessonId);

  const handleTakeQuiz = () => {
    navigate(`/lesson/${lessonId}/quiz`);
  };

  const handleBackToSkill = () => {
    navigate(-1);
  };

  // Show loading state while fetching data
  if (loading) {
    return (
      <main className="app-main">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Loading lesson details...</p>
        </div>
      </main>
    );
  }

  // Show error state if there's an error
  if (error) {
    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={handleBackToSkill} className="back-btn">
            ← Back to Skill
          </button>
          <h2>Error</h2>
        </div>
        <div className="error-message">
          <h3>❌ Error Loading Lesson</h3>
          <p>{error}</p>
          <button onClick={handleBackToSkill} className="retry-btn">
            Back to Skill
          </button>
        </div>
      </main>
    );
  }

  const { lesson, content } = lessonData;

  return (
    <main className="app-main">
      <div className="page-header">
        <button onClick={handleBackToSkill} className="back-btn">
          ← Back to Skill
        </button>
        <h2>{lesson?.icon || '📚'} {lesson?.name || 'Lesson Details'}</h2>
      </div>
      
      <div className="lesson-details-section">
        <div className="lesson-info">
          <h3>Lesson Information</h3>
          <p className="lesson-description">
            {lesson?.description || 'This lesson will teach you important cooking techniques and concepts.'}
          </p>
          
          <div className="lesson-meta">
            <div className="lesson-difficulty">
              <span>Difficulty:</span> {lesson?.difficulty || 'Beginner'}
            </div>
            <div className="lesson-duration">
              <span>Duration:</span> {lesson?.duration || '15-20 minutes'}
            </div>
          </div>
        </div>

        {/* Lesson Content Section */}
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
        </div>

        {/* Quiz Section */}
        <div className="quiz-section">
          <div className="quiz-intro">
            <h3>Ready to test your knowledge?</h3>
            <p>Take the quiz to complete this lesson and unlock the next one!</p>
          </div>
          <button onClick={handleTakeQuiz} className="start-quiz-btn">
            🧠 Take Quiz
          </button>
        </div>
      </div>
    </main>
  );
};

export default LessonPage; 