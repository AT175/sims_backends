import 'package:flutter/foundation.dart';

// ── Enums ──

enum CounsellorType { academic, psychosocial }
enum CaseStatus { active, monitor, closed, referred }
enum CasePriority { high, medium, low }
enum AppointmentStatus { scheduled, completed, cancelled, noShow }
enum ReferralStatus { pending, ongoing, completed }

// ── Models ──

class Counsellor {
  final String id;
  final String name;
  final CounsellorType type;
  final String title;
  final String phone;
  final String email;
  final String room;
  final String availability;
  const Counsellor({required this.id, required this.name, required this.type, required this.title, required this.phone, required this.email, required this.room, required this.availability});
}

class CounsellingCase {
  final String id;
  final String caseId;
  final String studentName;
  final String studentClass;
  final String category;
  final CounsellorType type;
  final String description;
  final String openedDate;
  final CaseStatus status;
  final CasePriority priority;
  final String assignedCounsellor;
  final String notes;
  final String followUpDate;
  final bool confidential;
  const CounsellingCase({required this.id, required this.caseId, required this.studentName, required this.studentClass, required this.category, required this.type, required this.description, required this.openedDate, required this.status, required this.priority, required this.assignedCounsellor, required this.notes, required this.followUpDate, required this.confidential});

  CounsellingCase copyWith({CaseStatus? status, CasePriority? priority, String? notes, String? followUpDate, String? assignedCounsellor, String? description}) =>
    CounsellingCase(id: id, caseId: caseId, studentName: studentName, studentClass: studentClass, category: category, type: type, description: description ?? this.description, openedDate: openedDate, status: status ?? this.status, priority: priority ?? this.priority, assignedCounsellor: assignedCounsellor ?? this.assignedCounsellor, notes: notes ?? this.notes, followUpDate: followUpDate ?? this.followUpDate, confidential: confidential);
}

class SessionLog {
  final String id;
  final String caseId;
  final String date;
  final String counsellor;
  final CounsellorType type;
  final String summary;
  final String notes;
  final String nextAction;
  final String nextSessionDate;
  const SessionLog({required this.id, required this.caseId, required this.date, required this.counsellor, required this.type, required this.summary, required this.notes, required this.nextAction, required this.nextSessionDate});
}

class CounsellingAppointment {
  final String id;
  final String date;
  final String time;
  final String studentName;
  final String studentClass;
  final CounsellorType type;
  final String counsellor;
  final String reason;
  final AppointmentStatus status;
  final String notes;
  const CounsellingAppointment({required this.id, required this.date, required this.time, required this.studentName, required this.studentClass, required this.type, required this.counsellor, required this.reason, required this.status, required this.notes});

  CounsellingAppointment copyWith({AppointmentStatus? status, String? notes}) =>
    CounsellingAppointment(id: id, date: date, time: time, studentName: studentName, studentClass: studentClass, type: type, counsellor: counsellor, reason: reason, status: status ?? this.status, notes: notes ?? this.notes);
}

class CounsellingReferral {
  final String id;
  final String date;
  final String studentName;
  final String studentClass;
  final String referredTo;
  final String reason;
  final CounsellorType type;
  final ReferralStatus status;
  final String notes;
  const CounsellingReferral({required this.id, required this.date, required this.studentName, required this.studentClass, required this.referredTo, required this.reason, required this.type, required this.status, required this.notes});

  CounsellingReferral copyWith({ReferralStatus? status, String? notes}) =>
    CounsellingReferral(id: id, date: date, studentName: studentName, studentClass: studentClass, referredTo: referredTo, reason: reason, type: type, status: status ?? this.status, notes: notes ?? this.notes);
}

class CareerResource {
  final String id;
  final String title;
  final String category;
  final String description;
  final String updated;
  final String link;
  const CareerResource({required this.id, required this.title, required this.category, required this.description, required this.updated, required this.link});
}

// ── Constants ──

const caseCategoriesAcademic = ['Academic stress', 'Subject choice', 'Career guidance', 'Study skills', 'Exam preparation', 'Underperformance'];
const caseCategoriesPsycho = ['Homesickness', 'Behavioral', 'Peer conflict', 'Anxiety', 'Depression', 'Family issues', 'Self-esteem', 'Trauma'];
const resourceCategories = ['University', 'Scholarship', 'Course Guide', 'Academic', 'Career', 'Vocational'];
const timeSlots = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00'];

String _todayISO() => DateTime.now().toIso8601String().substring(0, 10);

// ── Provider ──

