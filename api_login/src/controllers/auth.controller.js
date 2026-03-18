const User = require('../models/user.model');

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        
        console.log('Login intent:', email);

        // Validar que llegaron los datos
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Email y contraseña requeridos'
            });
        }

        // Buscar usuario en BD
        const user = await User.findByEmail(email);
        
        // Si no existe, error
        if (!user) {
            console.log('Usuario no encontrado:', email);
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
        }

        // Verificar contraseña
        if (!User.verifyPassword(password, user.password)) {
            console.log('Contraseña incorrecta para:', email);
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
        }

        console.log('Login exitoso:', email);

        res.json({
            success: true,
            message: 'Login exitoso',
            user: {
                id: user.id,
                email: user.email,
                name: user.name
            }
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno'
        });
    }
};