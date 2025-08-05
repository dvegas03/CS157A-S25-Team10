import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import './App.css';

// Import pages
import LoginPage from './pages/LoginPage';
import SignupPage from './pages/SignupPage';
import HomePage from './pages/HomePage';
import ProfilePage from './pages/ProfilePage';
import CuisinePage from './pages/CuisinePage';
import SkillPage from './pages/SkillPage';
import LessonPage from './pages/LessonPage';
import QuizPage from './pages/QuizPage';
import DatabaseDemoPage from './pages/DatabaseDemoPage';
import IncompleteLessonPage from './pages/IncompleteLessonPage';
import AdminPanel from './pages/AdminPanel';

// Import components
import Header from './components/Header';
import ProtectedRoute from './components/ProtectedRoute';

/**
 * Main App component that sets up routing and authentication.
 * Uses AuthProvider to wrap the entire application with authentication context.
 */
function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="app">
          <AppRoutes />
        </div>
      </Router>
    </AuthProvider>
  );
}

/**
 * Component that handles all routing logic.
 * Separates public and protected routes based on authentication status.
 */
function AppRoutes() {
  const { isAuthenticated } = useAuth();

  return (
    <>
      {/* Show header only for authenticated routes */}
      {isAuthenticated && <Header />}
      
      <Routes>
        {/* Public routes - accessible without authentication */}
        <Route 
          path="/login" 
          element={
            isAuthenticated ? <Navigate to="/" replace /> : <LoginPage />
          } 
        />
        <Route 
          path="/signup" 
          element={
            isAuthenticated ? <Navigate to="/" replace /> : <SignupPage />
          } 
        />
        
        {/* Protected routes - require authentication */}
        <Route path="/" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
        <Route path="/profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />
        <Route path="/cuisine/:cuisineId" element={<ProtectedRoute><CuisinePage /></ProtectedRoute>} />
        <Route path="/skill/:skillId" element={<ProtectedRoute><SkillPage /></ProtectedRoute>} />
        <Route path="/lesson/:lessonId" element={<ProtectedRoute><LessonPage /></ProtectedRoute>} />
        <Route path="/lesson/:lessonId/incomplete" element={<ProtectedRoute><IncompleteLessonPage /></ProtectedRoute>} />
        <Route path="/lesson/:lessonId/quiz" element={<ProtectedRoute><QuizPage /></ProtectedRoute>} />
        <Route path="/database-demo" element={<ProtectedRoute><DatabaseDemoPage /></ProtectedRoute>} />
        <Route path="/admin" element={<AdminPanel />} />
        
        {/* Catch-all route - redirect to home */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </>
  );
}

export default App;