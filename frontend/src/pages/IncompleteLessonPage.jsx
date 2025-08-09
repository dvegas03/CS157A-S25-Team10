import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { useLessonData } from "../hooks/useLessonData";
import "./IncompleteLessonPage.css";

// Helper for preloading one image
const preloadImage = src =>
  new Promise(resolve => {
    if (!src) return resolve();
    const img = new window.Image();
    img.onload = resolve;
    img.onerror = resolve;
    img.src = src;
  });

const IncompleteLessonPage = () => {
  const navigate = useNavigate();
  const { lessonId } = useParams();
  const { lessonData, loading, error } = useLessonData(lessonId);
  const [currentStep, setCurrentStep] = useState(0);

  const [imagesLoaded, setImagesLoaded] = useState(false);
  const [imgVisible, setImgVisible] = useState(false);

  // Preload images
  useEffect(() => {
    if (!lessonData?.content) return;
    const images = lessonData.content.map(c => c.pictureUrl).filter(Boolean);
    if (images.length === 0) {
      setImagesLoaded(true);
      return;
    }
    setImagesLoaded(false);
    Promise.all(images.map(preloadImage)).then(() => setImagesLoaded(true));
  }, [lessonData]);

  // For image fade-in per step
  const { lesson, content = [] } = lessonData || {};
  const totalSteps = content.length;
  const c = content[currentStep] || {};

  useEffect(() => {
    setImgVisible(false);
    if (c.pictureUrl) {
      const timer = setTimeout(() => setImgVisible(true), 80);
      return () => clearTimeout(timer);
    }
    setImgVisible(true);
  }, [c.pictureUrl, currentStep]);

  // Navigation helpers
  const back = () => {
    const skillId = lesson?.skillId;
    if (skillId) {
      navigate(`/skill/${skillId}`);
    } else {
      navigate('/')
    }
  };
  const next = () => setCurrentStep(i => i + 1);
  const prev = () => setCurrentStep(i => (i > 0 ? i - 1 : 0));
  const finish = () => navigate(`/lesson/${lessonId}/quiz`);

  // LOADING/ERROR EARLY RETURNS
  if (loading || !imagesLoaded) {
    return (
      <main className="app-main">
        <div className="loading-container">
          <div className="loading-spinner" />
          <p>Loading lesson…</p>
        </div>
      </main>
    );
  }
  if (error) {
    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={back} className="back-btn">
            ← Back to Skill
          </button>
          <h2>Error</h2>
        </div>
        <p className="text-red-600">{error}</p>
      </main>
    );
  }

  if (totalSteps === 0) {
    return (
      <main className="app-main">
        <div className="page-header">
          <button onClick={back} className="back-btn">
            ← Back to Skill
          </button>
          <h2>
            {lesson?.icon || "📚"} {lesson?.name || "Lesson"}
          </h2>
        </div>
        <div className="quiz-section-container">
          <div className="quiz-intro">
            <h3>Coming Soon</h3>
            <p>
              This lesson content is being prepared. In the meantime you can
              take the quiz to test your knowledge!
            </p>
          </div>
          <button onClick={finish} className="start-quiz-btn">
            🧠 Take Quiz
          </button>
        </div>
      </main>
    );
  }

  return (
    <main className="app-main lesson-main-container">
      {/* Header at the top */}
      <div className="page-header">
        <button onClick={back} className="back-btn">
          ← Back to Skill
        </button>
        <h2>
          {lesson?.icon || "📚"} {lesson?.name || "Lesson"}
        </h2>
      </div>

      {/* Main lesson body, grows to fill */}
      <div className="lesson-details-section">
        {/* Content flashcard - 400px wide */}
        <div className="content-section">
          <div className="step-counter-container">
            <p className="step-counter">
              Step {currentStep + 1} of {totalSteps}
            </p>
          </div>
          <h3 className="section-title">
            {c.sectionTitle}
          </h3>
          <p className="section-text">
            {c.contentText}
          </p>
        </div>

        <div className={`quiz-section ${currentStep > 0 ? '' : 'center'}`}>
          {currentStep > 0 && (
            <button
              onClick={prev}
              className="back-btn back-btn-padded"
            >
              ←
            </button>
          )}
          {currentStep < totalSteps - 1 ? (
            <button onClick={next} className="next-btn">
              Next →
            </button>
          ) : (
            <button onClick={finish} className="quiz-btn">
              Finish & Take Quiz
            </button>
          )}
        </div>
      </div>
    </main>
  );
};

export default IncompleteLessonPage;
