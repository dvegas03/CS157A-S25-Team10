import React, { useState } from 'react';

const SignupPage = ({ onSignup, onSwitchToLogin }) => {
  const [name, setName] = useState('');
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    
    try {
      const newUser = { name, username, email, pwd: password };

      const response = await fetch('/api/users/signup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newUser),
      });

      if (!response.ok) {
        const errorMessage = await response.text();
        throw new Error(errorMessage || 'Failed to create an account.');
      }

      const signedUpUser = await response.json();
      onSignup(signedUpUser); 

    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-container">
        <h1>Join Chef's Circle</h1>
        <p>Create an account to save your progress.</p>
        <form onSubmit={handleSubmit} className="auth-form">
          <input type="text" value={name} onChange={(e) => setName(e.target.value)} placeholder="Your Name" required className="auth-input" />
          <input type="text" value={username} onChange={(e) => setUsername(e.target.value)} placeholder="Username" required className="auth-input" />
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email Address" required className="auth-input" />
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Password" required className="auth-input" />
          {error && <p className="auth-error">{error}</p>}
          <button type="submit" className="auth-btn" disabled={loading}>
            {loading ? 'Creating Account...' : 'Sign Up'}
          </button>
        </form>
         <div className="auth-links">
            <button onClick={onSwitchToLogin} className="switch-btn">
              Already have an account? Login
            </button>
        </div>
      </div>
    </div>
  );
};

export default SignupPage;