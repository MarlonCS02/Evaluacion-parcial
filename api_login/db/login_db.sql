CREATE DATABASE IF NOT EXISTS login_db;
USE login_db;

-- Tabla de usuarios (solo emails permitidos)
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(50) NOT NULL  -- Contraseña simple
);

-- Tabla de estados (creados por usuarios)
CREATE TABLE IF NOT EXISTS user_status (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    status_name VARCHAR(50) NOT NULL,
    color VARCHAR(20) DEFAULT '#4CAF50',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insertar usuarios específicos (SOLO ESTOS PUEDEN LOGEARSE)
INSERT INTO users (email, name, password) VALUES
('usuario@test.com', 'Usuario Test', '123456'),
('admin@test.com', 'Administrador', '654321'),
('maria@test.com', 'Maria Gonzalez', '135792'),
('marlon4753@gmail.com', 'Marlon Castañeda', 'marlon02');

-- Ver datos
SELECT * FROM users;
SELECT * FROM user_status;