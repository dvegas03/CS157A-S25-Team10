import React, { useMemo, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useLessons } from '../hooks/useLessons';
import { useSkills } from '../hooks/useSkills';
import { useUserProgress } from '../hooks/useUserProgress';

/**
 * SkillPage component that displays lessons for a selected skill.
 * Fetches lessons data and provides navigation to individual lessons.
 */
const SkillPage = () => {
  const navigate = useNavigate();
  const { skillId } = useParams();
  const { lessons, loading: lessonsLoading, error: lessonsError } = useLessons(skillId);
  const { skills, loading: skillsLoading } = useSkills(); // We'll need to get the skill name
  const { isLessonCompleted } = useUserProgress();

  const [lessonQuery, setLessonQuery] = useState('');
  const filteredLessons = useMemo(() => {
    const query = lessonQuery.trim().toLowerCase();
    if (!query) return lessons;
    return lessons.filter(l =>
      (l.name && l.name.toLowerCase().includes(query)) ||
      (l.description && l.description.toLowerCase().includes(query))
    );
  }, [lessons, lessonQuery]);

  // Find the current skill data
  const currentSkill = skills.find(skill => skill.id === parseInt(skillId));

  const handleLessonSelect = (lesson) => {
    if (isLessonCompleted(lesson.id)) {
      navigate(`/lesson/${lesson.id}`);
    } else {
      navigate(`/lesson/${lesson.id}/incomplete`);
    }
  };

  const handleBackToCuisine = () => {
    const cuisineId = currentSkill?.cuisineId;
    if (cuisineId) {
      navigate(`/cuisine/${cuisineId}`);
    } else {
      navigate('/');
    }
  };

  // Show loading state while fetching data
  if (skillsLoading || lessonsLoading) {
    return (
      <main className="app-main">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Loading skill details...</p>
        </div>
      </main>
    );
  }

  // Show error state if there's an error
  if (lessonsError) {
    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={handleBackToCuisine} className="back-btn">
            ← Back to Cuisine
          </button>
          <h2>Error</h2>
        </div>
        <div className="error-message">
          <h3>❌ Error Loading Lessons</h3>
          <p>{lessonsError}</p>
          <button onClick={handleBackToCuisine} className="retry-btn">
            Back to Cuisine
          </button>
        </div>
      </main>
    );
  }

  return (
    <main className="app-main">
      <div className="page-header">
        <button onClick={handleBackToCuisine} className="back-btn">
          ← Back to Cuisine
        </button>
        <h2>{currentSkill?.icon || '🍝'} {currentSkill?.name} Lessons</h2>
      </div>
      
      <div className="lessons-section">
        <p className="lessons-subtitle">Choose a lesson to start learning</p>
        <div style={{ margin: '0.5rem auto 1rem', maxWidth: 480, width: '100%' }}>
          <input
            type="text"
            value={lessonQuery}
            onChange={(e) => setLessonQuery(e.target.value)}
            placeholder="Search Lessons... (Example: Pasta, Sauces, Knife Skills, ...)"
            aria-label="Search lessons"
            className="search-input"
            style={{
              width: '100%',
              padding: '0.6rem 0.8rem',
              borderRadius: 8,
              border: '1px solid #ddd',
              outline: 'none',
              color: '#000',
              backgroundColor: '#fff'
            }}
          />
        </div>
        <div className="lessons-grid">
          {filteredLessons.map((lesson) => {
            const isCompleted = isLessonCompleted(lesson.id);
            
            return (
              <div 
                key={lesson.id} 
                className={`lesson-card ${isCompleted ? 'completed' : ''}`}
                onClick={() => handleLessonSelect(lesson)}
              >
                <div className="lesson-icon">{lesson.icon || '📚'}</div>
                <h4>{lesson.name}</h4>
                <p className="lesson-description">{lesson.description}</p>
                <div className="lesson-progress">
                  <div className="progress-bar">
                    <div 
                      className="progress-fill" 
                      style={{ width: isCompleted ? '100%' : '0%' }}
                    ></div>
                  </div>
                  <span className="progress-text">
                    {isCompleted ? 'Completed' : 'Not started'}
                  </span>
                </div>
                {isCompleted && (
                  <div className="completed-badge">
                    ✅ Completed
                  </div>
                )}
              </div>
            );
          })}
        </div>
        
        {lessons.length === 0 && (
          <div className="no-lessons">
            <p>No lessons found for this skill.</p>
          </div>
        )}
        {lessons.length > 0 && filteredLessons.length === 0 && (
          <div className="no-lessons">
            <p>No lessons match your search.</p>
          </div>
        )}
      </div>
    </main>
  );
};

export default SkillPage; 