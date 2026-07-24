import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('tenants')
export class Tenant {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index({ unique: true })
  @Column({ unique: true })
  tenantKey: string;

  @Column()
  schoolName: string;

  @Column({ nullable: true })
  schoolCode: string | null;

  @Column({ nullable: true })
  region: string | null;

  @Column({ nullable: true })
  district: string | null;

  @Column({ nullable: true })
  address: string | null;

  @Column({ nullable: true })
  phone: string | null;

  @Column({ nullable: true })
  email: string | null;

  @Column({ nullable: true })
  logoUrl: string | null;

  @Column({ nullable: true })
  academicYear: string | null;

  @Column({ nullable: true })
  term: string | null;

  @Column({ type: 'int', default: 2000 })
  maxStudents: number;

  @Column({ type: 'int', default: 150 })
  maxStaff: number;

  @Column({ default: 'Standard' })
  subscriptionPlan: string;

  @Column({ nullable: true })
  subscriptionExpiry: string | null;

  @Column({ type: 'simple-array', default: '' })
  enabledModules: string[];

  @Column({ default: true })
  active: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
