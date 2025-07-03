CREATE DATABASE IF NOT EXISTS chefs_circle;
USE chefs_circle;

CREATE USER IF NOT EXISTS 'chef'@'localhost' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON chefs_circle.* TO 'chef'@'localhost';
FLUSH PRIVILEGES;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

INSERT INTO users (name, email) VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');
