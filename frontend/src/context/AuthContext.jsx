import React, { createContext, useContext, useReducer, useEffect } from 'react';

// Action types for the auth reducer
const AUTH_ACTIONS = {
  LOGIN_START: 'LOGIN_START',
  LOGIN_SUCCESS: 'LOGIN_SUCCESS',
  LOGIN_FAILURE: 'LOGIN_FAILURE',
  LOGOUT: 'LOGOUT',
  SIGNUP_START: 'SIGNUP_START',
  SIGNUP_SUCCESS: 'SIGNUP_SUCCESS',
  SIGNUP_FAILURE: 'SIGNUP_FAILURE',
  CLEAR_ERROR: 'CLEAR_ERROR'
};

// Initial state for authentication
const initialState = {
  user: null,
  isAuthenticated: false,
  loading: false,
  error: null
};

// Auth reducer to handle complex state transitions
const authReducer = (state, action) => {
  switch (action.type) {
    case AUTH_ACTIONS.LOGIN_START:
    case AUTH_ACTIONS.SIGNUP_START:
      return {
        ...state,
        loading: true,
        error: null
      };
    
    case AUTH_ACTIONS.LOGIN_SUCCESS:
    case AUTH_ACTIONS.SIGNUP_SUCCESS:
      return {
        ...state,
        user: action.payload,
        isAuthenticated: true,
        loading: false,
        error: null
      };
    
    case AUTH_ACTIONS.LOGIN_FAILURE:
    case AUTH_ACTIONS.SIGNUP_FAILURE:
      return {
        ...state,
        user: null,
        isAuthenticated: false,
        loading: false,
        error: action.payload
      };
    
    case AUTH_ACTIONS.LOGOUT:
      return {
        ...state,
        user: null,
        isAuthenticated: false,
        loading: false,
        error: null
      };
    
    case AUTH_ACTIONS.CLEAR_ERROR:
      return {
        ...state,
        error: null
      };
    
    default:
      return state;
  }
};

// Create the AuthContext
const AuthContext = createContext();

// Custom hook to use the auth context
export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

// AuthProvider component that wraps the app
export const AuthProvider = ({ children }) => {
  const [state, dispatch] = useReducer(authReducer, initialState);

  // Check for existing user session on app load
  useEffect(() => {
    const savedUser = localStorage.getItem('chefsCircleUser');
    if (savedUser) {
      try {
        const user = JSON.parse(savedUser);
        // Immediately set the user to avoid UI flickering
        dispatch({ type: AUTH_ACTIONS.LOGIN_SUCCESS, payload: user });

        // Then, fetch the latest user data to ensure it's up-to-date
        const fetchLatestUser = async () => {
          try {
            const response = await fetch(`/api/users/${user.id}`);
            if (response.ok) {
              const latestUser = await response.json();
              localStorage.setItem('chefsCircleUser', JSON.stringify(latestUser));
              dispatch({ type: AUTH_ACTIONS.LOGIN_SUCCESS, payload: latestUser });
            } else {
              // Handle cases where the user might have been deleted or token is invalid
              logout();
            }
          } catch (error) {
            console.error('Failed to fetch latest user data:', error);
            // Optional: decide if you want to log out the user on network error
          }
        };

        fetchLatestUser();
      } catch (error) {
        console.error('Error parsing saved user:', error);
        localStorage.removeItem('chefsCircleUser');
      }
    }
  }, []);

  // Login function
  const login = async (email, password) => {
    console.log('Login attempt with:', { email, password });
    dispatch({ type: AUTH_ACTIONS.LOGIN_START });
    
    try {
      const response = await fetch('/api/users/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      console.log('Response status:', response.status);
      console.log('Response ok:', response.ok);

      if (!response.ok) {
        const errorText = await response.text();
        console.log('Error response:', errorText);
        throw new Error('Incorrect username or password');
      }

      const user = await response.json();
      console.log('Login successful:', user);
      
      // Save user to localStorage for persistence
      localStorage.setItem('chefsCircleUser', JSON.stringify(user));
      
      dispatch({ type: AUTH_ACTIONS.LOGIN_SUCCESS, payload: user });
      return user;
    } catch (error) {
      console.log('Login error caught:', error.message);
      dispatch({ 
        type: AUTH_ACTIONS.LOGIN_FAILURE, 
        payload: 'Incorrect username or password'
      });
      throw error;
    }
  };

  // Signup function
  const signup = async (userData) => {
    console.log('Signup attempt with:', userData);
    dispatch({ type: AUTH_ACTIONS.SIGNUP_START });
    
    try {
      const response = await fetch('/api/users/signup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(userData),
      });

      console.log('Signup response status:', response.status);
      console.log('Signup response ok:', response.ok);

      if (!response.ok) {
        const errorData = await response.text();
        console.log('Signup error response:', errorData);
        throw new Error(errorData || 'Failed to create account');
      }

      const user = await response.json();
      console.log('Signup successful:', user);
      
      // Save user to localStorage for persistence
      localStorage.setItem('chefsCircleUser', JSON.stringify(user));
      
      dispatch({ type: AUTH_ACTIONS.SIGNUP_SUCCESS, payload: user });
      return user;
    } catch (error) {
      console.log('Signup error caught:', error.message);
      dispatch({ 
        type: AUTH_ACTIONS.SIGNUP_FAILURE, 
        payload: error.message || 'Failed to create account' 
      });
      throw error;
    }
  };

  // Logout function
  const logout = () => {
    localStorage.removeItem('chefsCircleUser');
    dispatch({ type: AUTH_ACTIONS.LOGOUT });
  };

  // Clear error function
  const clearError = () => {
    dispatch({ type: AUTH_ACTIONS.CLEAR_ERROR });
  };

  // Update user function for profile updates
  const updateUser = (updatedUser) => {
    const currentUser = { ...state.user, ...updatedUser };
    localStorage.setItem('chefsCircleUser', JSON.stringify(currentUser));
    dispatch({ type: AUTH_ACTIONS.LOGIN_SUCCESS, payload: currentUser });
  };

  const value = {
    ...state,
    login,
    signup,
    logout,
    clearError,
    updateUser
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};
