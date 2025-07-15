CREATE DATABASE IF NOT EXISTS chefs_circle;
USE chefs_circle;

CREATE USER IF NOT EXISTS 'chef'@'localhost' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON chefs_circle.* TO 'chef'@'localhost';
FLUSH PRIVILEGES;

DROP TABLE IF EXISTS streak;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    pwd VARCHAR(255) NOT NULL
);

INSERT INTO users (name, username, email, pwd) VALUES
('Alice', 'alice_a', 'alice@example.com', 'password123'),
('Bob', 'bob_b', 'bob@example.com', 'securepass'),
('Charlie', 'charlie_c', 'charlie@example.com', 'mypassword');

CREATE TABLE streak (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usr_id INT NOT NULL,
    curr_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    last_active_dt DATE,
    FOREIGN KEY (usr_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO streak (usr_id, curr_streak, longest_streak, last_active_dt) VALUES
(1, 5, 10, '2025-07-15'),
(2, 2, 4, '2025-07-15'),
(3, 0, 3, '2025-07-15');
