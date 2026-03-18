const db = require('../config/database');

class Status {
    // Crear nuevo estado
    static async create(userId, statusName, color) {
        const [result] = await db.query(
            'INSERT INTO user_status (user_id, status_name, color) VALUES (?, ?, ?)',
            [userId, statusName, color || '#4CAF50']
        );
        
        return {
            id: result.insertId,
            user_id: userId,
            status_name: statusName,
            color: color || '#4CAF50'
        };
    }

    // Obtener estados de un usuario
    static async getUserStatuses(userId) {
        const [rows] = await db.query(
            'SELECT * FROM user_status WHERE user_id = ? ORDER BY id DESC',
            [userId]
        );
        return rows;
    }

    // Eliminar estado
    static async delete(id, userId) {
        await db.query(
            'DELETE FROM user_status WHERE id = ? AND user_id = ?',
            [id, userId]
        );
        return true;
    }
}

module.exports = Status;