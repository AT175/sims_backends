import 'package:flutter/foundation.dart';

// ── Staff Dashboard Models ──

class StaffNotice {
  final String title, date, author, body, priority;
  const StaffNotice({required this.title, required this.date, required this.author, required this.body, required this.priority});
}

class StaffMeetingMinutes {
  final String title, date, attendees, facilitator, summary;
  const StaffMeetingMinutes({required this.title, required this.date, required this.attendees, required this.facilitator, required this.summary});
}

class StaffResource {
  final String title, type, uploadedBy, date, fileSize;
  const StaffResource({required this.title, required this.type, required this.uploadedBy, required this.date, required this.fileSize});
}

class StaffLeaveRequest {
  final String id, staffName, staffRole, dateSubmitted, type, startDate, endDate, days, reason, status;
  final String? reviewedBy, reviewDate, reviewNotes;
  const StaffLeaveRequest({required this.id, required this.staffName, required this.staffRole, required this.dateSubmitted, required this.type, required this.startDate, required this.endDate, required this.days, required this.reason, required this.status, this.reviewedBy, this.reviewDate, this.reviewNotes});
}

class StaffDirectoryEntry {
  final String name, position, department, phone, email;
  final String status;
  const StaffDirectoryEntry({required this.name, required this.position, required this.department, required this.phone, required this.email, this.status = 'Active'});
}

class StaffProvider extends ChangeNotifier {
  final List<StaffNotice> notices = [
    StaffNotice(title: 'Staff Meeting - July', date: '2026-07-08', author: 'Headmaster', body: 'All staff are required to attend the general meeting on Friday 12th July at 2pm.', priority: 'Important'),
    StaffNotice(title: 'Mid-term Exam Preparation', date: '2026-07-05', author: 'Academic Office', body: 'Submit question papers by 30th July. Format guidelines attached.', priority: 'Urgent'),
    StaffNotice(title: 'Professional Development Workshop', date: '2026-07-01', author: 'PLC Coordinator', body: 'Workshop on differentiated instruction scheduled for 18th July.', priority: 'Normal'),
  ];

  final List<StaffMeetingMinutes> minutes = [
    StaffMeetingMinutes(title: 'General Staff Meeting', date: '2026-06-28', attendees: '45', facilitator: 'Headmaster', summary: 'Discussed term 3 priorities, exam preparation, and student welfare.'),
    StaffMeetingMinutes(title: 'HOD Meeting', date: '2026-06-20', attendees: '12', facilitator: 'Asst. Headmaster (Academic)', summary: 'Curriculum coverage review, syllabus tracking, and assessment plans.'),
  ];

  final List<StaffResource> resources = [
    StaffResource(title: 'Lesson Plan Template 2026', type: 'Document', uploadedBy: 'Academic Office', date: '2026-01-15', fileSize: '245 KB'),
    StaffResource(title: 'Assessment Guidelines', type: 'PDF', uploadedBy: 'Academic Office', date: '2026-01-20', fileSize: '1.2 MB'),
    StaffResource(title: 'Child Protection Policy', type: 'PDF', uploadedBy: 'Admin Office', date: '2026-01-10', fileSize: '890 KB'),
  ];

  final List<StaffLeaveRequest> leaveRequests = [
    StaffLeaveRequest(id: 'l1', staffName: 'J. Mensah', staffRole: 'Senior Teacher', dateSubmitted: '2026-07-05', type: 'Annual', startDate: '2026-07-15', endDate: '2026-07-20', days: '6', reason: 'Family vacation planned during mid-term break.', status: 'Pending'),
    StaffLeaveRequest(id: 'l2', staffName: 'G. Adjei', staffRole: 'HOD', dateSubmitted: '2026-05-10', type: 'Sick', startDate: '2026-05-20', endDate: '2026-05-25', days: '6', reason: 'Medical procedure and recovery period.', status: 'Approved', reviewedBy: 'Headmaster', reviewDate: '2026-05-12', reviewNotes: 'Approved. Arrangements made for class coverage.'),
    StaffLeaveRequest(id: 'l3', staffName: 'M. Owusu', staffRole: 'Teacher', dateSubmitted: '2026-07-08', type: 'Sick', startDate: '2026-07-12', endDate: '2026-07-14', days: '3', reason: 'Severe malaria diagnosis, doctor recommends rest.', status: 'Pending'),
  ];

