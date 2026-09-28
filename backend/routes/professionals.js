const express = require('express');
const router = express.Router();
const { getProfessionals, getProfessionalById, updateProfessional } = require('../controllers/professionalController');

router.get('/', getProfessionals);
router.get('/:id', getProfessionalById);
router.put('/:id', updateProfessional);

module.exports = router;
