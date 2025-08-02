import { useState, useEffect } from 'react';

/**
 * Custom hook to fetch complete lesson data including content and quizzes.
 * Handles loading states and error handling.
 * 
 * @param {number} lessonId - The ID of the lesson to fetch data for
 * @returns {Object} - Object containing lesson data, loading state, and error
 */
export const useLessonData = (lessonId) => {
  const [lessonData, setLessonData] = useState({
    lesson: null,
    content: [],
    quizzes: []
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!lessonId) {
      setLessonData({ lesson: null, content: [], quizzes: [] });
      return;
    }

    const fetchLessonData = async () => {
      setLoading(true);
      setError(null);
      
      try {
        // Fetch full lesson data including content and quizzes
        const response = await fetch(`/api/lessons/${lessonId}/full`);
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setLessonData({
          lesson: data.lesson,
          content: data.content || [],
          quizzes: data.quizzes || []
        });
      } catch (err) {
        console.error('Error fetching lesson data:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchLessonData();
  }, [lessonId]);

  return { lessonData, loading, error };
}; 