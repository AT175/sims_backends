import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';
import { AdmissionApplication } from './admission-application.entity';
import { SubmitAdmissionDto, UpdateAdmissionStatusDto } from './admission.dto';
import { User } from '../auth/user.entity';
import { SubscriptionService } from '../subscription/subscription.service';

@Injectable()
export class AdmissionsService {
  constructor(
    @InjectRepository(AdmissionApplication)
    private readonly repo: Repository<AdmissionApplication>,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
    private readonly subscriptionService: SubscriptionService,
  ) {}

  async submit(dto: SubmitAdmissionDto, tenantId: string): Promise<AdmissionApplication> {
    const app = this.repo.create({
      applicantName: dto.applicantName,
      parentName: dto.parentName,
      parentPhone: dto.parentPhone,
      parentEmail: dto.parentEmail || null,
      csspsPlacementRef: dto.csspsPlacementRef || null,
      programme: dto.programme || null,
      appliedClassLevel: dto.appliedClassLevel || null,
      previousSchool: dto.previousSchool || null,
      previousClass: dto.previousClass || null,
      dateOfBirth: dto.dateOfBirth || null,
      gender: dto.gender || null,
      tenantId,
      status: 'received',
      documentsVerified: false,
      isDirectApplication: dto.isDirectApplication || !dto.csspsPlacementRef,
      paymentStatus: dto.paymentStatus || 'pending',
      paymentMethod: dto.paymentMethod || null,
    });
    return this.repo.save(app);
  }

  async checkStatus(applicantName: string, csspsPlacementRef: string): Promise<AdmissionApplication> {
    const app = await this.repo.findOne({
      where: { applicantName, csspsPlacementRef },
    });
    if (!app) {
      throw new NotFoundException('No application found with the provided details');
    }
    return app;
  }

  async checkStatusByPhone(applicantName: string, parentPhone: string): Promise<AdmissionApplication> {
    const app = await this.repo.findOne({
      where: { applicantName, parentPhone },
    });
    if (!app) {
      throw new NotFoundException('No application found with the provided details');
    }
    return app;
  }

  async findAll(tenantId: string): Promise<AdmissionApplication[]> {
    return this.repo.find({
      where: { tenantId },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string, tenantId: string): Promise<AdmissionApplication> {
    const app = await this.repo.findOne({ where: { id, tenantId } });
    if (!app) {
      throw new NotFoundException('Admission application not found');
    }
    return app;
  }

  private generateUsername(parentName: string, applicantName: string): string {
    const parentPart = parentName.toLowerCase().replace(/[^a-z]/g, '').slice(0, 8);
    const wardPart = applicantName.toLowerCase().replace(/[^a-z]/g, '').slice(0, 4);
    return `parent_${parentPart}_${wardPart}`;
  }

  private generatePassword(): string {
    const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const lower = 'abcdefghijkmnpqrstuvwxyz';
    const digits = '23456789';
    const all = upper + lower + digits;
    const bytes = crypto.randomBytes(10);
    let pwd = '';
    pwd += upper[bytes[0] % upper.length];
    pwd += lower[bytes[1] % lower.length];
    pwd += digits[bytes[2] % digits.length];
    for (let i = 3; i < 10; i++) {
      pwd += all[bytes[i] % all.length];
    }
    return pwd;
  }

  async updateStatus(
    id: string,
    dto: UpdateAdmissionStatusDto,
    tenantId: string,
  ): Promise<AdmissionApplication> {
    const app = await this.findOne(id, tenantId);
    const wasApproved = app.status === 'approved';
    app.status = dto.status;
    if (dto.documentsVerified !== undefined) {
      app.documentsVerified = dto.documentsVerified === 'true';
    }

    // Auto-create parent account when status changes to approved
    if (dto.status === 'approved' && !wasApproved && !app.parentUserId) {
      let username = this.generateUsername(app.parentName, app.applicantName);
      let suffix = 0;
      while (await this.userRepo.findOne({ where: { username } })) {
        suffix++;
        username = `${this.generateUsername(app.parentName, app.applicantName)}${suffix}`;
      }

      const password = this.generatePassword();
      const passwordHash = await bcrypt.hash(password, 10);

      const parentUser = this.userRepo.create({
        username,
        passwordHash,
        displayName: app.parentName,
        tenantId: app.tenantId,
        schoolName: null,
        schoolLogoUrl: null,
        roles: ['parent'],
        activeRole: 'parent',
        mustChangePassword: false,
      });
      await this.userRepo.save(parentUser);

      // Create trial subscription for the parent
      await this.subscriptionService.createTrial(
        parentUser.id,
        parentUser.tenantId,
        app.applicantName,
        app.csspsPlacementRef || 'DIRECT',
      );

      app.parentUserId = parentUser.id;
      app.generatedUsername = username;
      app.generatedPassword = password;
    }

    return this.repo.save(app);
  }
}
