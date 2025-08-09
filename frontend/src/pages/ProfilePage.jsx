import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useFavoriteCuisines } from '../hooks/useFavoriteCuisines';
import { useCuisineProgress } from '../hooks/useCuisineProgress';
import './ProfilePage.css';

/**
 * ProfilePage component that displays and allows editing of user profile information.
 */
const ProfilePage = () => {
  const { user, updateUser, logout } = useAuth();
  const navigate = useNavigate();
  const [isEditing, setIsEditing] = useState(false);
  const [formData, setFormData] = useState({
    name: user?.name || '',
    username: user?.username || '',
    email: user?.email || ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [selectedIcon, setSelectedIcon] = useState(null);
  const [iconLoading, setIconLoading] = useState(false);
  const { favorites, removeFavorite } = useFavoriteCuisines();
  const flagUrl = (code = '') => (code ? `https://flagcdn.com/w80/${code.toLowerCase()}.png` : '');

  const profileIcons = [
    '🐱', '🐶', '🐰', '🐼', '🐨', '🐯',
    '🦁', '🐸', '🐵', '🐧', '🐦', '🦆',
    '🍕', '🍔', '🍟', '🌭', '🌮', '🌯',
    '🥪', '🥙', '🧆', '🌮', '🍜', '🍝',
    '🍛', '🍣', '🥟', '🍤', '🍙', '🍚',
    '🍘', '🍥', '🥠', '🍢', '🍡'
  ];

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleEditProfile = () => {
    setIsEditing(true);
  };

  const handleSaveProfile = async () => {
    setLoading(true);
    setError(null);

    try {
      // Call the backend to update user information
      const response = await fetch(`/api/users/${user.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (!response.ok) {
        const errorData = await response.text();
        throw new Error(errorData || 'Failed to update profile');
      }

      const updatedUser = await response.json();
      
      // Update the user in the auth context
      updateUser(updatedUser);
      
      setIsEditing(false);
    } catch (error) {
      console.error('Error updating profile:', error);
      setError(error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCancelEdit = () => {
    setFormData({
      name: user?.name || '',
      username: user?.username || '',
      email: user?.email || ''
    });
    setSelectedIcon(null);
    setIsEditing(false);
    setError(null);
  };

  const handleBackToHome = () => {
    navigate('/');
  };

  const handleDeleteAccount = async () => {
    if (!user?.id) return;
    const confirmed = window.confirm('Are you sure you want to permanently delete your account? This cannot be undone.');
    if (!confirmed) return;

    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`/api/users/${user.id}`, { method: 'DELETE' });
      if (!response.ok && response.status !== 204) {
        const txt = await response.text();
        throw new Error(txt || 'Failed to delete account');
      }
      logout();
      navigate('/login');
    } catch (err) {
      console.error('Error deleting account:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleIconSelect = (icon) => {
    setSelectedIcon(icon);
  };

  const handleIconUpload = async () => {
    if (!selectedIcon) return;

    setIconLoading(true);
    setError(null);

    try {
      const response = await fetch(`/api/users/${user.id}/profile-image`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ profileImage: selectedIcon })
      });

      if (!response.ok) {
        const errorData = await response.text();
        throw new Error(errorData || 'Failed to upload icon');
      }

      const updatedUser = await response.json();
      updateUser(updatedUser);
      setSelectedIcon(null);
    } catch (error) {
      console.error('Error uploading icon:', error);
      setError(error.message);
    } finally {
      setIconLoading(false);
    }
  };

  const handleIconRemove = async () => {
    setIconLoading(true);
    setError(null);

    try {
      const response = await fetch(`/api/users/${user.id}/profile-image`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ profileImage: null })
      });

      if (!response.ok) {
        const errorData = await response.text();
        throw new Error(errorData || 'Failed to remove icon');
      }

      const updatedUser = await response.json();
      updateUser(updatedUser);
      setSelectedIcon(null);
    } catch (error) {
      console.error('Error removing icon:', error);
      setError(error.message);
    } finally {
      setIconLoading(false);
    }
  };

  const userInitial = user?.name ? user.name.charAt(0).toUpperCase() : 'U';

  return (
    <main className="app-main">
      <div className="page-header">
        <button onClick={handleBackToHome} className="back-btn">
          ← Back to Home
        </button>
        <h2>👤 Profile</h2>
      </div>
      
      <div className="profile-section">
        <div className="profile-grid">
          <div className="profile-card">
          <div className="profile-avatar">
            {user?.profileImage ? (
              <span className="profile-icon">{user.profileImage}</span>
            ) : (
              <span className="avatar-initial">{userInitial}</span>
            )}
          </div>

          {isEditing && (
            <div className="icon-selection-section">
              <h4>Choose Profile Icon</h4>
              <div className="icon-grid">
                {profileIcons.map((icon, index) => (
                  <button
                    key={index}
                    onClick={() => handleIconSelect(icon)}
                    className={`icon-option ${selectedIcon === icon ? 'selected' : ''}`}
                  >
                    {icon}
                  </button>
                ))}
              </div>
              {selectedIcon && (
                <div className="icon-actions">
                  <button
                    onClick={handleIconUpload}
                    disabled={iconLoading}
                    className="upload-icon-btn"
                  >
                    {iconLoading ? 'Uploading...' : 'Set as Profile Icon'}
                  </button>
                  <button
                    onClick={() => setSelectedIcon(null)}
                    className="cancel-icon-btn"
                  >
                    Cancel
                  </button>
                </div>
              )}
              {user?.profileImage && !selectedIcon && (
                <button
                  onClick={handleIconRemove}
                  disabled={iconLoading}
                  className="remove-icon-btn"
                >
                  {iconLoading ? 'Removing...' : 'Remove Current Icon'}
                </button>
              )}
            </div>
          )}

          <div className="profile-form">
            <div className="form-group">
              <label htmlFor="name">Name</label>
              <input
                type="text"
                id="name"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                disabled={!isEditing}
                className="profile-input"
              />
            </div>

            <div className="form-group">
              <label htmlFor="username">Username</label>
              <input
                type="text"
                id="username"
                name="username"
                value={formData.username}
                onChange={handleInputChange}
                disabled={!isEditing}
                className="profile-input"
              />
            </div>

            <div className="form-group">
              <label htmlFor="email">Email</label>
              <input
                type="email"
                id="email"
                name="email"
                value={formData.email}
                onChange={handleInputChange}
                disabled={!isEditing}
                className="profile-input"
              />
            </div>

            {error && (
              <div className="profile-error">
                {error}
              </div>
            )}

            {isEditing && (
              <div className="form-group">
                <button
                  onClick={handleDeleteAccount}
                  disabled={loading}
                  className="delete-account-btn"
                >
                  {loading ? 'Deleting...' : 'Delete Account'}
                </button>
              </div>
            )}

            <div className="profile-actions">
              {!isEditing ? (
                <button 
                  onClick={handleEditProfile} 
                  className="edit-profile-btn"
                >
                  ✏️ Edit Profile
                </button>
              ) : (
                <div className="edit-actions">
                  <button 
                    onClick={handleSaveProfile} 
                    className="save-profile-btn"
                    disabled={loading}
                  >
                    {loading ? 'Saving...' : 'Save Changes'}
                  </button>
                  <button 
                    onClick={handleCancelEdit} 
                    className="cancel-btn"
                    disabled={loading}
                  >
                    Cancel
                  </button>
                </div>
              )}
            </div>
          </div>
          </div>

          <div className="profile-card favorites-card">
            <div className="favorites-card-container">
              <h3>⭐ Favorite Cuisines</h3>
              {favorites.length === 0 ? (
                <p>No favorites yet. Add some from the home page.</p>
              ) : (
                <div className="favorites-grid">
                  {favorites.map((c) => (
                    <FavoriteCuisineRow
                      key={c.id}
                      cuisine={c}
                      onSelect={() => navigate(`/cuisine/${c.id}`)}
                      onRemove={() => removeFavorite(c.id)}
                      flagUrl={flagUrl}
                    />
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </main>
  );
};

// Compact favorite cuisine row: flag + name on left, progress underneath, remove on right
const FavoriteCuisineRow = ({ cuisine, onSelect, onRemove, flagUrl }) => {
  const { progress, loading } = useCuisineProgress(cuisine.id);

  return (
    <div
      className="favorite-row"
      onClick={onSelect}
    >
      <div className="favorite-row-content">
        <div className="favorite-row-header">
          {cuisine.icon && (
            <img
              src={flagUrl(cuisine.icon)}
              alt={`${cuisine.name} flag`}
              className="favorite-flag"
              loading="lazy"
              onError={(e) => (e.currentTarget.style.display = 'none')}
            />
          )}
          <span className="favorite-name">
            {cuisine.name}
          </span>
        </div>
        <div className="cuisine-progress">
          <div className="progress-bar">
            <div className="progress-fill" style={{ '--progress-width': `${progress.percentage}%` }}></div>
          </div>
          <span className="progress-text">
            {loading ? 'Loading...' : `${progress.completed} of ${progress.total} lessons completed`}
          </span>
        </div>
      </div>
      <div>
        <button
          className="remove-icon-btn favorite-remove-btn"
          onClick={(e) => {
            e.stopPropagation();
            onRemove();
          }}
        >
          Remove
        </button>
      </div>
    </div>
  );
};

export default ProfilePage;