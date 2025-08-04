import React, { useState, useEffect } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { useLessonData } from "../hooks/useLessonData";

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

  // Always define hooks before any return!
  const [imagesLoaded, setImagesLoaded] = useState(false);

  // For image fade-in
  const [imgVisible, setImgVisible] = useState(false);

  // Preload images on lesson content load
  useEffect(() => {
    if (!lessonData?.content) return;
    const images = lessonData.content.map(c => c.pictureUrl).filter(Boolean);
    if (images.length === 0) {
      setImagesLoaded(true);
      return;
    }
    setImagesLoaded(false); // reset before loading
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
  const back = () => navigate("/");
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
        <div className="lesson-details-section">
          <div className="page-header">
            <button onClick={back} className="back-btn">
              ← Back to Skill
            </button>
            <h2>
              {lesson?.icon || "📚"} {lesson?.name || "Lesson"}
            </h2>
          </div>
          <div className="quiz-section">
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
        </div>
      </main>
    );
  }

  return (
    <main className="app-main">
      <div className="lesson-details-section">
        {/* header */}
        <div className="page-header">
          <button onClick={back} className="back-btn">
            ← Back to Skill
          </button>
          <h2>
            {lesson?.icon || "📚"} {lesson?.name || "Lesson"}
          </h2>
        </div>
        {/* flash-card content */}
        <div className="content-container">
          <div className="content-section">
            <p
              className="step-counter"
              style={{
                textAlign: "center",
                fontSize: "0.9rem",
                color: "#718096",
              }}
            >
              Step {currentStep + 1} of {totalSteps}
            </p>
            <h3 className="section-title">{c.sectionTitle}</h3>
            {c.pictureUrl && (
              <img
                src={c.pictureUrl}
                alt={c.sectionTitle}
                style={{
                  width: "100%",
                  maxWidth: 400,
                  borderRadius: "12px",
                  border: "1px solid #e2e8f0",
                  margin: "0 auto 1.5rem auto",
                  display: "block",
                  opacity: imgVisible ? 1 : 0,
                  transition: "opacity 0.45s cubic-bezier(.4,0,.2,1)",
                  boxShadow: imgVisible
                    ? "0 6px 32px 0 rgba(0,0,0,0.12)"
                    : "none",
                }}
              />
            )}
            <p className="section-text">{c.contentText}</p>
          </div>
        </div>
        {/* Action buttons */}
        <div
          className="quiz-section"
          style={{
            display: "flex",
            alignItems: "center",
            gap: "1rem",
            justifyContent: currentStep > 0 ? "space-between" : "center",
          }}
        >
          {currentStep > 0 && (
            <button
              onClick={prev}
              className="back-btn"
              style={{ padding: "0.75rem 1rem" }}
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
