import { Module, Global } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditLog } from './audit-log.entity';
import { AuditService } from './audit.service';
import { SubscriptionModule } from '../subscription/subscription.module';

@Global()
@Module({
  imports: [TypeOrmModule.forFeature([AuditLog]), SubscriptionModule],
  providers: [AuditService],
  exports: [AuditService],
})
export class AuditModule {}
