const mongoose = require('mongoose');

const jobSchema = new mongoose.Schema({
  eventId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Event',
    required: true,
  },
  title: {
    type: String,
    required: [true, 'Please provide job title'],
    trim: true,
  },
  role: {
    type: String,
    required: true,
  },
  workersRequired: {
    type: Number,
    required: true,
    default: 1,
    min: 1,
  },
  requiredSkills: {
    type: [String],
    default: [],
  },
  experienceRequired: {
    type: String,
    default: '1+ years',
  },
  payment: {
    type: Number,
    required: [true, 'Please provide payment amount'],
  },
  description: {
    type: String,
    default: '',
  },
  status: {
    type: String,
    enum: ['Open', 'Filled', 'Closed'],
    default: 'Open',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Job', jobSchema);
