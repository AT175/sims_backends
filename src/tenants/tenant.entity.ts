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

  // ── School Level Support ──
  // kg = Kindergarten, primary = Basic 1-6, jhs = Basic 7-9, shs = SHS 1-3, combined = multiple levels
  @Column({ type: 'varchar', default: 'shs' })
  schoolLevel: string;

  // Grading scheme: 'wassce' (A1-F9), 'bece' (1-9), 'continuous' (percentage), 'descriptive' (Beginning/Developing/Proficient)
  @Column({ type: 'varchar', default: 'wassce' })
  gradingScheme: string;

  // Configurable class-level names per school, e.g. { "shs1": "SHS 1", "basic1": "Basic 1", "kg1": "KG 1" }
  @Column({ type: 'simple-json', nullable: true })
  classLevelNames: Record<string, string> | null;

  // Which levels this school offers (for combined schools), e.g. ['kg', 'primary', 'jhs', 'shs']
  @Column({ type: 'simple-array', default: '' })
  offeredLevels: string[];

  // Number of terms per year (3 for most Ghanaian schools, 2 for some)
  @Column({ type: 'int', default: 3 })
  termsPerYear: number;

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

  // Roles that are disabled for this tenant (based on school level), e.g. ['src', 'electoral_commission', 'dining_hall_master']
  @Column({ type: 'simple-array', default: '' })
  disabledRoles: string[];

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

  @Column({ type: 'simple-json', nullable: true })
  programmes: { name: string; description: string; icon: string }[] | null;

  @Column({ type: 'simple-json', nullable: true })
  staffProfiles: { name: string; title: string; photoUrl: string | null; bio: string | null }[] | null;

  @Column({ type: 'simple-json', nullable: true })
  upcomingEvents: { title: string; date: string; description: string; type: string }[] | null;

  @Column({ type: 'simple-json', nullable: true })
  testimonials: { author: string; role: string; content: string; rating: number }[] | null;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
