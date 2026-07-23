import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StaffDirectoryEntry } from './staff-directory.entity';
import { LeaveRequest } from './leave-request.entity';
import { CreateStaffDto, CreateLeaveRequestDto, ReviewLeaveDto } from './staff.dto';

@Injectable()
export class StaffService {
  constructor(
    @InjectRepository(StaffDirectoryEntry)
    private readonly staffRepo: Repository<StaffDirectoryEntry>,
    @InjectRepository(LeaveRequest)
    private readonly leaveRepo: Repository<LeaveRequest>,
  ) {}

  async getDirectory(tenantId: string): Promise<StaffDirectoryEntry[]> {
    return this.staffRepo.find({ where: { tenantId }, order: { name: 'ASC' } });
  }

  async createStaff(dto: CreateStaffDto, tenantId: string): Promise<StaffDirectoryEntry> {
    const entry = this.staffRepo.create({ ...dto, status: 'Active', tenantId });
    return this.staffRepo.save(entry);
  }

  async getLeaveRequests(tenantId: string): Promise<LeaveRequest[]> {
    return this.leaveRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } });
  }

  async createLeaveRequest(dto: CreateLeaveRequestDto, tenantId: string): Promise<LeaveRequest> {
    const req = this.leaveRepo.create({
      ...dto,
      status: 'Pending',
      tenantId,
    });
    return this.leaveRepo.save(req);
  }

  async reviewLeaveRequest(id: string, dto: ReviewLeaveDto, reviewedBy: string, tenantId: string): Promise<LeaveRequest> {
    const req = await this.leaveRepo.findOne({ where: { id, tenantId } });
    if (!req) {
      throw new NotFoundException('Leave request not found');
    }
    req.status = dto.status;
    req.reviewedBy = reviewedBy;
    req.reviewDate = new Date().toISOString().slice(0, 10);
    req.reviewNotes = dto.reviewNotes || null;
    return this.leaveRepo.save(req);
  }
}
