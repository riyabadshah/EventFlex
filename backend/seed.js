const connectDB = require('./config/db');
const dotenv = require('dotenv');

dotenv.config();

/**
 * Seed script - Demo/fake data seeding has been completely removed.
 * Real data must be created through the GoWow / EventFlex application interfaces and APIs.
 */
const seedData = async () => {
  try {
    await connectDB();
    console.log('GoWow EventFlex: Demo and mock data seeding is disabled.');
    console.log('Real data is preserved. Use the application or API endpoints to create genuine records.');
    process.exit(0);
  } catch (err) {
    console.error('Database connection error:', err);
    process.exit(1);
  }
};

if (require.main === module) {
  seedData();
}

module.exports = seedData;
