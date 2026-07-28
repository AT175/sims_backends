import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('admission_applications')
export class AdmissionApplication {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  applicantName: string;

  @Column()
  parentName: string;

  @Column()
  parentPhone: string;

  @Column({ type: 'varchar', nullable: true })
  parentEmail: string | null;

  @Column({ type: 'varchar', nullable: true })
  csspsPlacementRef: string | null;

  @Column({ type: 'varchar', nullable: true })
  programme: string | null;

  // The class level being applied to (e.g. 'shs1', 'jhs1', 'basic1', 'kg1')
  @Column({ type: 'varchar', nullable: true })
  appliedClassLevel: string | null;

  // Previous school info (for JHS/Primary/KG transfers)
  @Column({ type: 'varchar', nullable: true })
  previousSchool: string | null;

  @Column({ type: 'varchar', nullable: true })
  previousClass: string | null;

  // Date of birth (required for KG/Primary admissions)
  @Column({ type: 'varchar', nullable: true })
  dateOfBirth: string | null;

  // Gender
  @Column({ type: 'varchar', nullable: true })
  gender: string | null;

  @Column({ default: false })
  documentsVerified: boolean;

  @Column({ default: 'received' })
  status: string;

  @Column({ type: 'varchar', nullable: true })
  parentUserId: string | null;

  @Column({ type: 'varchar', nullable: true })
  generatedUsername: string | null;

  @Column({ type: 'varchar', nullable: true })
  generatedPassword: string | null;

  @Column({ type: 'boolean', default: false })
  isDirectApplication: boolean;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
