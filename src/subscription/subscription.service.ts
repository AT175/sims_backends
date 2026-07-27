import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SubscriptionEntity, SubscriptionPlan, SubscriptionStatus } from './subscription.entity';

const ANNUAL_FEE = 100;
const CURRENCY = 'GHS';
const TRIAL_DAYS = 30;
const ANNUAL_DAYS = 365;

function addDays(date: Date, days: number): string {
  const d = new Date(date);
  d.setDate(d.getDate() + days);
  return d.toISOString().slice(0, 10);
}

@Injectable()
export class SubscriptionService {
  constructor(
    @InjectRepository(SubscriptionEntity)
    private readonly repo: Repository<SubscriptionEntity>,
  ) {}

  async createTrial(userId: string, tenantId: string, studentName?: string, studentAdmNo?: string): Promise<SubscriptionEntity> {
    const existing = await this.repo.findOne({ where: { userId, tenantId } });
    if (existing) return existing;

    const sub = this.repo.create({
      userId,
      tenantId,
      plan: 'trial',
      status: 'active',
      startDate: new Date().toISOString().slice(0, 10),
      endDate: addDays(new Date(), TRIAL_DAYS),
      amount: 0,
      currency: CURRENCY,
      studentName: studentName || null,
      studentAdmissionNumber: studentAdmNo || null,
    });
    return this.repo.save(sub);
  }

  async getMySubscription(userId: string, tenantId: string): Promise<SubscriptionEntity | null> {
    const sub = await this.repo.findOne({ where: { userId, tenantId }, order: { createdAt: 'DESC' } });
    if (!sub) return null;
    return this.checkExpiry(sub);
  }

  async checkExpiry(sub: SubscriptionEntity): Promise<SubscriptionEntity> {
    const today = new Date().toISOString().slice(0, 10);
    if (sub.status === 'active' && sub.endDate < today) {
      sub.status = 'expired';
      await this.repo.save(sub);
    }
    return sub;
  }

  async upgradeToAnnual(userId: string, tenantId: string, paymentData: { paymentMethod: string; paymentReference: string }): Promise<SubscriptionEntity> {
    const sub = await this.repo.findOne({ where: { userId, tenantId }, order: { createdAt: 'DESC' } });

    const today = new Date();
    const startDate = today.toISOString().slice(0, 10);
    const endDate = addDays(today, ANNUAL_DAYS);

    if (sub) {
      sub.plan = 'annual';
      sub.status = 'active';
      sub.startDate = startDate;
      sub.endDate = endDate;
      sub.amount = ANNUAL_FEE;
      sub.paymentMethod = paymentData.paymentMethod;
      sub.paymentReference = paymentData.paymentReference;
      sub.paymentStatus = 'paid';
      return this.repo.save(sub);
    }

    const newSub = this.repo.create({
      userId,
      tenantId,
      plan: 'annual',
      status: 'active',
      startDate,
      endDate,
      amount: ANNUAL_FEE,
      currency: CURRENCY,
      paymentMethod: paymentData.paymentMethod,
      paymentReference: paymentData.paymentReference,
      paymentStatus: 'paid',
    });
    return this.repo.save(newSub);
  }

  async getAllSubscriptions(tenantId: string): Promise<SubscriptionEntity[]> {
    const subs = await this.repo.find({ where: { tenantId }, order: { createdAt: 'DESC' } });
    for (const s of subs) {
      await this.checkExpiry(s);
    }
    return subs;
  }

  async manuallyExtend(userId: string, tenantId: string, days: number): Promise<SubscriptionEntity> {
    const sub = await this.repo.findOne({ where: { userId, tenantId }, order: { createdAt: 'DESC' } });
    if (!sub) throw new NotFoundException('Subscription not found');
    const currentEnd = new Date(sub.endDate);
    const today = new Date();
    const base = currentEnd > today ? currentEnd : today;
    sub.endDate = addDays(base, days);
    sub.status = 'active';
    return this.repo.save(sub);
  }

  async cancelSubscription(userId: string, tenantId: string): Promise<SubscriptionEntity> {
    const sub = await this.repo.findOne({ where: { userId, tenantId }, order: { createdAt: 'DESC' } });
    if (!sub) throw new NotFoundException('Subscription not found');
    sub.status = 'cancelled';
    return this.repo.save(sub);
  }

  async hasActiveAccess(userId: string, tenantId: string): Promise<boolean> {
    const sub = await this.getMySubscription(userId, tenantId);
    if (!sub) return false;
    return sub.status === 'active';
  }

  async getStats(tenantId: string): Promise<any> {
    const subs = await this.repo.find({ where: { tenantId } });
    const active = subs.filter((s) => s.status === 'active');
    const trial = subs.filter((s) => s.plan === 'trial');
    const annual = subs.filter((s) => s.plan === 'annual');
    const expired = subs.filter((s) => s.status === 'expired');
    const revenue = annual.reduce((sum, s) => sum + Number(s.amount), 0);
    return {
      total: subs.length,
      active: active.length,
      trial: trial.length,
      annual: annual.length,
      expired: expired.length,
      revenue,
    };
  }
}
