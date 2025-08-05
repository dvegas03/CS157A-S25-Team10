import React from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';

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

  const userInitial = user?.name ? user.name.charAt(0).toUpperCase() : 'U';

  return (
    <header className="app-header">
      <div className="header-content">
        <div className="header-left">
          <h1 onClick={() => navigate('/')} style={{ cursor: 'pointer' }}>🍳 Chef's Circle</h1>
          <p>Learn to cook like a pro, one lesson at a time!</p>
        </div>
        <div className="header-right">
          <div className="stats">
            <div className="stat">
              <span className="stat-icon">⭐</span>
              <span>{user?.xp || 0} XP</span>
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
                  <div className="greeting-avatar">
                    {user.profileImage ? (
                      <span className="greeting-profile-icon">{user.profileImage}</span>
                    ) : (
                      <span className="greeting-initial">{userInitial}</span>
                    )}
                  </div>
                  <span className="greeting-text">Hi, {user.name}!</span>
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
