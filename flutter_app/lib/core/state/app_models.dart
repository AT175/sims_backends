// ── Registry Types ──

enum StudentStatus { active, graduated, withdrawn, transferred }
enum AdmissionStatus { received, underReview, approved, rejected }
enum CertType { transcript, testimonial, transferLetter, characterRef, other }
enum CorrespondenceDir { incoming, outgoing }
enum CorrespondencePriority { normal, important, urgent }
enum StaffStatus { active, onLeave, retired, resigned }
enum Programme { science, arts, business, technical, agriculture, visualArts, homeEconomics }

extension ProgrammeX on Programme {
  String get label => switch (this) {
    Programme.science => 'Science',
    Programme.arts => 'Arts',
    Programme.business => 'Business',
    Programme.technical => 'Technical',
    Programme.agriculture => 'Agriculture',
    Programme.visualArts => 'Visual Arts',
    Programme.homeEconomics => 'Home Economics',
  };
}

class StudentRecord {
  final String id;
  final String admNo;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final Programme programme;
  final String className;
  final String house;
  final String guardianName;
  final String guardianPhone;
  final String guardianAddress;
  final String admissionDate;
  final StudentStatus status;
  final String? photoUrl;
  final String? csspsRef;

  const StudentRecord({
    required this.id,
    required this.admNo,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.programme,
    required this.className,
    required this.house,
    required this.guardianName,
    required this.guardianPhone,
    required this.guardianAddress,
    required this.admissionDate,
    required this.status,
    this.photoUrl,
    this.csspsRef,
  });

  String get fullName => '$firstName $lastName';
}

class DocumentItem {
  final String type;
  final bool submitted;
  const DocumentItem({required this.type, required this.submitted});
  DocumentItem copyWith({bool? submitted}) => DocumentItem(type: type, submitted: submitted ?? this.submitted);
}

class AdmissionApplication {
  final String id;
  final String applicantName;
  final String parentName;
  final String parentPhone;
  final String parentEmail;
  final String dateApplied;
  final AdmissionStatus status;
  final bool documentsVerified;
  final Programme programme;
  final String? csspsRef;
  final String notes;
  final List<DocumentItem> documents;
  final String? processedBy;

  const AdmissionApplication({
    required this.id,
    required this.applicantName,
    required this.parentName,
    required this.parentPhone,
    required this.parentEmail,
    required this.dateApplied,
    required this.status,
    required this.documentsVerified,
    required this.programme,
    this.csspsRef,
    required this.notes,
    this.documents = const [],
    this.processedBy,
  });

  AdmissionApplication copyWith({
    AdmissionStatus? status,
    bool? documentsVerified,
    List<DocumentItem>? documents,
    String? processedBy,
    String? notes,
  }) => AdmissionApplication(
    id: id, applicantName: applicantName, parentName: parentName,
    parentPhone: parentPhone, parentEmail: parentEmail, dateApplied: dateApplied,
    status: status ?? this.status,
    documentsVerified: documentsVerified ?? this.documentsVerified,
    programme: programme, csspsRef: csspsRef,
    notes: notes ?? this.notes,
    documents: documents ?? this.documents,
    processedBy: processedBy ?? this.processedBy,
  );
}

class Certificate {
  final String id;
  final String studentName;
  final String admNo;
  final CertType type;
  final String dateIssued;
  final String issuedBy;
  final String purpose;

  const Certificate({
    required this.id,
    required this.studentName,
    required this.admNo,
    required this.type,
    required this.dateIssued,
    required this.issuedBy,
    required this.purpose,
  });
}

class Correspondence {
  final String id;
  final String date;
  final CorrespondenceDir direction;
  final String subject;
  final String counterparty;
  final CorrespondencePriority priority;
  final String loggedBy;
  final String notes;

  const Correspondence({
    required this.id,
    required this.date,
    required this.direction,
    required this.subject,
    required this.counterparty,
    required this.priority,
    required this.loggedBy,
    required this.notes,
  });
}

class RegistryStaff {
  final String id;
  final String name;
  final String position;
  final String role;
  final String department;
  final String dateOfEmployment;
  final List<String> qualifications;
  final String phone;
  final StaffStatus status;

  const RegistryStaff({
    required this.id,
    required this.name,
    required this.position,
    required this.role,
    required this.department,
    required this.dateOfEmployment,
    required this.qualifications,
    required this.phone,
    required this.status,
  });
}

// ── Admissions / Registry Extended Types ──

class PlacementRecord {
  final String id;
  final String fullName;
  final String csspsRef;
  final String intendedClass;
  final Programme programme;
  final String preloadedBy;
  final String datePreloaded;
  final bool matched;

