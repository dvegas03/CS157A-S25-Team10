import { useState, useEffect } from 'react';
import './ProfilePage.css';

function ProfilePage({ user, onBack, onUpdateUser }) {
  const [formData, setFormData] = useState({
    name: user?.name || '',
    username: user?.username || '',
    email: user?.email || ''
  });
  const [isEditing, setIsEditing] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [message, setMessage] = useState('');

  useEffect(() => {
    setFormData({
      name: user?.name || '',
      username: user?.username || '',
      email: user?.email || ''
    });
  }, [user]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSave = async () => {
    setIsLoading(true);
    setMessage('');

    try {
      const response = await fetch(`/api/users/${user.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      });

      if (response.ok) {
        const updatedUser = await response.json();
        onUpdateUser(updatedUser);
        setIsEditing(false);
        setMessage('Profile updated successfully!');
        setTimeout(() => setMessage(''), 3000);
      } else {
        const errorData = await response.json();
        setMessage(errorData.message || 'Failed to update profile');
      }
    } catch (error) {
      setMessage('Error updating profile. Please try again.');
      console.error('Error updating profile:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleCancel = () => {
    setFormData({
      name: user?.name || '',
      username: user?.username || '',
      email: user?.email || ''
    });
    setIsEditing(false);
    setMessage('');
  };

  return (
    <div className="profile-page">
      <header className="profile-header">
        <button onClick={onBack} className="back-btn">
          ← Back to Home
        </button>
        <h1>👤 Profile</h1>
      </header>

      <main className="profile-main">
        <div className="profile-card">
          <div className="profile-avatar">
            {user?.name ? user.name.charAt(0).toUpperCase() : 'U'}
          </div>

          {message && (
            <div className={`message ${message.includes('successfully') ? 'success' : 'error'}`}>
              {message}
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
                className={isEditing ? 'editable' : 'readonly'}
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
                className={isEditing ? 'editable' : 'readonly'}
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
                className={isEditing ? 'editable' : 'readonly'}
              />
            </div>

            <div className="profile-actions">
              {!isEditing ? (
                <button 
                  onClick={() => setIsEditing(true)}
                  className="edit-btn"
                >
                  ✏️ Edit Profile
                </button>
              ) : (
                <div className="edit-actions">
                  <button 
                    onClick={handleSave}
                    disabled={isLoading}
                    className="save-btn"
                  >
                    {isLoading ? 'Saving...' : '💾 Save Changes'}
                  </button>
                  <button 
                    onClick={handleCancel}
                    className="cancel-btn"
                  >
                    ❌ Cancel
                  </button>
                </div>
              )}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

export default ProfilePage; 