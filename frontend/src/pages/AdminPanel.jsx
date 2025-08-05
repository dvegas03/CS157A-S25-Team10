import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { FaUser, FaBook, FaUtensils, FaMedal, FaHome, FaChevronLeft } from "react-icons/fa";

const panels = [
  {
    icon: <FaUser />,
    title: "Users",
    desc: "Manage all users, assign roles, and view activity.",
    key: "users",
  },
  {
    icon: <FaUtensils />,
    title: "Cuisines",
    desc: "Add, edit, or remove cuisines in the learning system.",
    key: "cuisines",
  },
  {
    icon: <FaBook />,
    title: "Lessons",
    desc: "Create and organize lessons for all skills.",
    key: "lessons",
  },
  {
    icon: <FaMedal />,
    title: "Achievements",
    desc: "Define and update achievements and medals.",
    key: "achievements",
  },
];

export default function AdminPanel() {
  const navigate = useNavigate();
  const { user, loading } = useAuth();

  const [view, setView] = useState("panel");
  const [users, setUsers] = useState([]);
  const [usersLoading, setUsersLoading] = useState(false);
  const [usersError, setUsersError] = useState(null);

  // Fetch users when view is 'users'
  useEffect(() => {
    if (view === "users") {
      setUsersLoading(true);
      setUsersError(null);
      fetch("/api/users")
        .then((res) => {
          if (!res.ok) throw new Error("Failed to fetch users");
          return res.json();
        })
        .then((data) => setUsers(data))
        .catch(() => setUsersError("Could not fetch users."))
        .finally(() => setUsersLoading(false));
    }
  }, [view]);

  // Handler to delete user (except yourself)
  const handleDelete = async (id) => {
    if (!window.confirm("Delete this user?")) return;
    try {
      const res = await fetch(`/api/users/${id}`, { method: "DELETE" });
      if (!res.ok) throw new Error();
      setUsers((users) => users.filter((u) => u.id !== id));
    } catch {
      alert("Delete failed.");
    }
  };

  // Handler to toggle admin rights (except yourself)
  const handleToggleAdmin = async (u) => {
    const updated = { ...u, is_admin: u.is_admin === 1 ? 0 : 1 };
    try {
      const res = await fetch(`/api/users/${u.id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(updated),
      });
      if (!res.ok) throw new Error();
      setUsers((users) =>
        users.map((usr) =>
          usr.id === u.id ? { ...usr, is_admin: updated.is_admin } : usr
        )
      );
    } catch {
      alert("Admin update failed.");
    }
  };

  if (loading) return null;

  if (!user || user.is_admin !== 1) {
    return (
      <div style={{
        minHeight: "80vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        background: "#fff0f0",
        color: "#d32f2f"
      }}>
        <h1 style={{ fontSize: "3rem", marginBottom: "1rem" }}>403 Forbidden</h1>
        <p style={{ fontSize: "1.25rem", marginBottom: "2rem" }}>
          You do not have permission to access this page.
        </p>
        <button
          className="back-btn"
          onClick={() => navigate("/")}
        >
          <FaHome style={{ marginRight: "0.5rem" }} /> Go Home
        </button>
      </div>
    );
  }

  // USERS VIEW (cards layout)
  if (view === "users") {
    return (
      <div className="app-main">
        <div className="page-header">
          <button className="back-btn" onClick={() => setView("panel")}>
            <FaChevronLeft style={{ marginRight: "0.5rem" }} /> Back
          </button>
          <h2>All Users</h2>
        </div>
        <div className="users-section">
          {usersLoading ? (
            <div className="loading-section">Loading users...</div>
          ) : usersError ? (
            <div className="demo-error">{usersError}</div>
          ) : users.length === 0 ? (
            <div className="no-users">
              <p>No users found.</p>
            </div>
          ) : (
            <div className="users-grid">
              {users.map(u => (
                <div className="user-card" key={u.id}>
                  <div className="user-avatar">
                    {u.profileImage
                      ? <img src={u.profileImage} alt="avatar" style={{ width: "100%", borderRadius: "50%" }} />
                      : (u.name?.charAt(0)?.toUpperCase() || "U")}
                  </div>
                  <div className="user-info">
                    <div className="user-name">{u.name}</div>
                    <div className="user-username">@{u.username}</div>
                    <div className="user-email">{u.email}</div>
                    <div className="user-id">ID: {u.id}</div>
                  </div>
                  <div>
                    <span className="user-role" style={{
                      background: u.is_admin === 1
                        ? "linear-gradient(135deg,#ff6b6b,#ffa500)"
                        : "linear-gradient(135deg,#718096,#a0aec0)",
                      color: "#fff",
                      marginBottom: 6,
                      display: "inline-block"
                    }}>
                      {u.is_admin === 1 ? "Admin" : "User"}
                    </span>
                    <div style={{ marginTop: 8, display: "flex", gap: 8 }}>
                      {user.id !== u.id && (
                        <>
                          <button
                            className="start-lesson-btn"
                            style={{
                              background: u.is_admin === 1
                                ? "linear-gradient(135deg,#718096,#a0aec0)"
                                : "linear-gradient(135deg,#ff6b6b,#ffa500)"
                            }}
                            onClick={() => handleToggleAdmin(u)}
                          >
                            {u.is_admin === 1 ? "Make User" : "Make Admin"}
                          </button>
                          <button
                            className="start-lesson-btn"
                            style={{
                              background: "linear-gradient(135deg,#f56565,#e53e3e)",
                              marginLeft: 0
                            }}
                            onClick={() => handleDelete(u.id)}
                          >
                            Delete
                          </button>
                        </>
                      )}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    );
  }

  // MAIN ADMIN PANEL
  return (
    <div className="app-main">
      <div className="page-header">
        <button className="back-btn" onClick={() => navigate("/")}>
          <FaHome style={{ marginRight: "0.5rem" }} /> Home
        </button>
        <h2>Admin Panel</h2>
      </div>
      <div className="lessons-grid">
        {panels.map(({ icon, title, desc, key }) => (
          <div
            key={title}
            className={`lesson-card${key !== "users" ? " locked" : ""}`}
            style={{ cursor: key === "users" ? "pointer" : "not-allowed" }}
            onClick={() => key === "users" && setView("users")}
          >
            <div className="lesson-icon">{icon}</div>
            <h4>{title}</h4>
            <p className="lesson-description">{desc}</p>
            <button
              className="start-lesson-btn"
              style={{ opacity: key === "users" ? 1 : 0.7, cursor: key === "users" ? "pointer" : "not-allowed" }}
              disabled={key !== "users"}
            >
              {key === "users" ? "View Users" : "Coming Soon"}
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
