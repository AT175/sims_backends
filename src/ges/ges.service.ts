import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';
import { GesOffice, GesLevel } from './ges-office.entity';
import { GesReport } from './ges-report.entity';
import { Tenant } from '../tenants/tenant.entity';
import { User } from '../auth/user.entity';
import {
  CreateGesOfficeDto,
  UpdateGesOfficeDto,
  CreateGesReportDto,
  UpdateGesReportStatusDto,
} from './ges.dto';

const GES_ROLES = ['ges_national', 'ges_regional', 'ges_district', 'siso', 'ges_auditor', 'emis'];

@Injectable()
export class GesService {
  constructor(
    @InjectRepository(GesOffice)
    private readonly officeRepo: Repository<GesOffice>,
    @InjectRepository(GesReport)
    private readonly reportRepo: Repository<GesReport>,
    @InjectRepository(Tenant)
    private readonly tenantRepo: Repository<Tenant>,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  // ── Office CRUD ──

  async createOffice(dto: CreateGesOfficeDto): Promise<GesOffice> {
    const existing = await this.officeRepo.findOne({ where: { officeKey: dto.officeKey } });
    if (existing) throw new BadRequestException('Office key already exists');

    // Validate parent exists if provided
    if (dto.parentId) {
      const parent = await this.officeRepo.findOne({ where: { id: dto.parentId } });
      if (!parent) throw new BadRequestException('Parent office not found');
      // Validate hierarchy: district -> regional -> national
      const validLevels: Record<string, string> = {
        regional: 'national',
        district: 'regional',
      };
      if (validLevels[dto.level] && parent.level !== validLevels[dto.level]) {
        throw new BadRequestException(`${dto.level} office must have a ${validLevels[dto.level]} parent`);
      }
    } else if (dto.level !== 'national') {
      throw new BadRequestException('Only national-level offices can have no parent');
    }

    const office = this.officeRepo.create({
      officeKey: dto.officeKey,
      name: dto.name,
      level: dto.level as GesLevel,
      parentId: dto.parentId || null,
      gesCode: dto.gesCode || null,
      region: dto.region || null,
      district: dto.district || null,
      address: dto.address || null,
      phone: dto.phone || null,
      email: dto.email || null,
      headName: dto.headName || null,
      headTitle: dto.headTitle || null,
    });
    const saved = await this.officeRepo.save(office);

    // Create a tenant for this GES office so it can have users
    const existingTenant = await this.tenantRepo.findOne({ where: { tenantKey: dto.officeKey } });
    if (!existingTenant) {
      const gesTenant = this.tenantRepo.create({
        tenantKey: dto.officeKey,
        schoolName: dto.name,
        schoolCode: dto.gesCode || null,
        schoolLevel: 'shs',
        region: dto.region || null,
        district: dto.district || null,
        address: dto.address || null,
        phone: dto.phone || null,
        email: dto.email || null,
        isGesOffice: true,
        active: true,
        enabledModules: [],
        disabledRoles: [],
        maxStudents: 0,
        maxStaff: 0,
        subscriptionPlan: 'Premium',
      } as any);
      await this.tenantRepo.save(gesTenant);
    }

    return saved;
  }

  async findAllOffices(level?: string, parentId?: string): Promise<GesOffice[]> {
    const where: any = {};
    if (level) where.level = level;
    if (parentId) where.parentId = parentId;
    return this.officeRepo.find({ where, order: { name: 'ASC' } });
  }

  async findOfficeById(id: string): Promise<GesOffice> {
    const office = await this.officeRepo.findOne({ where: { id } });
    if (!office) throw new NotFoundException('GES office not found');
    return office;
  }

  async findOfficeByKey(key: string): Promise<GesOffice | null> {
    return this.officeRepo.findOne({ where: { officeKey: key } });
  }

  // Find GES office by tenant key (for logged-in GES users)
  async findOfficeByTenantKey(tenantKey: string): Promise<GesOffice | null> {
    return this.officeRepo.findOne({ where: { officeKey: tenantKey } });
  }

  async updateOffice(id: string, dto: UpdateGesOfficeDto): Promise<GesOffice> {
    const office = await this.findOfficeById(id);
    Object.assign(office, dto);
    return this.officeRepo.save(office);
  }

  async deleteOffice(id: string): Promise<{ message: string }> {
    const office = await this.findOfficeById(id);
    // Check for child offices
    const children = await this.officeRepo.find({ where: { parentId: office.id } });
    if (children.length > 0) {
      throw new BadRequestException('Cannot delete office with child offices. Delete children first.');
    }
    await this.officeRepo.remove(office);
    return { message: 'GES office deleted' };
  }

  // Get full hierarchy tree
  async getOfficeTree(): Promise<any[]> {
    const all = await this.officeRepo.find({ order: { level: 'ASC', name: 'ASC' } });
    const buildTree = (parentId: string | null): any[] => {
      return all
        .filter((o) => o.parentId === parentId)
        .map((o) => ({
          ...o,
          children: buildTree(o.id),
        }));
    };
    return buildTree(null);
  }

  // Get all offices under a given office (descendants)
  async getDescendants(officeId: string): Promise<GesOffice[]> {
    const result: GesOffice[] = [];
    const collect = async (pid: string) => {
      const children = await this.officeRepo.find({ where: { parentId: pid } });
      for (const child of children) {
        result.push(child);
        await collect(child.id);
      }
    };
    await collect(officeId);
    return result;
  }

  // Get all office IDs in the hierarchy (self + descendants)
  async getOfficeHierarchyIds(officeId: string): Promise<string[]> {
    const descendants = await this.getDescendants(officeId);
    return [officeId, ...descendants.map((d) => d.id)];
  }

  // ── Report CRUD ──

  async createReport(dto: CreateGesReportDto, tenantId: string, gesOfficeId?: string): Promise<GesReport> {
    // Resolve GES office: use provided one, or find office for this tenant
    let officeId = dto.gesOfficeId || gesOfficeId;
    if (!officeId) {
      const tenant = await this.tenantRepo.findOne({ where: { tenantKey: tenantId } });
      if (tenant && (tenant as any).gesOfficeId) {
        officeId = (tenant as any).gesOfficeId;
      }
    }
    if (!officeId) throw new BadRequestException('No GES office specified and tenant has no office assignment');

    const tenant = await this.tenantRepo.findOne({ where: { tenantKey: tenantId } });
    const report = this.reportRepo.create({
      tenantId,
      schoolName: tenant?.schoolName || tenantId,
      schoolLevel: tenant?.schoolLevel || null,
      schoolCode: tenant?.schoolCode || null,
      gesOfficeId: officeId,
      reportType: dto.reportType as GesReport['reportType'],
      title: dto.title,
      description: dto.description || null,
      academicYear: dto.academicYear,
      term: dto.term || null,
      reportData: dto.reportData || null,
      attachments: dto.attachments || [],
      status: 'draft' as GesReport['status'],
      deadline: dto.deadline ? new Date(dto.deadline) : null,
    });
    return this.reportRepo.save(report);
  }

  async findReportsByTenant(tenantId: string): Promise<GesReport[]> {
    return this.reportRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } });
  }

  async findReportsByOffice(officeId: string, includeChildren: boolean = false): Promise<GesReport[]> {
    if (includeChildren) {
      const officeIds = await this.getOfficeHierarchyIds(officeId);
      return this.reportRepo.find({
        where: officeIds.map((id) => ({ gesOfficeId: id })),
        order: { createdAt: 'DESC' },
      });
    }
    return this.reportRepo.find({ where: { gesOfficeId: officeId }, order: { createdAt: 'DESC' } });
  }

  async findReportById(id: string): Promise<GesReport> {
    const report = await this.reportRepo.findOne({ where: { id } });
    if (!report) throw new NotFoundException('GES report not found');
    return report;
  }

  async submitReport(id: string): Promise<GesReport> {
    const report = await this.findReportById(id);
    report.status = 'submitted';
    report.submittedAt = new Date();
    return this.reportRepo.save(report);
  }

  async updateReportStatus(id: string, dto: UpdateGesReportStatusDto, reviewerId: string): Promise<GesReport> {
    const report = await this.findReportById(id);
    report.status = dto.status as GesReport['status'];
    report.reviewedBy = reviewerId;
    report.reviewNotes = dto.reviewNotes || null;
    report.reviewedAt = new Date();
    return this.reportRepo.save(report);
  }

  // ── School-Office assignment ──

  async assignSchoolToOffice(tenantId: string, gesOfficeId: string): Promise<Tenant> {
    const tenant = await this.tenantRepo.findOne({ where: { tenantKey: tenantId } });
    if (!tenant) throw new NotFoundException('Tenant not found');
    const office = await this.findOfficeById(gesOfficeId);
    if (office.level !== 'district') {
      throw new BadRequestException('Schools must be assigned to a district-level office');
    }
    (tenant as any).gesOfficeId = gesOfficeId;
    return this.tenantRepo.save(tenant);
  }

  async getSchoolsByOffice(officeId: string, includeChildren: boolean = false): Promise<Tenant[]> {
    if (includeChildren) {
      const officeIds = await this.getOfficeHierarchyIds(officeId);
      // Schools are linked to district offices
      const districts = await this.officeRepo.find({
        where: officeIds.map((id) => ({ id, level: 'district' as GesLevel })),
      });
      const districtIds = districts.map((d) => d.id);
      if (districtIds.length === 0) return [];
      return this.tenantRepo.find({
        where: districtIds.map((did) => ({ gesOfficeId: did } as any)),
      });
    }
    return this.tenantRepo.find({ where: { gesOfficeId: officeId } as any });
  }

  // ── User Management ──

  async createGesUser(data: {
    username: string;
    password?: string;
    displayName: string;
    role: string;
    tenantId: string;
  }): Promise<{ user: any; generatedPassword?: string }> {
    if (!GES_ROLES.includes(data.role)) {
      throw new BadRequestException(`Invalid GES role. Must be one of: ${GES_ROLES.join(', ')}`);
    }

    const existing = await this.userRepo.findOne({ where: { username: data.username } });
    if (existing) throw new BadRequestException('Username already exists');

    const tenant = await this.tenantRepo.findOne({ where: { tenantKey: data.tenantId } });
    if (!tenant) throw new BadRequestException('Tenant not found');
    if (!tenant.isGesOffice) throw new BadRequestException('GES users can only be created in GES office tenants');

    let generatedPassword: string | undefined;
    let password = data.password;
    if (!password) {
      const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
      const lower = 'abcdefghijkmnpqrstuvwxyz';
      const digits = '23456789';
      const all = upper + lower + digits;
      const bytes = crypto.randomBytes(16);
      let pwd = '';
      pwd += upper[bytes[0] % upper.length];
      pwd += lower[bytes[1] % lower.length];
      pwd += digits[bytes[2] % digits.length];
      for (let i = 3; i < 12; i++) {
        pwd += all[bytes[i] % all.length];
      }
      pwd = pwd.split('').sort(() => Math.random() - 0.5).join('');
      generatedPassword = pwd;
      password = pwd;
    }

    if (password.length < 6) throw new BadRequestException('Password must be at least 6 characters');

    const passwordHash = await bcrypt.hash(password, 10);
    const user = this.userRepo.create({
      username: data.username,
      passwordHash,
      displayName: data.displayName,
      tenantId: data.tenantId,
      schoolName: tenant.schoolName,
      schoolLogoUrl: null,
      roles: [data.role],
      activeRole: data.role,
      mustChangePassword: !data.password,
    });
    await this.userRepo.save(user);

    return {
      user: {
        id: user.id,
        username: user.username,
        displayName: user.displayName,
        roles: user.roles,
        activeRole: user.activeRole,
        tenantId: user.tenantId,
        mustChangePassword: user.mustChangePassword,
      },
      generatedPassword,
    };
  }

  async listGesUsers(tenantId: string): Promise<any[]> {
    const users = await this.userRepo.find({ where: { tenantId } });
    return users.map((u) => ({
      id: u.id,
      username: u.username,
      displayName: u.displayName,
      roles: u.roles,
      activeRole: u.activeRole,
      mustChangePassword: u.mustChangePassword,
      createdAt: u.createdAt,
    }));
  }

  async resetGesUserPassword(userId: string, newPassword?: string): Promise<{ message: string; generatedPassword?: string }> {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');

    let generatedPassword: string | undefined;
    let password = newPassword;
    if (!password) {
      const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
      const lower = 'abcdefghijkmnpqrstuvwxyz';
      const digits = '23456789';
      const all = upper + lower + digits;
      const bytes = crypto.randomBytes(16);
      let pwd = '';
      pwd += upper[bytes[0] % upper.length];
      pwd += lower[bytes[1] % lower.length];
      pwd += digits[bytes[2] % digits.length];
      for (let i = 3; i < 12; i++) {
        pwd += all[bytes[i] % all.length];
      }
      pwd = pwd.split('').sort(() => Math.random() - 0.5).join('');
      generatedPassword = pwd;
      password = pwd;
    }

    user.passwordHash = await bcrypt.hash(password, 10);
    user.mustChangePassword = true;
    await this.userRepo.save(user);
    return { message: 'Password reset', generatedPassword };
  }

  async deleteGesUser(userId: string): Promise<{ message: string }> {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    await this.userRepo.remove(user);
    return { message: 'User deleted' };
  }

  // ── Supervisory Report Generation ──

  async generateSupervisoryReport(tenantId: string, gesOfficeId: string, academicYear: string, term: string): Promise<GesReport> {
    const tenant = await this.tenantRepo.findOne({ where: { tenantKey: tenantId } });
    if (!tenant) throw new NotFoundException('School not found');

    const reportData: Record<string, any> = {
      schoolName: tenant.schoolName,
      schoolLevel: tenant.schoolLevel,
      schoolCode: tenant.schoolCode,
      region: tenant.region,
      district: tenant.district,
      active: tenant.active,
      subscriptionPlan: tenant.subscriptionPlan,
      enabledModules: tenant.enabledModules,
      disabledRoles: tenant.disabledRoles,
      maxStudents: tenant.maxStudents,
      maxStaff: tenant.maxStaff,
      generatedAt: new Date().toISOString(),
    };

    const report = this.reportRepo.create({
      tenantId,
      schoolName: tenant.schoolName,
      schoolLevel: tenant.schoolLevel || null,
      schoolCode: tenant.schoolCode || null,
      gesOfficeId,
      reportType: 'supervisory' as GesReport['reportType'],
      title: `Supervisory Report - ${tenant.schoolName} - ${term} ${academicYear}`,
      description: `Comprehensive supervisory report generated for ${tenant.schoolName}`,
      academicYear,
      term,
      reportData,
      attachments: [],
      status: 'submitted' as GesReport['status'],
      submittedAt: new Date(),
    });
    return this.reportRepo.save(report);
  }

  async generateBatchSupervisoryReports(officeId: string, academicYear: string, term: string): Promise<{ generated: number; reports: GesReport[] }> {
    const schools = await this.getSchoolsByOffice(officeId, true);
    const reports: GesReport[] = [];
    for (const school of schools) {
      try {
        const report = await this.generateSupervisoryReport(school.tenantKey, officeId, academicYear, term);
        reports.push(report);
      } catch {
        // Skip schools that fail
      }
    }
    return { generated: reports.length, reports };
  }

  // ── Dashboard stats ──

  async getOfficeStats(officeId: string, includeChildren: boolean = false) {
    const reports = await this.findReportsByOffice(officeId, includeChildren);
    const schools = await this.getSchoolsByOffice(officeId, includeChildren);

    const byStatus = reports.reduce((acc, r) => {
      acc[r.status] = (acc[r.status] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    const byType = reports.reduce((acc, r) => {
      acc[r.reportType] = (acc[r.reportType] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    const byLevel = schools.reduce((acc, s) => {
      const level = s.schoolLevel || 'unknown';
      acc[level] = (acc[level] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    const activeSchools = schools.filter((s) => s.active).length;
    const inactiveSchools = schools.filter((s) => !s.active).length;

    const byPlan = schools.reduce((acc, s) => {
      const plan = s.subscriptionPlan || 'Standard';
      acc[plan] = (acc[plan] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    return {
      totalSchools: schools.length,
      activeSchools,
      inactiveSchools,
      totalReports: reports.length,
      byStatus,
      byType,
      byLevel,
      byPlan,
      pendingReview: reports.filter((r) => r.status === 'submitted' || r.status === 'under_review').length,
      overdue: reports.filter((r) => r.status === 'overdue' || (r.deadline && new Date(r.deadline) < new Date() && r.status !== 'approved')).length,
    };
  }

  // ── EMIS Statistics ──

  async getEmisStats(officeId: string, includeChildren: boolean = false) {
    const schools = await this.getSchoolsByOffice(officeId, includeChildren);
    const reports = await this.findReportsByOffice(officeId, includeChildren);

    const enrollmentReports = reports.filter((r) => r.reportType === 'enrollment' || r.reportType === 'supervisory' || r.reportType === 'emis');
    const staffingReports = reports.filter((r) => r.reportType === 'staffing' || r.reportType === 'supervisory');

    let totalEnrollment = 0;
    let totalStaff = 0;
    for (const r of enrollmentReports) {
      if (r.reportData?.totalEnrollment) totalEnrollment += r.reportData.totalEnrollment;
    }
    for (const r of staffingReports) {
      if (r.reportData?.totalStaff) totalStaff += r.reportData.totalStaff;
    }

    const byLevel = schools.reduce((acc, s) => {
      const level = s.schoolLevel || 'unknown';
      acc[level] = (acc[level] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    const byRegion = schools.reduce((acc, s) => {
      const region = s.region || 'unknown';
      acc[region] = (acc[region] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    return {
      totalSchools: schools.length,
      totalEnrollment,
      totalStaff,
      avgEnrollmentPerSchool: schools.length > 0 ? Math.round(totalEnrollment / schools.length) : 0,
      avgStaffPerSchool: schools.length > 0 ? Math.round(totalStaff / schools.length) : 0,
      byLevel,
      byRegion,
      totalReports: reports.length,
      enrollmentReports: enrollmentReports.length,
      staffingReports: staffingReports.length,
    };
  }
}
