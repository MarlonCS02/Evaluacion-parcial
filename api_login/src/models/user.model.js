const db = require('../config/database');

class User {
    static async findByEmail(email) {
        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ?',
            [email]
        );
        return rows[0];
    }

    // Buscar usuario por ID
    static async findById(id) {
        const [rows] = await db.query(
            'SELECT id, email, name FROM users WHERE id = ?',
            [id]
        );
        return rows[0];
    }

    static verifyPassword(inputPassword, storedPassword) {
        return inputPassword === storedPassword;
    }
}

module.exports = User;