import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_attendance')
export class TeacherAttendanceEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() studentName: string;
  @Column() admNo: string;
  @Column() classForm: string;
  @Column() subject: string;
  @Column({ type: 'date' }) date: string;
  @Column({ default: 'Present' }) status: string;
  @Column({ type: 'text', nullable: true }) notes: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
