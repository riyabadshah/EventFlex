const jwt = require('jsonwebtoken');
const User = require('../models/User');
const Organizer = require('../models/Organizer');
const Professional = require('../models/Professional');

// Helper to sign JWT
const sendTokenResponse = (user, statusCode, res, extraData = {}) => {
  const token = jwt.sign(
    { id: user._id, role: user.role },
    process.env.JWT_SECRET || 'gowow_fallback_secret_key_2026',
    { expiresIn: process.env.JWT_EXPIRE || '30d' }
  );

  res.status(statusCode).json({
    success: true,
    token,
    user: {
      id: user._id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      createdAt: user.createdAt,
    },
    ...extraData,
  });
};

// @desc    Register new user (Organizer or Professional)
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res) => {
  try {
    const { name, email, password, phone, role, organizationName, location, skills, experience } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ success: false, message: 'Please provide name, email and password' });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ success: false, message: 'Email already registered' });
    }

    const assignedRole = role === 'organizer' ? 'organizer' : 'professional';

    const user = await User.create({
      name,
      email,
      password,
      phone: phone || '',
      role: assignedRole,
    });

    let profileData = null;

    if (assignedRole === 'organizer') {
      profileData = await Organizer.create({
        userId: user._id,
        organizationName: organizationName || `${name} Productions`,
        location: location || '',
        verificationStatus: 'Pending',
      });
    } else {
      const skillsArr = Array.isArray(skills)
        ? skills
        : typeof skills === 'string'
        ? skills.split(',').map((s) => s.trim()).filter(Boolean)
        : [];

      profileData = await Professional.create({
        userId: user._id,
        skills: skillsArr,
        experience: experience || '1 year',
        location: location || '',
        rating: 5.0,
        verificationStatus: 'Pending',
      });
    }

    return sendTokenResponse(user, 201, res, { profile: profileData });
  } catch (err) {
    console.error('Registration Error:', err);
    return res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Please provide email and password' });
    }

    const user = await User.findOne({ email }).select('+password');
    if (!user) {
      return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }

    const isMatch = await user.matchPassword(password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }

    let profile = null;
    if (user.role === 'organizer') {
      profile = await Organizer.findOne({ userId: user._id });
    } else if (user.role === 'professional') {
      profile = await Professional.findOne({ userId: user._id });
    }

    return sendTokenResponse(user, 200, res, { profile });
  } catch (err) {
    console.error('Login Error:', err);
    return res.status(500).json({ success: false, message: err.message });
  }
};

// @desc    Get current logged in user & profile
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    let profile = null;

    if (user.role === 'organizer') {
      profile = await Organizer.findOne({ userId: user._id });
    } else if (user.role === 'professional') {
      profile = await Professional.findOne({ userId: user._id });
    }

    res.status(200).json({
      success: true,
      user,
      profile,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
