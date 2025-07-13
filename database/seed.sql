CREATE DATABASE IF NOT EXISTS chefs_circle;
USE chefs_circle;

CREATE USER IF NOT EXISTS 'chef'@'localhost' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON chefs_circle.* TO 'chef'@'localhost';
FLUSH PRIVILEGES;

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
