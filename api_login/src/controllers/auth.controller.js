const User = require('../models/user.model');
const jwt = require('jsonwebtoken');
require('dotenv').config();

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        console.log(`Intento de login: ${email}`);

        // Validar datos
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Email y contraseña requeridos'
            });
        }

        const user = await User.findByEmail(email);

        if (!user) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
        }

        const isValidPassword = await User.verifyPassword(password, user.password);

        if (!isValidPassword) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
        }

        if (!user.is_active) {
            return res.status(403).json({
                success: false,
                message: 'Usuario inactivo'
            });
        }

        await User.updateLastLogin(user.id);
        
        const stats = await User.getLoginStats(user.id);

        const token = jwt.sign(
            { id: user.id, email: user.email, role: user.role },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );

        console.log(`Login exitoso - Registrado en BD: ${email}`);
        console.log(`Estadísticas: Login #${stats.login_count}`);

        res.json({
            success: true,
            message: 'Login exitoso',
            token,
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
                profile_image: user.profile_image,
                login_count: stats.login_count,
                last_login: stats.last_login
            }
        });

    } catch (error) {
        console.error('Error en login:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

exports.register = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        console.log(`📝 Registrando: ${email}`);

        if (!name || !email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Todos los campos requeridos'
            });
        }

        const existingUser = await User.findByEmail(email);
        if (existingUser) {
            return res.status(400).json({
                success: false,
                message: 'El email ya está registrado'
            });
        }

        const userId = await User.create({ name, email, password });

        console.log(`Usuario registrado en BD - ID: ${userId}`);

        res.status(201).json({
            success: true,
            message: 'Usuario registrado exitosamente',
            userId
        });

    } catch (error) {
        console.error('Error en registro:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

exports.verifyToken = async (req, res) => {
    try {
        const user = await User.findById(req.userId);
        
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        res.json({
            success: true,
            user
        });

    } catch (error) {
        console.error('Error verificando token:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

exports.getProfile = async (req, res) => {
    try {
        const user = await User.findById(req.userId);
        const stats = await User.getLoginStats(req.userId);
        
        res.json({
            success: true,
            user: {
                ...user,
                login_count: stats.login_count
            }
        });

    } catch (error) {
        console.error('Error obteniendo perfil:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};