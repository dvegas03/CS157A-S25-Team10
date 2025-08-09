import { useCallback, useEffect, useMemo, useState } from 'react';
import { useAuth } from '../context/AuthContext';

/**
 * Manages user's favorite cuisines: fetch, add, remove, toggle.
 */
export const useFavoriteCuisines = () => {
  const { user } = useAuth();
  const [favorites, setFavorites] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const userId = user?.id;

  const fetchFavorites = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    setError(null);
    try {
      const res = await fetch(`/api/users/${userId}/favorites/cuisines`);
      if (!res.ok) throw new Error('Failed to fetch favorite cuisines');
      const data = await res.json();
      setFavorites(Array.isArray(data) ? data : []);
    } catch (e) {
      setError(e.message || 'Failed to load favorites');
    } finally {
      setLoading(false);
    }
  }, [userId]);

  useEffect(() => {
    fetchFavorites();
  }, [fetchFavorites]);

  const isFavorite = useCallback(
    (cuisineId) => favorites.some((c) => c.id === cuisineId),
    [favorites]
  );

  const addFavorite = useCallback(
    async (cuisineId) => {
      if (!userId) return;
      try {
        setLoading(true);
        const res = await fetch(`/api/users/${userId}/favorites/cuisines/${cuisineId}`, {
          method: 'POST',
        });
        if (!res.ok) throw new Error('Failed to add favorite');
        if (!favorites.some((c) => c.id === cuisineId)) {
          setFavorites((prev) => [...prev, { id: cuisineId }]);
          fetchFavorites();
        }
      } finally {
        setLoading(false);
      }
    },
    [userId, favorites, fetchFavorites]
  );

  const removeFavorite = useCallback(
    async (cuisineId) => {
      if (!userId) return;
      try {
        setLoading(true);
        const res = await fetch(`/api/users/${userId}/favorites/cuisines/${cuisineId}`, {
          method: 'DELETE',
        });
        if (!res.ok && res.status !== 204) throw new Error('Failed to remove favorite');
        setFavorites((prev) => prev.filter((c) => c.id !== cuisineId));
        await fetchFavorites();
      } finally {
        setLoading(false);
      }
    },
    [userId, fetchFavorites]
  );

  const toggleFavorite = useCallback(
    async (cuisineId) => {
      if (isFavorite(cuisineId)) {
        await removeFavorite(cuisineId);
      } else {
        await addFavorite(cuisineId);
      }
    },
    [isFavorite, addFavorite, removeFavorite]
  );

  const favoriteIds = useMemo(() => new Set(favorites.map((c) => c.id)), [favorites]);

  return { favorites, favoriteIds, isFavorite, addFavorite, removeFavorite, toggleFavorite, fetchFavorites, loading, error };
};


