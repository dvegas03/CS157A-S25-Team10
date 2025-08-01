import React from 'react';

const LessonView = ({ skill, lessons, userProgress, onBack }) => {

  const getLessonStatus = (lesson) => {
    if (userProgress.includes(lesson.id)) {
      return 'completed';
    }
    const lastCompletedLesson = lessons.find(l => l.id === userProgress[userProgress.length - 1]);
    const lastCompletedOrder = lastCompletedLesson ? lastCompletedLesson.order_in_skill : 0;

    if (lesson.order_in_skill === lastCompletedOrder + 1) {
      return 'available';
    }
    
    return 'locked';
  }

  return (
    <div className="lesson-view-container">
      <div className="page-header">
         <button onClick={onBack} className="back-btn">← Back to Skills</button>
         <h2>{skill.icon_img} {skill.name}</h2>
      </div>
      <div className="card-grid">
        {lessons.length > 0 ? lessons.map(lesson => {
            const status = getLessonStatus(lesson);
            return (
              <div key={lesson.id} className={`lesson-view-card ${status}`}>
                <div className="card-icon">
                    {status === 'completed' && '✅'}
                    {status === 'available' && '▶️'}
                    {status === 'locked' && '🔒'}
                </div>
                <div className="card-content">
                  <h3>{lesson.title}</h3>
                </div>
                {status === 'available' && <button className="start-lesson-btn">Start</button>}
              </div>
            )
        }) : <p className="empty-message">No lessons available for this skill yet.</p>}
      </div>
    </div>
  );
};

export default LessonView;
