const Event = require('../models/Event');
const Job = require('../models/Job');
const Organizer = require('../models/Organizer');

// @desc    Get all events (with populated organizer & staffing jobs)
// @route   GET /api/events
// @access  Public
exports.getEvents = async (req, res) => {
  try {
    const { eventType, location } = req.query;
    const filter = {};
    if (eventType && eventType !== 'All') filter.eventType = eventType;
    if (location && location !== 'All Locations') filter.location = new RegExp(location, 'i');

    const events = await Event.find(filter).populate('organizerId').sort({ createdAt: -1 });

    // Attach jobs/roles to each event
    const eventsWithRoles = await Promise.all(
      events.map(async (event) => {
        const jobs = await Job.find({ eventId: event._id });
        return {
          ...event.toObject(),
          roles: jobs,
        };
      })
    );

    res.status(200).json({ success: true, count: eventsWithRoles.length, data: eventsWithRoles });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Get single event by ID
// @route   GET /api/events/:id
// @access  Public
exports.getEventById = async (req, res) => {
  try {
    const event = await Event.findById(req.params.id).populate('organizerId');
    if (!event) {
      return res.status(404).json({ success: false, message: 'Event not found' });
    }
    const jobs = await Job.find({ eventId: event._id });
    res.status(200).json({ success: true, data: { ...event.toObject(), roles: jobs } });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Create new event
// @route   POST /api/events
// @access  Public or Protected
exports.createEvent = async (req, res) => {
  try {
    let organizerId = req.body.organizerId;

    if (!organizerId) {
      // Find default organizer or first available
      const org = await Organizer.findOne();
      if (org) {
        organizerId = org._id;
      } else {
        return res.status(400).json({ success: false, message: 'OrganizerId required' });
      }
    }

    const event = await Event.create({
      organizerId,
      eventName: req.body.eventName,
      eventType: req.body.eventType || 'Conferences',
      description: req.body.description || '',
      location: req.body.location,
      date: req.body.date,
      startTime: req.body.startTime || '09:00 AM',
      endTime: req.body.endTime || '06:00 PM',
      status: req.body.status || 'Upcoming',
    });

    res.status(201).json({ success: true, data: event });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Update event
// @route   PUT /api/events/:id
// @access  Protected
exports.updateEvent = async (req, res) => {
  try {
    const event = await Event.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!event) return res.status(404).json({ success: false, message: 'Event not found' });
    res.status(200).json({ success: true, data: event });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Delete event
// @route   DELETE /api/events/:id
// @access  Protected
exports.deleteEvent = async (req, res) => {
  try {
    const event = await Event.findByIdAndDelete(req.params.id);
    if (!event) return res.status(404).json({ success: false, message: 'Event not found' });
    await Job.deleteMany({ eventId: req.params.id });
    res.status(200).json({ success: true, message: 'Event and associated jobs deleted' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
