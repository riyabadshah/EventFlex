const Job = require('../models/Job');
const Event = require('../models/Event');

// @desc    Get all staffing jobs with populated Event
// @route   GET /api/jobs
// @access  Public
exports.getJobs = async (req, res) => {
  try {
    const { role, location, minPayment, eventId } = req.query;
    const filter = {};
    if (eventId) filter.eventId = eventId;
    if (role && role !== 'All Roles') filter.role = new RegExp(role, 'i');
    if (minPayment) filter.payment = { $gte: Number(minPayment) };

    const jobs = await Job.find(filter)
      .populate({
        path: 'eventId',
        populate: { path: 'organizerId' },
      })
      .sort({ createdAt: -1 });

    res.status(200).json({ success: true, count: jobs.length, data: jobs });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Get single job by ID
// @route   GET /api/jobs/:id
// @access  Public
exports.getJobById = async (req, res) => {
  try {
    const job = await Job.findById(req.params.id).populate({
      path: 'eventId',
      populate: { path: 'organizerId' },
    });
    if (!job) return res.status(404).json({ success: false, message: 'Job not found' });
    res.status(200).json({ success: true, data: job });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Create new staffing job requirement
// @route   POST /api/jobs
// @access  Public or Protected
exports.createJob = async (req, res) => {
  try {
    const { eventId, title, role, workersRequired, requiredSkills, experienceRequired, payment, description } = req.body;

    if (!eventId || !role || !payment) {
      return res.status(400).json({ success: false, message: 'Please provide eventId, role and payment' });
    }

    const skillsArr = Array.isArray(requiredSkills)
      ? requiredSkills
      : typeof requiredSkills === 'string'
      ? requiredSkills.split(',').map((s) => s.trim()).filter(Boolean)
      : [];

    const job = await Job.create({
      eventId,
      title: title || role,
      role,
      workersRequired: Number(workersRequired) || 1,
      requiredSkills: skillsArr,
      experienceRequired: experienceRequired || '1+ years',
      payment: Number(payment),
      description: description || '',
      status: 'Open',
    });

    const populatedJob = await Job.findById(job._id).populate('eventId');
    res.status(201).json({ success: true, data: populatedJob });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Update job
// @route   PUT /api/jobs/:id
// @access  Protected
exports.updateJob = async (req, res) => {
  try {
    const job = await Job.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!job) return res.status(404).json({ success: false, message: 'Job not found' });
    res.status(200).json({ success: true, data: job });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Delete job
// @route   DELETE /api/jobs/:id
// @access  Protected
exports.deleteJob = async (req, res) => {
  try {
    const job = await Job.findByIdAndDelete(req.params.id);
    if (!job) return res.status(404).json({ success: false, message: 'Job not found' });
    res.status(200).json({ success: true, message: 'Job requirement deleted' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
