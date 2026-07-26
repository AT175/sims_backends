import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_remedial')
export class RemedialStudentEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() studentName: string;
  @Column() admNo: string;
  @Column() classForm: string;
  @Column() subject: string;
  @Column() area: string;
  @Column({ type: 'text', default: '' }) intervention: string;
  @Column({ type: 'date' }) dateStarted: string;
  @Column({ default: 'Just Started' }) progress: string;
  @Column({ type: 'text', default: '' }) notes: string;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
