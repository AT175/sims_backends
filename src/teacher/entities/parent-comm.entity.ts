import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_parent_comms')
export class ParentCommEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() studentName: string;
  @Column() admNo: string;
  @Column() classForm: string;
  @Column({ default: '' }) guardianName: string;
  @Column({ default: '' }) guardianPhone: string;
  @Column({ default: 'Phone Call' }) channel: string;
  @Column({ default: 'Outgoing' }) direction: string;
  @Column({ default: '' }) subject: string;
  @Column({ type: 'text', default: '' }) notes: string;
  @Column({ type: 'date' }) date: string;
  @Column({ type: 'boolean', default: false }) followUpNeeded: boolean;
  @Column({ type: 'date', nullable: true }) followUpDate: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
