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

  @Column({ type: 'simple-array' })
  roles: string[];

  @Column({ default: 'headmaster' })
  activeRole: string;

  @Column({ type: 'int', default: 0 })
  failedLoginAttempts: number;

  @Column({ type: 'timestamp', nullable: true })
  lockedUntil: Date | null;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
