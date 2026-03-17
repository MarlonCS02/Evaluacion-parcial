const db = require('../config/database');
const bcrypt = require('bcryptjs');

class User {
    static async findByEmail(email) {
        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ?',
            [email]
        );
        return rows[0];
    }

    static async findById(id) {
        const [rows] = await db.query(
            'SELECT id, name, email, role, profile_image, is_active, created_at, last_login, login_count FROM users WHERE id = ?',
            [id]
        );
        return rows[0];
    }

    static async create(userData) {
        const { name, email, password, role = 'user' } = userData;
        
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        const [result] = await db.query(
            'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)',
            [name, email, hashedPassword, role]
        );

        return result.insertId;
    }

    static async updateLastLogin(id) {
        await db.query(
            'UPDATE users SET last_login = CURRENT_TIMESTAMP, login_count = login_count + 1 WHERE id = ?',
            [id]
        );
        console.log(`Usuario ID ${id} - login registrado en BD`);
    }

    static async verifyPassword(plainPassword, hashedPassword) {
        return await bcrypt.compare(plainPassword, hashedPassword);
    }

    static async getLoginStats(id) {
        const [rows] = await db.query(
            'SELECT login_count, last_login FROM users WHERE id = ?',
            [id]
        );
        return rows[0];
    }
}

module.exports = User;