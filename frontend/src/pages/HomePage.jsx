import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useCuisines } from '../hooks/useCuisines';
import { useCuisineProgress } from '../hooks/useCuisineProgress';

// Helper to get flag image URL from ISO code
const flagUrl = (code = '') => `https://flagcdn.com/w80/${code.toLowerCase()}.png`;

/**
 * HomePage component that displays the main dashboard.
 * Shows welcome message, cuisine selection, and achievements.
 */
const HomePage = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const { cuisines, loading, error } = useCuisines();

  const handleCuisineSelect = (cuisine) => {
    navigate(`/cuisine/${cuisine.id}`);
  };

  // Show loading state while fetching cuisines
  if (loading) {
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
  if (error) {
    return (
      <main className="app-main">
        <div className="error-message">
          <h3>❌ Error Loading Cuisines</h3>
          <p>{error}</p>
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
        <div className="cuisines-grid">
          {cuisines.map((cuisine) => (
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
      </div>

      <div className="achievements-section">
        <h3>🏆 Your Achievements</h3>
        <div className="achievements-grid">
          <div className="achievement">
            <span className="achievement-icon">🥇</span>
            <span>First Lesson</span>
          </div>
          <div className="achievement locked">
            <span className="achievement-icon">🥈</span>
            <span>5 Day Streak</span>
          </div>
          <div className="achievement locked">
            <span className="achievement-icon">🥉</span>
            <span>100 XP</span>
          </div>
        </div>
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