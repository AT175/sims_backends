import 'reflect-metadata';
import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';
import { User } from './auth/user.entity';
import { Student } from './students/student.entity';
import { AdmissionApplication } from './admissions/admission-application.entity';

function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Environment variable ${name} is required for seeding`);
  }
  return value;
}

function generatePassword(length = 16): string {
  return crypto.randomBytes(length).toString('base64url').slice(0, length);
}

const AppDataSource = new DataSource({
  type: 'postgres',
  host: requireEnv('DB_HOST'),
  port: parseInt(requireEnv('DB_PORT'), 10),
  username: requireEnv('DB_USERNAME'),
  password: requireEnv('DB_PASSWORD'),
  database: requireEnv('DB_DATABASE'),
  entities: [User, Student, AdmissionApplication],
  synchronize: true,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

async function seed() {
  await AppDataSource.initialize();
  const userRepo = AppDataSource.getRepository(User);

  const existing = await userRepo.findOne({ where: { username: 'admin' } });
  if (existing) {
    if (existing.roles.includes('asst_headmaster_admin')) {
      existing.roles = existing.roles.filter((r) => r !== 'asst_headmaster_admin');
      await userRepo.save(existing);
    }
  } else {
    const adminPassword = process.env.ADMIN_PASSWORD || 'Admin@2026';
    const adminHash = await bcrypt.hash(adminPassword, 10);
    await userRepo.save(
      userRepo.create({
        username: 'admin',
        passwordHash: adminHash,
        displayName: 'System Administrator',
        tenantId: 'tenant-001',
        schoolName: 'Ghana Senior High School',
        schoolLogoUrl: null,
        roles: ['headmaster', 'asst_headmaster_academic', 'asst_headmaster_domestic', 'bursary', 'registry'],
        activeRole: 'headmaster',
      })
    );
    if (!process.env.ADMIN_PASSWORD) {
      process.stdout.write(`admin:${adminPassword}\n`);
    }
  }

  const existingAdmin = await userRepo.findOne({ where: { username: 'asst_admin' } });
  if (!existingAdmin) {
    const asstPassword = process.env.ASST_ADMIN_PASSWORD || 'AsstAdmin@2026';
    const adminRoleHash = await bcrypt.hash(asstPassword, 10);
    await userRepo.save(
      userRepo.create({
        username: 'asst_admin',
        passwordHash: adminRoleHash,
        displayName: 'Kwabena Mensah',
        tenantId: 'tenant-001',
        schoolName: 'Ghana Senior High School',
        schoolLogoUrl: null,
        roles: ['asst_headmaster_admin'],
        activeRole: 'asst_headmaster_admin',
      })
    );
    if (!process.env.ASST_ADMIN_PASSWORD) {
      process.stdout.write(`asst_admin:${asstPassword}\n`);
    }
  }

  const existingSysAdmin = await userRepo.findOne({ where: { username: 'sysadmin' } });
  if (!existingSysAdmin) {
    const sysadminPassword = process.env.SYSADMIN_PASSWORD || 'SysAdmin@2026';
    const sysAdminHash = await bcrypt.hash(sysadminPassword, 10);
    await userRepo.save(
      userRepo.create({
        username: 'sysadmin',
        passwordHash: sysAdminHash,
        displayName: 'System Administrator',
        tenantId: 'tenant-001',
        schoolName: 'Ghana Senior High School',
        schoolLogoUrl: null,
        roles: ['system_admin'],
        activeRole: 'system_admin',
      })
    );
    if (!process.env.SYSADMIN_PASSWORD) {
      process.stdout.write(`sysadmin:${sysadminPassword}\n`);
    }
  }

  const extraUsers = [
    { username: 'headmaster', displayName: 'Headmaster', roles: ['headmaster'], activeRole: 'headmaster' },
    { username: 'bursary', displayName: 'Bursary Officer', roles: ['bursary'], activeRole: 'bursary' },
    { username: 'registry', displayName: 'Registry Officer', roles: ['registry'], activeRole: 'registry' },
    { username: 'teacher', displayName: 'Teacher', roles: ['teacher'], activeRole: 'teacher' },
    { username: 'security', displayName: 'Security Officer', roles: ['security'], activeRole: 'security' },
    { username: 'chaplain', displayName: 'Rev. Emmanuel Mensah', roles: ['chaplain'], activeRole: 'chaplain' },
    { username: 'academic_board', displayName: 'Academic Board Member', roles: ['academic_board'], activeRole: 'academic_board' },
    { username: 'dining_hall', displayName: 'Dining Hall Master', roles: ['dining_hall_master'], activeRole: 'dining_hall_master' },
    { username: 'exam_committee', displayName: 'Examination Committee Member', roles: ['exam_committee'], activeRole: 'exam_committee' },
    { username: 'safe_space', displayName: 'Safe Space Officer', roles: ['safe_space'], activeRole: 'safe_space' },
    { username: 'auditor', displayName: 'Internal Auditor', roles: ['internal_auditor'], activeRole: 'internal_auditor' },
    { username: 'secretary', displayName: 'Headmaster Secretary', roles: ['headmaster_secretary'], activeRole: 'headmaster_secretary' },
  ];

  for (const u of extraUsers) {
    const exists = await userRepo.findOne({ where: { username: u.username } });
    if (!exists) {
      const password = process.env.DEFAULT_USER_PASSWORD || 'SimUser@2026';
      const hash = await bcrypt.hash(password, 10);
      await userRepo.save(
        userRepo.create({
          username: u.username,
          passwordHash: hash,
          displayName: u.displayName,
          tenantId: 'tenant-001',
          schoolName: 'Ghana Senior High School',
          schoolLogoUrl: null,
          roles: u.roles,
          activeRole: u.activeRole,
        })
      );
      if (!process.env.DEFAULT_USER_PASSWORD) {
        process.stdout.write(`${u.username}:${password}\n`);
      }
    }
  }

  await AppDataSource.destroy();
}

seed().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
