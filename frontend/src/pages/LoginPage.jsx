import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate, Link } from 'react-router-dom';

const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const { login, loading, error, clearError } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('Form submitted with:', { email, password });
    
    // Clear any previous errors
    clearError();
    
    try {
      await login(email, password);
      // Navigate to home page on successful login
      navigate('/');
    } catch (error) {
      // Error is already handled by the AuthContext
      console.error('Login failed:', error);
    }
  };

  const handleInputChange = (field, value) => {
    // Clear error when user starts typing
    if (error) {
      clearError();
    }
    
    if (field === 'email') {
      setEmail(value);
    } else if (field === 'password') {
      setPassword(value);
    }
  };

  return (
    <div className="login-page">
      <div className="login-container">
        <h1 className="login-title">Welcome!</h1>
        <p className="login-subtitle">Login to continue your culinary journey.</p>
        
        <form onSubmit={handleSubmit} className="login-form">
          <div className="input-group">
            <input
              type="email"
              value={email}
              onChange={(e) => handleInputChange('email', e.target.value)}
              placeholder="Email Address"
              required
              className="login-input"
              disabled={loading}
            />
          </div>
          
          <div className="input-group">
            <div className="password-input-wrapper">
              <input
                type={showPassword ? "text" : "password"}
                value={password}
                onChange={(e) => handleInputChange('password', e.target.value)}
                placeholder="Password"
                required
                className="login-input password-input"
                disabled={loading}
              />
              <button
                type="button"
                className="password-toggle"
                onClick={() => setShowPassword(!showPassword)}
                disabled={loading}
              >
                {showPassword ? "👁️" : "👁️‍🗨️"}
              </button>
            </div>
          </div>
          
          {error && (
            <div className="login-error">
              Invalid email or password
            </div>
          )}
          
          <button 
            type="submit" 
            className="login-btn" 
            disabled={loading}
          >
            {loading ? 'Logging in...' : 'Login'}
          </button>
        </form>
        
        <div className="login-links">
          <span className="signup-text">Don't have an account? </span>
          <Link to="/signup" className="signup-link">
            Sign Up
          </Link>
        </div>
      </div>
    </div>
  );
};

export default LoginPage; 