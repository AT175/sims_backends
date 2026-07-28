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
