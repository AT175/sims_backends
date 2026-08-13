import 'package:flutter/foundation.dart';

// ── Academic Board ──
class BoardMeeting {
  final String id, title, date, attendees, agenda, status, minutes;
  const BoardMeeting({required this.id, required this.title, required this.date, required this.attendees, required this.agenda, required this.status, required this.minutes});
}

class AcademicPolicy {
  final String id, title, category, status, description;
  final String? dateApproved;
  const AcademicPolicy({required this.id, required this.title, required this.category, required this.status, this.dateApproved, required this.description});
}

class DepartmentReport {
  final String id, department, head, reportDate, summary, performanceRating;
  const DepartmentReport({required this.id, required this.department, required this.head, required this.reportDate, required this.summary, required this.performanceRating});
}

// ── Dining Hall ──
class MealAttendance {
  final String id, date, meal, absentees;
  final int expected, present;
  const MealAttendance({required this.id, required this.date, required this.meal, required this.expected, required this.present, required this.absentees});
}

class HygieneInspection {
  final String id, date, area, rating, inspector, notes;
  const HygieneInspection({required this.id, required this.date, required this.area, required this.rating, required this.inspector, required this.notes});
}

class StudentFeedback {
  final String id, date, studentName, meal, comment;
  final int rating;
  const StudentFeedback({required this.id, required this.date, required this.studentName, required this.meal, required this.rating, required this.comment});
}

class SeatingPlan {
  final String id, table, house, form, students;
  final int capacity;
  const SeatingPlan({required this.id, required this.table, required this.house, required this.form, required this.capacity, required this.students});
}

class MenuItem {
  final String id, date, meal, mainDish, side, drink, status;
  const MenuItem({required this.id, required this.date, required this.meal, required this.mainDish, required this.side, required this.drink, required this.status});
}

class SupplyItem {
  final String id, item, category, unit, status;
  final int quantity, minStock;
  const SupplyItem({required this.id, required this.item, required this.category, required this.quantity, required this.unit, required this.minStock, required this.status});
}

// ── Exam Committee ──
class ExamSchedule {
  final String id, examName, subject, date, time, duration, venue, status;
  const ExamSchedule({required this.id, required this.examName, required this.subject, required this.date, required this.time, required this.duration, required this.venue, required this.status});
}

class QuestionPaper {
  final String id, subject, examiner, status, dateSubmitted, notes;
  const QuestionPaper({required this.id, required this.subject, required this.examiner, required this.status, required this.dateSubmitted, required this.notes});
}

class InvigilationDuty {
  final String id, examName, date, time, venue, invigilator;
  const InvigilationDuty({required this.id, required this.examName, required this.date, required this.time, required this.venue, required this.invigilator});
}

class MalpracticeCase {
  final String id, studentName, studentClass, exam, type, date, description, action;
  const MalpracticeCase({required this.id, required this.studentName, required this.studentClass, required this.exam, required this.type, required this.date, required this.description, required this.action});
}

class ExamResult {
  final String id, examName, subject, remarks;
  final int completed, passed, failed;
  final double averageScore;
  const ExamResult({required this.id, required this.examName, required this.subject, required this.completed, required this.passed, required this.failed, required this.averageScore, required this.remarks});
}

// ── Safe Space ──
class SafetyIncident {
  final String id, date, location, severity, status, description, reportedBy, action;
  const SafetyIncident({required this.id, required this.date, required this.location, required this.severity, required this.status, required this.description, required this.reportedBy, required this.action});
}

class SafetyInspection {
  final String id, date, area, finding, riskLevel, recommendation;
  final bool resolved;
  const SafetyInspection({required this.id, required this.date, required this.area, required this.finding, required this.riskLevel, required this.recommendation, required this.resolved});
}

class RelationshipCase {
  final String id, date, parties, issue, status, mediator, notes;
  const RelationshipCase({required this.id, required this.date, required this.parties, required this.issue, required this.status, required this.mediator, required this.notes});
}

class TrainingRecord {
  final String id, title, date, trainer, type;
  final int participants;
  const TrainingRecord({required this.id, required this.title, required this.date, required this.trainer, required this.participants, required this.type});
}

// ── Internal Auditor ──
class AuditSchedule {
  final String id, title, type, startDate, endDate, auditor, status;
  const AuditSchedule({required this.id, required this.title, required this.type, required this.startDate, required this.endDate, required this.auditor, required this.status});
}