  final List<StaffDirectoryEntry> directory = [
    StaffDirectoryEntry(name: 'J. Mensah', position: 'Senior Teacher', department: 'Mathematics', phone: '024-111-2222', email: 'j.mensah@school.edu', status: 'Active'),
    StaffDirectoryEntry(name: 'G. Adjei', position: 'HOD Science', department: 'Science', phone: '027-333-4444', email: 'g.adjei@school.edu', status: 'Active'),
    StaffDirectoryEntry(name: 'F. Boateng', position: 'Teacher (English)', department: 'English', phone: '020-555-6666', email: 'f.boateng@school.edu', status: 'On Leave'),
    StaffDirectoryEntry(name: 'A. Tetteh', position: 'Accountant', department: 'Finance', phone: '055-777-8888', email: 'a.tetteh@school.edu', status: 'Active'),
    StaffDirectoryEntry(name: 'R. Amponsah', position: 'Asst. Headmaster', department: 'Administration', phone: '024-999-0000', email: 'r.amponsah@school.edu', status: 'Active'),
  ];

  int get pendingLeave => leaveRequests.where((l) => l.status == 'Pending').length;

  void reviewLeave(String id, String newStatus, [String? reviewedBy, String? notes]) {
    final idx = leaveRequests.indexWhere((l) => l.id == id);
    if (idx >= 0) {
      final l = leaveRequests[idx];
      leaveRequests[idx] = StaffLeaveRequest(
        id: l.id, staffName: l.staffName, staffRole: l.staffRole, dateSubmitted: l.dateSubmitted,
        type: l.type, startDate: l.startDate, endDate: l.endDate, days: l.days, reason: l.reason,
        status: newStatus, reviewedBy: reviewedBy, reviewDate: reviewedBy != null ? DateTime.now().toIso8601String().substring(0, 10) : null, reviewNotes: notes,
      );
      notifyListeners();
    }
  }
}

// ── Subject HOD Models ──

class HodSyllabusTopic {
  final String subject, classForm, week, topic, subTopics, status;
  const HodSyllabusTopic({required this.subject, required this.classForm, required this.week, required this.topic, required this.subTopics, required this.status});
}

class HodLessonPlan {
  final String date, teacher, subject, classForm, topic, status, notes;
  const HodLessonPlan({required this.date, required this.teacher, required this.subject, required this.classForm, required this.topic, required this.status, required this.notes});
}

class HodExam {
  final String examName, subject, classForm, date, duration, maxScore, status;
  const HodExam({required this.examName, required this.subject, required this.classForm, required this.date, required this.duration, required this.maxScore, required this.status});
}

class HodResult {
  final String examName, subject, classForm, students, average, highest, lowest, passRate;
  const HodResult({required this.examName, required this.subject, required this.classForm, required this.students, required this.average, required this.highest, required this.lowest, required this.passRate});
}

class HodProvider extends ChangeNotifier {
  final String department = 'Mathematics';
  final String hodName = 'J. Mensah';

  final List<HodSyllabusTopic> syllabus = [
    HodSyllabusTopic(subject: 'Mathematics', classForm: 'SHS2 Sci A', week: '1', topic: 'Quadratic Equations', subTopics: 'Factorisation, completing the square, formula', status: 'Completed'),
    HodSyllabusTopic(subject: 'Mathematics', classForm: 'SHS2 Sci A', week: '2', topic: 'Inequalities', subTopics: 'Linear, quadratic, absolute value', status: 'Completed'),
    HodSyllabusTopic(subject: 'Mathematics', classForm: 'SHS2 Sci A', week: '3', topic: 'Linear Programming', subTopics: 'Graphical methods, optimization', status: 'In Progress'),
    HodSyllabusTopic(subject: 'Mathematics', classForm: 'SHS2 Sci A', week: '4', topic: 'Trigonometry', subTopics: 'Ratios, identities, equations', status: 'Pending'),
  ];

  final List<HodLessonPlan> lessonPlans = [
    HodLessonPlan(date: '2026-07-10', teacher: 'J. Mensah', subject: 'Mathematics', classForm: 'SHS2 Sci A', topic: 'Linear Programming - Introduction', status: 'Approved', notes: 'Good use of real-world examples.'),
    HodLessonPlan(date: '2026-07-09', teacher: 'K. Owusu', subject: 'Mathematics', classForm: 'SHS1 Sci A', topic: 'Algebraic Expressions', status: 'Approved', notes: 'Well structured.'),
    HodLessonPlan(date: '2026-07-08', teacher: 'J. Mensah', subject: 'Mathematics', classForm: 'SHS3 Sci A', topic: 'Differentiation - Chain Rule', status: 'Pending', notes: ''),
  ];

