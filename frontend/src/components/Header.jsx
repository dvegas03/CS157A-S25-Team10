import React from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';

/**
 * Header component that displays the app title, user stats, and navigation controls.
 * Only shown for authenticated users.
 */
const Header = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const handleProfileClick = () => {
    navigate('/profile');
  };

  return (
    <header className="app-header">
      <div className="header-content">
        <div className="header-left">
          <h1>🍳 Chef's Circle</h1>
          <p>Learn to cook like a pro, one lesson at a time!</p>
        </div>
        <div className="header-right">
          <div className="stats">
            <div className="stat">
              <span className="stat-icon">⭐</span>
              <span>0 XP</span>
            </div>
            <div className="stat">
              <span className="stat-icon">🔥</span>
              <span>0 Day Streak</span>
            </div>
            <div className="user-actions">
              {user && (
                <button 
                  onClick={handleProfileClick} 
                  className="user-greeting-btn"
                >
                  Hi, {user.name}!
                </button>
              )}
              <button onClick={handleLogout} className="login-button">
                Logout
              </button>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header; 