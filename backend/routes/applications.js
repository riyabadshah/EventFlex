const express = require('express');
const router = express.Router();
const { applyForJob, getApplications, updateApplicationStatus } = require('../controllers/applicationController');

router.post('/', applyForJob);
router.get('/', getApplications);
router.put('/:id/status', updateApplicationStatus);

module.exports = router;
