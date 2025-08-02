import { useState, useEffect } from 'react';

/**
 * Custom hook to fetch skills for a specific cuisine.
 * Handles loading states and error handling.
 * 
 * @param {number} cuisineId - The ID of the cuisine to fetch skills for
 * @returns {Object} - Object containing skills, loading state, and error
 */
export const useSkills = (cuisineId) => {
  const [skills, setSkills] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!cuisineId) {
      setSkills([]);
      return;
    }

    const fetchSkills = async () => {
      setLoading(true);
      setError(null);
      
      try {
        const response = await fetch(`/api/skills/cuisine/${cuisineId}`);
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setSkills(data);
      } catch (err) {
        console.error('Error fetching skills:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchSkills();
  }, [cuisineId]);

  return { skills, loading, error };
}; 