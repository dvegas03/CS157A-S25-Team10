import React from 'react';

const CuisineSelection = ({ cuisines, onCuisineSelect }) => {
  return (
    <div className="cuisines-section">
      <h3>Explore Cuisines</h3>
      <div className="cuisines-grid">
        {cuisines.map((cuisine) => (
          <div key={cuisine.id} className="cuisine-card" onClick={() => onCuisineSelect(cuisine)}>
            <div className="cuisine-icon">{cuisine.icon_img}</div>
            <h4>{cuisine.name}</h4>
          </div>
        ))}
      </div>
    </div>
  );
};

export default CuisineSelection;
