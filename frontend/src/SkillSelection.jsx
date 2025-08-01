import React from 'react';

const SkillSelection = ({ cuisine, skills, onSkillSelect, onBack }) => {
  return (
    <div className="skill-selection-container">
      <div className="page-header">
         <button onClick={onBack} className="back-btn">← Back to Cuisines</button>
         <h2>{cuisine.icon_img} {cuisine.name}</h2>
      </div>
      <div className="card-grid">
        {skills.length > 0 ? skills.map(skill => (
          <div key={skill.id} className="skill-card" onClick={() => onSkillSelect(skill)}>
            <div className="card-icon">{skill.icon_img}</div>
            <div className="card-content">
              <h3>{skill.name}</h3>
              <p>{skill.description}</p>
            </div>
             <button className="start-lesson-btn">View Lessons</button>
          </div>
        )) : <p className="empty-message">No skills available for this cuisine yet.</p>}
      </div>
    </div>
  );
};

export default SkillSelection;
