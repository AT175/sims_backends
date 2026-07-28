import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EarningEntity, EarningStatus } from './earning.entity';
import { EarningConfigEntity } from './earning-config.entity';

const EXCLUDED_ROLES = ['parent', 'student', 'pta', 'governing_board'];

@Injectable()
export class EarningsService {
  constructor(
    @InjectRepository(EarningEntity)
    private readonly earningRepo: Repository<EarningEntity>,
    @InjectRepository(EarningConfigEntity)
    private readonly configRepo: Repository<EarningConfigEntity>,
  ) {}

  async getConfig(tenantId: string): Promise<EarningConfigEntity> {
    let config = await this.configRepo.findOne({ where: { tenantId } });
    if (!config) {
      config = this.configRepo.create({ tenantId });
      await this.configRepo.save(config);
    }
    return config;
  }

  async updateConfig(tenantId: string, data: Partial<Pick<EarningConfigEntity, 'ratePerAction' | 'maxActionsPerDay' | 'minPayoutThreshold' | 'currency' | 'enabled'>>): Promise<EarningConfigEntity> {
    const config = await this.getConfig(tenantId);
    Object.assign(config, data);
    return this.configRepo.save(config);
  }

  isEligible(roles: string[]): boolean {
    return !roles.some((r) => EXCLUDED_ROLES.includes(r));
  }

  async recordAction(userId: string, tenantId: string, roles: string[], action: string, resource: string | null): Promise<void> {
    if (!this.isEligible(roles)) return;

    const config = await this.getConfig(tenantId);
    if (!config.enabled) return;

    const today = new Date().toISOString().slice(0, 10);
    const todayCount = await this.earningRepo
      .createQueryBuilder('e')
      .where('e.userId = :userId', { userId })
      .andWhere('e.tenantId = :tenantId', { tenantId })
      .andWhere('e.type = :type', { type: 'credit' })
      .andWhere("e.createdAt::text LIKE :today", { today: `${today}%` })
      .getCount();

    if (todayCount >= config.maxActionsPerDay) return;

    const earning = this.earningRepo.create({
      userId,
      tenantId,
      type: 'credit',
      amount: config.ratePerAction,
      currency: config.currency,
      action,
      resource,
      status: 'pending',
    });
    await this.earningRepo.save(earning);
  }

  async getMyEarnings(userId: string, tenantId: string): Promise<{ balance: number; totalEarned: number; totalClaimed: number; recent: EarningEntity[] }> {
    const earnings = await this.earningRepo.find({
      where: { userId, tenantId },
      order: { createdAt: 'DESC' },
      take: 50,
    });

    const allEarnings = await this.earningRepo.find({ where: { userId, tenantId } });
    const totalEarned = allEarnings
      .filter((e) => e.type === 'credit')
      .reduce((sum, e) => sum + Number(e.amount), 0);
    const totalClaimed = allEarnings
      .filter((e) => e.type === 'payout' && (e.status === 'disbursed' || e.status === 'claimed'))
      .reduce((sum, e) => sum + Number(e.amount), 0);

    const pendingCredits = allEarnings
      .filter((e) => e.type === 'credit' && e.status === 'pending')
      .reduce((sum, e) => sum + Number(e.amount), 0);
    const pendingPayouts = allEarnings
      .filter((e) => e.type === 'payout' && e.status === 'pending')
      .reduce((sum, e) => sum + Number(e.amount), 0);

    const balance = pendingCredits - pendingPayouts;

    return {
      balance: Math.max(0, balance),
      totalEarned,
      totalClaimed,
      recent: earnings,
    };
  }

  async claimEarnings(userId: string, tenantId: string, mobileMoneyNumber: string): Promise<EarningEntity> {
    const config = await this.getConfig(tenantId);
    const { balance } = await this.getMyEarnings(userId, tenantId);

    if (balance < config.minPayoutThreshold) {
      throw new BadRequestException(`Minimum payout threshold is ${config.currency} ${config.minPayoutThreshold}. Your balance is ${config.currency} ${balance.toFixed(2)}.`);
    }

    if (!mobileMoneyNumber || mobileMoneyNumber.trim().length < 10) {
      throw new BadRequestException('Please provide a valid mobile money number (at least 10 digits).');
    }

    const payout = this.earningRepo.create({
      userId,
      tenantId,
      type: 'payout',
      amount: balance,
      currency: config.currency,
      action: 'Payout claim',
      status: 'pending',
      mobileMoneyNumber: mobileMoneyNumber.trim(),
    });
    await this.earningRepo.save(payout);

    const credits = await this.earningRepo.find({ where: { userId, tenantId, type: 'credit', status: 'pending' } });
    for (const c of credits) {
      c.status = 'claimed';
      await this.earningRepo.save(c);
    }

    return payout;
  }

  async getAllEarnings(tenantId: string): Promise<EarningEntity[]> {
    return this.earningRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' }, take: 200 });
  }

  async getPendingPayouts(tenantId: string): Promise<EarningEntity[]> {
    return this.earningRepo.find({ where: { tenantId, type: 'payout', status: 'pending' }, order: { createdAt: 'DESC' } });
  }

  async disbursePayout(payoutId: string, disbursedBy: string, reference: string): Promise<EarningEntity> {
    const payout = await this.earningRepo.findOne({ where: { id: payoutId } });
    if (!payout) throw new NotFoundException('Payout not found');
    if (payout.status !== 'pending') throw new BadRequestException('Payout is not pending');

    payout.status = 'disbursed';
    payout.payoutReference = reference;
    payout.disbursedBy = disbursedBy;
    return this.earningRepo.save(payout);
  }

  async cancelPayout(payoutId: string): Promise<EarningEntity> {
    const payout = await this.earningRepo.findOne({ where: { id: payoutId } });
    if (!payout) throw new NotFoundException('Payout not found');
    if (payout.status !== 'pending') throw new BadRequestException('Payout is not pending');

    payout.status = 'cancelled';
    await this.earningRepo.save(payout);

    const credits = await this.earningRepo.find({ where: { userId: payout.userId, tenantId: payout.tenantId, type: 'credit', status: 'claimed' } });
    for (const c of credits) {
      c.status = 'pending';
      await this.earningRepo.save(c);
    }

    return payout;
  }

  async getStats(tenantId: string): Promise<any> {
    const all = await this.earningRepo.find({ where: { tenantId } });
    const credits = all.filter((e) => e.type === 'credit');
    const payouts = all.filter((e) => e.type === 'payout');
    const pendingPayouts = payouts.filter((e) => e.status === 'pending');
    const disbursed = payouts.filter((e) => e.status === 'disbursed');
    const totalEarned = credits.reduce((s, e) => s + Number(e.amount), 0);
    const totalDisbursed = disbursed.reduce((s, e) => s + Number(e.amount), 0);
    const uniqueUsers = new Set(all.map((e) => e.userId)).size;

    return {
      totalEarned,
      totalDisbursed,
      pendingPayouts: pendingPayouts.length,
      pendingAmount: pendingPayouts.reduce((s, e) => s + Number(e.amount), 0),
      uniqueUsers,
      totalActions: credits.length,
    };
  }
}
