const mongoose = require('mongoose');

const attendanceSchema = new mongoose.Schema({
  jobId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Job',
    required: true,
  },
  professionalId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Professional',
    required: true,
  },
  checkIn: {
    type: Date,
    default: Date.now,
  },
  checkOut: {
    type: Date,
  },
  method: {
    type: String,
    enum: ['QR', 'GPS', 'Manual'],
    default: 'QR',
  },
  status: {
    type: String,
    enum: ['Present', 'Late', 'Absent'],
    default: 'Present',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Attendance', attendanceSchema);