class AuditFinding {
  final String id, auditTitle, severity, finding, recommendation, status, date;
  const AuditFinding({required this.id, required this.auditTitle, required this.severity, required this.finding, required this.recommendation, required this.status, required this.date});
}

// ── Headmaster Secretary ──
class Appointment {
  final String id, date, time, visitorName, purpose, status, notes;
  const Appointment({required this.id, required this.date, required this.time, required this.visitorName, required this.purpose, required this.status, required this.notes});
}

class CorrespondenceItem {
  final String id, date, type, from, to, subject, status;
  const CorrespondenceItem({required this.id, required this.date, required this.type, required this.from, required this.to, required this.subject, required this.status});
}

class VisitorLog {
  final String id, date, timeIn, timeOut, visitorName, purpose, contact;
  const VisitorLog({required this.id, required this.date, required this.timeIn, required this.timeOut, required this.visitorName, required this.purpose, required this.contact});
}

class SecretaryTask {
  final String id, title, priority, status, dueDate, assignedBy, notes;
  const SecretaryTask({required this.id, required this.title, required this.priority, required this.status, required this.dueDate, required this.assignedBy, required this.notes});
}

class DynamicDashboardProvider extends ChangeNotifier {
  // Academic Board
  List<BoardMeeting> meetings = [
    BoardMeeting(id: '1', title: 'Term Planning Meeting', date: '2026-09-01', attendees: '12', agenda: 'Term academic plan, exam schedule', status: 'Scheduled', minutes: ''),
    BoardMeeting(id: '2', title: 'Mid-Term Review', date: '2026-10-15', attendees: '14', agenda: 'Review progress, address gaps', status: 'Scheduled', minutes: ''),
    BoardMeeting(id: '3', title: 'Curriculum Review', date: '2026-06-20', attendees: '10', agenda: 'Curriculum updates for new term', status: 'Completed', minutes: 'Approved new curriculum framework'),
  ];

  List<AcademicPolicy> policies = [
    AcademicPolicy(id: '1', title: 'Continuous Assessment Policy', category: 'Assessment', status: 'Active', dateApproved: '2026-01-15', description: '40% CA + 60% End of term'),
    AcademicPolicy(id: '2', title: 'Homework Submission Policy', category: 'Academic', status: 'Active', dateApproved: '2026-01-20', description: 'Strict deadlines, late penalty 10%'),
    AcademicPolicy(id: '3', title: 'Remedial Classes Policy', category: 'Support', status: 'Draft', description: 'Free remedial for struggling students'),
  ];

  List<DepartmentReport> deptReports = [
    DepartmentReport(id: '1', department: 'Science', head: 'Mr. Osei', reportDate: '2026-07-10', summary: 'Strong performance in practicals', performanceRating: 'Excellent'),
    DepartmentReport(id: '2', department: 'Mathematics', head: 'Mrs. Adjei', reportDate: '2026-07-10', summary: 'Improvement in core topics', performanceRating: 'Good'),
    DepartmentReport(id: '3', department: 'Languages', head: 'Mr. Boateng', reportDate: '2026-07-10', summary: 'Need more oral practice sessions', performanceRating: 'Average'),
  ];

  // Dining Hall
  final List<MealAttendance> mealAttendance = [
    MealAttendance(id: '1', date: '2026-07-13', meal: 'Breakfast', expected: 850, present: 820, absentees: '30 (sick/excused)'),
    MealAttendance(id: '2', date: '2026-07-13', meal: 'Lunch', expected: 850, present: 845, absentees: '5'),
    MealAttendance(id: '3', date: '2026-07-12', meal: 'Dinner', expected: 850, present: 830, absentees: '20'),
  ];

  final List<HygieneInspection> hygieneInspections = [
    HygieneInspection(id: '1', date: '2026-07-10', area: 'Main Dining Hall', rating: 'Good', inspector: 'Dining Hall Master', notes: 'Floors clean, tables sanitized'),
    HygieneInspection(id: '2', date: '2026-07-10', area: 'Kitchen', rating: 'Excellent', inspector: 'Health Officer', notes: 'Food storage compliant'),
    HygieneInspection(id: '3', date: '2026-07-08', area: 'Store Room', rating: 'Fair', inspector: 'Dining Hall Master', notes: 'Needs better organization'),
  ];

