const Professional = require('../models/Professional');

exports.getProfessionals = async (req, res) => {
  try {
    const { skills, location } = req.query;
    const filter = {};
    if (skills) filter.skills = { $in: skills.split(',') };
    if (location) filter.location = new RegExp(location, 'i');

    const professionals = await Professional.find(filter).populate('userId', '-password');
    res.status(200).json({ success: true, count: professionals.length, data: professionals });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getProfessionalById = async (req, res) => {
  try {
    const professional = await Professional.findById(req.params.id).populate('userId', '-password');
    if (!professional) return res.status(404).json({ success: false, message: 'Professional not found' });
    res.status(200).json({ success: true, data: professional });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.updateProfessional = async (req, res) => {
  try {
    const professional = await Professional.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!professional) return res.status(404).json({ success: false, message: 'Professional not found' });
    res.status(200).json({ success: true, data: professional });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
