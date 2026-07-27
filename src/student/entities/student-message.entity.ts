import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('student_messages')
export class StudentMessage {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() studentId: string;
  @Column() studentName: string;
  @Column() admissionNo: string;

  @Column({ default: 'parent' }) recipientType: string;
  @Column({ default: '' }) recipientName: string;

  @Column() subject: string;
  @Column({ type: 'text' }) body: string;

  @Column({ default: 'Sent' }) status: string;
  @Column({ type: 'text', nullable: true }) reply: string | null;
  @Column({ type: 'date', nullable: true }) replyDate: string | null;
  @Column({ type: 'varchar', nullable: true }) replyBy: string | null;

  @Index() @Column() tenantId: string;

  @CreateDateColumn()
  createdAt: Date;
}
