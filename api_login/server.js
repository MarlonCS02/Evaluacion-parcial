const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./src/routes/auth.routes');
const statusRoutes = require('./src/routes/status.routes');

const app = express();

app.use(cors());
app.use(express.json());

// Rutas
app.use('/api/auth', authRoutes);
app.use('/api/status', statusRoutes);

app.get('/', (req, res) => {
    res.json({ 
        message: 'API funcionando',
        usuarios_permitidos: [
            'usuario@test.com',
            'admin@test.com', 
            'maria@test.com',
            'marlon4753@gmail.com'
        ]
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`\n Servidor en http://localhost:${PORT}`);
    console.log('    Usuarios permitidos:');
    console.log('   - usuario@test.com / 123456');
    console.log('   - admin@test.com / 123456');
    console.log('   - maria@test.com / 123456');
    console.log('   - marlon4753@gmail.com / marlon02');
});