import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('counselling_cases')
export class CounsellingCase {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ type: 'varchar', nullable: true }) caseId: string | null;
  @Column() studentName: string;
  @Column({ type: 'varchar', nullable: true }) studentClass: string | null;
  @Column({ type: 'varchar', nullable: true }) category: string | null;
  @Column() type: string;
  @Column({ type: 'text' }) description: string;
  @Column({ type: 'date' }) openedDate: string;
  @Column({ default: 'Active' }) status: string;
  @Column({ default: 'Medium' }) priority: string;
  @Column({ type: 'varchar', nullable: true }) assignedCounsellor: string | null;
  @Column({ type: 'text', default: '' }) notes: string;
  @Column({ type: 'date', nullable: true }) followUpDate: string | null;
  @Column({ default: false }) confidential: boolean;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
