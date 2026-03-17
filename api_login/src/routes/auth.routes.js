const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const authMiddleware = require('../middleware/auth');

// Rutas públicas
router.post('/login', authController.login);
router.post('/register', authController.register);

// Rutas protegidas
router.get('/verify', authMiddleware, authController.verifyToken);
router.get('/profile', authMiddleware, authController.getProfile);

module.exports = router;