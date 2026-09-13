import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LessonPlanEntity } from '../teacher/entities/lesson-plan.entity';
import { AssignmentEntity } from '../teacher/entities/assignment.entity';
import { QuizEntity } from '../teacher/entities/quiz.entity';
import { GradebookEntryEntity } from '../teacher/entities/gradebook-entry.entity';
import { TeacherAttendanceEntity } from '../teacher/entities/teacher-attendance.entity';
import { LessonRecapEntity } from '../teacher/entities/lesson-recap.entity';
import { ExamResult } from '../academic/exam-result.entity';

@Injectable()
export class TeacherAnalyticsService {
  constructor(
    @InjectRepository(LessonPlanEntity) private lessonPlanRepo: Repository<LessonPlanEntity>,
    @InjectRepository(AssignmentEntity) private assignmentRepo: Repository<AssignmentEntity>,
    @InjectRepository(QuizEntity) private quizRepo: Repository<QuizEntity>,
    @InjectRepository(GradebookEntryEntity) private gradebookRepo: Repository<GradebookEntryEntity>,
    @InjectRepository(TeacherAttendanceEntity) private teacherAttendanceRepo: Repository<TeacherAttendanceEntity>,
    @InjectRepository(LessonRecapEntity) private recapRepo: Repository<LessonRecapEntity>,
    @InjectRepository(ExamResult) private examRepo: Repository<ExamResult>,
  ) {}

  async getTeacherPerformance(tenantId: string, teacherId?: string, term?: string) {
    const lpWhere: any = { tenantId };
    if (teacherId) lpWhere.teacherId = teacherId;
    const lessonPlans = await this.lessonPlanRepo.find({ where: lpWhere });

    const aWhere: any = { tenantId };
    if (teacherId) aWhere.createdBy = teacherId;
    const assignments = await this.assignmentRepo.find({ where: aWhere });

    const qWhere: any = { tenantId };
    const quizzes = await this.quizRepo.find({ where: qWhere });

    const recapWhere: any = { tenantId };
    if (teacherId) recapWhere.teacherId = teacherId;
    const recaps = await this.recapRepo.find({ where: recapWhere });

    // Student performance in subjects taught by this teacher
    const gWhere: any = { tenantId };
    if (term) gWhere.term = term;
    const gradebook = await this.gradebookRepo.find({ where: gWhere });

    // Group by subject
    const subjectStats: Record<string, { count: number; totalScore: number; totalMax: number }> = {};
    for (const g of gradebook) {
      if (!subjectStats[g.subject]) subjectStats[g.subject] = { count: 0, totalScore: 0, totalMax: 0 };
      subjectStats[g.subject].count++;
      subjectStats[g.subject].totalScore += g.total;
      subjectStats[g.subject].totalMax += g.totalMax;
    }

    const subjectAverages = Object.entries(subjectStats).map(([subject, stats]) => ({
      subject,
      averageScore: stats.count > 0 ? (stats.totalScore / stats.count).toFixed(1) : '0',
      averageMax: stats.count > 0 ? (stats.totalMax / stats.count).toFixed(0) : '0',
      averagePercent: stats.count > 0 && stats.totalMax > 0 ? ((stats.totalScore / stats.totalMax) * 100).toFixed(1) : '0',
      studentCount: stats.count,
    }));

    return {
      lessonPlansGenerated: lessonPlans.length,
      assignmentsCreated: assignments.length,
      assignmentsPublished: assignments.filter((a) => a.status === 'Published').length,
      quizzesCreated: quizzes.length,
      lessonRecapsSubmitted: recaps.length,
      subjectAverages,
      totalStudentsInGradebook: gradebook.length,
    };
  }

  async getTeacherRankings(tenantId: string, term?: string) {
    const gWhere: any = { tenantId };
    if (term) gWhere.term = term;
    const gradebook = await this.gradebookRepo.find({ where: gWhere });

    // Group by subject and classForm
    const teacherStats: Record<string, { subject: string; classForm: string; count: number; totalScore: number; totalMax: number }> = {};
    for (const g of gradebook) {
      const key = `${g.subject}|${g.classForm}`;
      if (!teacherStats[key]) teacherStats[key] = { subject: g.subject, classForm: g.classForm, count: 0, totalScore: 0, totalMax: 0 };
      teacherStats[key].count++;
      teacherStats[key].totalScore += g.total;
      teacherStats[key].totalMax += g.totalMax;
    }

    const rankings = Object.values(teacherStats).map((s) => ({
      subject: s.subject,
      classForm: s.classForm,
      averagePercent: s.totalMax > 0 ? ((s.totalScore / s.totalMax) * 100).toFixed(1) : '0',
      studentCount: s.count,
    })).sort((a, b) => parseFloat(b.averagePercent) - parseFloat(a.averagePercent));

    return rankings;
  }

