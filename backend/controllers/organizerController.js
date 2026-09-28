const Organizer = require('../models/Organizer');

exports.getOrganizers = async (req, res) => {
  try {
    const organizers = await Organizer.find().populate('userId', '-password');
    res.status(200).json({ success: true, count: organizers.length, data: organizers });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getOrganizerById = async (req, res) => {
  try {
    const organizer = await Organizer.findById(req.params.id).populate('userId', '-password');
    if (!organizer) return res.status(404).json({ success: false, message: 'Organizer not found' });
    res.status(200).json({ success: true, data: organizer });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.updateOrganizer = async (req, res) => {
  try {
    const organizer = await Organizer.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!organizer) return res.status(404).json({ success: false, message: 'Organizer not found' });
    res.status(200).json({ success: true, data: organizer });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
