import { useState, useEffect } from 'react';
import { useUserProgress } from './useUserProgress';

/**
 * Custom hook to calculate progress for a specific skill.
 * Fetches lessons for the skill and calculates completion percentage.
 * 
 * @param {number} skillId - The ID of the skill to calculate progress for
 * @returns {Object} - Object containing progress data and loading state
 */
export const useSkillProgress = (skillId) => {
  const [progress, setProgress] = useState({
    completed: 0,
    total: 0,
    percentage: 0
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { completedLessons } = useUserProgress();

  useEffect(() => {
    if (!skillId) {
      setProgress({ completed: 0, total: 0, percentage: 0 });
      return;
    }

    const calculateProgress = async () => {
      setLoading(true);
      setError(null);

      try {
        // Fetch lessons for this skill
        const response = await fetch(`/api/lessons/skill/${skillId}`);
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const lessons = await response.json();

        // Count completed lessons
        const totalLessons = lessons.length;
        const completedCount = lessons.filter(lesson => 
          completedLessons.has(lesson.id)
        ).length;

        const percentage = totalLessons > 0 ? (completedCount / totalLessons) * 100 : 0;

        setProgress({
          completed: completedCount,
          total: totalLessons,
          percentage: percentage
        });
      } catch (err) {
        console.error('Error calculating skill progress:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    calculateProgress();
  }, [skillId, completedLessons]);

  return { progress, loading, error };
}; 