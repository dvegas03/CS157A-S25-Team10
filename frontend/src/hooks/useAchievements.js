import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';

export const useAchievements = () => {
    const { user } = useAuth();
    const [achievements, setAchievements] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        if (!user) return;

        const fetchAchievements = async () => {
            try {
                const response = await fetch(`/api/achievements/user/${user.id}`);
                if (!response.ok) {
                    throw new Error('Failed to fetch achievements');
                }
                const data = await response.json();
                setAchievements(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        fetchAchievements();
    }, [user]);

    return { achievements, loading, error };
};
