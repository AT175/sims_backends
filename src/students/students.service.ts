import { Injectable, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Student } from './student.entity';
import { User } from '../auth/user.entity';
import { CreateStudentDto, UpdateStudentDto } from './student.dto';
import * as crypto from 'crypto';
import * as bcrypt from 'bcrypt';

export interface CreatedStudentResult {
  student: Student;
  credentials?: { username: string; password: string };
}

@Injectable()
export class StudentsService {
  constructor(
    @InjectRepository(Student)
    private readonly repo: Repository<Student>,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async findAll(tenantId: string): Promise<Student[]> {
    return this.repo.find({
      where: { tenantId, deletedAt: null as any },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string, tenantId: string): Promise<Student> {
    const student = await this.repo.findOne({ where: { id, tenantId } });
    if (!student || student.deletedAt) {
      throw new NotFoundException('Student not found');
    }
    return student;
  }

  async create(dto: CreateStudentDto, tenantId: string): Promise<CreatedStudentResult> {
    const student = this.repo.create({ ...dto, tenantId });
    const saved = await this.repo.save(student);

    // Generate a username from admission number (e.g. ADM2024001 -> adm2024001)
    const baseUsername = dto.admissionNumber.toLowerCase().replace(/\s+/g, '');
    let username = baseUsername;
    let suffix = 0;
    while (await this.userRepo.findOne({ where: { username } })) {
      suffix++;
      username = `${baseUsername}${suffix}`;
    }

    // Generate a random password
    const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const lower = 'abcdefghijkmnpqrstuvwxyz';
    const digits = '23456789';
    const all = upper + lower + digits;
    const bytes = crypto.randomBytes(16);
    let password = '';
    password += upper[bytes[0] % upper.length];
    password += lower[bytes[1] % lower.length];
    password += digits[bytes[2] % digits.length];
    for (let i = 3; i < 12; i++) {
      password += all[bytes[i] % all.length];
    }
    password = password.split('').sort(() => Math.random() - 0.5).join('');

    const passwordHash = await bcrypt.hash(password, 10);
    const displayName = `${dto.firstName} ${dto.lastName}`;

    const user = this.userRepo.create({
      username,
      passwordHash,
      displayName,
      tenantId,
      schoolName: null,
      schoolLogoUrl: null,
      roles: ['student'],
      activeRole: 'student',
      mustChangePassword: true,
    });
    await this.userRepo.save(user);

    // Link student to user
    saved.userId = user.id;
    await this.repo.save(saved);

    return { student: saved, credentials: { username, password } };
  }

  async update(id: string, dto: UpdateStudentDto, tenantId: string): Promise<Student> {
    const student = await this.findOne(id, tenantId);
    Object.assign(student, dto);
    return this.repo.save(student);
  }

  async softDelete(id: string, tenantId: string): Promise<void> {
    const student = await this.findOne(id, tenantId);
    student.deletedAt = new Date();
    await this.repo.save(student);
  }

  async generateVoterIds(tenantId: string): Promise<{ success: boolean; count: number; voterIds: any[] }> {
    const students = await this.repo.find({
      where: { tenantId, deletedAt: null as any, voterId: null as any },
    });

    let count = 0;
    const voterIds = [];

    for (const student of students) {
      const year = new Date().getFullYear();
      const randomPart = crypto.randomBytes(4).toString('hex').toUpperCase();
      const voterId = `VOT-${year}-${randomPart}`;
      student.voterId = voterId;
      await this.repo.save(student);
      voterIds.push({
        id: student.id,
        name: `${student.firstName} ${student.lastName}`,
        admissionNumber: student.admissionNumber,
        voterId,
      });
      count++;
    }

    return { success: true, count, voterIds };
  }

  async getStudentVoterId(userId: string, tenantId: string): Promise<{ voterId: string | null; hasVoted: boolean; isCandidate: boolean; candidateInfo?: any }> {
    let student = await this.repo.findOne({ where: { userId, tenantId } });
    if (!student) {
      student = await this.repo.findOne({ where: { id: userId, tenantId } });
    }
    if (!student) {
      throw new NotFoundException('Student not found');
    }

    const result: any = {
      voterId: student.voterId,
      hasVoted: student.hasVoted,
      isCandidate: student.isCandidate,
    };

    if (student.isCandidate) {
      result.candidateInfo = {
        position: student.candidatePosition,
        manifesto: student.candidateManifesto,
        status: student.candidateStatus,
        votes: student.candidateVotes,
      };
    }

    return result;
  }

  async castVote(voterId: string, candidateId: string, tenantId: string): Promise<{ success: boolean }> {
    const voter = await this.repo.findOne({ where: { voterId, tenantId } });
    if (!voter) {
      throw new NotFoundException('Voter not found');
    }

    if (voter.hasVoted) {
      throw new ForbiddenException('You have already voted');
    }

    const candidate = await this.repo.findOne({ where: { id: candidateId, tenantId } });
    if (!candidate || !candidate.isCandidate) {
      throw new NotFoundException('Candidate not found');
    }

    // Mark voter as having voted
    voter.hasVoted = true;
    await this.repo.save(voter);

    // Increment candidate's vote count
    candidate.candidateVotes = (candidate.candidateVotes || 0) + 1;
    await this.repo.save(candidate);

    return { success: true };
  }

  async getCandidates(tenantId: string): Promise<any[]> {
    const candidates = await this.repo.find({
      where: { tenantId, isCandidate: true, deletedAt: null as any },
    });
    return candidates.map(c => ({
      id: c.id,
      name: `${c.firstName} ${c.lastName}`,
      position: c.candidatePosition || 'SRC President',
      manifesto: c.candidateManifesto || '',
      photoUrl: c.photoUrl,
      votes: c.candidateVotes,
    }));
  }

  async generateTempCredentials(studentId: string, tenantId: string): Promise<{ success: boolean; username: string; password: string; verificationCode: string; expiresAt: Date }> {
    const student = await this.repo.findOne({ where: { id: studentId, tenantId } });
    if (!student) {
      throw new NotFoundException('Student not found');
    }

    const username = `VOTER_${crypto.randomBytes(4).toString('hex').toUpperCase()}`;
    const password = crypto.randomBytes(8).toString('hex').toUpperCase();
    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date();
    expiresAt.setHours(expiresAt.getHours() + 2);

    student.tempUsername = username;
    student.tempPasswordHash = await bcrypt.hash(password, 10);
    student.verificationCode = verificationCode;
    student.tempExpiresAt = expiresAt;
    student.tempUsed = false;
    await this.repo.save(student);

    return { success: true, username, password, verificationCode, expiresAt };
  }

  async verifyVoter(voterId: string, tenantId: string): Promise<{ success: boolean; student?: any }> {
    const student = await this.repo.findOne({ where: { voterId, tenantId } });
    if (!student) {
      throw new NotFoundException('Voter not found');
    }

    if (student.hasVoted) {
      throw new ForbiddenException('This voter has already voted');
    }

    return {
      success: true,
      student: {
        id: student.id,
        name: `${student.firstName} ${student.lastName}`,
        admissionNumber: student.admissionNumber,
        class: student.classSectionId,
        house: student.houseId,
        photoUrl: student.photoUrl,
        voterId: student.voterId,
      },
    };
  }

  async seedStudents(tenantId: string): Promise<{ success: boolean; count: number; message: string; voterIds: any[] }> {
    const effectiveTenantId = tenantId || 'tenant-001';
    const sampleStudents = [
      {
        admissionNumber: '2026-001',
        firstName: 'Ama',
        lastName: 'Serwaa',
        dateOfBirth: '2008-05-15',
        gender: 'Female',
        classSectionId: 'SHS3 Sci A',
        houseId: 'Unity',
        guardianName: 'Kofi Serwaa',
        guardianPhone: '+233241234567',
        guardianAddress: 'Accra, Ghana',
        admissionDate: '2024-09-01',
        status: 'active',
        tenantId: effectiveTenantId,
      },
      {
        admissionNumber: '2026-002',
        firstName: 'Kofi',
        lastName: 'Bamfo',
        dateOfBirth: '2008-08-20',
        gender: 'Male',
        classSectionId: 'SHS3 Arts B',
        houseId: 'Peace',
        guardianName: 'Nana Bamfo',
        guardianPhone: '+233242345678',
        guardianAddress: 'Kumasi, Ghana',
        admissionDate: '2024-09-01',
        status: 'active',
        tenantId: effectiveTenantId,
      },
      {
        admissionNumber: '2026-003',
        firstName: 'Grace',
        lastName: 'Opoku',
        dateOfBirth: '2008-03-10',
        gender: 'Female',
        classSectionId: 'SHS3 Sci B',
        houseId: 'Unity',
        guardianName: 'Kwame Opoku',
        guardianPhone: '+233243456789',
        guardianAddress: 'Tamale, Ghana',
        admissionDate: '2024-09-01',
        status: 'active',
        tenantId: effectiveTenantId,
      },
      {
        admissionNumber: '2026-004',
        firstName: 'Daniel',
        lastName: 'Osei',
        dateOfBirth: '2008-11-25',
        gender: 'Male',
        classSectionId: 'SHS3 Sci A',
        houseId: 'Justice',
        guardianName: 'Emmanuel Osei',
        guardianPhone: '+233244567890',
        guardianAddress: 'Cape Coast, Ghana',
        admissionDate: '2024-09-01',
        status: 'active',
        tenantId: effectiveTenantId,
      },
      {
        admissionNumber: '2026-005',
        firstName: 'Emmanuel',
        lastName: 'Mensah',
        dateOfBirth: '2008-07-08',
        gender: 'Male',
        classSectionId: 'SHS3 Arts A',
        houseId: 'Freedom',
        guardianName: 'Kojo Mensah',
        guardianPhone: '+233245678901',
        guardianAddress: 'Takoradi, Ghana',
        admissionDate: '2024-09-01',
        status: 'active',
        tenantId: effectiveTenantId,
      },
      {
        admissionNumber: '2026-006',
        firstName: 'Abena',
        lastName: 'Owusu',
        dateOfBirth: '2008-09-30',
        gender: 'Female',
        classSectionId: 'SHS3 Sci C',
        houseId: 'Peace',
        guardianName: 'Kwame Owusu',
        guardianPhone: '+233246789012',
        guardianAddress: 'Sunyani, Ghana',
        admissionDate: '2024-09-01',
        status: 'active',
        tenantId: effectiveTenantId,
      },
      {
        admissionNumber: '2026-007',
        firstName: 'Kwame',
        lastName: 'Asante',
        dateOfBirth: '2008-04-12',
        gender: 'Male',
        classSectionId: 'SHS3 Sci A',
        houseId: 'Unity',
        guardianName: 'Nana Asante',
        guardianPhone: '+233247890123',
        guardianAddress: 'Ho, Ghana',
        admissionDate: '2024-09-01',
        status: 'active',
        tenantId: effectiveTenantId,
      },
      {
        admissionNumber: '2026-008',
        firstName: 'Felicity',
        lastName: 'Adjei',
        dateOfBirth: '2008-12-05',
        gender: 'Female',
        classSectionId: 'SHS3 Arts B',
        houseId: 'Peace',
        guardianName: 'Kofi Adjei',
        guardianPhone: '+233248901234',
        guardianAddress: 'Wa, Ghana',
        admissionDate: '2024-09-01',
        status: 'active',
        tenantId: effectiveTenantId,
      },
    ];

    let count = 0;
    const year = new Date().getFullYear();
    const voterIds = [];

    for (const studentData of sampleStudents) {
      const existing = await this.repo.findOne({
        where: { admissionNumber: studentData.admissionNumber, tenantId: effectiveTenantId },
      });

      if (!existing) {
        const student = this.repo.create(studentData);
        const randomPart = crypto.randomBytes(4).toString('hex').toUpperCase();
        const voterId = `VOT-${year}-${randomPart}`;
        student.voterId = voterId;
        // Mark first two students as candidates
        if (studentData.admissionNumber === '2026-001') {
          student.isCandidate = true;
          student.candidatePosition = 'SRC President';
          student.candidateManifesto = 'Empowering student voices through innovation';
          student.candidateStatus = 'approved';
        } else if (studentData.admissionNumber === '2026-002') {
          student.isCandidate = true;
          student.candidatePosition = 'SRC President';
          student.candidateManifesto = 'Building unity and excellence together';
          student.candidateStatus = 'approved';
        }
        await this.repo.save(student);
        voterIds.push({
          name: `${student.firstName} ${student.lastName}`,
          voterId,
          class: student.classSectionId,
        });
        count++;
      } else {
        // Ensure existing students get candidate flags too
        if (!existing.isCandidate && (studentData.admissionNumber === '2026-001' || studentData.admissionNumber === '2026-002')) {
          existing.isCandidate = true;
          existing.candidatePosition = 'SRC President';
          existing.candidateManifesto = studentData.admissionNumber === '2026-001'
            ? 'Empowering student voices through innovation'
            : 'Building unity and excellence together';
          existing.candidateStatus = 'approved';
          await this.repo.save(existing);
        }
        voterIds.push({
          name: `${existing.firstName} ${existing.lastName}`,
          voterId: existing.voterId,
          class: existing.classSectionId,
        });
      }
    }

    return {
      success: true,
      count,
      message: `Successfully seeded ${count} students with voter IDs. ${voterIds.length - count} already existed.`,
      voterIds,
    };
  }
}
