import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('students')
export class Student {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ unique: true })
  admissionNumber: string;

  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column()
  dateOfBirth: string;

  @Column()
  gender: string;

  @Column()
  classSectionId: string;

  @Column({ type: 'varchar', nullable: true })
  houseId: string | null;

  @Column()
  guardianName: string;

  @Column()
  guardianPhone: string;

  @Column()
  guardianAddress: string;

  @Column()
  admissionDate: string;

  @Column({ default: 'active' })
  status: string;

  @Index()
  @Column()
  tenantId: string;

  @Column({ type: 'timestamp', nullable: true })
  syncedAt: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  deletedAt: Date | null;

  @Column({ type: 'varchar', nullable: true })
  voterId: string | null;

  @Column({ type: 'boolean', default: false })
  hasVoted: boolean;

  @Column({ type: 'boolean', default: false })
  isCandidate: boolean;

  @Column({ type: 'varchar', nullable: true })
  candidatePosition: string | null;

  @Column({ type: 'text', nullable: true })
  candidateManifesto: string | null;

  @Column({ type: 'varchar', default: 'pending' })
  candidateStatus: string;

  @Column({ type: 'int', default: 0 })
  candidateVotes: number;

  @Column({ type: 'varchar', nullable: true })
  photoUrl: string | null;

  @Column({ type: 'varchar', nullable: true })
  tempUsername: string | null;

  @Column({ type: 'varchar', nullable: true })
  tempPasswordHash: string | null;

  @Column({ type: 'timestamp', nullable: true })
  tempExpiresAt: Date | null;

  @Column({ type: 'boolean', default: false })
  tempUsed: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
