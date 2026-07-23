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
import { BursaryModule } from './bursary/bursary.module';
import { StaffModule } from './staff/staff.module';
import { AcademicModule } from './academic/academic.module';
import { BoardingModule } from './boarding/boarding.module';
import { LibraryModule } from './library/library.module';
import { SportsModule } from './sports/sports.module';
import { PTAModule } from './pta/pta.module';
import { TransportModule } from './transport/transport.module';
import { SecurityModule } from './security/security.module';
import { CleaningModule } from './cleaning/cleaning.module';
import { ChaplainModule } from './chaplain/chaplain.module';
import { CounsellingModule } from './counselling/counselling.module';
import { KitchenModule } from './kitchen/kitchen.module';
import { RequisitionModule } from './requisition/requisition.module';
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
          synchronize: true,
          logging: isDev,
          ssl: !isDev ? { rejectUnauthorized: false } : false,
        };
      },
    }),
    AuthModule,
    SyncModule,
    StudentsModule,
    AdmissionsModule,
    AuditModule,
    BursaryModule,
    StaffModule,
    AcademicModule,
    BoardingModule,
    LibraryModule,
    SportsModule,
    PTAModule,
    TransportModule,
    SecurityModule,
    CleaningModule,
    ChaplainModule,
    CounsellingModule,
    KitchenModule,
    RequisitionModule,
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
