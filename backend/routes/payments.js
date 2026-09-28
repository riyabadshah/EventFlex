const express = require('express');
const router = express.Router();
const { getPayments, createPayment, updatePaymentStatus } = require('../controllers/paymentController');

router.get('/', getPayments);
router.post('/', createPayment);
router.put('/:id/status', updatePaymentStatus);

module.exports = router;
