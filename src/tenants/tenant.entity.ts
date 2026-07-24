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
  @Column({ type: 'varchar', unique: true })
  tenantKey: string;

  @Column({ type: 'varchar' })
  schoolName: string;

  @Column({ type: 'varchar', nullable: true })
  schoolCode: string | null;

  @Column({ type: 'varchar', nullable: true })
  region: string | null;

  @Column({ type: 'varchar', nullable: true })
  district: string | null;

  @Column({ type: 'varchar', nullable: true })
  address: string | null;

  @Column({ type: 'varchar', nullable: true })
  phone: string | null;

  @Column({ type: 'varchar', nullable: true })
  email: string | null;

  @Column({ type: 'varchar', nullable: true })
  logoUrl: string | null;

  @Column({ type: 'varchar', nullable: true })
  academicYear: string | null;

  @Column({ type: 'varchar', nullable: true })
  term: string | null;

  @Column({ type: 'int', default: 2000 })
  maxStudents: number;

  @Column({ type: 'int', default: 150 })
  maxStaff: number;

  @Column({ type: 'varchar', default: 'Standard' })
  subscriptionPlan: string;

  @Column({ type: 'varchar', nullable: true })
  subscriptionExpiry: string | null;

  @Column({ type: 'simple-array', default: '' })
  enabledModules: string[];

  @Column({ type: 'boolean', default: true })
  active: boolean;

  // ── Branding & Website Fields ──

  @Column({ type: 'varchar', nullable: true })
  motto: string | null;

  @Column({ type: 'varchar', nullable: true })
  primaryColor: string | null;

  @Column({ type: 'varchar', nullable: true })
  secondaryColor: string | null;

  @Column({ type: 'varchar', nullable: true })
  bannerImage: string | null;

  @Column({ type: 'text', nullable: true })
  aboutText: string | null;

  @Column({ type: 'text', nullable: true })
  mission: string | null;

  @Column({ type: 'text', nullable: true })
  vision: string | null;

  @Column({ type: 'text', nullable: true })
  principalsMessage: string | null;

  @Column({ type: 'text', nullable: true })
  admissionsInfo: string | null;

  @Column({ type: 'varchar', nullable: true })
  facebookUrl: string | null;

  @Column({ type: 'varchar', nullable: true })
  instagramUrl: string | null;

  @Column({ type: 'varchar', nullable: true })
  twitterUrl: string | null;

  @Column({ type: 'simple-json', nullable: true })
  newsItems: { title: string; body: string; date: string }[] | null;

  @Column({ type: 'simple-json', nullable: true })
  galleryImages: string[] | null;

  @Column({ type: 'varchar', nullable: true })
  customDomain: string | null;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