  async getSubjectPerformance(tenantId: string, subject: string) {
    const gradebook = await this.gradebookRepo.find({ where: { tenantId, subject } });
    const examResults = await this.examRepo.find({ where: { tenantId, subject } });

    const classStats: Record<string, { count: number; totalScore: number; totalMax: number }> = {};
    for (const g of gradebook) {
      if (!classStats[g.classForm]) classStats[g.classForm] = { count: 0, totalScore: 0, totalMax: 0 };
      classStats[g.classForm].count++;
      classStats[g.classForm].totalScore += g.total;
      classStats[g.classForm].totalMax += g.totalMax;
    }

    const byClass = Object.entries(classStats).map(([classForm, stats]) => ({
      classForm,
      averagePercent: stats.totalMax > 0 ? ((stats.totalScore / stats.totalMax) * 100).toFixed(1) : '0',
      studentCount: stats.count,
    }));

    const examAvg = examResults.length > 0
      ? (examResults.reduce((s, r) => s + Number(r.marks), 0) / examResults.length).toFixed(1)
      : '0';

    return {
      subject,
      totalStudents: gradebook.length,
      examAverage: examAvg,
      byClass,
      gradeDistribution: this.getGradeDistribution(examResults),
    };
  }

  async getInsights(tenantId: string) {
    const insights: { type: string; message: string; severity: string }[] = [];

    // Lesson plan activity
    const lessonPlans = await this.lessonPlanRepo.find({ where: { tenantId } });
    const recaps = await this.recapRepo.find({ where: { tenantId } });
    const assignments = await this.assignmentRepo.find({ where: { tenantId } });

    // Check for teachers not submitting lesson plans
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    const recentLessonPlans = lessonPlans.filter((lp) => new Date(lp.date) >= thirtyDaysAgo);
    if (recentLessonPlans.length < lessonPlans.length * 0.3) {
      insights.push({ type: 'lesson_plans', message: `Only ${recentLessonPlans.length} lesson plans submitted in the last 30 days. Teachers may need encouragement.`, severity: 'warning' });
    }

    // Check assignment publishing rate
    const publishedAssignments = assignments.filter((a) => a.status === 'Published');
    if (assignments.length > 0 && publishedAssignments.length / assignments.length < 0.5) {
      insights.push({ type: 'assignments', message: `${assignments.length - publishedAssignments.length} assignments are still in Draft status. Consider publishing them.`, severity: 'info' });
    }

    // Check lesson recap activity
    const recentRecaps = recaps.filter((r) => new Date(r.date) >= thirtyDaysAgo);
    if (recentRecaps.length === 0) {
      insights.push({ type: 'recaps', message: 'No lesson recaps submitted in the last 30 days. Parents are not receiving daily updates.', severity: 'warning' });
    }

    // Subject performance insights
    const gradebook = await this.gradebookRepo.find({ where: { tenantId } });
    const subjectAverages: Record<string, { total: number; count: number }> = {};
    for (const g of gradebook) {
      if (!subjectAverages[g.subject]) subjectAverages[g.subject] = { total: 0, count: 0 };
      subjectAverages[g.subject].total += g.totalMax > 0 ? (g.total / g.totalMax) * 100 : 0;
      subjectAverages[g.subject].count++;
    }

    for (const [subject, stats] of Object.entries(subjectAverages)) {
      const avg = stats.total / stats.count;
      if (avg < 40) {
        insights.push({ type: 'subject_performance', message: `Average score in ${subject} is ${avg.toFixed(0)}%. Students are struggling. Consider remedial support.`, severity: 'critical' });
      } else if (avg > 80) {
        insights.push({ type: 'subject_performance', message: `Average score in ${subject} is ${avg.toFixed(0)}%. Excellent performance!`, severity: 'success' });
      }
    }

    return insights;
  }

  private getGradeDistribution(results: ExamResult[]) {
    const grades: Record<string, number> = {};
    for (const r of results) {
      const grade = r.grade || this.calcGrade(Number(r.marks));
      grades[grade] = (grades[grade] || 0) + 1;
    }
    return grades;
  }

  private calcGrade(score: number): string {
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    if (score >= 40) return 'E';
    return 'F';
  }
}
