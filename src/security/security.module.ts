import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SecurityIncident } from './security-incident.entity';
import { GateLog } from './gate-log.entity';
import { SecurityService } from './security.service';
import { SecurityController } from './security.controller';

@Module({
  imports: [TypeOrmModule.forFeature([SecurityIncident, GateLog])],
  providers: [SecurityService],
  controllers: [SecurityController],
})
export class SecurityModule {}
