const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
  organizerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Organizer',
    required: true,
  },
  eventName: {
    type: String,
    required: [true, 'Please provide an event name'],
    trim: true,
  },
  eventType: {
    type: String,
    required: true,
    default: 'Conferences',
  },
  description: {
    type: String,
    default: '',
  },
  location: {
    type: String,
    required: [true, 'Please provide event location'],
  },
  date: {
    type: String,
    required: [true, 'Please provide event date'],
  },
  startTime: {
    type: String,
    default: '09:00 AM',
  },
  endTime: {
    type: String,
    default: '06:00 PM',
  },
  status: {
    type: String,
    enum: ['Upcoming', 'Active', 'Completed'],
    default: 'Upcoming',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Event', eventSchema);
