import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('exeat_records')
export class ExeatRecord {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', nullable: true })
  exeatNo: string | null;

  @Column({ type: 'date' })
  date: string;

  @Column()
  studentName: string;

  @Column()
  admissionNo: string;

  @Column({ type: 'varchar', nullable: true })
  house: string | null;

  @Column({ type: 'varchar', nullable: true })
  class: string | null;

  @Column()
  reason: string;

  @Column({ type: 'text', default: '' })
  reasonDetail: string;

  @Column({ type: 'varchar', nullable: true })
  destination: string | null;

  @Column({ type: 'date' })
  departureDate: string;

  @Column({ type: 'date' })
  returnDate: string;

  @Column({ type: 'varchar', nullable: true })
  guardianName: string | null;

  @Column({ type: 'varchar', nullable: true })
  guardianPhone: string | null;

  @Column({ type: 'varchar', nullable: true })
  transportMode: string | null;

  @Column({ default: 'Pending' })
  status: string;

  @Column({ type: 'varchar', nullable: true })
  issuedBy: string | null;

  @Column({ type: 'varchar', nullable: true })
  approvedBy: string | null;

  @Column({ type: 'date', nullable: true })
  approvedDate: string | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;
}
