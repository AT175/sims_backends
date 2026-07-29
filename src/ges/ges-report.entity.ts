import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

export type GesReportType =
  | 'enrollment'
  | 'staffing'
  | 'infrastructure'
  | 'academic_performance'
  | 'financial'
  | 'health_safety'
  | 'inspection'
  | 'compliance'
  | 'special_report'
  | 'supervisory'
  | 'audit'
  | 'emis';

export type GesReportStatus = 'draft' | 'submitted' | 'under_review' | 'approved' | 'rejected' | 'overdue';

@Entity('ges_reports')
export class GesReport {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  tenantId: string;

  // School info (denormalized for quick access)
  @Column({ type: 'varchar' })
  schoolName: string;

  @Column({ type: 'varchar', nullable: true })
  schoolLevel: string | null;

  @Column({ type: 'varchar', nullable: true })
  schoolCode: string | null;

  // Which GES office this report is submitted to
  @Index()
  @Column({ type: 'varchar' })
  gesOfficeId: string;

  // Report details
  @Column({ type: 'varchar' })
  reportType: GesReportType;

  @Column({ type: 'varchar' })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  // Reporting period
  @Column({ type: 'varchar' })
  academicYear: string;

  @Column({ type: 'varchar', nullable: true })
  term: string | null;

  // Report data (flexible JSON for different report types)
  @Column({ type: 'simple-json', nullable: true })
  reportData: Record<string, any> | null;

  // Attachments (file URLs)
  @Column({ type: 'simple-array', default: '' })
  attachments: string[];

  @Column({ type: 'varchar', default: 'draft' })
  status: GesReportStatus;

  // Review info
  @Column({ type: 'varchar', nullable: true })
  reviewedBy: string | null;

  @Column({ type: 'text', nullable: true })
  reviewNotes: string | null;

  @Column({ type: 'timestamp', nullable: true })
  reviewedAt: Date | null;

  // Deadline for submission
  @Column({ type: 'timestamp', nullable: true })
  deadline: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  submittedAt: Date | null;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
