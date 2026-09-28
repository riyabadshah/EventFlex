const connectDB = require('./config/db');
const dotenv = require('dotenv');

dotenv.config();

/**
 * Test flow script - Demo creation has been removed.
 */
const runVerification = async () => {
  try {
    await connectDB();
    console.log('MongoDB connection verified successfully.');
    process.exit(0);
  } catch (err) {
    console.error('Database connection error:', err);
    process.exit(1);
  }
};

if (require.main === module) {
  runVerification();
}

module.exports = runVerification;