  const PlacementRecord({
    required this.id,
    required this.fullName,
    required this.csspsRef,
    required this.intendedClass,
    required this.programme,
    required this.preloadedBy,
    required this.datePreloaded,
    required this.matched,
  });

  PlacementRecord copyWith({bool? matched}) => PlacementRecord(
    id: id, fullName: fullName, csspsRef: csspsRef, intendedClass: intendedClass,
    programme: programme, preloadedBy: preloadedBy, datePreloaded: datePreloaded,
    matched: matched ?? this.matched,
  );
}

class ScratchCard {
  final String id;
  final String pin;
  final String serial;
  final double amount;
  final bool used;
  final String? usedBy;
  final String? usedAt;
  final String batchId;
  final String generatedAt;

  const ScratchCard({
    required this.id,
    required this.pin,
    required this.serial,
    required this.amount,
    required this.used,
    this.usedBy,
    this.usedAt,
    required this.batchId,
    required this.generatedAt,
  });
}

class Prospectus {
  final String id;
  final String title;
  final String academicYear;
  final String content;
  final String publishedBy;
  final String datePublished;
  final List<String> targetedAdmissionIds;

  const Prospectus({
    required this.id,
    required this.title,
    required this.academicYear,
    required this.content,
    required this.publishedBy,
    required this.datePublished,
    required this.targetedAdmissionIds,
  });
}

class ParentAccount {
  final String id;
  final String username;
  final String password;
  final String parentName;
  final String parentPhone;
  final String parentEmail;
  final String wardName;
  final String wardAdmNo;
  final String wardClass;
  final String wardHouse;
  final Programme wardProgramme;
  final String createdAt;
  final String admissionId;

  const ParentAccount({
    required this.id,
    required this.username,
    required this.password,
    required this.parentName,
    required this.parentPhone,
    required this.parentEmail,
    required this.wardName,
    required this.wardAdmNo,
    required this.wardClass,
    required this.wardHouse,
    required this.wardProgramme,
    required this.createdAt,
    required this.admissionId,
  });
}

enum FormFieldType { text, date, gender, programme, phone, email, address, photo, csspsRef }

class AdmissionFormField {
  final String id;
  final String label;
  final FormFieldType type;
  final bool required;
  final bool enabled;

  const AdmissionFormField({
    required this.id,
    required this.label,
    required this.type,
    required this.required,
    required this.enabled,
  });

  AdmissionFormField copyWith({bool? enabled}) => AdmissionFormField(
    id: id, label: label, type: type, required: required, enabled: enabled ?? this.enabled,
  );
}

class AdmissionFormConfig {
  final List<AdmissionFormField> fields;
  final List<String> requiredDocuments;
  final bool photoRequired;
  final String academicYear;

  const AdmissionFormConfig({
    required this.fields,
    required this.requiredDocuments,
    required this.photoRequired,
    required this.academicYear,
  });

  AdmissionFormConfig copyWith({
    List<AdmissionFormField>? fields,
    List<String>? requiredDocuments,
    bool? photoRequired,
    String? academicYear,
  }) => AdmissionFormConfig(
    fields: fields ?? this.fields,
    requiredDocuments: requiredDocuments ?? this.requiredDocuments,
    photoRequired: photoRequired ?? this.photoRequired,
    academicYear: academicYear ?? this.academicYear,
  );
}

// ── Bursary Types ──

enum FeeStatus { cleared, owing, partial }
enum PaymentMethod { cash, bankTransfer, mobileMoney, cheque, card }
enum PayrollStatus { pending, processed, paid }
enum ExpenditureCategory { utilities, stores, repairs, salaries, transport, equipment, misc, capital }
enum BudgetStatus { draft, submitted, approved, rejected, active }
enum InvoiceStatus { issued, paid, overdue, cancelled }

class FeeRecord {
  final String id;
  final String studentName;
  final String admNo;
  final String className;
  final String term;
  final String feeType;
  final double amountDue;
  final double amountPaid;
  final double balance;
  final FeeStatus status;
  final String guardianName;
  final String guardianPhone;
  final String? lastPaymentDate;

  const FeeRecord({
    required this.id,
    required this.studentName,
    required this.admNo,
    required this.className,
    required this.term,
    required this.feeType,
    required this.amountDue,
    required this.amountPaid,
    required this.balance,
    required this.status,
    required this.guardianName,
    required this.guardianPhone,
    this.lastPaymentDate,
  });
}

