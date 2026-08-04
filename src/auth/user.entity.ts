import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ unique: true })
  username: string;

  @Column()
  passwordHash: string;

  @Column()
  displayName: string;

  @Index()
  @Column()
  tenantId: string;

  @Column({ type: 'varchar', nullable: true })
  schoolName: string | null;

  @Column({ type: 'varchar', nullable: true })
  schoolLogoUrl: string | null;

  @Column({ type: 'varchar', nullable: true })
  profilePictureUrl: string | null;

  // School level this user has access to (for combined schools)
  // kg, primary, jhs, shs, or null for full access
  @Column({ type: 'varchar', nullable: true })
  schoolLevel: string | null;

  @Column({ type: 'simple-array' })
  roles: string[];

  @Column({ default: 'headmaster' })
  activeRole: string;

  @Column({ type: 'int', default: 0 })
  failedLoginAttempts: number;

  @Column({ type: 'timestamp', nullable: true })
  lockedUntil: Date | null;

  @Column({ type: 'boolean', default: false })
  mustChangePassword: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
