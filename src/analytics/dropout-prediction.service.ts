import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DropoutAlertEntity } from './dropout-alert.entity';
import { Student } from '../students/student.entity';
import { AttendanceRecord } from '../academic/attendance-record.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { FeeRecord } from '../bursary/fee-record.entity';
import { CounsellingCase } from '../counselling/counselling-case.entity';

export interface RiskFactor {
  factor: string;
  score: number;
  detail: string;
}

export interface StudentRiskProfile {
  studentId: string;
  studentName: string;
  admissionNumber: string;
  classForm: string;
  riskScore: number;
  riskLevel: string;
  riskFactors: RiskFactor[];
  recommendation: string;
}

@Injectable()
export class DropoutPredictionService {
  constructor(
    @InjectRepository(DropoutAlertEntity) private alertRepo: Repository<DropoutAlertEntity>,
    @InjectRepository(Student) private studentRepo: Repository<Student>,
    @InjectRepository(AttendanceRecord) private attendanceRepo: Repository<AttendanceRecord>,
    @InjectRepository(ExamResult) private examRepo: Repository<ExamResult>,
    @InjectRepository(FeeRecord) private feeRepo: Repository<FeeRecord>,
    @InjectRepository(CounsellingCase) private counsellingRepo: Repository<CounsellingCase>,
  ) {}

