import { useState, useEffect } from 'react'
import './App.css'

function App() {
  const [currentLesson, setCurrentLesson] = useState(0)
  const [score, setScore] = useState(0)
  const [streak, setStreak] = useState(0)
  const [showLesson, setShowLesson] = useState(false)
  const [selectedAnswer, setSelectedAnswer] = useState(null)
  const [isCorrect, setIsCorrect] = useState(null)
  
  // Database states
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [showDatabase, setShowDatabase] = useState(false)

  useEffect(() => {
    fetchUsers()
  }, [])

  const fetchUsers = async () => {
    try {
      setLoading(true)
      setError(null)
      const response = await fetch('/api/users')
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      
      const data = await response.json()
      setUsers(data)
    } catch (err) {
      setError(err.message)
      console.error('Error fetching users:', err)
    } finally {
      setLoading(false)
    }
  }

  const filteredUsers = users.filter(user => 
    user.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.username?.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const handleRefresh = () => {
    fetchUsers()
  }

  // Cooking lessons data
  const lessons = [
    {
      id: 1,
      title: "Kitchen Basics",
      description: "Learn essential cooking techniques",
      icon: "",
      questions: [
        {
          question: "What is the most important rule when handling raw meat?",
          options: [
            "Always wash your hands thoroughly",
            "Use the same cutting board for everything",
            "Leave it out at room temperature",
            "Skip washing vegetables"
          ],
          correct: 0
        },
        {
          question: "Which cooking method is best for tenderizing tough cuts of meat?",
          options: [
            "High heat searing",
            "Slow cooking/braising",
            "Deep frying",
            "Microwaving"
          ],
          correct: 1
        },
        {
          question: "What does 'mise en place' mean?",
          options: [
            "Clean as you go",
            "Everything in its place",
            "Cook with love",
            "Season to taste"
          ],
          correct: 1
        }
      ]
    },
    {
      id: 2,
      title: "Knife Skills",
      description: "Master the art of cutting and chopping",
      icon: "",
      questions: [
        {
          question: "What is the safest way to hold a knife?",
          options: [
            "By the blade",
            "Pinch grip on the handle",
            "Hold it loosely",
            "Use your thumb and index finger"
          ],
          correct: 1
        },
        {
          question: "Which cut creates small, uniform cubes?",
          options: [
            "Julienne",
            "Brunoise",
            "Chiffonade",
            "Batonnet"
          ],
          correct: 1
        }
      ]
    },
    {
      id: 3,
      title: "Seasoning Secrets",
      description: "Learn to balance flavors like a pro",
      icon: "",
      questions: [
        {
          question: "What's the best way to season food?",
          options: [
            "Add all salt at the end",
            "Season in layers throughout cooking",
            "Use only salt and pepper",
            "Season once at the beginning"
          ],
          correct: 1
        },
        {
          question: "What does 'season to taste' mean?",
          options: [
            "Add salt until it's salty",
            "Taste and adjust seasoning as needed",
            "Use exactly 1 teaspoon of salt",
            "Follow the recipe exactly"
          ],
          correct: 1
        }
      ]
    }
  ]

  const handleStartLesson = (lessonIndex) => {
    setCurrentLesson(lessonIndex)
    setShowLesson(true)
    setSelectedAnswer(null)
    setIsCorrect(null)
  }

  const handleAnswerSelect = (answerIndex) => {
    setSelectedAnswer(answerIndex)
    const currentQuestions = lessons[currentLesson].questions
    const correct = currentQuestions[0].correct === answerIndex
    
    setIsCorrect(correct)
    
    if (correct) {
      setScore(score + 10)
      setStreak(streak + 1)
    } else {
      setStreak(0)
    }
  }

  const handleNextQuestion = () => {
    setSelectedAnswer(null)
    setIsCorrect(null)
  }

  const handleFinishLesson = () => {
    setShowLesson(false)
    setSelectedAnswer(null)
    setIsCorrect(null)
  }

  if (showLesson) {
    const lesson = lessons[currentLesson]
    const currentQuestion = lesson.questions[0] // For simplicity, showing first question

    return (
      <div className="app">
        <header className="app-header">
          <div className="lesson-header">
            <button onClick={handleFinishLesson} className="back-btn">
              ← Back to Lessons
            </button>
            <div className="lesson-info">
              <h1>{lesson.icon} {lesson.title}</h1>
              <p>{lesson.description}</p>
            </div>
            <div className="stats">
              <div className="stat">
                <span className="stat-icon">⭐</span>
                <span>{score}</span>
              </div>
              <div className="stat">
                <span className="stat-icon">🔥</span>
                <span>{streak}</span>
              </div>
            </div>
          </div>
        </header>

        <main className="app-main">
          <div className="lesson-container">
            <div className="question-card">
              <h2 className="question-text">{currentQuestion.question}</h2>
              
              <div className="options-grid">
                {currentQuestion.options.map((option, index) => (
                  <button
                    key={index}
                    onClick={() => handleAnswerSelect(index)}
                    disabled={selectedAnswer !== null}
                    className={`option-btn ${
                      selectedAnswer === index 
                        ? (isCorrect ? 'correct' : 'incorrect')
                        : ''
                    } ${selectedAnswer !== null && index === currentQuestion.correct ? 'correct' : ''}`}
                  >
                    {option}
                  </button>
                ))}
              </div>

              {selectedAnswer !== null && (
                <div className="feedback">
                  <div className={`feedback-message ${isCorrect ? 'correct' : 'incorrect'}`}>
                    {isCorrect ? (
                      <>
                        <span className="feedback-icon">🎉</span>
                        <span>Correct! Great job!</span>
                      </>
                    ) : (
                      <>
                        <span className="feedback-icon">💡</span>
                        <span>Not quite right. Keep learning!</span>
                      </>
                    )}
                  </div>
                  <button onClick={handleNextQuestion} className="next-btn">
                    Next Question →
                  </button>
                </div>
              )}
            </div>
          </div>
        </main>
      </div>
    )
  }

  if (showDatabase) {
    if (loading) {
      return (
        <div className="app">
          <header className="app-header">
            <div className="header-content">
              <div className="header-left">
                <h1>🍽️ Chef's Circle - Database Demo</h1>
                <p>Backend User Management System</p>
              </div>
              <button onClick={() => setShowDatabase(false)} className="back-btn">
                ← Back to Cooking App
              </button>
            </div>
          </header>
          <div className="loading-container">
            <div className="loading-spinner"></div>
            <p>Loading users from database...</p>
          </div>
        </div>
      )
    }

    return (
      <div className="app">
        <header className="app-header">
          <div className="header-content">
            <div className="header-left">
              <h1>🍽️ Chef's Circle - Database Demo</h1>
              <p>Backend User Management System</p>
            </div>
            <button onClick={() => setShowDatabase(false)} className="back-btn">
              ← Back to Cooking App
            </button>
          </div>
        </header>

        <main className="app-main">
          <div className="controls">
            <div className="search-container">
              <input
                type="text"
                placeholder="Search users by name, email, or username..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="search-input"
              />
              <span className="search-icon"></span>
            </div>
            
            <button onClick={handleRefresh} className="refresh-btn">
              🔄 Refresh
            </button>
          </div>

          {error && (
            <div className="error-message">
              <h3>❌ Error Loading Users</h3>
              <p>{error}</p>
              <button onClick={handleRefresh} className="retry-btn">
                Try Again
              </button>
            </div>
          )}

          {!error && (
            <div className="users-container">
              <div className="users-header">
                <h2>Users ({filteredUsers.length})</h2>
                {searchTerm && (
                  <span className="search-results">
                    Showing results for "{searchTerm}"
                  </span>
                )}
              </div>

              {filteredUsers.length === 0 ? (
                <div className="no-users">
                  {searchTerm ? (
                    <p>No users found matching "{searchTerm}"</p>
                  ) : (
                    <p>No users found in the system</p>
                  )}
                </div>
              ) : (
                <div className="users-grid">
                  {filteredUsers.map((user, index) => (
                    <div key={user.id || index} className="user-card">
                      <div className="user-avatar">
                        {user.name ? user.name.charAt(0).toUpperCase() : 'U'}
                      </div>
                      <div className="user-info">
                        <h3 className="user-name">
                          {user.name || 'Unknown Name'}
                        </h3>
                        <p className="user-email">
                          {user.email || 'No email provided'}
                        </p>
                        {user.username && (
                          <p className="user-username">
                            @{user.username}
                          </p>
                        )}
                        {user.role && (
                          <span className="user-role">{user.role}</span>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}
        </main>

        <footer className="app-footer">
          <p>Connected to: /api/users (proxied to http://localhost:8080/backend/api/users)</p>
        </footer>
      </div>
    )
  }

  return (
    <div className="app">
      <header className="app-header">
        <div className="header-content">
          <div className="header-left">
            <h1>‍🍳 Chef's Circle</h1>
            <p>Learn to cook like a pro, one lesson at a time!</p>
          </div>
          <div className="header-right">
            <div className="stats">
              <div className="stat">
                <span className="stat-icon">⭐</span>
                <span>{score} XP</span>
              </div>
              <div className="stat">
                <span className="stat-icon">🔥</span>
                <span>{streak} Day Streak</span>
              </div>
            </div>
          </div>
        </div>
      </header>

      <main className="app-main">
        <div className="welcome-section">
          <h2>Ready to become a master chef? </h2>
          <p>Choose a lesson to start your culinary journey!</p>
        </div>

        <div className="lessons-grid">
          {lessons.map((lesson, index) => (
            <div key={lesson.id} className="lesson-card">
              <div className="lesson-icon">{lesson.icon}</div>
              <div className="lesson-content">
                <h3>{lesson.title}</h3>
                <p>{lesson.description}</p>
                <div className="lesson-meta">
                  <span className="lesson-difficulty">Beginner</span>
                  <span className="lesson-duration">5 min</span>
                </div>
              </div>
              <button 
                onClick={() => handleStartLesson(index)}
                className="start-lesson-btn"
              >
                Start Lesson
              </button>
            </div>
          ))}
        </div>

        <div className="achievements-section">
          <h3>🏆 Your Achievements</h3>
          <div className="achievements-grid">
            <div className="achievement">
              <span className="achievement-icon">🥇</span>
              <span>First Lesson</span>
            </div>
            <div className="achievement locked">
              <span className="achievement-icon">🥈</span>
              <span>5 Day Streak</span>
            </div>
            <div className="achievement locked">
              <span className="achievement-icon">🥉</span>
              <span>100 XP</span>
            </div>
          </div>
        </div>

        <div className="database-demo-section">
          <h3>🔗 Backend Integration Demo</h3>
          <p>See how our cooking app connects to the backend database!</p>
          <button 
            onClick={() => setShowDatabase(true)}
            className="database-btn"
          >
            View Database Users
          </button>
        </div>
      </main>

      <footer className="app-footer">
        <p>🍽️ Keep cooking, keep learning! Made with love for food enthusiasts</p>
      </footer>
    </div>
  )
}

export default App
