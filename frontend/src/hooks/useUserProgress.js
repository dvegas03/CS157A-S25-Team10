import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';

/**
 * Custom hook to manage user progress and lesson completion.
 * Handles fetching user progress and saving lesson completions.
 * 
 * @returns {Object} - Object containing user progress functions and state
 */
export const useUserProgress = () => {
  const { user, updateUser } = useAuth();
  const [userProgress, setUserProgress] = useState([]);
  const [completedLessons, setCompletedLessons] = useState(new Set());
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Fetch user progress when user is available
  useEffect(() => {
    if (user && user.id) {
      fetchUserProgress();
    }
  }, [user]);

  const fetchUserProgress = async () => {
    if (!user?.id) return;

    setLoading(true);
    setError(null);

    try {
      const response = await fetch(`/api/user-progress/user/${parseInt(user.id)}`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const progress = await response.json();
      setUserProgress(progress);
      
      // Extract completed lesson IDs
      const completedLessonIds = progress
        .filter(p => p.status === 'completed')
        .map(p => parseInt(p.lessonId)); // Ensure lessonId is a number
      setCompletedLessons(new Set(completedLessonIds));
    } catch (err) {
      console.error('Error fetching user progress:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const saveLessonCompletion = async (lessonId, score = 100) => {
    if (!user?.id) {
      console.error('No user available for saving lesson completion');
      return false;
    }

    setLoading(true);
    setError(null);

    try {
      const progressData = {
        userId: parseInt(user.id), // Ensure userId is a number
        lessonId: parseInt(lessonId), // Ensure lessonId is a number
        status: 'completed',
        score: score
      };

      console.log('User object:', user);
      console.log('Sending progress data:', progressData);
      const response = await fetch('/api/user-progress/update', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(progressData)
      });

      console.log('Response status:', response.status);
      console.log('Response ok:', response.ok);

      if (!response.ok) {
        const errorText = await response.text();
        console.error('Error response:', errorText);
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const updatedUser = await response.json();
      console.log('User updated:', updatedUser);

      // Update the user in the auth context
      if (updateUser) {
        updateUser(updatedUser);
      }

      // Update local state immediately
      setCompletedLessons(prev => new Set([...prev, lessonId]));
      
      // Refresh user progress from backend to ensure consistency
      await fetchUserProgress();
      
      return true;
    } catch (err) {
      console.error('Error saving lesson completion:', err);
      setError(err.message);
      alert(`Error saving lesson completion: ${err.message}`);
      return false;
    } finally {
      setLoading(false);
    }
  };

  const isLessonCompleted = (lessonId) => {
    return completedLessons.has(parseInt(lessonId));
  };

  const getLessonProgress = (lessonId) => {
    return userProgress.find(p => p.lessonId === parseInt(lessonId));
  };

  return {
    userProgress,
    completedLessons,
    loading,
    error,
    saveLessonCompletion,
    isLessonCompleted,
    getLessonProgress,
    refreshProgress: fetchUserProgress
  };
};