  final List<StudentFeedback> studentFeedback = [
    StudentFeedback(id: '1', date: '2026-07-12', studentName: 'Kwesi M.', meal: 'Lunch', rating: 4, comment: 'Rice and stew was good'),
    StudentFeedback(id: '2', date: '2026-07-11', studentName: 'Ama S.', meal: 'Breakfast', rating: 3, comment: 'Tea was cold'),
    StudentFeedback(id: '3', date: '2026-07-10', studentName: 'Yaw B.', meal: 'Dinner', rating: 5, comment: 'Best meal this week!'),
  ];

  final List<SeatingPlan> seatingPlans = [
    SeatingPlan(id: '1', table: 'Table A1', house: 'Kings House', form: 'Form 1', capacity: 10, students: '8 assigned'),
    SeatingPlan(id: '2', table: 'Table A2', house: 'Kings House', form: 'Form 1', capacity: 10, students: '10 assigned'),
    SeatingPlan(id: '3', table: 'Table B1', house: 'Queens House', form: 'Form 2', capacity: 10, students: '7 assigned'),
  ];

  final List<MenuItem> menuItems = [
    MenuItem(id: '1', date: '2026-07-14', meal: 'Breakfast', mainDish: 'Bread & Eggs', side: 'Porridge', drink: 'Tea', status: 'Approved'),
    MenuItem(id: '2', date: '2026-07-14', meal: 'Lunch', mainDish: 'Jollof Rice', side: 'Salad', drink: 'Water', status: 'Approved'),
    MenuItem(id: '3', date: '2026-07-14', meal: 'Dinner', mainDish: 'Banku & Tilapia', side: 'Pepper', drink: 'Water', status: 'Draft'),
  ];

  final List<SupplyItem> supplies = [
    SupplyItem(id: '1', item: 'Rice', category: 'Food', quantity: 120, unit: 'kg', minStock: 50, status: 'In Stock'),
    SupplyItem(id: '2', item: 'Cooking Oil', category: 'Food', quantity: 20, unit: 'litres', minStock: 30, status: 'Low Stock'),
    SupplyItem(id: '3', item: 'Plastic Plates', category: 'Cutlery', quantity: 0, unit: 'pieces', minStock: 100, status: 'Out of Stock'),
  ];

  // Exam Committee
  final List<ExamSchedule> exams = [
    ExamSchedule(id: '1', examName: 'End of Term 2 Exams', subject: 'Mathematics', date: '2026-09-20', time: '08:00', duration: '2h 30m', venue: 'Assembly Hall', status: 'Scheduled'),
    ExamSchedule(id: '2', examName: 'End of Term 2 Exams', subject: 'English', date: '2026-09-22', time: '08:00', duration: '2h 30m', venue: 'Assembly Hall', status: 'Scheduled'),
    ExamSchedule(id: '3', examName: 'Mid-Term Assessment', subject: 'Science', date: '2026-08-15', time: '10:00', duration: '1h 30m', venue: 'Classrooms', status: 'Completed'),
  ];

  final List<QuestionPaper> questionPapers = [
    QuestionPaper(id: '1', subject: 'Mathematics', examiner: 'Mrs. Adjei', status: 'Approved', dateSubmitted: '2026-09-01', notes: 'Core + elective sections'),
    QuestionPaper(id: '2', subject: 'English', examiner: 'Mr. Boateng', status: 'Reviewed', dateSubmitted: '2026-09-03', notes: 'Essay + comprehension'),
    QuestionPaper(id: '3', subject: 'Science', examiner: 'Mr. Osei', status: 'Drafted', dateSubmitted: '2026-09-05', notes: 'Practical + theory'),
  ];

  final List<InvigilationDuty> invigilation = [
    InvigilationDuty(id: '1', examName: 'End of Term 2', date: '2026-09-20', time: '08:00', venue: 'Hall A', invigilator: 'Mr. Osei'),
    InvigilationDuty(id: '2', examName: 'End of Term 2', date: '2026-09-20', time: '08:00', venue: 'Hall B', invigilator: 'Mrs. Adjei'),
    InvigilationDuty(id: '3', examName: 'End of Term 2', date: '2026-09-22', time: '08:00', venue: 'Hall A', invigilator: 'Mr. Boateng'),
  ];

  final List<MalpracticeCase> malpractice = [
    MalpracticeCase(id: '1', studentName: 'Kofi A.', studentClass: 'Form 3B', exam: 'Mid-Term Science', type: 'Cheating', date: '2026-08-15', description: 'Found with notes in pocket', action: 'Paper cancelled, warning issued'),
  ];

