import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like, IsNull } from 'typeorm';
import { GesOffice, GesLevel } from './ges-office.entity';
import { GesReport } from './ges-report.entity';
import { Tenant } from '../tenants/tenant.entity';
import {
  CreateGesOfficeDto,
  UpdateGesOfficeDto,
  CreateGesReportDto,
  UpdateGesReportStatusDto,
} from './ges.dto';

@Injectable()
export class GesService {
  constructor(
    @InjectRepository(GesOffice)
    private readonly officeRepo: Repository<GesOffice>,
    @InjectRepository(GesReport)
    private readonly reportRepo: Repository<GesReport>,
    @InjectRepository(Tenant)
    private readonly tenantRepo: Repository<Tenant>,
  ) {}

  // ── Office CRUD ──

  async createOffice(dto: CreateGesOfficeDto): Promise<GesOffice> {
    const existing = await this.officeRepo.findOne({ where: { officeKey: dto.officeKey } });
    if (existing) throw new BadRequestException('Office key already exists');

    // Validate parent exists if provided
    if (dto.parentId) {
      const parent = await this.officeRepo.findOne({ where: { id: dto.parentId } });
      if (!parent) throw new BadRequestException('Parent office not found');
      // Validate hierarchy: circuit -> district -> regional -> national
      const validLevels: Record<string, string> = {
        regional: 'national',
        district: 'regional',
        circuit: 'district',
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
    return this.officeRepo.save(office);
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
    // Resolve GES office: use provided one, or find circuit for this tenant
    let officeId = dto.gesOfficeId || gesOfficeId;
    if (!officeId) {
      const tenant = await this.tenantRepo.findOne({ where: { tenantKey: tenantId } });
      if (tenant && (tenant as any).gesCircuitId) {
        officeId = (tenant as any).gesCircuitId;
      }
    }
    if (!officeId) throw new BadRequestException('No GES office specified and tenant has no circuit assignment');

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

  async assignSchoolToCircuit(tenantId: string, circuitId: string): Promise<Tenant> {
    const tenant = await this.tenantRepo.findOne({ where: { tenantKey: tenantId } });
    if (!tenant) throw new NotFoundException('Tenant not found');
    const circuit = await this.findOfficeById(circuitId);
    if (circuit.level !== 'circuit') {
      throw new BadRequestException('Assigned office must be a circuit-level office');
    }
    (tenant as any).gesCircuitId = circuitId;
    return this.tenantRepo.save(tenant);
  }

  async getSchoolsByOffice(officeId: string, includeChildren: boolean = false): Promise<Tenant[]> {
    if (includeChildren) {
      const officeIds = await this.getOfficeHierarchyIds(officeId);
      // Schools are linked to circuit offices, so find all circuits in hierarchy
      const circuits = await this.officeRepo.find({
        where: officeIds.map((id) => ({ id, level: 'circuit' as GesLevel })),
      });
      const circuitIds = circuits.map((c) => c.id);
      if (circuitIds.length === 0) return [];
      return this.tenantRepo.find({
        where: circuitIds.map((cid) => ({ gesCircuitId: cid } as any)),
      });
    }
    // Direct: only schools assigned to this specific office (must be circuit)
    return this.tenantRepo.find({ where: { gesCircuitId: officeId } as any });
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

    // School level breakdown
    const byLevel = schools.reduce((acc, s) => {
      const level = s.schoolLevel || 'unknown';
      acc[level] = (acc[level] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    return {
      totalSchools: schools.length,
      totalReports: reports.length,
      byStatus,
      byType,
      byLevel,
      pendingReview: reports.filter((r) => r.status === 'submitted' || r.status === 'under_review').length,
      overdue: reports.filter((r) => r.status === 'overdue' || (r.deadline && new Date(r.deadline) < new Date() && r.status !== 'approved')).length,
    };
  }
}
