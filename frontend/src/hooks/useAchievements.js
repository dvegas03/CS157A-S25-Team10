import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080/api';

export const useAchievements = () => {
    const { user } = useAuth();
    const [achievements, setAchievements] = useState([]);
    const [userAchievements, setUserAchievements] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchAchievements = async () => {
            try {
                const [allAchievementsRes, userAchievementsRes] = await Promise.all([
                    fetch(`${API_URL}/achievements`),
                    fetch(`${API_URL}/achievements/user/${user.id}`)
                ]);

                if (!allAchievementsRes.ok || !userAchievementsRes.ok) {
                    throw new Error('Failed to fetch achievements');
                }

                const allAchievements = await allAchievementsRes.json();
                const userAchievements = await userAchievementsRes.json();
                
                setAchievements(allAchievements);
                setUserAchievements(userAchievements);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        if (user) {
            fetchAchievements();
        }
    }, [user]);

    return { achievements, userAchievements, loading, error };
};