  final List<ExamResult> examResults = [
    ExamResult(id: '1', examName: 'Mid-Term Assessment', subject: 'Science', completed: 120, passed: 95, failed: 25, averageScore: 68, remarks: 'Practical scores need improvement'),
    ExamResult(id: '2', examName: 'Mid-Term Assessment', subject: 'Mathematics', completed: 118, passed: 88, failed: 30, averageScore: 64, remarks: 'Extra revision recommended'),
  ];

  // Safe Space
  final List<SafetyIncident> incidents = [
    SafetyIncident(id: '1', date: '2026-07-12', location: 'Dormitory B', severity: 'Medium', status: 'Investigating', description: 'Student altercation', reportedBy: 'Housemaster', action: 'Mediation scheduled'),
    SafetyIncident(id: '2', date: '2026-07-10', location: 'Science Lab', severity: 'Low', status: 'Resolved', description: 'Broken equipment', reportedBy: 'Lab Assistant', action: 'Replaced, safety briefing done'),
    SafetyIncident(id: '3', date: '2026-07-08', location: 'Playground', severity: 'High', status: 'Resolved', description: 'Student injury during sports', reportedBy: 'Sports Master', action: 'First aid, parent notified'),
  ];

  final List<SafetyInspection> safetyInspections = [
    SafetyInspection(id: '1', date: '2026-07-10', area: 'Dormitories', finding: 'Fire extinguisher expired', riskLevel: 'Major Risk', recommendation: 'Replace immediately', resolved: false),
    SafetyInspection(id: '2', date: '2026-07-10', area: 'Kitchen', finding: 'Clean and compliant', riskLevel: 'Safe', recommendation: 'Maintain standards', resolved: true),
    SafetyInspection(id: '3', date: '2026-07-05', area: 'Classrooms', finding: 'Loose window pane', riskLevel: 'Minor Risk', recommendation: 'Repair window', resolved: true),
  ];

  final List<RelationshipCase> relationshipCases = [
    RelationshipCase(id: '1', date: '2026-07-11', parties: 'Student A vs Student B', issue: 'Bullying allegation', status: 'Mediated', mediator: 'Counsellor', notes: 'Both students counseled'),
    RelationshipCase(id: '2', date: '2026-07-09', parties: 'Student C vs Teacher', issue: 'Disrespect complaint', status: 'Open', mediator: 'Safe Space Officer', notes: 'Investigation ongoing'),
  ];

  final List<TrainingRecord> trainingRecords = [
    TrainingRecord(id: '1', title: 'Fire Evacuation Drill', date: '2026-07-05', trainer: 'Fire Safety Officer', participants: 850, type: 'Fire Drill'),
    TrainingRecord(id: '2', title: 'Basic First Aid Training', date: '2026-06-20', trainer: 'School Nurse', participants: 45, type: 'First Aid'),
    TrainingRecord(id: '3', title: 'Emergency Response Briefing', date: '2026-06-15', trainer: 'Safe Space Officer', participants: 120, type: 'Emergency Response'),
  ];

  // Internal Auditor
  final List<AuditSchedule> audits = [
    AuditSchedule(id: '1', title: 'Q2 Financial Audit', type: 'Financial', startDate: '2026-07-01', endDate: '2026-07-15', auditor: 'Internal Auditor', status: 'In Progress'),
    AuditSchedule(id: '2', title: 'Procurement Compliance', type: 'Compliance', startDate: '2026-08-01', endDate: '2026-08-10', auditor: 'Internal Auditor', status: 'Planned'),
    AuditSchedule(id: '3', title: 'IT Systems Audit', type: 'IT', startDate: '2026-06-01', endDate: '2026-06-15', auditor: 'Internal Auditor', status: 'Completed'),
  ];

  final List<AuditFinding> auditFindings = [
    AuditFinding(id: '1', auditTitle: 'Q2 Financial Audit', severity: 'Medium', finding: 'Missing receipts for 3 transactions', recommendation: 'Obtain receipts, update filing', status: 'Open', date: '2026-07-05'),
    AuditFinding(id: '2', auditTitle: 'IT Systems Audit', severity: 'High', finding: 'User access not reviewed quarterly', recommendation: 'Implement quarterly access review', status: 'Addressed', date: '2026-06-15'),
    AuditFinding(id: '3', auditTitle: 'Q1 Financial Audit', severity: 'Low', finding: 'Minor rounding discrepancies', recommendation: 'Use automated calculations', status: 'Closed', date: '2026-04-20'),
  ];

