import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { FaUser, FaBook, FaUtensils, FaMedal, FaHome, FaChevronLeft } from "react-icons/fa";
import "./AdminPanel.css";

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
      <div className="forbidden-container">
        <h1 className="forbidden-title">403 Forbidden</h1>
        <p className="forbidden-text">
          You do not have permission to access this page.
        </p>
        <button
          className="back-btn"
          onClick={() => navigate("/")}
        >
          <FaHome className="icon-with-margin" /> Go Home
        </button>
      </div>
    );
  }

  if (view === "users") {
    return (
      <div className="app-main">
        <div className="page-header">
          <button className="back-btn" onClick={() => setView("panel")}>
            <FaChevronLeft className="icon-with-margin" /> Back
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
                      ? <img src={u.profileImage} alt="avatar" className="user-avatar" />
                      : (u.name?.charAt(0)?.toUpperCase() || "U")}
                  </div>
                  <div className="user-info">
                    <div className="user-name">{u.name}</div>
                    <div className="user-username">@{u.username}</div>
                    <div className="user-email">{u.email}</div>
                    <div className="user-id">ID: {u.id}</div>
                  </div>
                  <div>
                    <span className={`user-role ${u.is_admin === 1 ? '' : 'user'}`}>
                      {u.is_admin === 1 ? "Admin" : "User"}
                    </span>
                    <div className="user-actions">
                      {user.id !== u.id && (
                        <>
                          <button
                            className={`start-lesson-btn admin-button ${u.is_admin === 1 ? '' : 'make-admin'}`}
                            onClick={() => handleToggleAdmin(u)}
                          >
                            {u.is_admin === 1 ? "Make User" : "Make Admin"}
                          </button>
                          <button
                            className="start-lesson-btn delete-button"
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
          <FaHome className="icon-with-margin" /> Home
        </button>
        <h2>Admin Panel</h2>
      </div>
      <div className="lessons-grid">
        {panels.map(({ icon, title, desc, key }) => (
          <div
            key={title}
            className={`lesson-card panel-card${key !== "users" ? " locked" : ""}`}
            onClick={() => key === "users" && setView("users")}
          >
            <div className="lesson-icon">{icon}</div>
            <h4>{title}</h4>
            <p className="lesson-description">{desc}</p>
            <button
              className={`start-lesson-btn panel-button${key !== "users" ? " locked" : ""}`}
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
