import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CareerProfileEntity } from './career-profile.entity';
import { Student } from '../students/student.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { UNIVERSITIES, SCHOLARSHIPS, CAREER_PATHS } from './opportunities';

@Injectable()
export class CareerService {
  constructor(
    @InjectRepository(CareerProfileEntity) private profileRepo: Repository<CareerProfileEntity>,
    @InjectRepository(Student) private studentRepo: Repository<Student>,
    @InjectRepository(ExamResult) private examRepo: Repository<ExamResult>,
  ) {}

  async getRecommendations(studentId: string, tenantId: string) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const profile = await this.profileRepo.findOne({ where: { tenantId, studentId } });
    const results = await this.examRepo.find({ where: { tenantId, admNo: student.admissionNumber } });

    // Get student's subjects from exam results
    const subjects = [...new Set(results.map((r) => r.subject))];
    const avgScore = results.length > 0
      ? results.reduce((s, r) => s + Number(r.marks), 0) / results.length
      : 0;

    // Match career paths based on subjects
    const matchedCareers = CAREER_PATHS.filter((c) => {
      if (profile?.interests?.length) {
        return c.subjects.some((s) => subjects.includes(s)) || profile.interests.some((i) => c.category.toLowerCase().includes(i.toLowerCase()));
      }
      return c.subjects.some((s) => subjects.includes(s));
    }).map((c) => ({
      ...c,
      matchScore: c.subjects.filter((s) => subjects.includes(s)).length,
    })).sort((a, b) => b.matchScore - a.matchScore);

    // Match universities based on subjects and grades
    const matchedUniversities = UNIVERSITIES.filter((u) => {
      return u.subjectRequirements.some((req) => subjects.some((s) => s.includes(req) || req.includes(s)));
    }).map((u) => ({
      ...u,
      eligible: this.checkEligibility(u, subjects, avgScore),
    }));

    // Match scholarships
    const matchedScholarships = SCHOLARSHIPS.filter((s) => {
      return avgScore >= 60; // Basic academic requirement
    });

    return {
      studentName: `${student.firstName} ${student.lastName}`,
      subjects,
      averageScore: avgScore.toFixed(1),
      recommendedCareers: matchedCareers.slice(0, 5),
      recommendedUniversities: matchedUniversities.slice(0, 8),
      recommendedScholarships: matchedScholarships,
      profile: profile ? { interests: profile.interests, favoriteSubjects: profile.favoriteSubjects, savedOpportunities: profile.savedOpportunities } : null,
    };
  }

  private checkEligibility(university: any, subjects: string[], avgScore: number): string {
    const reqMet = university.subjectRequirements.filter((req: string) =>
      subjects.some((s) => s.includes(req) || req.includes(s))
    ).length;
    const totalReq = university.subjectRequirements.length;
    const subjectMatch = reqMet / totalReq;

    if (subjectMatch >= 0.8 && avgScore >= 75) return 'Strong match';
    if (subjectMatch >= 0.6 && avgScore >= 60) return 'Good match';
    if (subjectMatch >= 0.4) return 'Possible with effort';
    return 'May not meet requirements';
  }

  async saveProfile(studentId: string, tenantId: string, data: { interests: string[]; favoriteSubjects: string[]; preferredCareerPath?: string }) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    let profile = await this.profileRepo.findOne({ where: { tenantId, studentId } });
    if (profile) {
      profile.interests = data.interests;
      profile.favoriteSubjects = data.favoriteSubjects;
      profile.preferredCareerPath = data.preferredCareerPath || null;
    } else {
      profile = this.profileRepo.create({
        tenantId, studentId,
        studentName: `${student.firstName} ${student.lastName}`,
        interests: data.interests,
        favoriteSubjects: data.favoriteSubjects,
        preferredCareerPath: data.preferredCareerPath || null,
        savedOpportunities: [],
      });
    }
    return this.profileRepo.save(profile);
  }

  async saveOpportunity(studentId: string, tenantId: string, opportunityId: string) {
    const profile = await this.profileRepo.findOne({ where: { tenantId, studentId } });
    if (!profile) throw new NotFoundException('Profile not found. Save your profile first.');
    if (!profile.savedOpportunities.includes(opportunityId)) {
      profile.savedOpportunities.push(opportunityId);
    }
    return this.profileRepo.save(profile);
  }

  getOpportunities(type?: string) {
    if (type === 'university') return { universities: UNIVERSITIES };
    if (type === 'scholarship') return { scholarships: SCHOLARSHIPS };
    if (type === 'career') return { careerPaths: CAREER_PATHS };
    return { universities: UNIVERSITIES, scholarships: SCHOLARSHIPS, careerPaths: CAREER_PATHS };
  }

  getCareerPaths(subjectCombination?: string) {
    if (!subjectCombination) return CAREER_PATHS;
    const subjects = subjectCombination.split(',').map((s) => s.trim());
    return CAREER_PATHS.filter((c) => c.subjects.some((s) => subjects.some((subj) => subj.includes(s) || s.includes(subj))));
  }
}