  // Headmaster Secretary
  final List<Appointment> appointments = [
    Appointment(id: '1', date: '2026-07-14', time: '10:00', visitorName: 'PTA Chairman', purpose: 'Discuss term calendar', status: 'Confirmed', notes: ''),
    Appointment(id: '2', date: '2026-07-15', time: '14:00', visitorName: 'District Director', purpose: 'Official visit', status: 'Pending', notes: 'Awaiting confirmation'),
    Appointment(id: '3', date: '2026-07-10', time: '09:00', visitorName: 'Auditor', purpose: 'Audit review meeting', status: 'Completed', notes: 'Minutes filed'),
  ];

  final List<CorrespondenceItem> correspondence = [
    CorrespondenceItem(id: '1', date: '2026-07-13', type: 'Incoming', from: 'Ghana Education Service', to: 'Headmaster', subject: 'Term calendar approval', status: 'Forwarded'),
    CorrespondenceItem(id: '2', date: '2026-07-12', type: 'Outgoing', from: 'Headmaster', to: 'All Staff', subject: 'Staff meeting notice', status: 'Filed'),
    CorrespondenceItem(id: '3', date: '2026-07-10', type: 'Incoming', from: 'PTA Exec', to: 'Headmaster', subject: 'Budget proposal', status: 'Pending'),
  ];

  final List<VisitorLog> visitors = [
    VisitorLog(id: '1', date: '2026-07-13', timeIn: '10:00', timeOut: '11:30', visitorName: 'Mr. Addo', purpose: 'Parent visit', contact: '024XXXXXXX'),
    VisitorLog(id: '2', date: '2026-07-12', timeIn: '13:00', timeOut: '14:00', visitorName: 'Mrs. Owusu', purpose: 'Fee inquiry', contact: '020XXXXXXX'),
  ];

  final List<SecretaryTask> secretaryTasks = [
    SecretaryTask(id: '1', title: 'Prepare term report draft', priority: 'High', status: 'In Progress', dueDate: '2026-07-20', assignedBy: 'Headmaster', notes: ''),
    SecretaryTask(id: '2', title: 'File incoming correspondence', priority: 'Medium', status: 'Pending', dueDate: '2026-07-15', assignedBy: 'Headmaster', notes: '3 letters pending'),
    SecretaryTask(id: '3', title: 'Schedule staff meeting', priority: 'Low', status: 'Completed', dueDate: '2026-07-10', assignedBy: 'Headmaster', notes: 'Scheduled for Friday'),
  ];

  // ── Mutation methods: Academic Board ──
  int _meetingIdCounter = 100;
  int _policyIdCounter = 100;
  int _deptReportIdCounter = 100;

  void addMeeting({required String title, required String date, required String attendees, required String agenda, required String status, String minutes = ''}) {
    meetings.insert(0, BoardMeeting(
      id: (++_meetingIdCounter).toString(),
      title: title, date: date, attendees: attendees,
      agenda: agenda, status: status, minutes: minutes,
    ));
    notifyListeners();
  }

  void deleteMeeting(String id) {
    meetings.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  void addPolicy({required String title, required String category, required String status, String? dateApproved, required String description}) {
    policies.insert(0, AcademicPolicy(
      id: (++_policyIdCounter).toString(),
      title: title, category: category, status: status,
      dateApproved: dateApproved, description: description,
    ));
    notifyListeners();
  }

  void deletePolicy(String id) {
    policies.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void addDeptReport({required String department, required String head, required String reportDate, required String summary, required String performanceRating}) {
    deptReports.insert(0, DepartmentReport(
      id: (++_deptReportIdCounter).toString(),
      department: department, head: head, reportDate: reportDate,
      summary: summary, performanceRating: performanceRating,
    ));
    notifyListeners();
  }

  void deleteDeptReport(String id) {
    deptReports.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  // Computed
  int get scheduledExams => exams.where((e) => e.status == 'Scheduled').length;
  int get openIncidents => incidents.where((i) => i.status != 'Resolved').length;
  int get openFindings => auditFindings.where((f) => f.status == 'Open').length;
  int get pendingAppointments => appointments.where((a) => a.status == 'Pending').length;
  int get pendingTasks => secretaryTasks.where((t) => t.status != 'Completed').length;
}
