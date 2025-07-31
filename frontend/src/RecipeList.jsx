import React from 'react';

const RecipeList = ({ cuisine, recipes, onSelectRecipe, onBack }) => {
  const recipeList = recipes || [];

  return (
    <div className="recipe-list-page">
      <div className="content-wrapper">
        <div className="page-header">
          <button onClick={onBack} className="back-btn">← Back to Cuisines</button>
          <h2>{cuisine} Recipes</h2>
        </div>
        <div className="recipes-grid">
          {recipeList.map((recipe) => (
            <div key={recipe.name} className="recipe-card" onClick={() => onSelectRecipe(recipe)}>
              <div className="recipe-image">{recipe.image}</div>
              <h4>{recipe.name}</h4>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default RecipeList;