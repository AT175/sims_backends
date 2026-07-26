import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('student_classes')
export class StudentClass {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  studentId: string;

  @Column()
  subject: string;

  @Column()
  teacher: string;

  @Column({ type: 'varchar', nullable: true })
  nextSession: string | null;

  @Column({ type: 'varchar', nullable: true })
  classForm: string | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