  async calculateRiskScore(studentId: string, tenantId: string): Promise<StudentRiskProfile> {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const factors: RiskFactor[] = [];

    // 1. Attendance rate (last 30 days)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    const attendanceRecords = await this.attendanceRepo.find({
      where: { tenantId, admNo: student.admissionNumber },
      order: { date: 'DESC' },
      take: 30,
    });
    const recentAttendance = attendanceRecords.filter((r) => new Date(r.date) >= thirtyDaysAgo);
    if (recentAttendance.length > 0) {
      const presentCount = recentAttendance.filter((r) => r.status === 'Present').length;
      const rate = (presentCount / recentAttendance.length) * 100;
      if (rate < 70) {
        factors.push({ factor: 'Low Attendance', score: 30, detail: `Attendance rate: ${rate.toFixed(0)}% in last 30 days` });
      } else if (rate < 85) {
        factors.push({ factor: 'Below Average Attendance', score: 15, detail: `Attendance rate: ${rate.toFixed(0)}% in last 30 days` });
      }
    }

    // 2. Grade decline (current vs previous term)
    const allResults = await this.examRepo.find({
      where: { tenantId, admNo: student.admissionNumber },
      order: { createdAt: 'DESC' },
    });
    const terms = [...new Set(allResults.map((r) => r.term))];
    if (terms.length >= 2) {
      const currentTerm = terms[0];
      const previousTerm = terms[1];
      const currentAvg = this.avgScore(allResults.filter((r) => r.term === currentTerm));
      const previousAvg = this.avgScore(allResults.filter((r) => r.term === previousTerm));
      if (previousAvg > 0) {
        const decline = ((previousAvg - currentAvg) / previousAvg) * 100;
        if (decline > 20) {
          factors.push({ factor: 'Grade Decline', score: 25, detail: `Scores dropped ${decline.toFixed(0)}% from ${previousTerm} to ${currentTerm}` });
        } else if (decline > 10) {
          factors.push({ factor: 'Slight Grade Decline', score: 10, detail: `Scores dropped ${decline.toFixed(0)}% from ${previousTerm} to ${currentTerm}` });
        }
      }
    }

    // 3. Fee balance
    const fees = await this.feeRepo.find({ where: { tenantId, admNo: student.admissionNumber, status: 'Owing' as any } });
    if (fees.length > 0) {
      const totalBalance = fees.reduce((sum, f) => sum + Number(f.balance), 0);
      if (totalBalance > 0) {
        const oldestFee = fees.reduce((oldest, f) => {
          const billingDate = f.billingDate || f.createdAt.toISOString().slice(0, 10);
          return billingDate < oldest ? billingDate : oldest;
        }, '9999-12-31');
        const daysOwing = Math.floor((Date.now() - new Date(oldestFee).getTime()) / (1000 * 60 * 60 * 24));
        if (daysOwing > 30) {
          factors.push({ factor: 'Outstanding Fees', score: 20, detail: `Owing GHS ${totalBalance.toFixed(2)} for ${daysOwing} days` });
        } else {
          factors.push({ factor: 'Fees Owing', score: 10, detail: `Owing GHS ${totalBalance.toFixed(2)}` });
        }
      }
    }

    // 4. Counselling cases
    const cases = await this.counsellingRepo.find({
      where: { tenantId, studentName: `${student.firstName} ${student.lastName}`, status: 'Active' as any },
    });
    if (cases.length > 0) {
      factors.push({ factor: 'Active Counselling Case', score: 15, detail: `${cases.length} active counselling case(s)` });
    }

    // 5. Low recent scores
    const recentResults = allResults.filter((r) => r.term === terms[0]);
    if (recentResults.length > 0) {
      const lowScores = recentResults.filter((r) => Number(r.marks) < 40);
      if (lowScores.length >= 2) {
        factors.push({ factor: 'Failing Subjects', score: 20, detail: `Failing ${lowScores.length} subjects in current term` });
      }
    }

    const riskScore = Math.min(100, factors.reduce((sum, f) => sum + f.score, 0));
    const riskLevel = riskScore >= 61 ? 'High' : riskScore >= 31 ? 'Medium' : 'Low';

    let recommendation = '';
    if (riskLevel === 'High') {
      recommendation = 'Immediate intervention recommended. Schedule meeting with parent, assign counsellor, and create remedial plan.';
    } else if (riskLevel === 'Medium') {
      recommendation = 'Monitor closely. Check in with student and inform parent. Consider extra support.';
    } else {
      recommendation = 'No immediate action needed. Continue regular monitoring.';
    }

    return {
      studentId,
      studentName: `${student.firstName} ${student.lastName}`,
      admissionNumber: student.admissionNumber,
      classForm: student.classSectionId,
      riskScore,
      riskLevel,
      riskFactors: factors,
      recommendation,
    };
  }

  async runPredictionForAll(tenantId: string): Promise<{ scanned: number; alerts: number; highRisk: number }> {
    const students = await this.studentRepo.find({ where: { tenantId, status: 'active' as any } });
    let alertCount = 0;
    let highCount = 0;

    for (const student of students) {
      try {
        const profile = await this.calculateRiskScore(student.id, tenantId);
        if (profile.riskScore > 0) {
          const existing = await this.alertRepo.findOne({ where: { tenantId, studentId: student.id } });
          if (existing) {
            existing.riskScore = profile.riskScore;
            existing.riskLevel = profile.riskLevel;
            existing.riskFactors = profile.riskFactors.map((f) => `${f.factor}: ${f.detail}`);
            existing.recommendation = profile.recommendation;
            await this.alertRepo.save(existing);
          } else {
            await this.alertRepo.save(this.alertRepo.create({
              tenantId,
              studentId: student.id,
              studentName: profile.studentName,
              admissionNumber: profile.admissionNumber,
              classForm: profile.classForm,
              riskScore: profile.riskScore,
              riskLevel: profile.riskLevel,
              riskFactors: profile.riskFactors.map((f) => `${f.factor}: ${f.detail}`),
              recommendation: profile.recommendation,
            }));
          }
          alertCount++;
          if (profile.riskLevel === 'High') highCount++;
        }
      } catch (e) { /* skip student on error */ }
    }

    return { scanned: students.length, alerts: alertCount, highRisk: highCount };
  }

  async getAlerts(tenantId: string, riskLevel?: string) {
    const where: any = { tenantId };
    if (riskLevel) where.riskLevel = riskLevel;
    return this.alertRepo.find({ where, order: { riskScore: 'DESC' as any } });
  }

  async getStudentRiskProfile(studentId: string, tenantId: string) {
    return this.calculateRiskScore(studentId, tenantId);
  }

  async resolveAlert(alertId: string, tenantId: string) {
    const alert = await this.alertRepo.findOne({ where: { id: alertId, tenantId } });
    if (!alert) throw new NotFoundException('Alert not found');
    alert.status = 'Resolved';
    return this.alertRepo.save(alert);
  }

  private avgScore(results: ExamResult[]): number {
    if (results.length === 0) return 0;
    return results.reduce((sum, r) => sum + Number(r.marks), 0) / results.length;
  }
}
