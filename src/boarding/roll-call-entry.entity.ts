import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('roll_call_entries')
export class RollCallEntry {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'date' })
  date: string;

  @Column()
  house: string;

  @Column()
  studentName: string;

  @Column({ type: 'varchar', nullable: true })
  room: string | null;

  @Column({ default: 'Present' })
  status: string;

  @Column({ type: 'text', nullable: true })
  notes: string | null;

  @Column()
  recordedBy: string;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;
}
