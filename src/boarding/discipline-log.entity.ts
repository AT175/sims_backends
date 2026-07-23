import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('boarding_discipline_logs')
export class BoardingDisciplineLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'date' })
  date: string;

  @Column()
  house: string;

  @Column()
  studentName: string;

  @Column({ type: 'text' })
  incident: string;

  @Column({ default: 'Minor' })
  severity: string;

  @Column({ type: 'text', default: '' })
  actionTaken: string;

  @Column()
  recordedBy: string;

  @Column({ default: false })
  escalated: boolean;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;
}
