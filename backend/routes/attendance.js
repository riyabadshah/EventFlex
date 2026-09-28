const express = require('express');
const router = express.Router();
const { getAttendance, checkIn, checkOut, updateAttendance } = require('../controllers/attendanceController');

router.get('/', getAttendance);
router.post('/check-in', checkIn);
router.post('/check-out', checkOut);
router.put('/:id', updateAttendance);

module.exports = router;
