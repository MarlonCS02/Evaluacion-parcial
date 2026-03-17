-- Crear base de datos
CREATE DATABASE IF NOT EXISTS login_db;
USE login_db;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    profile_image VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    login_count INT DEFAULT 0
);

-- Insertar usuarios de prueba (contraseña: 123456 para todos)
INSERT INTO users (name, email, password, role) VALUES
('Usuario Test', 'usuario@test.com', '$2a$10$XOP5X5Q5Q5Q5Q5Q5Q5Q5QO', 'user'),
('Administrador', 'admin@test.com', '$2a$10$XOP5X5Q5Q5Q5Q5Q5Q5Q5QO', 'admin'),
('María González', 'maria@test.com', '$2a$10$XOP5X5Q5Q5Q5Q5Q5Q5Q5QO', 'user');

-- Verificar datos
SELECT * FROM users;