import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('attendance_records')
export class AttendanceRecord {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  studentName: string;

  @Column()
  admNo: string;

  @Column({ type: 'date' })
  date: string;

  @Column({ default: 'Present' })
  status: string;

  @Column({ type: 'varchar', nullable: true })
  classSection: string | null;

  @Column({ type: 'varchar', nullable: true })
  remarks: string | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;
}
