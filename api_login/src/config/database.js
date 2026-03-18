const mysql = require('mysql2');
require('dotenv').config();

console.log('   Conectando a MySQL con:');
console.log('   Host:', process.env.DB_HOST);
console.log('   User:', process.env.DB_USER);
console.log('   Password:', process.env.DB_PASSWORD ? '****' : '(vacío)');
console.log('   DB:', process.env.DB_NAME);

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '', 
    database: process.env.DB_NAME || 'login_db',
    waitForConnections: true,
    connectionLimit: 10
});

const promisePool = pool.promise();

// Probar conexión
(async () => {
    try {
        const connection = await promisePool.getConnection();
        console.log('Conectado a MySQL correctamente');
        connection.release();
    } catch (error) {
        console.error(' Error conectando a MySQL:');
        console.error('   Código:', error.code);
        console.error('   Mensaje:', error.message);
        
        if (error.code === 'ER_ACCESS_DENIED_ERROR') {
            console.error('\n  SOLUCIÓN:');
            console.error('   1. Verifica que MySQL esté corriendo');
            console.error('   2. La contraseña debe estar VACÍA en .env');
            console.error('   3. En XAMPP, la contraseña por defecto es vacía');
        }
    }
})();

module.exports = promisePool;