class CounsellingProvider extends ChangeNotifier {
  final List<Counsellor> _counsellors = [
    Counsellor(id: '1', name: 'Mr. Osei', type: CounsellorType.academic, title: 'Academic Guidance Coordinator', phone: '024 100 2000', email: 'osei@sims.edu', room: 'Counselling Room 1', availability: 'Mon-Fri, 08:00 - 16:00'),
    Counsellor(id: '2', name: 'Mrs. Mensah', type: CounsellorType.psychosocial, title: 'Psychosocial Support Coordinator', phone: '024 300 4000', email: 'mensah@sims.edu', room: 'Counselling Room 2', availability: 'Mon-Fri, 08:00 - 16:00'),
  ];
  List<Counsellor> get counsellors => _counsellors;

  final List<CounsellingCase> _cases = [
    CounsellingCase(id: '1', caseId: 'C-045', studentName: 'Student A', studentClass: 'Form 2B', category: 'Academic stress', type: CounsellorType.academic, description: 'Student struggling with multiple subjects, anxiety before exams', openedDate: '2026-07-05', status: CaseStatus.active, priority: CasePriority.high, assignedCounsellor: 'Mr. Osei', notes: 'Initial assessment completed. Student shows signs of exam anxiety.', followUpDate: '2026-07-12', confidential: true),
    CounsellingCase(id: '2', caseId: 'C-044', studentName: 'Student B', studentClass: 'Form 1A', category: 'Homesickness', type: CounsellorType.psychosocial, description: 'Boarding student missing family, affecting sleep and appetite', openedDate: '2026-07-03', status: CaseStatus.active, priority: CasePriority.medium, assignedCounsellor: 'Mrs. Mensah', notes: 'Supportive counselling sessions ongoing. Housemaster informed.', followUpDate: '2026-07-10', confidential: true),
    CounsellingCase(id: '3', caseId: 'C-043', studentName: 'Student C', studentClass: 'Form 3C', category: 'Behavioral', type: CounsellorType.psychosocial, description: 'Disruptive behavior in class, possible underlying issues', openedDate: '2026-06-28', status: CaseStatus.monitor, priority: CasePriority.medium, assignedCounsellor: 'Mrs. Mensah', notes: 'Referred to clinical psychologist for assessment.', followUpDate: '2026-07-15', confidential: true),
    CounsellingCase(id: '4', caseId: 'C-042', studentName: 'Student D', studentClass: 'Form 3A', category: 'Career guidance', type: CounsellorType.academic, description: 'Uncertain about subject selection for WASSCE', openedDate: '2026-06-20', status: CaseStatus.closed, priority: CasePriority.low, assignedCounsellor: 'Mr. Osei', notes: 'Career assessment completed. Student decided on Science track.', followUpDate: '', confidential: false),
    CounsellingCase(id: '5', caseId: 'C-041', studentName: 'Student E', studentClass: 'Form 2A', category: 'Subject choice', type: CounsellorType.academic, description: 'Needs guidance on elective subjects', openedDate: '2026-06-18', status: CaseStatus.active, priority: CasePriority.low, assignedCounsellor: 'Mr. Osei', notes: 'Exploring interest in Business vs Arts.', followUpDate: '2026-07-14', confidential: false),
    CounsellingCase(id: '6', caseId: 'C-040', studentName: 'Student F', studentClass: 'Form 1B', category: 'Peer conflict', type: CounsellorType.psychosocial, description: 'Bullying concerns reported by class teacher', openedDate: '2026-06-15', status: CaseStatus.referred, priority: CasePriority.high, assignedCounsellor: 'Mrs. Mensah', notes: 'Referred to speech therapist. School discipline team involved.', followUpDate: '2026-07-08', confidential: true),
  ];
  List<CounsellingCase> get cases => _cases;

  final List<SessionLog> _sessions = [
    SessionLog(id: '1', caseId: '1', date: '2026-07-05', counsellor: 'Mr. Osei', type: CounsellorType.academic, summary: 'Initial assessment', notes: 'Student expressed anxiety about upcoming exams. Discussed study strategies and relaxation techniques.', nextAction: 'Follow-up session to review study plan', nextSessionDate: '2026-07-12'),
    SessionLog(id: '2', caseId: '2', date: '2026-07-03', counsellor: 'Mrs. Mensah', type: CounsellorType.psychosocial, summary: 'Initial counselling session', notes: 'Student shared feelings of loneliness. Explored coping mechanisms and social activities.', nextAction: 'Encourage participation in house activities', nextSessionDate: '2026-07-10'),
    SessionLog(id: '3', caseId: '2', date: '2026-07-08', counsellor: 'Mrs. Mensah', type: CounsellorType.psychosocial, summary: 'Follow-up session', notes: 'Student reports slightly better sleep. Joined the reading club.', nextAction: 'Continue monitoring, involve housemaster', nextSessionDate: '2026-07-15'),
    SessionLog(id: '4', caseId: '4', date: '2026-06-20', counsellor: 'Mr. Osei', type: CounsellorType.academic, summary: 'Career assessment', notes: 'Administered interest inventory. Student leans toward Science.', nextAction: 'None — case closed', nextSessionDate: ''),
  ];
  List<SessionLog> get sessions => _sessions;

