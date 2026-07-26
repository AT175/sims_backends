import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_gradebook')
export class GradebookEntryEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() studentName: string;
  @Column() admNo: string;
  @Column() classForm: string;
  @Column() subject: string;
  @Column() term: string;
  @Column({ type: 'int', default: 0 }) classwork: number;
  @Column({ type: 'int', default: 10 }) classworkMax: number;
  @Column({ type: 'int', default: 0 }) homework: number;
  @Column({ type: 'int', default: 10 }) homeworkMax: number;
  @Column({ type: 'int', default: 0 }) test: number;
  @Column({ type: 'int', default: 20 }) testMax: number;
  @Column({ type: 'int', default: 0 }) exam: number;
  @Column({ type: 'int', default: 100 }) examMax: number;
  @Column({ type: 'int', default: 0 }) total: number;
  @Column({ type: 'int', default: 140 }) totalMax: number;
  @Column({ default: '' }) grade: string;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
