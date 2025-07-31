import React from 'react';

const Cuisines = ({ onSelectCuisine }) => {
  const cuisines = [
    { name: 'American', icon: '🇺🇸' },
    { name: 'Chinese', icon: '🇨🇳' },
    { name: 'Italian', icon: '🇮🇹' },
  ];

  return (
    <div className="cuisines-section">
      <h3>Explore Cuisines</h3>
      <div className="cuisines-grid">
        {cuisines.map((cuisine) => (
          <div key={cuisine.name} className="cuisine-card" onClick={() => onSelectCuisine(cuisine.name)}>
            <div className="cuisine-icon">{cuisine.icon}</div>
            <h4>{cuisine.name}</h4>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Cuisines;