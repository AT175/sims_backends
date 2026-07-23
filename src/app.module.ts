import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD, Reflector } from '@nestjs/core';
import { AuthModule } from './auth/auth.module';
import { SyncModule } from './sync/sync.module';
import { StudentsModule } from './students/students.module';
import { AdmissionsModule } from './admissions/admissions.module';
import { AuditModule } from './audit/audit.module';
import { RolesGuard } from './auth/roles.guard';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    ThrottlerModule.forRoot([
      {
        name: 'default',
        ttl: 60000,
        limit: 100,
      },
      {
        name: 'auth',
        ttl: 60000,
        limit: 10,
      },
    ]),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        const isDev = config.get('NODE_ENV', 'development') !== 'production';
        return {
          type: 'postgres',
          host: config.getOrThrow('DB_HOST'),
          port: config.getOrThrow<number>('DB_PORT'),
          username: config.getOrThrow('DB_USERNAME'),
          password: config.getOrThrow('DB_PASSWORD'),
          database: config.getOrThrow('DB_DATABASE'),
          autoLoadEntities: true,
          synchronize: isDev,
          logging: isDev,
        };
      },
    }),
    AuthModule,
    SyncModule,
    StudentsModule,
    AdmissionsModule,
    AuditModule,
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    {
      provide: APP_GUARD,
      useClass: RolesGuard,
    },
    Reflector,
  ],
})
export class AppModule {}
