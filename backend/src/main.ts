import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import helmet from 'helmet';
import { AppModule } from './app.module';

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

  const port = configService.get<number>('PORT', 3000);
  await app.listen(port);
}

bootstrap();
