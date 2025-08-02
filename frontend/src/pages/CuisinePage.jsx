import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useSkills } from '../hooks/useSkills';
import { useCuisines } from '../hooks/useCuisines';
import { useSkillProgress } from '../hooks/useSkillProgress';

/**
 * CuisinePage component that displays skills for a selected cuisine.
 * Fetches skills data and provides navigation to individual skills.
 */
const CuisinePage = () => {
  const navigate = useNavigate();
  const { cuisineId } = useParams();
  const { skills, loading: skillsLoading, error: skillsError } = useSkills(cuisineId);
  const { cuisines, loading: cuisinesLoading } = useCuisines();

  // Find the current cuisine data
  const currentCuisine = cuisines.find(cuisine => cuisine.id === parseInt(cuisineId));

  const handleSkillSelect = (skill) => {
    navigate(`/skill/${skill.id}`);
  };

  const handleBackToHome = () => {
    navigate('/');
  };

  // Show loading state while fetching data
  if (cuisinesLoading || skillsLoading) {
    return (
      <main className="app-main">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Loading cuisine details...</p>
        </div>
      </main>
    );
  }

  // Show error state if there's an error
  if (skillsError) {
    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={handleBackToHome} className="back-btn">
            ← Back to Home
          </button>
          <h2>Error</h2>
        </div>
        <div className="error-message">
          <h3>❌ Error Loading Skills</h3>
          <p>{skillsError}</p>
          <button onClick={handleBackToHome} className="retry-btn">
            Back to Home
          </button>
        </div>
      </main>
    );
  }

  return (
    <main className="app-main">
      <div className="page-header">
        <button onClick={handleBackToHome} className="back-btn">
          ← Back to Home
        </button>
        <h2>{currentCuisine?.icon} {currentCuisine?.name} Skills</h2>
      </div>
      
      <div className="skills-section">
        <p className="skills-subtitle">Choose a skill to start learning</p>
        <div className="skills-grid">
          {skills.map((skill) => (
            <SkillCard 
              key={skill.id} 
              skill={skill} 
              onSelect={handleSkillSelect}
            />
          ))}
        </div>
        
        {skills.length === 0 && (
          <div className="no-skills">
            <p>No skills found for this cuisine.</p>
          </div>
        )}
      </div>
    </main>
  );
};

// Separate component for skill card to use the progress hook
const SkillCard = ({ skill, onSelect }) => {
  const { progress, loading } = useSkillProgress(skill.id);

  return (
    <div 
      className="skill-card" 
      onClick={() => onSelect(skill)}
    >
      <div className="skill-icon">{skill.icon || '🍝'}</div>
      <h4>{skill.name}</h4>
      <p className="skill-description">{skill.description}</p>
      <div className="skill-progress">
        <div className="progress-bar">
          <div 
            className="progress-fill" 
            style={{ width: `${progress.percentage}%` }}
          ></div>
        </div>
        <span className="progress-text">
          {loading ? 'Loading...' : `${progress.completed} of ${progress.total} lessons completed`}
        </span>
      </div>
    </div>
  );
};

export default CuisinePage; 