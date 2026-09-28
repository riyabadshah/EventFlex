const Payment = require('../models/Payment');

// @desc    Get all payment records
// @route   GET /api/payments
// @access  Public
exports.getPayments = async (req, res) => {
  try {
    const { jobId, professionalId, status } = req.query;
    const filter = {};
    if (jobId) filter.jobId = jobId;
    if (professionalId) filter.professionalId = professionalId;
    if (status && status !== 'All') filter.paymentStatus = status;

    const payments = await Payment.find(filter)
      .populate({
        path: 'jobId',
        populate: { path: 'eventId' },
      })
      .populate({
        path: 'professionalId',
        populate: { path: 'userId' },
      })
      .sort({ createdAt: -1 });

    res.status(200).json({ success: true, count: payments.length, data: payments });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Create new payment record
// @route   POST /api/payments
// @access  Public
exports.createPayment = async (req, res) => {
  try {
    const { jobId, professionalId, amount, paymentStatus } = req.body;
    if (!jobId || !professionalId || !amount) {
      return res.status(400).json({ success: false, message: 'Please provide jobId, professionalId, and amount' });
    }

    const payment = await Payment.create({
      jobId,
      professionalId,
      amount: Number(amount),
      paymentStatus: paymentStatus || 'Pending',
    });

    const populated = await Payment.findById(payment._id)
      .populate({
        path: 'jobId',
        populate: { path: 'eventId' },
      })
      .populate({
        path: 'professionalId',
        populate: { path: 'userId' },
      });

    res.status(201).json({ success: true, data: populated });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Update payment status (Pending -> Processing -> Paid)
// @route   PUT /api/payments/:id/status
// @access  Public
exports.updatePaymentStatus = async (req, res) => {
  try {
    const { paymentStatus } = req.body;
    if (!paymentStatus) {
      return res.status(400).json({ success: false, message: 'paymentStatus is required' });
    }

    const updateData = { paymentStatus };
    if (paymentStatus === 'Paid') {
      updateData.paidAt = new Date();
    }

    const payment = await Payment.findByIdAndUpdate(req.params.id, updateData, { new: true })
      .populate({
        path: 'jobId',
        populate: { path: 'eventId' },
      })
      .populate({
        path: 'professionalId',
        populate: { path: 'userId' },
      });

    if (!payment) return res.status(404).json({ success: false, message: 'Payment record not found' });
    res.status(200).json({ success: true, data: payment });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
