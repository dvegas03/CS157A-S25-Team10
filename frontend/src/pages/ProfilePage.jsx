import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

/**
 * ProfilePage component that displays and allows editing of user profile information.
 */
const ProfilePage = () => {
  const { user, updateUser } = useAuth();
  const navigate = useNavigate();
  const [isEditing, setIsEditing] = useState(false);
  const [formData, setFormData] = useState({
    name: user?.name || '',
    username: user?.username || '',
    email: user?.email || ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

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
    // Reset form data to original user data
    setFormData({
      name: user?.name || '',
      username: user?.username || '',
      email: user?.email || ''
    });
    setIsEditing(false);
    setError(null);
  };

  const handleBackToHome = () => {
    navigate('/');
  };

  // Get user's first initial for avatar
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
          {/* Avatar */}
          <div className="profile-avatar">
            <span className="avatar-initial">{userInitial}</span>
          </div>

          {/* Profile Form */}
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

            {/* Action Buttons */}
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
      </div>
    </main>
  );
};

export default ProfilePage; 