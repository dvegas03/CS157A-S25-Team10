import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useLessonData } from '../hooks/useLessonData';
import { useUserProgress } from '../hooks/useUserProgress';

/**
 * QuizPage component that displays an interactive quiz for a lesson.
 * Handles question navigation, answer selection, and scoring.
 */
const QuizPage = () => {
  const navigate = useNavigate();
  const { lessonId } = useParams();
  const { lessonData, loading, error } = useLessonData(lessonId);
  const { saveLessonCompletion, isLessonCompleted } = useUserProgress();
  
  // Quiz state
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState(null);
  const [isCorrect, setIsCorrect] = useState(null);
  const [lessonScore, setLessonScore] = useState(0);
  const [lessonAnswers, setLessonAnswers] = useState({});
  const [showResults, setShowResults] = useState(false);
  const [savingCompletion, setSavingCompletion] = useState(false);

  const handleBackToLesson = () => {
    navigate(`/lesson/${lessonId}/incomplete`);
  };

  const handleAnswerSelect = (answerIndex) => {
    if (selectedAnswer !== null) return; // Prevent multiple selections
    
    setSelectedAnswer(answerIndex);
    
    const quizzes = lessonData.quizzes;
    if (!quizzes || quizzes.length === 0) return;
    
    const currentQuiz = quizzes[currentQuestion];
    
    // Create options array from quiz data
    const options = [
      currentQuiz.correctAnswer,
      currentQuiz.wrongAnswer1,
      currentQuiz.wrongAnswer2,
      currentQuiz.wrongAnswer3
    ];
    
    const correctIndex = 0; // Correct answer is always first in our database structure
    const isCorrectAnswer = answerIndex === correctIndex;
    
    setIsCorrect(isCorrectAnswer);
    
    // Track the answer for this question
    setLessonAnswers(prev => ({
      ...prev,
      [currentQuestion]: answerIndex
    }));
    
    if (isCorrectAnswer) {
      setLessonScore(prev => prev + 1);
    }
  };

  const handleNextQuestion = () => {
    const quizzes = lessonData.quizzes;
    if (!quizzes) return;
    
    const totalQuestions = quizzes.length;
    
    if (currentQuestion + 1 < totalQuestions) {
      // Move to next question
      setCurrentQuestion(currentQuestion + 1);
      setSelectedAnswer(null);
      setIsCorrect(null);
    } else {
      // Quiz completed
      setShowResults(true);
    }
  };

  const handleFinishQuiz = async () => {
    setSavingCompletion(true);
    
    try {
      const totalQuestions = lessonData.quizzes.length;
      const percentage = Math.round((lessonScore / totalQuestions) * 100);
      
      // Only complete the lesson if all questions were answered correctly
      if (lessonScore === totalQuestions) {
        console.log('All questions correct, saving lesson completion for lessonId:', lessonId);
        // Save lesson completion with 100% score - convert lessonId to number
        const success = await saveLessonCompletion(parseInt(lessonId), 100);
        
        console.log('Save lesson completion result:', success);
        
        if (success) {
          // Navigate back to home page after successful completion
          console.log('Lesson completion saved successfully!');
          navigate('/');
        } else {
          // If saving failed, still navigate but show an error
          console.error('Failed to save lesson completion');
          alert('Failed to save lesson completion. Please try again.');
          navigate('/');
        }
      } else {
        // If not all questions correct, just navigate back without saving completion
        console.log('Lesson not completed - not all questions correct');
        navigate('/');
      }
    } catch (error) {
      console.error('Error completing lesson:', error);
      // Still navigate even if there's an error
      navigate('/');
    } finally {
      setSavingCompletion(false);
    }
  };

  // Show loading state while fetching data
  if (loading) {
    return (
      <main className="app-main">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Loading quiz...</p>
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
          <h3>❌ Error Loading Quiz</h3>
          <p>{error}</p>
          <button onClick={handleBackToLesson} className="retry-btn">
            Back to Lesson
          </button>
        </div>
      </main>
    );
  }

  const { lesson, quizzes } = lessonData;

  // Show quiz results
  if (showResults) {
    const totalQuestions = quizzes.length;
    const percentage = Math.round((lessonScore / totalQuestions) * 100);
    const allCorrect = lessonScore === totalQuestions;
    
    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={handleBackToLesson} className="back-btn">
            ← Back to Lesson
          </button>
          <h2>Quiz Results</h2>
        </div>
        
        <div className="quiz-results">
          <div className="results-card">
            <h3>{allCorrect ? '🎉 Quiz Complete!' : '📝 Quiz Finished'}</h3>
            <div className="score-display">
              <div className="score-circle">
                <span className="score-number">{lessonScore}</span>
                <span className="score-total">/{totalQuestions}</span>
              </div>
              <p className="score-percentage">{percentage}%</p>
            </div>
            
            <div className="score-message">
              {allCorrect ? (
                <div>
                  <p>Excellent! You've mastered this lesson! 🏆</p>
                  <p className="completion-notice">✅ Lesson will be marked as completed!</p>
                </div>
              ) : percentage >= 80 ? (
                <div>
                  <p>Good job! You're very close to mastery! 👍</p>
                  <p className="completion-notice">⚠️ Need all questions correct to complete the lesson</p>
                </div>
              ) : percentage >= 60 ? (
                <div>
                  <p>You're on the right track! Keep practicing! 📚</p>
                  <p className="completion-notice">⚠️ Need all questions correct to complete the lesson</p>
                </div>
              ) : (
                <div>
                  <p>Keep practicing! Review the lesson content and try again! 📚</p>
                  <p className="completion-notice">⚠️ Need all questions correct to complete the lesson</p>
                </div>
              )}
            </div>
            
            <button 
              onClick={handleFinishQuiz} 
              className={`finish-quiz-btn ${allCorrect ? 'success' : 'neutral'}`}
              disabled={savingCompletion}
            >
              {savingCompletion ? 'Saving...' : allCorrect ? 'Complete Lesson' : 'Continue Learning'}
            </button>
          </div>
        </div>
      </main>
    );
  }

  // Show quiz questions
  if (quizzes && quizzes.length > 0) {
    const currentQuiz = quizzes[currentQuestion];
    const totalQuestions = quizzes.length;

    // Create options array from quiz data
    const options = [
      currentQuiz.correctAnswer,
      currentQuiz.wrongAnswer1,
      currentQuiz.wrongAnswer2,
      currentQuiz.wrongAnswer3
    ];

    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={handleBackToLesson} className="back-btn">
            ← Back to Lesson
          </button>
          <div className="quiz-info">
            <h2>{lesson?.icon || '🧠'} Quiz</h2>
            <div className="question-progress">
              Question {currentQuestion + 1} of {totalQuestions} • Score: {lessonScore}/{totalQuestions}
            </div>
          </div>
        </div>

        <div className="quiz-container">
          <div className="question-card">
            <h2 className="question-text">{currentQuiz.questionText}</h2>
            
            <div className="options-grid">
              {options.map((option, index) => (
                <button
                  key={index}
                  onClick={() => handleAnswerSelect(index)}
                  disabled={selectedAnswer !== null}
                  className={`option-btn ${
                    selectedAnswer === index 
                      ? (isCorrect ? 'correct' : 'incorrect')
                      : ''
                  } ${selectedAnswer !== null && index === 0 ? 'correct' : ''}`}
                >
                  {option}
                </button>
              ))}
            </div>

            {selectedAnswer !== null && (
              <div className="feedback">
                <div className={`feedback-message ${isCorrect ? 'correct' : 'incorrect'}`}>
                  {isCorrect ? (
                    <>
                      <span className="feedback-icon">🎉</span>
                      <span>Correct! Great job!</span>
                    </>
                  ) : (
                    <>
                      <span className="feedback-icon">💡</span>
                      <span>Not quite right. The correct answer is highlighted!</span>
                    </>
                  )}
                </div>
                <button onClick={handleNextQuestion} className="next-btn">
                  {currentQuestion + 1 < totalQuestions ? 'Next Question →' : 'See Results →'}
                </button>
              </div>
            )}
          </div>
        </div>
      </main>
    );
  }

  // No quiz available
  return (
    <main className="app-main">
      <div className="page-header">
        <button onClick={handleBackToLesson} className="back-btn">
          ← Back to Lesson
        </button>
        <h2>No Quiz Available</h2>
      </div>
      
      <div className="no-quiz-section">
        <h3>No Quiz Available</h3>
        <p>This lesson doesn't have a quiz yet. Check back later!</p>
        <button onClick={handleBackToLesson} className="back-to-lesson-btn">
          Back to Lesson
        </button>
      </div>
    </main>
  );
};

export default QuizPage; 