const mongoose = require('mongoose');

const organizerSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  organizationName: {
    type: String,
    required: [true, 'Please provide an organization or company name'],
    trim: true,
  },
  location: {
    type: String,
    default: '',
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

module.exports = mongoose.model('Organizer', organizerSchema);
