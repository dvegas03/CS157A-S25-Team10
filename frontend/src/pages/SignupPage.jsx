import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate, Link } from 'react-router-dom';

const SignupPage = () => {
  const [formData, setFormData] = useState({
    name: '',
    username: '',
    email: '',
    password: '',
    confirmPassword: ''
  });
  const [validationErrors, setValidationErrors] = useState({});
  const { signup, loading, error, clearError } = useAuth();
  const navigate = useNavigate();

  // Validate form data
  const validateForm = () => {
    const errors = {};
    
    console.log('Validating form with data:', formData);

    if (!formData.name.trim()) {
      errors.name = 'Name is required';
    }

    if (!formData.username.trim()) {
      errors.username = 'Username is required';
    } else if (formData.username.length < 3) {
      errors.username = 'Username must be at least 3 characters';
    }

    if (!formData.email.trim()) {
      errors.email = 'Email is required';
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      errors.email = 'Please enter a valid email address';
    }

    // Check password requirements
    console.log('Password field:', formData.password, 'Length:', formData.password?.length);
    if (!formData.password) {
      errors.password = 'Password is required';
      console.log('Setting password error: Password is required');
    } else if (formData.password.length < 6) {
      errors.password = 'Password must be at least 6 characters';
      console.log('Setting password error: Password too short');
    }

    // Check password confirmation
    console.log('Confirm password field:', formData.confirmPassword);
    if (!formData.confirmPassword) {
      errors.confirmPassword = 'Please confirm your password';
      console.log('Setting confirm password error: Please confirm your password');
    } else if (formData.password && formData.password !== formData.confirmPassword) {
      errors.confirmPassword = 'Passwords do not match';
      console.log('Setting confirm password error: Passwords do not match');
    }

    console.log('Final validation errors:', errors);
    setValidationErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));

    // Clear validation error for this field when user starts typing
    if (validationErrors[name]) {
      setValidationErrors(prev => ({
        ...prev,
        [name]: ''
      }));
    }

    // Real-time password matching validation
    if (name === 'password' || name === 'confirmPassword') {
      const password = name === 'password' ? value : formData.password;
      const confirmPassword = name === 'confirmPassword' ? value : formData.confirmPassword;
      
      // Only show password match error if both fields have content
      if (password && confirmPassword) {
        if (password !== confirmPassword) {
          setValidationErrors(prev => ({
            ...prev,
            confirmPassword: 'Passwords do not match'
          }));
        } else {
          // Clear the error if passwords match
          setValidationErrors(prev => ({
            ...prev,
            confirmPassword: ''
          }));
        }
      }
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('Signup form submitted');
    console.log('Form data:', formData);
    
    if (!validateForm()) {
      console.log('Form validation failed');
      return;
    }

    console.log('Form validation passed, attempting signup');
    try {
      // Remove confirmPassword and rename password to pwd for backend
      const { confirmPassword, password, ...signupData } = formData;
      const backendData = {
        ...signupData,
        pwd: password
      };
      console.log('Signup data being sent:', backendData);
      await signup(backendData);
      console.log('Signup successful, navigating to home');
      // Navigate to home page on successful signup
      navigate('/');
    } catch (error) {
      console.log('SignupPage caught error:', error);
      // Error is already handled by the AuthContext
      console.error('Signup failed:', error);
    }
  };

  return (
    <div className="login-page">
      <div className="login-container">
        <h1 className="login-title">Join Chef's Circle!</h1>
        <p className="login-subtitle">Create your account to start your culinary journey.</p>
        
        <form onSubmit={handleSubmit} className="login-form">
          <div className="input-group">
            <input
              type="text"
              name="name"
              value={formData.name}
              onChange={handleInputChange}
              placeholder="Full Name"
              required
              className="login-input"
              disabled={loading}
            />
            {validationErrors.name && (
              <div className="login-error">{validationErrors.name}</div>
            )}
          </div>

          <div className="input-group">
            <input
              type="text"
              name="username"
              value={formData.username}
              onChange={handleInputChange}
              placeholder="Username"
              required
              className="login-input"
              disabled={loading}
            />
            {validationErrors.username && (
              <div className="login-error">{validationErrors.username}</div>
            )}
          </div>

          <div className="input-group">
            <input
              type="email"
              name="email"
              value={formData.email}
              onChange={handleInputChange}
              placeholder="Email Address"
              required
              className="login-input"
              disabled={loading}
            />
            {validationErrors.email && (
              <div className="login-error">{validationErrors.email}</div>
            )}
          </div>

          <div className="input-group">
            <input
              type="password"
              name="password"
              value={formData.password}
              onChange={handleInputChange}
              placeholder="Password"
              required
              className="login-input"
              disabled={loading}
            />
            {validationErrors.password && (
              <div className="login-error">{validationErrors.password}</div>
            )}
          </div>

          <div className="input-group">
            <input
              type="password"
              name="confirmPassword"
              value={formData.confirmPassword}
              onChange={handleInputChange}
              placeholder="Confirm Password"
              required
              className="login-input"
              disabled={loading}
            />
            {validationErrors.confirmPassword && (
              <div className="login-error">{validationErrors.confirmPassword}</div>
            )}
          </div>
          
          {error && (
            <div className="login-error">
              {error}
            </div>
          )}
          
          <button 
            type="submit" 
            className="login-btn" 
            disabled={loading}
            onClick={() => console.log('Signup button clicked')}
          >
            {loading ? 'Creating Account...' : 'Sign Up'}
          </button>
        </form>
        
        <div className="login-links">
          <span className="signup-text">Already have an account? </span>
          <Link to="/login" className="signup-link">
            Login
          </Link>
        </div>
      </div>
    </div>
  );
};

export default SignupPage; 