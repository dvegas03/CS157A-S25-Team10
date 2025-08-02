import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';

/**
 * Custom hook to manage user progress and lesson completion.
 * Handles fetching user progress and saving lesson completions.
 * 
 * @returns {Object} - Object containing user progress functions and state
 */
export const useUserProgress = () => {
  const { user } = useAuth();
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
      const response = await fetch(`/api/user-progress/user/${user.id}`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const progress = await response.json();
      setUserProgress(progress);
      
      // Extract completed lesson IDs
      const completedLessonIds = progress
        .filter(p => p.status === 'completed')
        .map(p => p.lessonId);
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
        userId: user.id,
        lessonId: lessonId,
        status: 'completed',
        score: score
      };

      const response = await fetch('/api/user-progress/update', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(progressData)
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const savedProgress = await response.json();
      console.log('Saved progress:', savedProgress);

      // Update local state immediately
      setCompletedLessons(prev => new Set([...prev, lessonId]));
      
      // Refresh user progress from backend to ensure consistency
      await fetchUserProgress();
      
      return true;
    } catch (err) {
      console.error('Error saving lesson completion:', err);
      setError(err.message);
      return false;
    } finally {
      setLoading(false);
    }
  };

  const isLessonCompleted = (lessonId) => {
    return completedLessons.has(lessonId);
  };

  const getLessonProgress = (lessonId) => {
    return userProgress.find(p => p.lessonId === lessonId);
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