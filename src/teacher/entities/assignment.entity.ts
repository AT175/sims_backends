import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_assignments')
export class AssignmentEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() title: string;
  @Column({ type: 'text', default: '' }) description: string;
  @Column() classForm: string;
  @Column() subject: string;
  @Column({ type: 'date' }) dueDate: string;
  @Column({ type: 'date', nullable: true }) expiryDate: string | null;
  @Column({ type: 'date' }) dateCreated: string;
  @Column({ type: 'int', default: 20 }) maxScore: number;
  @Column({ default: 'Draft' }) status: string;
  @Column({ default: '' }) createdBy: string;
  @Column({ nullable: true }) teacherId: string | null;
  @Column({ type: 'json', default: [] }) submissions: any[];

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
