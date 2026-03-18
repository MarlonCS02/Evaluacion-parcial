module.exports = (req, res, next) => {
    const userId = req.headers['user-id'];
    
    if (!userId) {
        return res.status(401).json({
            success: false,
            message: 'No autorizado'
        });
    }

    req.userId = parseInt(userId);
    next();
};