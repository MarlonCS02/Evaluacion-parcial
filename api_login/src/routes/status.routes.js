const express = require('express');
const router = express.Router();
const statusController = require('../controllers/status.controller');
const authMiddleware = require('../middleware/auth');

router.use(authMiddleware);

router.post('/', statusController.createStatus);
router.get('/', statusController.getStatuses);
router.delete('/:id', statusController.deleteStatus);

module.exports = router;