  final List<HodExam> exams = [
    HodExam(examName: 'Mid-Term 3', subject: 'Mathematics', classForm: 'SHS2 Sci A', date: '2026-08-05', duration: '2hrs', maxScore: '100', status: 'Question Paper Approved'),
    HodExam(examName: 'Mid-Term 3', subject: 'Mathematics', classForm: 'SHS1 Sci A', date: '2026-08-06', duration: '2hrs', maxScore: '100', status: 'Question Paper Pending'),
  ];

  final List<HodResult> results = [
    HodResult(examName: 'End-Term 2', subject: 'Mathematics', classForm: 'SHS2 Sci A', students: '35', average: '72', highest: '96', lowest: '42', passRate: '88%'),
    HodResult(examName: 'End-Term 2', subject: 'Mathematics', classForm: 'SHS1 Sci A', students: '40', average: '68', highest: '92', lowest: '38', passRate: '82%'),
  ];
}

// ── Governing Board Models ──

class BoardPolicy {
  final String title, category, dateApproved, status, description;
  const BoardPolicy({required this.title, required this.category, required this.dateApproved, required this.status, required this.description});
}

class BoardBudget {
  final String department, allocated, approved, spent, remaining, fiscalYear, status;
  const BoardBudget({required this.department, required this.allocated, required this.approved, required this.spent, required this.remaining, required this.fiscalYear, required this.status});
}

class BoardMinutes {
  final String title, date, attendees, chair, summary;
  const BoardMinutes({required this.title, required this.date, required this.attendees, required this.chair, required this.summary});
}

class BoardReport {
  final String title, date, author, category, summary;
  const BoardReport({required this.title, required this.date, required this.author, required this.category, required this.summary});
}

class GoverningBoardProvider extends ChangeNotifier {
  final List<BoardPolicy> policies = [
    BoardPolicy(title: 'Admissions Policy 2026', category: 'Academic', dateApproved: '2026-01-15', status: 'Active', description: 'Guidelines for student admissions and placement.'),
    BoardPolicy(title: 'Staff Code of Conduct', category: 'HR', dateApproved: '2025-09-01', status: 'Active', description: 'Professional conduct expectations for all staff.'),
    BoardPolicy(title: 'Financial Management Policy', category: 'Finance', dateApproved: '2025-08-10', status: 'Active', description: 'Budgeting, procurement, and financial reporting procedures.'),
  ];

  final List<BoardBudget> budgets = [
    BoardBudget(department: 'Academic', allocated: '120000', approved: '120000', spent: '78000', remaining: '42000', fiscalYear: '2025/2026', status: 'Active'),
    BoardBudget(department: 'Administration', allocated: '80000', approved: '80000', spent: '55000', remaining: '25000', fiscalYear: '2025/2026', status: 'Active'),
    BoardBudget(department: 'Domestic', allocated: '200000', approved: '200000', spent: '145000', remaining: '55000', fiscalYear: '2025/2026', status: 'Active'),
    BoardBudget(department: 'Capital Projects', allocated: '500000', approved: '350000', spent: '180000', remaining: '170000', fiscalYear: '2025/2026', status: 'Partially Approved'),
  ];

  final List<BoardMinutes> minutes = [
    BoardMinutes(title: 'Quarterly Board Meeting Q2', date: '2026-04-15', attendees: '12', chair: 'Board Chair', summary: 'Reviewed Q2 performance, approved capital projects budget, discussed staff welfare.'),
    BoardMinutes(title: 'Quarterly Board Meeting Q1', date: '2026-01-20', attendees: '11', chair: 'Board Chair', summary: 'Approved annual budget, reviewed admissions policy, set strategic priorities.'),
  ];

  final List<BoardReport> reports = [
    BoardReport(title: 'Annual Performance Report 2025', date: '2026-01-10', author: 'Headmaster', category: 'Academic', summary: 'Overall school performance, exam results, and strategic recommendations.'),
    BoardReport(title: 'Financial Audit Report 2025', date: '2026-01-15', author: 'Internal Auditor', category: 'Finance', summary: 'Audit findings, compliance status, and recommendations.'),
    BoardReport(title: 'Facilities Assessment', date: '2025-12-01', author: 'Admin Office', category: 'Operations', summary: 'Condition assessment of all school facilities and maintenance priorities.'),
  ];
}