class PayrollEntry {
  final String id;
  final String staffName;
  final String position;
  final String department;
  final double grossSalary;
  final double deductions;
  final double netSalary;
  final String payPeriod;
  final PayrollStatus status;
  final double ssfContribution;
  final double taxDeduction;

  const PayrollEntry({
    required this.id,
    required this.staffName,
    required this.position,
    required this.department,
    required this.grossSalary,
    required this.deductions,
    required this.netSalary,
    required this.payPeriod,
    required this.status,
    this.ssfContribution = 0,
    this.taxDeduction = 0,
  });
}

class ExpenditureRecord {
  final String id;
  final String date;
  final ExpenditureCategory category;
  final String description;
  final double amount;
  final String vendor;
  final String paymentMethod;
  final String authorizedBy;
  final String? receiptNo;
  final String notes;

  const ExpenditureRecord({
    required this.id,
    required this.date,
    required this.category,
    required this.description,
    required this.amount,
    required this.vendor,
    this.paymentMethod = 'Cash',
    required this.authorizedBy,
    this.receiptNo,
    this.notes = '',
  });
}

class BudgetItem {
  final String id;
  final String department;
  final double allocated;
  final double spent;
  final double remaining;
  final String term;
  final BudgetStatus status;
  final String notes;

  const BudgetItem({
    required this.id,
    required this.department,
    required this.allocated,
    required this.spent,
    required this.remaining,
    required this.term,
    required this.status,
    this.notes = '',
  });
}

class InvoiceItem {
  final String description;
  final double amount;
  const InvoiceItem({required this.description, required this.amount});
}

class Invoice {
  final String id;
  final String invoiceNo;
  final String studentName;
  final String admNo;
  final String className;
  final String guardianName;
  final String term;
  final List<InvoiceItem> items;
  final double totalAmount;
  final double amountPaid;
  final double balance;
  final InvoiceStatus status;
  final String dateIssued;
  final String dueDate;
  final String issuedBy;

  const Invoice({
    required this.id,
    required this.invoiceNo,
    required this.studentName,
    required this.admNo,
    required this.className,
    required this.guardianName,
    required this.term,
    this.items = const [],
    required this.totalAmount,
    required this.amountPaid,
    required this.balance,
    required this.status,
    required this.dateIssued,
    required this.dueDate,
    this.issuedBy = 'Accountant',
  });
}

class PaymentReceipt {
  final String id;
  final String receiptNo;
  final String feeId;
  final String studentName;
  final String admNo;
  final double amount;
  final String method;
  final String date;
  final String receivedBy;
  final String notes;
  const PaymentReceipt({
    required this.id, required this.receiptNo, required this.feeId,
    required this.studentName, required this.admNo, required this.amount,
    required this.method, required this.date, required this.receivedBy, required this.notes,
  });
}

class BudgetSubmissionItem {
  final String description;
  final int quantity;
  final double unitCost;
  final double total;
  const BudgetSubmissionItem({required this.description, required this.quantity, required this.unitCost, required this.total});
}

class BudgetSubmission {
  final String id;
  final String department;
  final String submittedBy;
  final String supervisorName;
  final String dateSubmitted;
  final double totalRequested;
  final String status;
  final String justification;
  final List<BudgetSubmissionItem> items;
  final String supervisorNotes;
  final String accountantNotes;
  const BudgetSubmission({
    required this.id, required this.department, required this.submittedBy,
    required this.supervisorName, required this.dateSubmitted, required this.totalRequested,
    required this.status, required this.justification, required this.items,
    required this.supervisorNotes, required this.accountantNotes,
  });
}

// ── Academic Types ──

enum ExamStatus { scheduled, ongoing, completed, cancelled }
enum ResultsEntryStatus { notStarted, inProgress, submitted, verified }
enum TimetableStatus { draft, published, archived }
enum HodApprovalStatus { pending, approved, deferred, rejected }
enum ReportCardStatus { notGenerated, generated, underReview, released }
enum TranscriptStatus { draft, pendingReview, approved, released, rejected }
enum CurriculumStatus { notStarted, inProgress, completed, revised }

class Exam {
  final String id;
  final String title;
  final String subject;
  final String classForm;
  final String date;
  final String startTime;
  final String endTime;
  final String venue;
  final int maxScore;
  final ExamStatus status;
  final ResultsEntryStatus resultsStatus;
  final String invigilator;
  final String term;

  const Exam({
    required this.id,
    required this.title,
    required this.subject,
    required this.classForm,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.maxScore,
    required this.status,
    required this.resultsStatus,
    required this.invigilator,
    required this.term,
  });
}

