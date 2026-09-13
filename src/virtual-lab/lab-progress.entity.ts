import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('lab_progress')
export class LabProgressEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Index() @Column() studentId: string;
  @Column() studentName: string;
  @Column() labId: string;
  @Column() labTitle: string;
  @Column() subject: string;
  @Column({ type: 'varchar', nullable: true }) classForm: string | null;

  @Column({ default: false }) completed: boolean;
  @Column({ type: 'int', default: 0 }) score: number;
  @Column({ type: 'int', default: 0 }) timeSpent: number; // seconds
  @Column({ type: 'text', nullable: true }) observations: string | null;
  @Column({ type: 'text', nullable: true }) reportContent: string | null;

  @CreateDateColumn() createdAt: Date;
}
