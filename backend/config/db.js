const mongoose = require('mongoose');

const connectDB = async () => {
  const uri = process.env.MONGO_URI;

  try {
    if (uri && !uri.includes('<db_user>')) {
      await mongoose.connect(uri, {
        serverSelectionTimeoutMS: 4000,
      });
      console.log('MongoDB connected successfully');
      return;
    }
  } catch (err) {
    console.warn(`[MongoDB Warning] Could not connect to configured MONGO_URI (${err.message}).`);
  }

  // Graceful fallback for local development if Atlas URI is not yet configured or local mongo service is not running
  try {
    const { MongoMemoryServer } = require('mongodb-memory-server');
    const mongod = await MongoMemoryServer.create();
    const memUri = mongod.getUri();
    await mongoose.connect(memUri);
    console.log('MongoDB connected successfully');
    console.log('  -> Note: Using MongoDB memory instance until you provide your MongoDB Atlas URI in backend/.env');
  } catch (memErr) {
    console.error('MongoDB connection error:', memErr.message);
  }
};

module.exports = connectDB;
