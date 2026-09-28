const express = require('express');
const router = express.Router();
const { getOrganizers, getOrganizerById, updateOrganizer } = require('../controllers/organizerController');

router.get('/', getOrganizers);
router.get('/:id', getOrganizerById);
router.put('/:id', updateOrganizer);

module.exports = router;
