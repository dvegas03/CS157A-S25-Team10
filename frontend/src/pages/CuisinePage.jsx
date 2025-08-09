import React, { useMemo, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useSkills } from '../hooks/useSkills';
import { useCuisines } from '../hooks/useCuisines';
import { useSkillProgress } from '../hooks/useSkillProgress';
import './CuisinePage.css';

/**
 * CuisinePage component that displays skills for a selected cuisine.
 * Fetches skills data and provides navigation to individual skills.
 */

const flagUrl = (code = '') =>
  code ? `https://flagcdn.com/w80/${code.toLowerCase()}.png` : '';

const CuisinePage = () => {
  const navigate = useNavigate();
  const { cuisineId } = useParams();
  const { skills, loading: skillsLoading, error: skillsError } = useSkills(cuisineId);
  const { cuisines, loading: cuisinesLoading } = useCuisines();
  const [skillQuery, setSkillQuery] = useState('');

  // TODO: Consider debouncing this search if the list gets large
  const filteredSkills = useMemo(() => {
    const query = skillQuery.trim().toLowerCase();
    if (!query) return skills;
    return skills.filter(s =>
      s.name && s.name.toLowerCase().includes(query)
    );
  }, [skills, skillQuery]);

  // Find the current cuisine data
  const currentCuisine = cuisines.find(c => c.id === parseInt(cuisineId, 10));

  const handleSkillSelect = skill => navigate(`/skill/${skill.id}`);
  const handleBackToHome = () => navigate(-1);

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

  if (!currentCuisine) {
    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={handleBackToHome} className="back-btn">
            ← Back to Home
          </button>
          <h2>Cuisine Not Found</h2>
        </div>
        <div className="no-skills">
          <p>This cuisine does not exist or failed to load.</p>
        </div>
      </main>
    );
  }

  return (
    <main className="app-main">
      <div className="page-header page-header-flex">
        <button onClick={handleBackToHome} className="back-btn">
          ← Back to Home
        </button>
        <h2 className="page-title">
          {/* Flag or emoji */}
          {currentCuisine.icon && (
            <img
              src={flagUrl(currentCuisine.icon)}
              alt={`${currentCuisine.name} flag`}
              className="cuisine-flag"
              loading="lazy"
              onError={e => (e.target.style.display = 'none')}
            />
          )}
          <span className="cuisine-title-text">
            {currentCuisine.name} Skills
          </span>
        </h2>
      </div>
      
      <div className="skills-section">
        <p className="skills-subtitle">Choose a skill to start learning</p>
        <div className="search-input-container">
          <input
            type="text"
            value={skillQuery}
            onChange={(e) => setSkillQuery(e.target.value)}
            placeholder="Search Skills... (Example: Knife Skills, Sauces, Baking, ...)"
            aria-label="Search skills"
            className="search-input"
          />
        </div>
        <div className="skills-grid">
          {filteredSkills.map((skill) => (
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
        {skills.length > 0 && filteredSkills.length === 0 && (
          <div className="no-skills">
            <p>No skills match your search.</p>
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
            style={{ '--progress-width': `${progress.percentage}%` }}
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
