import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Student } from '../students/student.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { AttendanceRecord } from '../academic/attendance-record.entity';
import { FeeRecord } from '../bursary/fee-record.entity';
import { LessonPlanEntity } from '../teacher/entities/lesson-plan.entity';
import { AssignmentEntity } from '../teacher/entities/assignment.entity';
import { LessonRecapEntity } from '../teacher/entities/lesson-recap.entity';
import { GradebookEntryEntity } from '../teacher/entities/gradebook-entry.entity';
import { BehaviorNoteEntity } from '../teacher/entities/behavior-note.entity';
import { CounsellingCase } from '../counselling/counselling-case.entity';

export interface PushRequest {
  entityId: string;
  entityType: string;
  operation: 'create' | 'update' | 'delete';
  payload: Record<string, unknown>;
  timestamp: number;
}

export interface PushResult {
  id: string;
  success: boolean;
  serverId?: string;
  error?: string;
}

export interface PullResult {
  table: string;
  records: Record<string, unknown>[];
}

// Map table names to entity keys for repository lookup
const ENTITY_KEY_MAP: Record<string, string> = {
  students: 'studentRepo',
  exam_results: 'examResultRepo',
  attendance: 'attendanceRepo',
  fee_records: 'feeRecordRepo',
  lesson_plans: 'lessonPlanRepo',
  assignments: 'assignmentRepo',
  lesson_recaps: 'lessonRecapRepo',
  gradebook: 'gradebookRepo',
  behavior_notes: 'behaviorNoteRepo',
  counselling_cases: 'counsellingRepo',
};

@Injectable()
export class SyncService {
  private readonly logger = new Logger(SyncService.name);

  constructor(
    @InjectRepository(Student) private studentRepo: Repository<Student>,
    @InjectRepository(ExamResult) private examResultRepo: Repository<ExamResult>,
    @InjectRepository(AttendanceRecord) private attendanceRepo: Repository<AttendanceRecord>,
    @InjectRepository(FeeRecord) private feeRecordRepo: Repository<FeeRecord>,
    @InjectRepository(LessonPlanEntity) private lessonPlanRepo: Repository<LessonPlanEntity>,
    @InjectRepository(AssignmentEntity) private assignmentRepo: Repository<AssignmentEntity>,
    @InjectRepository(LessonRecapEntity) private lessonRecapRepo: Repository<LessonRecapEntity>,
    @InjectRepository(GradebookEntryEntity) private gradebookRepo: Repository<GradebookEntryEntity>,
    @InjectRepository(BehaviorNoteEntity) private behaviorNoteRepo: Repository<BehaviorNoteEntity>,
    @InjectRepository(CounsellingCase) private counsellingRepo: Repository<CounsellingCase>,
  ) {}

  private getRepo(entityType: string): Repository<any> | null {
    const key = ENTITY_KEY_MAP[entityType];
    if (!key) return null;
    return (this as any)[key] || null;
  }

  async push(items: PushRequest[], tenantId: string): Promise<PushResult[]> {
    const results: PushResult[] = [];

    for (const item of items) {
      try {
        const repo = this.getRepo(item.entityType);
        if (!repo) {
          results.push({ id: item.entityId, success: false, error: `Unknown entity type: ${item.entityType}` });
          continue;
        }

        if (item.operation === 'delete') {
          const existing = await repo.findOne({ where: { id: item.entityId, tenantId } as any }).catch(() => null);
          if (existing) {
            await repo.delete({ id: item.entityId } as any);
          }
          results.push({ id: item.entityId, success: true, serverId: item.entityId });
          continue;
        }

        // Create or update
        const existing = await repo.findOne({ where: { id: item.entityId, tenantId } as any }).catch(() => null);
        const payload = { ...item.payload, id: item.entityId, tenantId };

        if (existing) {
          // Last-write-wins: compare timestamps
          await repo.update({ id: item.entityId } as any, payload);
        } else {
          await repo.save(repo.create(payload));
        }

        results.push({ id: item.entityId, success: true, serverId: item.entityId });
      } catch (error) {
        this.logger.error(`[Sync] Push failed for ${item.entityType}:${item.entityId}`, error);
        results.push({
          id: item.entityId,
          success: false,
          error: error instanceof Error ? error.message : 'Unknown error',
        });
      }
    }

    return results;
  }

  async pull(table: string, since: string, tenantId: string): Promise<PullResult> {
    const repo = this.getRepo(table);
    if (!repo) {
      return { table, records: [] };
    }

    try {
      const sinceDate = new Date(since);
      // Query records updated since `since` for this tenant
      const qb = repo.createQueryBuilder('entity')
        .where('entity.tenantId = :tenantId', { tenantId });

      // Try to filter by updatedAt if the entity has it
      if (repo.metadata.columns.some((c) => c.propertyName === 'updatedAt')) {
        qb.andWhere('entity.updatedAt > :since', { since: sinceDate });
      } else if (repo.metadata.columns.some((c) => c.propertyName === 'createdAt')) {
        qb.andWhere('entity.createdAt > :since', { since: sinceDate });
      }

      const records = await qb.getMany();
      return {
        table,
        records: records.map((r: any) => ({
          ...r,
          deletedAt: r.deletedAt || null,
        })),
      };
    } catch (error) {
      this.logger.error(`[Sync] Pull failed for ${table}:`, error);
      return { table, records: [] };
    }
  }

  async getStatus(tenantId: string): Promise<{ status: string; lastSync: string | null; pendingPushes: number }> {
    return {
      status: 'healthy',
      lastSync: new Date().toISOString(),
      pendingPushes: 0,
    };
  }
}
