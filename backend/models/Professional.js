const mongoose = require('mongoose');

const professionalSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  skills: {
    type: [String],
    default: [],
  },
  experience: {
    type: String,
    default: '1 year',
  },
  location: {
    type: String,
    default: '',
  },
  rating: {
    type: Number,
    default: 5.0,
    min: 1.0,
    max: 5.0,
  },
  verificationStatus: {
    type: String,
    enum: ['Pending', 'Verified', 'Rejected'],
    default: 'Pending',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Professional', professionalSchema);
