const { Client } = require('pg');
const bcrypt = require('bcrypt');

async function seed() {
  const client = new Client({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5432', 10),
    user: process.env.DB_USERNAME || 'sims',
    password: process.env.DB_PASSWORD || 'sims_password',
    database: process.env.DB_DATABASE || 'sims',
  });

  await client.connect();

  const passwordHash = await bcrypt.hash('admin123', 10);

  const seedUsers = [
    { username: 'admin', displayName: 'System Administrator', roles: 'headmaster,asst_headmaster_academic,asst_headmaster_admin,asst_headmaster_domestic,bursary,registry', activeRole: 'headmaster' },
    { username: 'headmaster', displayName: 'Headmaster', roles: 'headmaster', activeRole: 'headmaster' },
    { username: 'academic', displayName: 'Asst. Headmaster (Academic)', roles: 'asst_headmaster_academic', activeRole: 'asst_headmaster_academic' },
    { username: 'admin_officer', displayName: 'Asst. Headmaster (Admin)', roles: 'asst_headmaster_admin', activeRole: 'asst_headmaster_admin' },
    { username: 'domestic', displayName: 'Asst. Headmaster (Domestic)', roles: 'asst_headmaster_domestic', activeRole: 'asst_headmaster_domestic' },
    { username: 'bursary', displayName: 'Bursary Officer', roles: 'bursary', activeRole: 'bursary' },
    { username: 'stores', displayName: 'Stores Officer', roles: 'stores', activeRole: 'stores' },
    { username: 'registry', displayName: 'Registry Officer', roles: 'registry', activeRole: 'registry' },
    { username: 'security', displayName: 'Security Officer', roles: 'security', activeRole: 'security' },
    { username: 'catering', displayName: 'Catering Officer', roles: 'catering', activeRole: 'catering' },
    { username: 'health', displayName: 'Health Officer', roles: 'health', activeRole: 'health' },
    { username: 'transport', displayName: 'Transport Officer', roles: 'transport', activeRole: 'transport' },
    { username: 'cleaning', displayName: 'Cleaning Supervisor', roles: 'cleaning', activeRole: 'cleaning' },
    { username: 'senior_housemaster', displayName: 'Senior Housemaster', roles: 'senior_housemaster', activeRole: 'senior_housemaster' },
    { username: 'housemaster', displayName: 'Housemaster', roles: 'housemaster', activeRole: 'housemaster' },
    { username: 'housemistress', displayName: 'Housemistress', roles: 'housemistress', activeRole: 'housemistress' },
    { username: 'teacher', displayName: 'Teacher', roles: 'teacher', activeRole: 'teacher' },
    { username: 'subject_hod', displayName: 'Subject HOD', roles: 'subject_hod', activeRole: 'subject_hod' },
    { username: 'counselling', displayName: 'Counselling Unit', roles: 'counselling', activeRole: 'counselling' },
    { username: 'library_ict', displayName: 'Library & ICT Officer', roles: 'library_ict', activeRole: 'library_ict' },
    { username: 'sports_clubs', displayName: 'Sports & Clubs Coordinator', roles: 'sports_clubs', activeRole: 'sports_clubs' },
    { username: 'plc', displayName: 'PLC Coordinator', roles: 'plc', activeRole: 'plc' },
    { username: 'governing_board', displayName: 'Governing Board Member', roles: 'governing_board', activeRole: 'governing_board' },
    { username: 'pta', displayName: 'PTA Member', roles: 'pta', activeRole: 'pta' },
    { username: 'staff', displayName: 'Staff Member', roles: 'staff', activeRole: 'staff' },
    { username: 'welfare', displayName: 'Welfare Committee Member', roles: 'welfare_committee', activeRole: 'welfare_committee' },
    { username: 'src', displayName: 'SRC Member', roles: 'src', activeRole: 'src' },
    { username: 'electoral', displayName: 'Electoral Commission Member', roles: 'electoral_commission', activeRole: 'electoral_commission' },
    { username: 'student', displayName: 'Student', roles: 'student', activeRole: 'student' },
    { username: 'parent', displayName: 'Parent', roles: 'parent', activeRole: 'parent' },
    { username: 'chaplain', displayName: 'Rev. Emmanuel Mensah', roles: 'chaplain', activeRole: 'chaplain' },
    { username: 'academic_board', displayName: 'Academic Board Member', roles: 'academic_board', activeRole: 'academic_board' },
    { username: 'dining_hall', displayName: 'Dining Hall Master', roles: 'dining_hall_master', activeRole: 'dining_hall_master' },
    { username: 'exam_committee', displayName: 'Examination Committee Member', roles: 'exam_committee', activeRole: 'exam_committee' },
    { username: 'safe_space', displayName: 'Safe Space Officer', roles: 'safe_space', activeRole: 'safe_space' },
    { username: 'auditor', displayName: 'Internal Auditor', roles: 'internal_auditor', activeRole: 'internal_auditor' },
    { username: 'secretary', displayName: 'Headmaster Secretary', roles: 'headmaster_secretary', activeRole: 'headmaster_secretary' },
  ];

  for (const u of seedUsers) {
    const exists = await client.query('SELECT id FROM users WHERE username = $1', [u.username]);
    if (exists.rows.length > 0) {
      console.log(`  Skip: ${u.username} already exists`);
      continue;
    }
    await client.query(
      `INSERT INTO users (username, "passwordHash", "displayName", "tenantId", "schoolName", "schoolLogoUrl", roles, "activeRole")
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [u.username, passwordHash, u.displayName, 'tenant-001', 'Ghana Senior High School', null, u.roles, u.activeRole]
    );
    console.log(`  Created: ${u.username} -> ${u.activeRole}`);
  }

  console.log('\nSeed complete! All users have password: admin123');
  await client.end();
}

seed().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