// ── Welfare Committee Models ──

class WelfareTransaction {
  final String id, date, type, description, amount, balance, recordedBy;
  const WelfareTransaction({required this.id, required this.date, required this.type, required this.description, required this.amount, required this.balance, required this.recordedBy});
}

class WelfareSupport {
  final String id, date, beneficiary, amount, reason, category, status, approvedBy;
  const WelfareSupport({required this.id, required this.date, required this.beneficiary, required this.amount, required this.reason, required this.category, required this.status, required this.approvedBy});
}

class WelfareDisbursement {
  final String id, date, beneficiary, amount, purpose, status, approvedBy, disbursedDate;
  const WelfareDisbursement({required this.id, required this.date, required this.beneficiary, required this.amount, required this.purpose, required this.status, required this.approvedBy, required this.disbursedDate});
}

class WelfareMember {
  final String name, role, contribution, joinDate, status;
  const WelfareMember({required this.name, required this.role, required this.contribution, required this.joinDate, required this.status});
}

class WelfareProvider extends ChangeNotifier {
  final List<WelfareTransaction> ledger = [
    WelfareTransaction(id: 't1', date: '2026-07-01', type: 'Income', description: 'Monthly contributions', amount: '2500', balance: '18500', recordedBy: 'Welfare Secretary'),
    WelfareTransaction(id: 't2', date: '2026-06-15', type: 'Expense', description: 'Support - Medical (Staff)', amount: '800', balance: '16000', recordedBy: 'Welfare Secretary'),
    WelfareTransaction(id: 't3', date: '2026-06-01', type: 'Income', description: 'Monthly contributions', amount: '2500', balance: '16800', recordedBy: 'Welfare Secretary'),
    WelfareTransaction(id: 't4', date: '2026-05-20', type: 'Expense', description: 'Condolence donation', amount: '500', balance: '14300', recordedBy: 'Welfare Secretary'),
  ];

  final List<WelfareSupport> supportRequests = [
    WelfareSupport(id: 's1', date: '2026-07-08', beneficiary: 'Staff Member (Anonymous)', amount: '1200', reason: 'Medical expenses', category: 'Medical', status: 'Pending', approvedBy: ''),
    WelfareSupport(id: 's2', date: '2026-06-15', beneficiary: 'Staff Member (Anonymous)', amount: '800', reason: 'Hospital bills', category: 'Medical', status: 'Approved', approvedBy: 'Committee Chair'),
    WelfareSupport(id: 's3', date: '2026-05-10', beneficiary: 'Staff Member (Anonymous)', amount: '500', reason: 'Bereavement', category: 'Condolence', status: 'Approved', approvedBy: 'Committee Chair'),
  ];

  final List<WelfareDisbursement> disbursements = [
    WelfareDisbursement(id: 'd1', date: '2026-06-16', beneficiary: 'Staff Member (Anonymous)', amount: '800', purpose: 'Medical support', status: 'Disbursed', approvedBy: 'Committee Chair', disbursedDate: '2026-06-16'),
    WelfareDisbursement(id: 'd2', date: '2026-05-11', beneficiary: 'Staff Member (Anonymous)', amount: '500', purpose: 'Condolence donation', status: 'Disbursed', approvedBy: 'Committee Chair', disbursedDate: '2026-05-11'),
  ];

  final List<WelfareMember> members = [
    WelfareMember(name: 'J. Mensah', role: 'Member', contribution: '50/mo', joinDate: '2024-01-15', status: 'Active'),
    WelfareMember(name: 'G. Adjei', role: 'Member', contribution: '50/mo', joinDate: '2024-01-15', status: 'Active'),
    WelfareMember(name: 'F. Boateng', role: 'Secretary', contribution: '50/mo', joinDate: '2024-01-15', status: 'Active'),
    WelfareMember(name: 'A. Tetteh', role: 'Treasurer', contribution: '50/mo', joinDate: '2024-01-15', status: 'Active'),
    WelfareMember(name: 'R. Amponsah', role: 'Chair', contribution: '50/mo', joinDate: '2024-01-15', status: 'Active'),
  ];

  double get totalBalance => 18500;
  int get pendingRequests => supportRequests.where((s) => s.status == 'Pending').length;
}
