import React from 'react';

const RecipePage = ({ recipe, allLessons, onStartLesson, onBack }) => {
  const filteredLessons = allLessons.filter(lesson => 
    recipe.lessonIds.includes(lesson.id)
  );

  return (
    <div className="recipe-page">
      <div className="content-wrapper">
        <div className="page-header">
          <button onClick={onBack} className="back-btn">← Back to Recipes</button>
          <h2>{recipe.name}</h2>
        </div>
        
        <div className="lessons-grid">
          {filteredLessons.map((lesson, index) => (
              <div key={lesson.id} className="lesson-card">
                <div className="lesson-content">
                  <h3>{lesson.title}</h3>
                  <p>{lesson.description}</p>
                  <div className="lesson-meta">
                    <span className="lesson-difficulty">Beginner</span>
                    <span className="lesson-duration">5 min</span>
                  </div>
                </div>
                <button 
                  onClick={() => onStartLesson(index)}
                  className="start-lesson-btn"
                >
                  Start Lesson
                </button>
              </div>
            ))}
          </div>

        <div className="recipe-details-container">
          <div className="ingredients-section">
            <h3>Ingredients</h3>
            <ul>
              <li>Ingredient 1</li>
              <li>Ingredient 2</li>
              <li>Ingredient 3</li>
            </ul>
          </div>
          <div className="instructions-section">
            <h3>Instructions</h3>
            <ol>
              <li>Step 1: Lorem ipsum dolor sit amet...</li>
              <li>Step 2: Consectetur adipiscing elit...</li>
              <li>Step 3: Sed do eiusmod tempor incididunt...</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RecipePage;