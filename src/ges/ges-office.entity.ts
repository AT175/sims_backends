import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
} from 'typeorm';

export type GesLevel = 'national' | 'regional' | 'district' | 'circuit';

@Entity('ges_offices')
export class GesOffice {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index({ unique: true })
  @Column({ type: 'varchar', unique: true })
  officeKey: string;

  @Column({ type: 'varchar' })
  name: string;

  @Column({ type: 'varchar' })
  level: GesLevel;

  // Parent office (e.g. circuit -> district, district -> region, region -> national)
  @Index()
  @Column({ type: 'varchar', nullable: true })
  parentId: string | null;

  // GES code for this office
  @Column({ type: 'varchar', nullable: true })
  gesCode: string | null;

  // Location info
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

  // Head of office
  @Column({ type: 'varchar', nullable: true })
  headName: string | null;

  @Column({ type: 'varchar', nullable: true })
  headTitle: string | null;

  @Column({ type: 'boolean', default: true })
  active: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
