import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { getRepository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { User } from './auth/user.entity';

async function ensureAdminUser(app: any) {
  const configService = app.get(ConfigService);
  const adminUsername = configService.get('ADMIN_USERNAME', 'sysadmin');
  const adminPassword = configService.get('ADMIN_PASSWORD', 'SysAdmin@2026');

  const userRepo = app.get('UserRepository') || getRepository(User);

  // Migrate old 'admin' user: if it exists with headmaster roles, convert to system_admin
  const oldAdmin = await userRepo.findOne({ where: { username: 'admin' } });
  if (oldAdmin && !oldAdmin.roles.includes('system_admin')) {
    oldAdmin.roles = ['system_admin'];
    oldAdmin.activeRole = 'system_admin';
    oldAdmin.displayName = 'System Administrator';
    oldAdmin.schoolName = null;
    await userRepo.save(oldAdmin);
    console.log('[Bootstrap] Migrated old "admin" user to system_admin role.');
  }

  // Ensure the proper sysadmin user exists with correct roles
  const existing = await userRepo.findOne({ where: { username: adminUsername } });
  if (!existing) {
    const hash = await bcrypt.hash(adminPassword, 10);
    await userRepo.save(
      userRepo.create({
        username: adminUsername,
        passwordHash: hash,
        displayName: 'System Administrator',
        tenantId: 'tenant-001',
        schoolName: null,
        schoolLogoUrl: null,
        roles: ['system_admin'],
        activeRole: 'system_admin',
      })
    );
    console.log(`[Bootstrap] System admin user "${adminUsername}" created.`);
  } else if (!existing.roles.includes('system_admin')) {
    // Fix roles if the existing user doesn't have system_admin
    existing.roles = ['system_admin'];
    existing.activeRole = 'system_admin';
    existing.displayName = 'System Administrator';
    existing.schoolName = null;
    await userRepo.save(existing);
    console.log(`[Bootstrap] Updated user "${adminUsername}" to system_admin role.`);
  }
}

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  app.setGlobalPrefix('api');

  app.use(helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'", "'unsafe-inline'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        imgSrc: ["'self'", 'data:', 'blob:'],
        connectSrc: ["'self'"],
        fontSrc: ["'self'"],
        objectSrc: ["'none'"],
        frameAncestors: ["'none'"],
        upgradeInsecureRequests: [],
      },
    },
    crossOriginEmbedderPolicy: false,
  }));

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  const corsOrigin = configService.get('CORS_ORIGIN');
  const configuredOrigins = corsOrigin ? corsOrigin.split(',').map((o: string) => o.trim()) : [];
  const isDev = configService.get('NODE_ENV', 'development') !== 'production';
  const devOrigins = isDev ? ['http://localhost:8082', 'http://localhost:8083', 'http://127.0.0.1:8082', 'http://127.0.0.1:8083'] : [];
  const allowedOrigins = [...new Set([...configuredOrigins, ...devOrigins])];
  app.enableCors({
    origin: (origin, callback) => {
      if (!origin || allowedOrigins.includes(origin) || (isDev && origin && /^http:\/\/(localhost|127\.0\.0\.1):\d+$/.test(origin))) {
        callback(null, true);
      } else {
        callback(new Error(`CORS origin not allowed: ${origin}`), false);
      }
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Tenant-Id'],
  });

  await ensureAdminUser(app);

  const port = configService.get<number>('PORT', 3000);
  await app.listen(port);
}

bootstrap();
