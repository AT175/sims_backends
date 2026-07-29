import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GesOffice } from './ges-office.entity';
import { GesReport } from './ges-report.entity';
import { Tenant } from '../tenants/tenant.entity';
import { User } from '../auth/user.entity';
import { GesService } from './ges.service';
import { GesController } from './ges.controller';

@Module({
  imports: [TypeOrmModule.forFeature([GesOffice, GesReport, Tenant, User])],
  controllers: [GesController],
  providers: [GesService],
  exports: [GesService],
})
export class GesModule {}