  final List<CounsellingAppointment> _appointments = [
    CounsellingAppointment(id: '1', date: '2026-07-19', time: '10:00', studentName: 'Student A', studentClass: 'Form 2B', type: CounsellorType.academic, counsellor: 'Mr. Osei', reason: 'Follow-up on exam anxiety', status: AppointmentStatus.scheduled, notes: ''),
    CounsellingAppointment(id: '2', date: '2026-07-19', time: '11:00', studentName: 'Student E', studentClass: 'Form 2A', type: CounsellorType.academic, counsellor: 'Mr. Osei', reason: 'Subject choice discussion', status: AppointmentStatus.scheduled, notes: ''),
    CounsellingAppointment(id: '3', date: '2026-07-19', time: '14:00', studentName: 'Student B', studentClass: 'Form 1A', type: CounsellorType.psychosocial, counsellor: 'Mrs. Mensah', reason: 'Homesickness follow-up', status: AppointmentStatus.scheduled, notes: ''),
    CounsellingAppointment(id: '4', date: '2026-07-07', time: '14:00', studentName: 'Student B', studentClass: 'Form 1A', type: CounsellorType.psychosocial, counsellor: 'Mrs. Mensah', reason: 'Counselling session', status: AppointmentStatus.completed, notes: 'Went well, student more settled'),
  ];
  List<CounsellingAppointment> get appointments => _appointments;

  final List<CounsellingReferral> _referrals = [
    CounsellingReferral(id: '1', date: '2026-07-02', studentName: 'Student C', studentClass: 'Form 3C', referredTo: 'Clinical Psychologist', reason: 'Behavioral assessment', type: CounsellorType.psychosocial, status: ReferralStatus.ongoing, notes: 'Assessment in progress, awaiting report'),
    CounsellingReferral(id: '2', date: '2026-06-15', studentName: 'Student F', studentClass: 'Form 1B', referredTo: 'Speech Therapist', reason: 'Speech evaluation', type: CounsellorType.psychosocial, status: ReferralStatus.completed, notes: 'Evaluation complete, no issues found'),
  ];
  List<CounsellingReferral> get referrals => _referrals;

  final List<CareerResource> _resources = [
    CareerResource(id: '1', title: 'KNUST Admission Requirements 2026/27', category: 'University', description: 'Comprehensive guide to KNUST admission requirements for all programmes', updated: 'Jun 2026', link: 'https://knust.edu.gh/admissions'),
    CareerResource(id: '2', title: 'Scholarship Opportunities - Ghana', category: 'Scholarship', description: 'List of available scholarships for Ghanaian students', updated: 'Jun 2026', link: 'https://scholarships.gov.gh'),
    CareerResource(id: '3', title: 'Engineering Programmes Guide', category: 'Course Guide', description: 'Overview of engineering programmes across Ghanaian universities', updated: 'May 2026', link: ''),
    CareerResource(id: '4', title: 'Nursing Schools Directory', category: 'Course Guide', description: 'Directory of accredited nursing schools in Ghana', updated: 'May 2026', link: ''),
    CareerResource(id: '5', title: 'WASSCE Subject Selection Guide', category: 'Academic', description: 'Guide to help students choose appropriate elective subjects', updated: 'Jun 2026', link: ''),
  ];
  List<CareerResource> get resources => _resources;

  int _idCounter = 200;
  String _nextId() => (++_idCounter).toString();

  // ── Computed getters ──
  List<CounsellingCase> getActiveCases() => _cases.where((c) => c.status == CaseStatus.active || c.status == CaseStatus.monitor).toList();
  List<CounsellingCase> getFollowUpsDue() {
    final today = _todayISO();
    return _cases.where((c) => c.followUpDate.isNotEmpty && c.followUpDate.compareTo(today) <= 0 && (c.status == CaseStatus.active || c.status == CaseStatus.monitor)).toList();
  }
  List<CounsellingAppointment> getTodayAppointments() {
    final today = _todayISO();
    return _appointments.where((a) => a.date == today && a.status == AppointmentStatus.scheduled).toList();
  }
  List<CounsellingAppointment> getUpcomingAppointments() {
    final today = _todayISO();
    return _appointments.where((a) => a.date.compareTo(today) >= 0 && a.status == AppointmentStatus.scheduled).toList()..sort((a, b) => a.date.compareTo(b.date));
  }
  CounsellingCase? getCaseById(String id) => _cases.where((c) => c.id == id).firstOrNull;
  List<SessionLog> getSessionsByCase(String caseId) => _sessions.where((s) => s.caseId == caseId).toList()..sort((a, b) => b.date.compareTo(a.date));
  List<CounsellingCase> getCasesByType(CounsellorType type) => _cases.where((c) => c.type == type).toList();
  List<CounsellingCase> getCasesByCounsellor(String name) => _cases.where((c) => c.assignedCounsellor == name).toList();
  List<CounsellingAppointment> getAppointmentsByType(CounsellorType type) => _appointments.where((a) => a.type == type).toList();