class TimetableEntry {
  final String id;
  final String classForm;
  final String day;
  final int period;
  final String startTime;
  final String endTime;
  final String subject;
  final String teacher;
  final String room;
  final TimetableStatus status;

  const TimetableEntry({
    required this.id,
    required this.classForm,
    required this.day,
    required this.period,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.teacher,
    required this.room,
    required this.status,
  });
}

class HodApproval {
  final String id;
  final String type;
  final String from;
  final String department;
  final String detail;
  final String date;
  final HodApprovalStatus status;

  const HodApproval({
    required this.id,
    required this.type,
    required this.from,
    required this.department,
    required this.detail,
    required this.date,
    required this.status,
  });
}

class ReportCard {
  final String id;
  final String classForm;
  final String studentName;
  final String admNo;
  final String term;
  final String academicYear;
  final double average;
  final String classPosition;
  final String conduct;
  final String attendance;
  final String remarks;
  final ReportCardStatus status;

  const ReportCard({
    required this.id,
    required this.classForm,
    required this.studentName,
    required this.admNo,
    required this.term,
    required this.academicYear,
    required this.average,
    required this.classPosition,
    required this.conduct,
    required this.attendance,
    required this.remarks,
    required this.status,
  });
}

class CurriculumSubject {
  final String id;
  final String subject;
  final String department;
  final String hod;
  final String classForm;
  final int syllabusTopics;
  final int topicsCovered;
  final double coveragePct;
  final CurriculumStatus status;
  final String lastUpdated;

  const CurriculumSubject({
    required this.id,
    required this.subject,
    required this.department,
    required this.hod,
    required this.classForm,
    required this.syllabusTopics,
    required this.topicsCovered,
    required this.coveragePct,
    required this.status,
    required this.lastUpdated,
  });
}

class Transcript {
  final String id;
  final String studentName;
  final String admNo;
  final String classForm;
  final String academicYear;
  final List<String> termsCovered;
  final double cumulativeAverage;
  final String overallPosition;
  final String conduct;
  final String attendance;
  final TranscriptStatus status;
  final String generatedDate;
  final String? approvedBy;
  final String? approvedDate;

  const Transcript({
    required this.id,
    required this.studentName,
    required this.admNo,
    required this.classForm,
    required this.academicYear,
    required this.termsCovered,
    required this.cumulativeAverage,
    required this.overallPosition,
    required this.conduct,
    required this.attendance,
    required this.status,
    required this.generatedDate,
    this.approvedBy,
    this.approvedDate,
  });
}

class CalendarEvent {
  final String id;
  final String title;
  final String type;
  final String date;
  final String? endDate;
  final String description;
  final String term;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    this.endDate,
    required this.description,
    required this.term,
  });
}

class AcademicTerm {
  final String id;
  final String term;
  final String academicYear;
  final String startDate;
  final String endDate;
  final String midTermBreak;
  final bool isCurrent;

  const AcademicTerm({
    required this.id,
    required this.term,
    required this.academicYear,
    required this.startDate,
    required this.endDate,
    required this.midTermBreak,
    required this.isCurrent,
  });
}

class SubjectPerformance {
  final String id;
  final String subject;
  final String department;
  final String hod;
  final double avgScore;
  final double coveragePct;
  final int teacherCount;
  final int studentCount;
  final double passRate;
  final String trend;

  const SubjectPerformance({
    required this.id,
    required this.subject,
    required this.department,
    required this.hod,
    required this.avgScore,
    required this.coveragePct,
    required this.teacherCount,
    required this.studentCount,
    required this.passRate,
    required this.trend,
  });
}

class TeacherActivity {
  final String id;
  final String teacherName;
  final String department;
  final int lessonPlansThisTerm;
  final int materialsUploaded;
  final int assignmentsCreated;
  final int attendanceMarkedPct;
  final int syllabusCoverage;
  final String lastActive;
  final String status;

  const TeacherActivity({
    required this.id,
    required this.teacherName,
    required this.department,
    required this.lessonPlansThisTerm,
    required this.materialsUploaded,
    required this.assignmentsCreated,
    required this.attendanceMarkedPct,
    required this.syllabusCoverage,
    required this.lastActive,
    required this.status,
  });
}

class AdmissionInsight {
  final String id;
  final String classForm;
  final int applied;
  final int admitted;
  final int rejected;
  final int pending;
  final int capacity;
  final int filled;

  const AdmissionInsight({
    required this.id,
    required this.classForm,
    required this.applied,
    required this.admitted,
    required this.rejected,
    required this.pending,
    required this.capacity,
    required this.filled,
  });
}

