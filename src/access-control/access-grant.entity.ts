import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  Index,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('access_grants')
export class AccessGrant {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  userId: string;

  @Column()
  username: string;

  @Column()
  displayName: string;

  @Index()
  @Column()
  dashboardKey: string;

  @Column()
  dashboardLabel: string;

  @Column({ type: 'text' })
  allowedPages: string;

  @Column()
  grantedBy: string;

  @CreateDateColumn()
  grantedAt: Date;

  @Index()
  @Column()
  tenantId: string;

  @UpdateDateColumn()
  updatedAt: Date;
}
