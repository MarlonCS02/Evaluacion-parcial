const Status = require('../models/status.model');

// Crear nuevo estado
exports.createStatus = async (req, res) => {
    try {
        const { status_name, color } = req.body;
        const userId = req.userId; // viene del middleware

        console.log('Creando estado para usuario:', userId);

        if (!status_name) {
            return res.status(400).json({
                success: false,
                message: 'Nombre del estado requerido'
            });
        }

        const newStatus = await Status.create(userId, status_name, color);

        res.status(201).json({
            success: true,
            message: 'Estado creado',
            status: newStatus
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno'
        });
    }
};

// Obtener estados del usuario
exports.getStatuses = async (req, res) => {
    try {
        const userId = req.userId;
        const statuses = await Status.getUserStatuses(userId);

        res.json({
            success: true,
            statuses: statuses
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno'
        });
    }
};

// Eliminar estado
exports.deleteStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.userId;

        await Status.delete(id, userId);

        res.json({
            success: true,
            message: 'Estado eliminado'
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno'
        });
    }
};