  // ── Case CRUD ──
  void addCase({required String studentName, required String studentClass, required String category, required CounsellorType type, required String description, required CasePriority priority, required String assignedCounsellor, required String notes, required String followUpDate, required bool confidential}) {
    final caseNum = _cases.length + 46;
    _cases.insert(0, CounsellingCase(
      id: _nextId(), caseId: 'C-${caseNum.toString().padLeft(3, '0')}',
      studentName: studentName, studentClass: studentClass, category: category, type: type,
      description: description, openedDate: _todayISO(), status: CaseStatus.active, priority: priority,
      assignedCounsellor: assignedCounsellor, notes: notes, followUpDate: followUpDate, confidential: confidential,
    ));
    notifyListeners();
  }

  void updateCaseStatus(String id, CaseStatus status) {
    final idx = _cases.indexWhere((c) => c.id == id);
    if (idx >= 0) { _cases[idx] = _cases[idx].copyWith(status: status); notifyListeners(); }
  }

  void updateCase(String id, {String? notes, String? followUpDate, String? assignedCounsellor, String? description}) {
    final idx = _cases.indexWhere((c) => c.id == id);
    if (idx >= 0) { _cases[idx] = _cases[idx].copyWith(notes: notes, followUpDate: followUpDate, assignedCounsellor: assignedCounsellor, description: description); notifyListeners(); }
  }

  void deleteCase(String id) {
    _cases.removeWhere((c) => c.id == id);
    _sessions.removeWhere((s) => s.caseId == id);
    notifyListeners();
  }

  // ── Session CRUD ──
  void addSession({required String caseId, required String counsellor, required CounsellorType type, required String summary, required String notes, required String nextAction, required String nextSessionDate}) {
    _sessions.insert(0, SessionLog(
      id: _nextId(), caseId: caseId, date: _todayISO(), counsellor: counsellor, type: type,
      summary: summary, notes: notes, nextAction: nextAction, nextSessionDate: nextSessionDate,
    ));
    if (nextSessionDate.isNotEmpty) {
      updateCase(caseId, followUpDate: nextSessionDate);
    }
    notifyListeners();
  }

  void deleteSession(String id) {
    _sessions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ── Appointment CRUD ──
  void addAppointment({required String date, required String time, required String studentName, required String studentClass, required CounsellorType type, required String counsellor, required String reason, String notes = ''}) {
    _appointments.insert(0, CounsellingAppointment(
      id: _nextId(), date: date, time: time, studentName: studentName, studentClass: studentClass,
      type: type, counsellor: counsellor, reason: reason, status: AppointmentStatus.scheduled, notes: notes,
    ));
    notifyListeners();
  }

  void updateAppointmentStatus(String id, AppointmentStatus status) {
    final idx = _appointments.indexWhere((a) => a.id == id);
    if (idx >= 0) { _appointments[idx] = _appointments[idx].copyWith(status: status); notifyListeners(); }
  }

  void deleteAppointment(String id) {
    _appointments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // ── Referral CRUD ──
  void addReferral({required String studentName, required String studentClass, required String referredTo, required String reason, required CounsellorType type, String notes = ''}) {
    _referrals.insert(0, CounsellingReferral(
      id: _nextId(), date: _todayISO(), studentName: studentName, studentClass: studentClass,
      referredTo: referredTo, reason: reason, type: type, status: ReferralStatus.pending, notes: notes,
    ));
    notifyListeners();
  }

  void updateReferralStatus(String id, ReferralStatus status) {
    final idx = _referrals.indexWhere((r) => r.id == id);
    if (idx >= 0) { _referrals[idx] = _referrals[idx].copyWith(status: status); notifyListeners(); }
  }

  void deleteReferral(String id) {
    _referrals.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  // ── Resource CRUD ──
  void addResource({required String title, required String category, required String description, String link = ''}) {
    final now = DateTime.now();
    final updated = '${_monthAbbr(now.month)} ${now.year}';
    _resources.insert(0, CareerResource(id: _nextId(), title: title, category: category, description: description, updated: updated, link: link));
    notifyListeners();
  }

  void deleteResource(String id) {
    _resources.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  String _monthAbbr(int m) => ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}
