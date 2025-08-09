import { useState, useEffect } from 'react';
import { useUserProgress } from './useUserProgress';

/**
 * Custom hook to calculate progress for a specific cuisine.
 * Fetches all skills and lessons for the cuisine and calculates completion percentage.
 * 
 * @param {number} cuisineId - The ID of the cuisine to calculate progress for
 * @returns {Object} - Object containing progress data and loading state
 */
export const useCuisineProgress = (cuisineId) => {
  const [progress, setProgress] = useState({
    completed: 0,
    total: 0,
    percentage: 0
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { completedLessons } = useUserProgress();

  useEffect(() => {
    if (!cuisineId) {
      setProgress({ completed: 0, total: 0, percentage: 0 });
      return;
    }

    // TODO: Consider extracting this logic into a tiny helper so other hooks can reuse it
    const calculateProgress = async () => {
      setLoading(true);
      setError(null);

      try {
        // First get all skills for this cuisine
        const skillsResponse = await fetch(`/api/skills/cuisine/${cuisineId}`);
        if (!skillsResponse.ok) {
          throw new Error(`HTTP error! status: ${skillsResponse.status}`);
        }
        const skills = await skillsResponse.json();
        // console.log('Fetched skills for cuisine:', skills.length);
        
        // Then get all lessons for all skills
        let totalLessons = 0;
        let completedLessonsInCuisine = 0;
        
        for (const skill of skills) {
          const lessonsResponse = await fetch(`/api/lessons/skill/${skill.id}`);
          if (lessonsResponse.ok) {
            const lessons = await lessonsResponse.json();
            totalLessons += lessons.length;
            
            // Count completed lessons in this cuisine
            for (const lesson of lessons) {
              if (completedLessons.has(lesson.id)) {
                completedLessonsInCuisine++;
              }
            }
          }
        }

        const percentage = totalLessons > 0 ? (completedLessonsInCuisine / totalLessons) * 100 : 0;
        // console.log('Completed lessons in this cuisine:', completedLessonsInCuisine);

        setProgress({
          completed: completedLessonsInCuisine,
          total: totalLessons,
          percentage: percentage
        });
      } catch (err) {
        console.error('Error calculating cuisine progress:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    calculateProgress();
  }, [cuisineId, completedLessons]);

  return { progress, loading, error };
}; 