class PLCRequisition {
  final String id;
  final String date;
  final String itemName;
  final int quantity;
  final String unit;
  final String purpose;
  final String requestedBy;
  final String status;
  final String approvedBy;
  final String approvedDate;
  final String notes;

  const PLCRequisition({
    required this.id,
    required this.date,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.purpose,
    required this.requestedBy,
    required this.status,
    required this.approvedBy,
    required this.approvedDate,
    required this.notes,
  });
}

// ── SPIP Types ──

enum SPIPPriority { low, medium, high }
enum SPIPStatus { draft, active, monitoring, completed, archived }
enum SPIPGoalStatus { notStarted, inProgress, achieved, revised }
enum SPIPFocusArea { instruction, people, culture, operations, community }
enum SPIPMilestoneStatus { pending, achieved, missed }

extension SPIPPriorityX on SPIPPriority {
  String get label => switch (this) {
    SPIPPriority.low => 'Low', SPIPPriority.medium => 'Medium', SPIPPriority.high => 'High',
  };
}
extension SPIPStatusX on SPIPStatus {
  String get label => switch (this) {
    SPIPStatus.draft => 'Draft', SPIPStatus.active => 'Active',
    SPIPStatus.monitoring => 'Monitoring', SPIPStatus.completed => 'Completed',
    SPIPStatus.archived => 'Archived',
  };
}
extension SPIPGoalStatusX on SPIPGoalStatus {
  String get label => switch (this) {
    SPIPGoalStatus.notStarted => 'Not Started', SPIPGoalStatus.inProgress => 'In Progress',
    SPIPGoalStatus.achieved => 'Achieved', SPIPGoalStatus.revised => 'Revised',
  };
}
extension SPIPFocusAreaX on SPIPFocusArea {
  String get label => switch (this) {
    SPIPFocusArea.instruction => 'Instruction', SPIPFocusArea.people => 'People',
    SPIPFocusArea.culture => 'Culture', SPIPFocusArea.operations => 'Operations',
    SPIPFocusArea.community => 'Community',
  };
}
extension SPIPMilestoneStatusX on SPIPMilestoneStatus {
  String get label => switch (this) {
    SPIPMilestoneStatus.pending => 'Pending', SPIPMilestoneStatus.achieved => 'Achieved',
    SPIPMilestoneStatus.missed => 'Missed',
  };
}

class SPIPGoal {
  final String id;
  final String title;
  final SPIPFocusArea focusArea;
  final String description;
  final String baseline;
  final String target;
  final String currentProgress;
  final SPIPGoalStatus status;
  final String responsible;
  final String deadline;

  const SPIPGoal({
    required this.id, required this.title, required this.focusArea,
    required this.description, required this.baseline, required this.target,
    required this.currentProgress, required this.status, required this.responsible,
    required this.deadline,
  });
}

class SPIPActionItem {
  final String id;
  final String description;
  final SPIPFocusArea focusArea;
  final String responsible;
  final String timeline;
  final bool completed;

  const SPIPActionItem({
    required this.id, required this.description, required this.focusArea,
    required this.responsible, required this.timeline, required this.completed,
  });
}

class SPIPMilestone {
  final String id;
  final String title;
  final String targetDate;
  final String? achievedDate;
  final SPIPMilestoneStatus status;

  const SPIPMilestone({
    required this.id, required this.title, required this.targetDate,
    this.achievedDate, required this.status,
  });
}

class SPIPReview {
  final String date;
  final String recordedBy;
  final String summary;
  final String outcomes;

  const SPIPReview({
    required this.date, required this.recordedBy,
    required this.summary, required this.outcomes,
  });
}

class SPIP {
  final String id;
  final String title;
  final String academicYear;
  final String planLead;
  final SPIPPriority priority;
  final String startDate;
  final String endDate;
  final SPIPStatus status;
  final String vision;
  final String strengths;
  final String weaknesses;
  final String rootCauses;
  final String priorityAreas;
  final List<String> teamMembers;
  final List<SPIPGoal> goals;
  final List<SPIPActionItem> actionItems;
  final List<SPIPMilestone> milestones;
  final List<SPIPReview> progressReviews;

  const SPIP({
    required this.id, required this.title, required this.academicYear,
    required this.planLead, required this.priority, required this.startDate,
    required this.endDate, required this.status, required this.vision,
    required this.strengths, required this.weaknesses, required this.rootCauses,
    required this.priorityAreas, required this.teamMembers, required this.goals,
    required this.actionItems, required this.milestones, required this.progressReviews,
  });
}

// ── Notification Type ──

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime timestamp;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.read,
  });
}
