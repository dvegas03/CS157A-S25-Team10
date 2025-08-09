import React, { useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useCuisines } from '../hooks/useCuisines';
import { useCuisineProgress } from '../hooks/useCuisineProgress';
import { useAchievements } from '../hooks/useAchievements';

// Helper to get flag image URL from ISO code
const flagUrl = (code = '') => `https://flagcdn.com/w80/${code.toLowerCase()}.png`;

/**
 * HomePage component that displays the main dashboard.
 * Shows welcome message, cuisine selection, and achievements.
 */
const HomePage = () => {
  const [cuisineQuery, setCuisineQuery] = useState('');
  const { user } = useAuth();
  const navigate = useNavigate();
  const { cuisines, loading: cuisinesLoading, error: cuisinesError } = useCuisines();
  const { achievements, loading: achievementsLoading, error: achievementsError } = useAchievements();

  const filteredCuisines = useMemo(() => {
    const query = cuisineQuery.trim().toLowerCase();
    if (!query) return cuisines;
    return cuisines.filter(c =>
      (c.name && c.name.toLowerCase().includes(query)) ||
      (c.description && c.description.toLowerCase().includes(query))
    );
  }, [cuisines, cuisineQuery]);

  const handleCuisineSelect = (cuisine) => {
    navigate(`/cuisine/${cuisine.id}`);
  };

  // Show loading state while fetching initial data
  if (cuisinesLoading) {
    return (
      <main className="app-main">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Loading cuisines...</p>
        </div>
      </main>
    );
  }

  // Show error state if there's an error
  if (cuisinesError) {
    return (
      <main className="app-main">
        <div className="error-message">
          <h3>❌ Error Loading Cuisines</h3>
          <p>{cuisinesError}</p>
          <button onClick={() => window.location.reload()} className="retry-btn">
            Try Again
          </button>
        </div>
      </main>
    );
  }

  return (
    <main className="app-main">
      <div className="welcome-section">
        <h2>Ready to become a master chef?</h2>
        <p>Choose a cuisine to start your culinary journey!</p>
      </div>

      <div className="cuisines-section">
        <h3>Choose Your Cuisine</h3>
        <p className="cuisines-subtitle">Select a cuisine to start your culinary journey</p>
        <div style={{ margin: '0.5rem auto 1rem', maxWidth: 480, width: '100%' }}>
          <input
            type="text"
            value={cuisineQuery}
            onChange={(e) => setCuisineQuery(e.target.value)}
            placeholder="Search Cuisines... (Example: Italian, Japanese, Mexican, ...)"
            aria-label="Search cuisines"
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
        <div className="cuisines-grid">
          {filteredCuisines.map((cuisine) => (
            <CuisineCard 
              key={cuisine.id} 
              cuisine={cuisine} 
              onSelect={handleCuisineSelect}
            />
          ))}
        </div>
        {cuisines.length === 0 && (
          <div className="no-cuisines">
            <p>No cuisines available at the moment.</p>
          </div>
        )}
        {cuisines.length > 0 && filteredCuisines.length === 0 && (
          <div className="no-cuisines">
            <p>No cuisines match your search.</p>
          </div>
        )}
      </div>

      <div className="achievements-section">
        <h3>🏆 Your Achievements</h3>
        {achievementsLoading ? (
            <p>Loading achievements...</p>
        ) : achievementsError ? (
            <p className="error-message">{achievementsError}</p>
        ) : (
            <div className="achievements-grid">
              {achievements.map(achievement => {
                // Detect tier for medal emoji
                let medal = '';
                if (/Novice/i.test(achievement.title)) medal = '🥉';
                else if (/Intermediate/i.test(achievement.title)) medal = '🥈';
                else if (/Expert/i.test(achievement.title)) medal = '🥇';

                return (
                  <div key={achievement.id} className={`achievement ${!achievement.unlocked ? 'locked' : ''}`}>
                    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                      {/* Medal on top */}
                      <span style={{ fontSize: '1.1em', marginBottom: '0.18em', lineHeight: 1 }}>{medal}</span>
                      {/* Flag icon or fallback emoji */}
                      {achievement.icon && achievement.icon.length <= 3 ? (
                        <img
                          src={flagUrl(achievement.icon)}
                          alt={`${achievement.title} flag`}
                          style={{ width: '1.5em', height: '1.5em', objectFit: 'contain' }}
                        />
                      ) : (
                        <span className="achievement-icon">{achievement.icon}</span>
                      )}
                    </div>
                    <span>{achievement.title}</span>
                  </div>
                );
              })}
            </div>
        )}
      </div>

      <div className="database-demo-section">
        <h3>🔗 Backend Integration Demo</h3>
        <p>See how our cooking app connects to the backend database!</p>
        <button 
          onClick={() => navigate('/database-demo')}
          className="database-btn"
        >
          View Database Users
        </button>
      </div>

      <footer className="app-footer">
        <p>🍽️ Keep cooking, keep learning! Made with love for food enthusiasts</p>
      </footer>
    </main>
  );
};

// Separate component for cuisine card to use the progress hook
const CuisineCard = ({ cuisine, onSelect }) => {
  const { progress, loading } = useCuisineProgress(cuisine.id);

  return (
    <div 
      className="cuisine-card" 
      onClick={() => onSelect(cuisine)}
    >
      <div className="cuisine-icon">
        <img
          src={flagUrl(cuisine.icon)}
          alt={`${cuisine.name} flag`}
          style={{ width: '1.5em', height: '1.5em', objectFit: 'contain' }}
        />
      </div>
      <h4>{cuisine.name}</h4>
      <p className="cuisine-description">{cuisine.description}</p>
      <div className="cuisine-progress">
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

export default HomePage;
