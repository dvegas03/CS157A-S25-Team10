import { useState, useEffect } from 'react';

/**
 * Custom hook to fetch lessons for a specific skill.
 * Handles loading states and error handling.
 * 
 * @param {number} skillId - The ID of the skill to fetch lessons for
 * @returns {Object} - Object containing lessons, loading state, and error
 */
export const useLessons = (skillId) => {
  const [lessons, setLessons] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!skillId) {
      setLessons([]);
      return;
    }

    const fetchLessons = async () => {
      setLoading(true);
      setError(null);
      
      try {
        const response = await fetch(`/api/lessons/skill/${skillId}`);
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setLessons(data);
      } catch (err) {
        console.error('Error fetching lessons:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchLessons();
  }, [skillId]);

  return { lessons, loading, error };
}; 