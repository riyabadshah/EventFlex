const Attendance = require('../models/Attendance');

// @desc    Get all attendance records
// @route   GET /api/attendance
// @access  Public
exports.getAttendance = async (req, res) => {
  try {
    const { jobId, professionalId } = req.query;
    const filter = {};
    if (jobId) filter.jobId = jobId;
    if (professionalId) filter.professionalId = professionalId;

    const records = await Attendance.find(filter)
      .populate({
        path: 'jobId',
        populate: { path: 'eventId' },
      })
      .populate({
        path: 'professionalId',
        populate: { path: 'userId' },
      })
      .sort({ createdAt: -1 });

    res.status(200).json({ success: true, count: records.length, data: records });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Record check-in (via QR, GPS, or manual)
// @route   POST /api/attendance/check-in
// @access  Public
exports.checkIn = async (req, res) => {
  try {
    const { jobId, professionalId, method } = req.body;
    if (!jobId || !professionalId) {
      return res.status(400).json({ success: false, message: 'Please provide jobId and professionalId' });
    }

    let record = await Attendance.findOne({ jobId, professionalId });
    if (record) {
      record.checkIn = new Date();
      record.status = 'Present';
      record.method = method || 'QR';
      await record.save();
    } else {
      record = await Attendance.create({
        jobId,
        professionalId,
        checkIn: new Date(),
        method: method || 'QR',
        status: 'Present',
      });
    }

    const populated = await Attendance.findById(record._id)
      .populate({
        path: 'jobId',
        populate: { path: 'eventId' },
      })
      .populate({
        path: 'professionalId',
        populate: { path: 'userId' },
      });

    res.status(200).json({ success: true, message: 'Check-in recorded successfully', data: populated });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Record check-out
// @route   POST /api/attendance/check-out
// @access  Public
exports.checkOut = async (req, res) => {
  try {
    const { jobId, professionalId } = req.body;
    if (!jobId || !professionalId) {
      return res.status(400).json({ success: false, message: 'Please provide jobId and professionalId' });
    }

    const record = await Attendance.findOne({ jobId, professionalId });
    if (!record) {
      return res.status(404).json({ success: false, message: 'Attendance record not found for check-out' });
    }

    record.checkOut = new Date();
    await record.save();

    res.status(200).json({ success: true, message: 'Check-out recorded successfully', data: record });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Update attendance status (Present, Late, Absent)
// @route   PUT /api/attendance/:id
// @access  Public
exports.updateAttendance = async (req, res) => {
  try {
    const record = await Attendance.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!record) return res.status(404).json({ success: false, message: 'Record not found' });
    res.status(200).json({ success: true, data: record });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
