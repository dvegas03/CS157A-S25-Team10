import { useState, useEffect } from 'react';

/**
 * Custom hook to fetch all cuisines.
 * Handles loading states and error handling.
 * 
 * @returns {Object} - Object containing cuisines, loading state, and error
 */
export const useCuisines = () => {
  const [cuisines, setCuisines] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchCuisines = async () => {
      setLoading(true);
      setError(null);
      
      try {
        const response = await fetch('/api/cuisines');
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setCuisines(data);
      } catch (err) {
        console.error('Error fetching cuisines:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchCuisines();
  }, []);

  return { cuisines, loading, error };
}; 