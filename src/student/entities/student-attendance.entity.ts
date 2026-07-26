import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('student_attendance')
export class StudentAttendance {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  studentId: string;

  @Column()
  studentName: string;

  @Column()
  date: string;

  @Column({ default: 'Class' })
  type: string;

  @Column({ default: '' })
  subject: string;

  @Column({ default: 'Present' })
  status: string;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
