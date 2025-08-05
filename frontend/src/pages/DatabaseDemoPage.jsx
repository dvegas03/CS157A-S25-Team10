import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const DatabaseDemoPage = () => {
  const navigate = useNavigate();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchUsers = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch('/api/users');
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const userData = await response.json();
      setUsers(userData);
      console.log('Fetched users:', userData);
    } catch (error) {
      console.error('Error fetching users:', error);
      setError('Failed to fetch users. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  // Fetch users when component mounts
  useEffect(() => {
    fetchUsers();
  }, []);

  return (
    <main className="app-main">
      <div className="page-header">
        <button onClick={() => navigate('/')} className="back-btn">
          ← Back to Home
        </button>
        <h2>Database Demo</h2>
      </div>
      
      <div className="database-demo-section">
        <h3>Database Integration Demo</h3>
        <p>This page shows all registered users in the database.</p>
        <p>Connected to: /api/users (proxied to http://localhost:8080/backend/api/users)</p>
        
        {loading && (
          <div className="loading-section">
            <p>Loading users from database...</p>
          </div>
        )}

        {error && (
          <div className="demo-error">
            {error}
          </div>
        )}

        {!loading && !error && users.length > 0 && (
          <div className="users-section">
            <h4>Database Users ({users.length} total)</h4>
            <div className="users-grid">
              {users.map((user) => (
                <div key={user.id} className="user-card">
                  <div className="user-avatar">
                    {user.name ? user.name.charAt(0).toUpperCase() : 'U'}
                  </div>
                  <div className="user-info">
                    <h5 className="user-name">{user.name || 'No Name'}</h5>
                    <p className="user-username">@{user.username}</p>
                    <p className="user-email">{user.email}</p>
                    <p className="user-id">ID: {user.id}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {!loading && !error && users.length === 0 && (
          <div className="no-users">
            <p>No users found in the database.</p>
          </div>
        )}
      </div>
    </main>
  );
};

export default DatabaseDemoPage; 