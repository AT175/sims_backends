import 'reflect-metadata';
import * as fs from 'fs';
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
  ssl: fs.existsSync('global-bundle.pem') ? { rejectUnauthorized: true, ca: fs.readFileSync('global-bundle.pem').toString() } : false,
});

async function seed() {
  await AppDataSource.initialize();
  const userRepo = AppDataSource.getRepository(User);

  // Only seed the system_admin (master admin for the entire system)
  // The sysadmin will then create the headmaster for each tenant via the dashboard
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
        schoolName: null,
        schoolLogoUrl: null,
        roles: ['system_admin'],
        activeRole: 'system_admin',
      })
    );
    if (!process.env.SYSADMIN_PASSWORD) {
      process.stdout.write(`sysadmin:${sysadminPassword}\n`);
    }
  }

  await AppDataSource.destroy();
}

seed().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
