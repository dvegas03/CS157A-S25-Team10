import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

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

  const profileIcons = [
    '🐱', '🐶', '🐰', '🐼', '🐨', '🐯',
    '🦁', '🐸', '🐵', '🐧', '🐦', '🦆',
    '🍕', '🍔', '🍟', '🌭', '🌮', '🌯',
    '🥪', '🥙', '🧆', '🌮', '🍜', '🍝',
    '🍛', '🍣', '🍱', '🥟', '🍤', '🍙',
    '🍚', '🍘', '🍥', '🥠', '🍢', '🍡'
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

            <div className="profile-actions" style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
              {!isEditing ? (
                <>
                  <button 
                    onClick={handleEditProfile} 
                    className="edit-profile-btn"
                  >
                    ✏️ Edit Profile
                  </button>
                  <button
                    onClick={handleDeleteAccount}
                    disabled={loading}
                    className="delete-account-btn"
                    style={{
                      backgroundColor: '#e63946',
                      color: 'white',
                      border: 'none',
                      padding: '0.6rem 1rem',
                      borderRadius: 8,
                      cursor: 'pointer'
                    }}
                  >
                    {loading ? 'Deleting...' : 'Delete Account'}
                  </button>
                </>
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
      </div>
    </main>
  );
};

export default ProfilePage; 