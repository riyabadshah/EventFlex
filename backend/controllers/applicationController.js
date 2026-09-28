const Application = require('../models/Application');
const Job = require('../models/Job');
const Professional = require('../models/Professional');
const Attendance = require('../models/Attendance');
const Payment = require('../models/Payment');

// @desc    Apply for staffing job
// @route   POST /api/applications
// @access  Public or Protected
exports.applyForJob = async (req, res) => {
  try {
    const { jobId, professionalId } = req.body;

    if (!jobId) {
      return res.status(400).json({ success: false, message: 'Please provide jobId' });
    }

    let proId = professionalId;
    if (!proId) {
      // Find first professional or default
      const defaultPro = await Professional.findOne();
      if (defaultPro) {
        proId = defaultPro._id;
      } else {
        return res.status(400).json({ success: false, message: 'Professional ID required' });
      }
    }

    // Check if application already exists
    const existing = await Application.findOne({ jobId, professionalId: proId });
    if (existing) {
      return res.status(400).json({ success: false, message: 'Already applied for this role', data: existing });
    }

    const application = await Application.create({
      jobId,
      professionalId: proId,
      status: 'Applied',
    });

    const populated = await Application.findById(application._id)
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

// @desc    Get all applications
// @route   GET /api/applications
// @access  Public
exports.getApplications = async (req, res) => {
  try {
    const { jobId, professionalId, status } = req.query;
    const filter = {};
    if (jobId) filter.jobId = jobId;
    if (professionalId) filter.professionalId = professionalId;
    if (status && status !== 'All') filter.status = status;

    const apps = await Application.find(filter)
      .populate({
        path: 'jobId',
        populate: { path: 'eventId' },
      })
      .populate({
        path: 'professionalId',
        populate: { path: 'userId' },
      })
      .sort({ appliedAt: -1 });

    res.status(200).json({ success: true, count: apps.length, data: apps });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Update application status (Accept, Shortlist, Reject)
// @route   PUT /api/applications/:id/status
// @access  Public or Protected
exports.updateApplicationStatus = async (req, res) => {
  try {
    const { status } = req.body;
    if (!status) {
      return res.status(400).json({ success: false, message: 'Status is required' });
    }

    const application = await Application.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true }
    )
      .populate({
        path: 'jobId',
        populate: { path: 'eventId' },
      })
      .populate({
        path: 'professionalId',
        populate: { path: 'userId' },
      });

    if (!application) {
      return res.status(404).json({ success: false, message: 'Application not found' });
    }

    // Automatic Workflow: If application is accepted, create corresponding Attendance and Payment entries
    if (status === 'Accepted') {
      const existingAtt = await Attendance.findOne({
        jobId: application.jobId._id,
        professionalId: application.professionalId._id,
      });

      if (!existingAtt) {
        await Attendance.create({
          jobId: application.jobId._id,
          professionalId: application.professionalId._id,
          method: 'QR',
          status: 'Present',
        });
      }

      const existingPay = await Payment.findOne({
        jobId: application.jobId._id,
        professionalId: application.professionalId._id,
      });

      if (!existingPay) {
        await Payment.create({
          jobId: application.jobId._id,
          professionalId: application.professionalId._id,
          amount: application.jobId.payment || 3500,
          paymentStatus: 'Pending',
        });
      }
    }

    res.status(200).json({ success: true, data: application });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
