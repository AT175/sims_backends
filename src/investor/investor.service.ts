import { Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { InvestorEntity } from './investor.entity';
import { Tenant } from '../tenants/tenant.entity';
import { User } from '../auth/user.entity';
import { SubscriptionEntity } from '../subscription/subscription.entity';
import { Student } from '../students/student.entity';
import { FeeRecord } from '../bursary/fee-record.entity';

// Total equity being offered
export const TOTAL_EQUITY_OFFERED = 20; // 20%
export const PLATFORM_VALUATION = 500000; // GHS 500,000 target valuation

@Injectable()
export class InvestorService {
  private readonly logger = new Logger(InvestorService.name);

  constructor(
    @InjectRepository(InvestorEntity) private investorRepo: Repository<InvestorEntity>,
    @InjectRepository(Tenant) private tenantRepo: Repository<Tenant>,
    @InjectRepository(User) private userRepo: Repository<User>,
    @InjectRepository(SubscriptionEntity) private subscriptionRepo: Repository<SubscriptionEntity>,
    @InjectRepository(Student) private studentRepo: Repository<Student>,
    @InjectRepository(FeeRecord) private feeRepo: Repository<FeeRecord>,
  ) {}

  // ── Investor CRUD (system_admin only) ─────────────────────

  async createInvestor(data: {
    fullName: string;
    email?: string;
    phone?: string;
    organization?: string;
    amountInvested: number;
    equityPercentage: number;
    investmentDate?: string;
    notes?: string;
    userId?: string;
    username?: string;
  }) {
    // Validate equity doesn't exceed total offered
    const totalAllocated = await this.getTotalEquityAllocated();
    if (totalAllocated + data.equityPercentage > TOTAL_EQUITY_OFFERED) {
      throw new BadRequestException(
        `Cannot allocate ${data.equityPercentage}%. Only ${TOTAL_EQUITY_OFFERED - totalAllocated}% remaining of ${TOTAL_EQUITY_OFFERED}% total offering.`,
      );
    }

    const investor = this.investorRepo.create({
      ...data,
      status: data.userId ? 'confirmed' : 'pending',
    });
    return this.investorRepo.save(investor);
  }

  async updateInvestor(id: string, data: Partial<InvestorEntity>) {
    const investor = await this.investorRepo.findOne({ where: { id } });
    if (!investor) throw new NotFoundException('Investor not found');

    if (data.equityPercentage !== undefined) {
      const totalAllocated = await this.getTotalEquityAllocated();
      const currentAllocated = totalAllocated - investor.equityPercentage;
      if (currentAllocated + data.equityPercentage > TOTAL_EQUITY_OFFERED) {
        throw new BadRequestException(
          `Cannot allocate ${data.equityPercentage}%. Only ${TOTAL_EQUITY_OFFERED - currentAllocated}% remaining.`,
        );
      }
    }

    Object.assign(investor, data);
    return this.investorRepo.save(investor);
  }

  async deleteInvestor(id: string) {
    const investor = await this.investorRepo.findOne({ where: { id } });
    if (!investor) throw new NotFoundException('Investor not found');
    await this.investorRepo.delete(id);
    return { success: true };
  }

  async getAllInvestors() {
    return this.investorRepo.find({ order: { createdAt: 'DESC' } });
  }

  async getInvestorByUserId(userId: string) {
    return this.investorRepo.findOne({ where: { userId } });
  }

  async getTotalEquityAllocated(): Promise<number> {
    const investors = await this.investorRepo.find({ where: { status: 'active' } });
    const confirmed = await this.investorRepo.find({ where: { status: 'confirmed' } });
    return [...investors, ...confirmed].reduce((sum, i) => sum + Number(i.equityPercentage), 0);
  }

  // ─ Platform Analytics (for investor dashboard) ─────────────

  async getPlatformOverview() {
    const [tenants, students, subscriptions, investors] = await Promise.all([
      this.tenantRepo.count({ where: { active: true, isGesOffice: false } }),
      this.studentRepo.count(),
      this.subscriptionRepo.find(),
      this.investorRepo.find(),
    ]);

    const activeSubscriptions = subscriptions.filter((s) => s.status === 'active');
    const totalRevenue = subscriptions
      .filter((s) => s.paymentStatus === 'paid')
      .reduce((sum, s) => sum + Number(s.amount), 0);
    const pendingRevenue = subscriptions
      .filter((s) => s.paymentStatus === 'pending' || !s.paymentStatus)
      .reduce((sum, s) => sum + Number(s.amount), 0);

    const equityAllocated = investors
      .filter((i) => i.status === 'active' || i.status === 'confirmed')
      .reduce((sum, i) => sum + Number(i.equityPercentage), 0);

    const totalInvested = investors
      .filter((i) => i.status === 'active' || i.status === 'confirmed')
      .reduce((sum, i) => sum + Number(i.amountInvested), 0);

    return {
      platform: {
        totalSchools: tenants,
        totalStudents: students,
        totalSubscriptions: subscriptions.length,
        activeSubscriptions: activeSubscriptions.length,
        totalRevenue: totalRevenue.toFixed(2),
        pendingRevenue: pendingRevenue.toFixed(2),
        currency: 'GHS',
      },
      equity: {
        totalOffered: TOTAL_EQUITY_OFFERED,
        equityAllocated: equityAllocated.toFixed(2),
        equityRemaining: (TOTAL_EQUITY_OFFERED - equityAllocated).toFixed(2),
        platformValuation: PLATFORM_VALUATION,
        totalInvested: totalInvested.toFixed(2),
        investorCount: investors.filter((i) => i.status === 'active' || i.status === 'confirmed').length,
        pendingInvestorCount: investors.filter((i) => i.status === 'pending').length,
      },
    };
  }

  async getRevenueTrends() {
    const subscriptions = await this.subscriptionRepo.find();

    // Group by month
    const monthlyData: Record<string, { revenue: number; count: number }> = {};
    for (const sub of subscriptions) {
      const monthKey = sub.createdAt.toISOString().slice(0, 7); // YYYY-MM
      if (!monthlyData[monthKey]) monthlyData[monthKey] = { revenue: 0, count: 0 };
      if (sub.paymentStatus === 'paid') {
        monthlyData[monthKey].revenue += Number(sub.amount);
      }
      monthlyData[monthKey].count += 1;
    }

    return Object.entries(monthlyData)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([month, data]) => ({
        month,
        revenue: data.revenue.toFixed(2),
        newSubscriptions: data.count,
      }));
  }

  async getSchoolGrowth() {
    const tenants = await this.tenantRepo.find({ where: { isGesOffice: false }, order: { createdAt: 'ASC' } });

    // Group by month
    const monthlyData: Record<string, number> = {};
    let cumulative = 0;
    for (const t of tenants) {
      const monthKey = t.createdAt.toISOString().slice(0, 7);
      cumulative += 1;
      monthlyData[monthKey] = cumulative;
    }

    return Object.entries(monthlyData)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([month, total]) => ({ month, totalSchools: total }));
  }

  async getSchoolBreakdown() {
    const tenants = await this.tenantRepo.find({ where: { isGesOffice: false, active: true } });

    // Count students per school
    const breakdown = await Promise.all(
      tenants.map(async (t) => {
        const studentCount = await this.studentRepo.count({ where: { tenantId: t.id } });
        const subs = await this.subscriptionRepo.find({ where: { tenantId: t.id } });
        const revenue = subs
          .filter((s) => s.paymentStatus === 'paid')
          .reduce((sum, s) => sum + Number(s.amount), 0);
        return {
          schoolName: t.schoolName,
          tenantKey: t.tenantKey,
          region: t.region,
          district: t.district,
          schoolLevel: t.schoolLevel,
          subscriptionPlan: t.subscriptionPlan,
          subscriptionExpiry: t.subscriptionExpiry,
          studentCount,
          revenue: revenue.toFixed(2),
          active: t.active,
          createdAt: t.createdAt,
        };
      }),
    );

    return breakdown.sort((a, b) => b.studentCount - a.studentCount);
  }

  async getInvestorPortfolio(userId: string) {
    const investor = await this.investorRepo.findOne({ where: { userId } });
    if (!investor) throw new NotFoundException('Investor profile not found');

    const [tenants, students, subscriptions] = await Promise.all([
      this.tenantRepo.count({ where: { active: true, isGesOffice: false } }),
      this.studentRepo.count(),
      this.subscriptionRepo.find(),
    ]);

    const totalRevenue = subscriptions
      .filter((s) => s.paymentStatus === 'paid')
      .reduce((sum, s) => sum + Number(s.amount), 0);

    // Calculate investor's share of revenue
    const equityShare = Number(investor.equityPercentage) / 100;
    const revenueShare = totalRevenue * equityShare;

    // Estimated portfolio value based on platform valuation
    const portfolioValue = (PLATFORM_VALUATION * Number(investor.equityPercentage)) / 100;

    return {
      investor: {
        fullName: investor.fullName,
        email: investor.email,
        organization: investor.organization,
        amountInvested: Number(investor.amountInvested).toFixed(2),
        equityPercentage: Number(investor.equityPercentage).toFixed(2),
        investmentDate: investor.investmentDate,
        status: investor.status,
      },
      portfolio: {
        equityPercentage: Number(investor.equityPercentage).toFixed(2),
        portfolioValue: portfolioValue.toFixed(2),
        revenueShare: revenueShare.toFixed(2),
        platformValuation: PLATFORM_VALUATION,
        roi: investor.amountInvested > 0
          ? (((portfolioValue - Number(investor.amountInvested)) / Number(investor.amountInvested)) * 100).toFixed(2)
          : '0.00',
      },
      platformSnapshot: {
        totalSchools: tenants,
        totalStudents: students,
        totalRevenue: totalRevenue.toFixed(2),
      },
    };
  }

  async getInvestmentTerms() {
    return {
      offering: {
        equityOffered: TOTAL_EQUITY_OFFERED,
        platformValuation: PLATFORM_VALUATION,
        currency: 'GHS',
        minInvestment: 5000,
        minEquity: 1,
        maxEquityPerInvestor: 10,
      },
      terms: [
        'This offering represents 20% equity in the SIMS platform (School Information Management System).',
        'The platform is a multi-tenant SaaS application serving Ghanaian schools (Basic, JHS, SHS).',
        'Investors receive proportional share of platform revenue based on equity percentage held.',
        'Minimum investment: GHS 5,000 (1% equity). Maximum per investor: 10% equity.',
        'Investment term: Minimum 2-year lock-in period from confirmation date.',
        'Dividends distributed annually based on platform net revenue.',
        'Investors receive read-only access to platform analytics dashboard.',
        'The platform reserves the right to buy back equity at fair market value after the lock-in period.',
        'This is a private offering and not a public securities listing.',
        'All investments are subject to due diligence and approval by the platform administrators.',
      ],
      platformHighlights: [
        'AI-powered lesson plan generation aligned with GES/NaCCA curriculum',
        'Multi-tenant architecture serving multiple schools on a single platform',
        'Offline-first design for schools with unreliable internet',
        'WhatsApp parent communication in 11 Ghanaian languages',
        'Virtual science labs, AI tutor, career pipeline, and peer learning network',
        'Early-warning dropout prediction system',
        'Teacher performance analytics',
      ],
    };
  }
}
