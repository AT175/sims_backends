import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('student_materials')
export class StudentMaterial {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  studentId: string;

  @Column()
  title: string;

  @Column()
  subject: string;

  @Column({ default: 'Note' })
  type: string;

  @Column({ default: false })
  downloaded: boolean;

  @Column({ type: 'varchar', nullable: true })
  fileUrl: string | null;

  @Column({ type: 'varchar', nullable: true })
  uploadedBy: string | null;

  @Column({ type: 'varchar', nullable: true })
  dateUploaded: string | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
