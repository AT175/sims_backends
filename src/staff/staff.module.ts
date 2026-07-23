import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StaffDirectoryEntry } from './staff-directory.entity';
import { LeaveRequest } from './leave-request.entity';
import { StaffService } from './staff.service';
import { StaffController } from './staff.controller';

@Module({
  imports: [TypeOrmModule.forFeature([StaffDirectoryEntry, LeaveRequest])],
  providers: [StaffService],
  controllers: [StaffController],
})
export class StaffModule {}
