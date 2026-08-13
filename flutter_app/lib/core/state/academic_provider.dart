import 'package:flutter/foundation.dart';
import 'app_models.dart';

/// Academic store — exams, timetables, HOD approvals, report cards, curriculum, SPIPs.
class AcademicProvider extends ChangeNotifier {
  int _examIdCounter = 100;
  int _timetableIdCounter = 100;
  int _reportCardIdCounter = 100;
  int _transcriptIdCounter = 100;
  int _curriculumIdCounter = 100;
  int _calendarIdCounter = 100;
  int _spipIdCounter = 100;
  int _spipGoalIdCounter = 100;
  int _spipActionIdCounter = 100;
  int _spipMilestoneIdCounter = 100;

  List<Exam> _exams = [
    Exam(id: 'e1', title: 'Mid-Sem 1 Elective Math', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', date: '2025-07-15', startTime: '08:00', endTime: '10:00', venue: 'Hall A', maxScore: 50, status: ExamStatus.scheduled, resultsStatus: ResultsEntryStatus.notStarted, invigilator: 'Mr. Mensah', term: 'Term 3'),
    Exam(id: 'e2', title: 'Mid-Sem 1 Chemistry', subject: 'Chemistry', classForm: 'SHS2 Sci A', date: '2025-07-16', startTime: '08:00', endTime: '10:00', venue: 'Hall A', maxScore: 50, status: ExamStatus.scheduled, resultsStatus: ResultsEntryStatus.notStarted, invigilator: 'Mr. Adjei', term: 'Term 3'),
    Exam(id: 'e3', title: 'Mid-Sem 1 English', subject: 'English Language', classForm: 'SHS2 Sci A', date: '2025-07-17', startTime: '10:00', endTime: '12:00', venue: 'Hall B', maxScore: 50, status: ExamStatus.scheduled, resultsStatus: ResultsEntryStatus.notStarted, invigilator: 'Mrs. Boateng', term: 'Term 3'),
    Exam(id: 'e4', title: 'Mid-Sem 1 Core Math', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', date: '2025-07-18', startTime: '08:00', endTime: '10:00', venue: 'Hall A', maxScore: 50, status: ExamStatus.scheduled, resultsStatus: ResultsEntryStatus.notStarted, invigilator: 'Mr. Mensah', term: 'Term 3'),
  ];

  List<TimetableEntry> _timetables = [
    TimetableEntry(id: 't1', classForm: 'SHS1 Sci A', day: 'Monday', period: 1, startTime: '07:30', endTime: '08:20', subject: 'Core Mathematics', teacher: 'Mr. Mensah', room: 'A1', status: TimetableStatus.published),
    TimetableEntry(id: 't2', classForm: 'SHS1 Sci A', day: 'Monday', period: 2, startTime: '08:20', endTime: '09:10', subject: 'English Language', teacher: 'Mrs. Boateng', room: 'A1', status: TimetableStatus.published),
    TimetableEntry(id: 't3', classForm: 'SHS1 Sci A', day: 'Monday', period: 3, startTime: '09:10', endTime: '10:00', subject: 'Chemistry', teacher: 'Mr. Adjei', room: 'Lab 1', status: TimetableStatus.published),
    TimetableEntry(id: 't4', classForm: 'SHS2 Sci A', day: 'Monday', period: 1, startTime: '07:30', endTime: '08:20', subject: 'Elective Mathematics', teacher: 'Mr. Mensah', room: 'B1', status: TimetableStatus.published),
    TimetableEntry(id: 't5', classForm: 'SHS3 Sci A', day: 'Monday', period: 1, startTime: '07:30', endTime: '08:20', subject: 'Physics', teacher: 'Mr. Adjei', room: 'C1', status: TimetableStatus.draft),
  ];

  List<HodApproval> _hodApprovals = [
    HodApproval(id: 'h1', type: 'Teacher Assignment', from: 'Mr. Adjei', department: 'Science', detail: 'Assign Mr. Owusu to SHS1 Physics', date: '2025-07-08', status: HodApprovalStatus.pending),
    HodApproval(id: 'h2', type: 'Syllabus Coverage Report', from: 'Mrs. Boateng', department: 'Languages', detail: 'Term 2 coverage: 80%', date: '2025-07-05', status: HodApprovalStatus.pending),
    HodApproval(id: 'h3', type: 'Exam Paper Moderation', from: 'Mr. Mensah', department: 'Mathematics', detail: 'Core Math mid-sem paper for moderation', date: '2025-07-10', status: HodApprovalStatus.pending),
    HodApproval(id: 'h4', type: 'Curriculum Change', from: 'Mr. Adjei', department: 'Science', detail: 'Add practical component to SHS2 Chemistry', date: '2025-06-28', status: HodApprovalStatus.approved),
  ];

  List<ReportCard> _reportCards = [
    ReportCard(id: 'r1', classForm: 'SHS1 Sci A', studentName: 'Kwame Asante', admNo: '2026/001', term: 'Term 2', academicYear: '2024/2025', average: 70, classPosition: '5th', conduct: 'Very Good', attendance: '95%', remarks: 'Keep it up', status: ReportCardStatus.released),
    ReportCard(id: 'r2', classForm: 'SHS3 Sci A', studentName: 'Ama Serwaa', admNo: 'SHS3001', term: 'Term 2', academicYear: '2024/2025', average: 75, classPosition: '3rd', conduct: 'Excellent', attendance: '98%', remarks: 'Outstanding student', status: ReportCardStatus.underReview),
  ];

  List<CurriculumSubject> _curriculum = [
    CurriculumSubject(id: 'c1', subject: 'Core Mathematics', department: 'Mathematics', hod: 'Mr. Mensah', classForm: 'SHS1 Sci A', syllabusTopics: 42, topicsCovered: 30, coveragePct: 71.4, status: CurriculumStatus.inProgress, lastUpdated: '2025-07-10'),
    CurriculumSubject(id: 'c2', subject: 'Chemistry', department: 'Science', hod: 'Mr. Adjei', classForm: 'SHS2 Sci A', syllabusTopics: 38, topicsCovered: 32, coveragePct: 84.2, status: CurriculumStatus.inProgress, lastUpdated: '2025-07-08'),
    CurriculumSubject(id: 'c3', subject: 'English Language', department: 'Languages', hod: 'Mrs. Boateng', classForm: 'SHS1 Arts B', syllabusTopics: 35, topicsCovered: 35, coveragePct: 100, status: CurriculumStatus.completed, lastUpdated: '2025-07-05'),
    CurriculumSubject(id: 'c4', subject: 'Physics', department: 'Science', hod: 'Mr. Adjei', classForm: 'SHS3 Sci A', syllabusTopics: 40, topicsCovered: 28, coveragePct: 70.0, status: CurriculumStatus.inProgress, lastUpdated: '2025-07-09'),
    CurriculumSubject(id: 'c5', subject: 'Economics', department: 'Business', hod: 'Mr. Tetteh', classForm: 'SHS3 Bus A', syllabusTopics: 36, topicsCovered: 20, coveragePct: 55.6, status: CurriculumStatus.inProgress, lastUpdated: '2025-07-07'),
  ];

  List<Transcript> _transcripts = [
    Transcript(id: 'tr1', studentName: 'Kwame Asante', admNo: 'SHS1001', classForm: 'SHS1 Sci A', academicYear: '2024/2025', termsCovered: ['Term 1', 'Term 2'], cumulativeAverage: 69, overallPosition: '5th', conduct: 'Very Good', attendance: '95%', status: TranscriptStatus.approved, generatedDate: '2025-04-15', approvedBy: 'Academic Office', approvedDate: '2025-04-16'),
    Transcript(id: 'tr2', studentName: 'Yaa Mensimah', admNo: 'SHS3002', classForm: 'SHS3 Sci A', academicYear: '2024/2025', termsCovered: ['Term 1', 'Term 2'], cumulativeAverage: 75, overallPosition: '3rd', conduct: 'Excellent', attendance: '97%', status: TranscriptStatus.pendingReview, generatedDate: '2025-07-08'),
  ];

  List<CalendarEvent> _calendar = [
    CalendarEvent(id: 'ev1', title: 'Term 3 Begins', type: 'Term Start', date: '2025-05-12', description: 'Start of Term 3', term: 'Term 3'),
    CalendarEvent(id: 'ev2', title: 'Mid-Semester Exams', type: 'Exam', date: '2025-07-15', endDate: '2025-07-22', description: 'Term 3 mid-semester examinations', term: 'Term 3'),
    CalendarEvent(id: 'ev3', title: 'Republic Day Holiday', type: 'Holiday', date: '2025-07-01', description: 'Public holiday', term: 'Term 3'),
    CalendarEvent(id: 'ev4', title: 'End of Term 3', type: 'Term End', date: '2025-08-08', description: 'End of academic year', term: 'Term 3'),
    CalendarEvent(id: 'ev5', title: 'HOD Meeting', type: 'Meeting', date: '2025-07-12', description: 'Monthly HOD review meeting', term: 'Term 3'),
    CalendarEvent(id: 'ev6', title: 'Report Cards Due', type: 'Deadline', date: '2025-08-05', description: 'All report cards must be generated and reviewed', term: 'Term 3'),
  ];

  List<AcademicTerm> _terms = [
    AcademicTerm(id: 'tm1', term: 'Term 1', academicYear: '2024/2025', startDate: '2024-09-10', endDate: '2024-12-13', midTermBreak: '2024-10-28', isCurrent: false),
    AcademicTerm(id: 'tm2', term: 'Term 2', academicYear: '2024/2025', startDate: '2025-01-13', endDate: '2025-04-11', midTermBreak: '2025-02-24', isCurrent: false),
    AcademicTerm(id: 'tm3', term: 'Term 3', academicYear: '2024/2025', startDate: '2025-05-12', endDate: '2025-08-08', midTermBreak: '2025-06-23', isCurrent: true),
  ];

  final List<SubjectPerformance> _subjectPerformance = [
    SubjectPerformance(id: 'sp1', subject: 'Elective Mathematics', department: 'Mathematics', hod: 'Mr. Mensah', avgScore: 64, coveragePct: 76, teacherCount: 2, studentCount: 85, passRate: 72, trend: 'up'),
    SubjectPerformance(id: 'sp2', subject: 'Chemistry', department: 'Science', hod: 'Mr. Adjei', avgScore: 61, coveragePct: 68, teacherCount: 2, studentCount: 85, passRate: 65, trend: 'stable'),
    SubjectPerformance(id: 'sp3', subject: 'Physics', department: 'Science', hod: 'Mr. Adjei', avgScore: 67, coveragePct: 90, teacherCount: 1, studentCount: 35, passRate: 78, trend: 'up'),
    SubjectPerformance(id: 'sp4', subject: 'English Language', department: 'Languages', hod: 'Mrs. Boateng', avgScore: 70, coveragePct: 79, teacherCount: 3, studentCount: 200, passRate: 82, trend: 'up'),
    SubjectPerformance(id: 'sp5', subject: 'Core Mathematics', department: 'Mathematics', hod: 'Mr. Mensah', avgScore: 58, coveragePct: 64, teacherCount: 3, studentCount: 200, passRate: 60, trend: 'down'),
  ];

  final List<TeacherActivity> _teacherActivity = [
    TeacherActivity(id: 'ta1', teacherName: 'Mr. Mensah', department: 'Mathematics', lessonPlansThisTerm: 28, materialsUploaded: 12, assignmentsCreated: 8, attendanceMarkedPct: 95, syllabusCoverage: 76, lastActive: '2025-07-10', status: 'Active'),
    TeacherActivity(id: 'ta2', teacherName: 'Mr. Adjei', department: 'Science', lessonPlansThisTerm: 24, materialsUploaded: 8, assignmentsCreated: 6, attendanceMarkedPct: 88, syllabusCoverage: 68, lastActive: '2025-07-09', status: 'Active'),
    TeacherActivity(id: 'ta3', teacherName: 'Mrs. Boateng', department: 'Languages', lessonPlansThisTerm: 30, materialsUploaded: 15, assignmentsCreated: 10, attendanceMarkedPct: 98, syllabusCoverage: 79, lastActive: '2025-07-10', status: 'Active'),
    TeacherActivity(id: 'ta4', teacherName: 'Mr. Owusu', department: 'Science', lessonPlansThisTerm: 5, materialsUploaded: 2, assignmentsCreated: 1, attendanceMarkedPct: 60, syllabusCoverage: 40, lastActive: '2025-07-03', status: 'On Leave'),
  ];

  final List<AdmissionInsight> _admissionInsights = [
    AdmissionInsight(id: 'ai1', classForm: 'SHS1 Sci A', applied: 120, admitted: 42, rejected: 65, pending: 13, capacity: 45, filled: 42),
    AdmissionInsight(id: 'ai2', classForm: 'SHS1 Arts B', applied: 95, admitted: 40, rejected: 48, pending: 7, capacity: 45, filled: 40),
    AdmissionInsight(id: 'ai3', classForm: 'SHS1 Bus C', applied: 70, admitted: 35, rejected: 30, pending: 5, capacity: 40, filled: 35),
    AdmissionInsight(id: 'ai4', classForm: 'SHS1 Gen D', applied: 55, admitted: 38, rejected: 12, pending: 5, capacity: 40, filled: 38),
  ];

  List<PLCRequisition> _plcRequisitions = [
    PLCRequisition(id: 'plc-70', date: '2026-07-05', itemName: 'A4 Paper (reams)', quantity: 5, unit: 'reams', purpose: 'Printing remedial worksheets for PLC action item', requestedBy: 'Mr. Mensah', status: 'Pending', approvedBy: '', approvedDate: '', notes: ''),
    PLCRequisition(id: 'plc-71', date: '2026-06-25', itemName: 'Whiteboard markers', quantity: 10, unit: 'packs', purpose: 'For PLC session demonstrations', requestedBy: 'Mrs. Adjei', status: 'Approved', approvedBy: 'Academic Office', approvedDate: '2026-06-26', notes: 'Collect from Stores'),
  ];

  List<SPIP> _spips = [
    SPIP(
      id: 'spip1',
      title: '2024/2025 Academic Excellence Plan',
      academicYear: '2024/2025',
      planLead: 'Mr. Osei (Academic Officer)',
      priority: SPIPPriority.high,
      startDate: '2024-09-10',
      endDate: '2025-08-08',
      status: SPIPStatus.active,
      vision: 'Raise academic achievement across all subjects through targeted instruction, empowered teachers, and structured monitoring.',
      strengths: 'Strong Science dept, dedicated teachers, good ICT infrastructure',
      weaknesses: 'Low Core Maths pass rate, weak English essay writing, inconsistent syllabus coverage',
      rootCauses: 'Insufficient remedial sessions, limited teacher PD, no standardised coverage tracking',
      priorityAreas: '1. Core Maths pass rate 2. English writing 3. Syllabus coverage 4. Teacher PD',
      teamMembers: ['Mr. Osei', 'Mr. Mensah', 'Mrs. Boateng', 'Mr. Adjei'],
      goals: [
        SPIPGoal(id: 'g1', title: 'Raise Core Maths pass rate', focusArea: SPIPFocusArea.instruction, description: 'Improve pass rate from 58% to 75%', baseline: '58% (Term 1)', target: '75% by year end', currentProgress: '67% (Term 2)', status: SPIPGoalStatus.inProgress, responsible: 'Mr. Mensah (HOD Maths)', deadline: '2025-08-08'),
        SPIPGoal(id: 'g2', title: 'Improve English essay writing', focusArea: SPIPFocusArea.instruction, description: 'Structured writing program across all forms', baseline: '57% (mid-Term 2)', target: '70% by year end', currentProgress: '57% (mid-Term 2)', status: SPIPGoalStatus.inProgress, responsible: 'Mrs. Boateng (HOD Languages)', deadline: '2025-08-08'),
        SPIPGoal(id: 'g3', title: 'Standardize syllabus coverage', focusArea: SPIPFocusArea.operations, description: 'Ensure all subjects reach 90%+ coverage', baseline: '72% average', target: '90% average', currentProgress: '76% average', status: SPIPGoalStatus.inProgress, responsible: 'All HODs', deadline: '2025-07-15'),
        SPIPGoal(id: 'g4', title: 'Teacher PD on evidence-based practices', focusArea: SPIPFocusArea.people, description: 'Train all teachers on differentiated instruction', baseline: '0% trained', target: '100% trained', currentProgress: '60% trained', status: SPIPGoalStatus.inProgress, responsible: 'Mr. Osei', deadline: '2025-06-30'),
      ],
      actionItems: [
        SPIPActionItem(id: 'a1', description: 'After-school remedial Maths sessions twice weekly', focusArea: SPIPFocusArea.instruction, responsible: 'Mr. Mensah', timeline: 'Term 2-3', completed: true),
        SPIPActionItem(id: 'a2', description: 'Weekly essay writing workshops', focusArea: SPIPFocusArea.instruction, responsible: 'Mrs. Boateng', timeline: 'Term 2-3', completed: false),
        SPIPActionItem(id: 'a3', description: 'Monthly coverage audit by HODs', focusArea: SPIPFocusArea.operations, responsible: 'All HODs', timeline: 'Ongoing', completed: false),
        SPIPActionItem(id: 'a4', description: 'PD workshop on differentiated instruction', focusArea: SPIPFocusArea.people, responsible: 'Mr. Osei', timeline: 'Term 2', completed: true),
      ],
      milestones: [
        SPIPMilestone(id: 'm1', title: 'Term 2 exam pass rate >=65%', targetDate: '2025-04-11', achievedDate: '2025-04-12', status: SPIPMilestoneStatus.achieved),
        SPIPMilestone(id: 'm2', title: '80% syllabus coverage by mid-Term 3', targetDate: '2025-06-20', status: SPIPMilestoneStatus.pending),
      ],
      progressReviews: [
        SPIPReview(date: '2025-04-15', recordedBy: 'Mr. Osei', summary: 'Term 2 exams show improvement in Core Maths (67% pass rate). English writing still lagging.', outcomes: 'Increase remedial sessions to 3x/week. Add peer review to essay workshops.'),
      ],
    ),
  ];

  List<Exam> get exams => List.unmodifiable(_exams);
  List<TimetableEntry> get timetables => List.unmodifiable(_timetables);
  List<HodApproval> get hodApprovals => List.unmodifiable(_hodApprovals);
  List<ReportCard> get reportCards => List.unmodifiable(_reportCards);
  List<CurriculumSubject> get curriculum => List.unmodifiable(_curriculum);
  List<Transcript> get transcripts => List.unmodifiable(_transcripts);
  List<CalendarEvent> get calendar => List.unmodifiable(_calendar);
  List<AcademicTerm> get terms => List.unmodifiable(_terms);
  List<SubjectPerformance> get subjectPerformance => List.unmodifiable(_subjectPerformance);
  List<TeacherActivity> get teacherActivity => List.unmodifiable(_teacherActivity);
  List<AdmissionInsight> get admissionInsights => List.unmodifiable(_admissionInsights);
  List<PLCRequisition> get plcRequisitions => List.unmodifiable(_plcRequisitions);
  List<SPIP> get spips => List.unmodifiable(_spips);

  int get activeSPIPs => _spips.where((s) => s.status == SPIPStatus.active || s.status == SPIPStatus.monitoring).length;
  int get totalStudents => 480;
  int get totalTeachers => 32;
  double get avgPassRate => _subjectPerformance.isEmpty ? 0 : _subjectPerformance.fold(0.0, (s, p) => s + p.passRate) / _subjectPerformance.length;

  Map<String, dynamic> getOverallStats(String officerName) => {
    'scheduledExams': scheduledExams,
    'pendingHODApprovals': pendingApprovals,
    'pendingReportCards': pendingReportCards,
    'pendingTranscripts': pendingTranscripts,
    'activeSPIPs': activeSPIPs,
    'avgCoverage': avgCoverage.toStringAsFixed(1),
    'totalStudents': totalStudents,
    'totalTeachers': totalTeachers,
    'avgPassRate': avgPassRate.toStringAsFixed(1),
  };

  List<ReportCard> getReportCardsByClass(String classForm) =>
      _reportCards.where((r) => r.classForm == classForm).toList();

  int get pendingApprovals => _hodApprovals.where((a) => a.status == HodApprovalStatus.pending).length;
  int get scheduledExams => _exams.where((e) => e.status == ExamStatus.scheduled).length;
  double get avgCoverage => _curriculum.isEmpty ? 0 : _curriculum.fold(0.0, (s, c) => s + c.coveragePct) / _curriculum.length;
  int get pendingTranscripts => _transcripts.where((t) => t.status == TranscriptStatus.pendingReview).length;
  int get pendingReportCards => _reportCards.where((r) => r.status == ReportCardStatus.underReview).length;
  List<PLCRequisition> get plcPending => _plcRequisitions.where((r) => r.status == 'Pending').toList();
  List<PLCRequisition> get plcApproved => _plcRequisitions.where((r) => r.status == 'Approved').toList();
  List<PLCRequisition> get plcRejected => _plcRequisitions.where((r) => r.status == 'Rejected').toList();

  void reviewHodApproval(String id, HodApprovalStatus status) {
    final idx = _hodApprovals.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      final a = _hodApprovals[idx];
      _hodApprovals[idx] = HodApproval(
        id: a.id, type: a.type, from: a.from, department: a.department,
        detail: a.detail, date: a.date, status: status,
      );
      notifyListeners();
    }
  }

  void approveHod(String id, String approver, String notes) {
    final idx = _hodApprovals.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      final a = _hodApprovals[idx];
      _hodApprovals[idx] = HodApproval(
        id: a.id, type: a.type, from: a.from, department: a.department,
        detail: notes.isNotEmpty ? '${a.detail}\n\nReview notes: $notes' : a.detail,
        date: a.date, status: HodApprovalStatus.approved,
      );
      notifyListeners();
    }
  }

  void deferHod(String id, String approver, String notes) {
    final idx = _hodApprovals.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      final a = _hodApprovals[idx];
      _hodApprovals[idx] = HodApproval(
        id: a.id, type: a.type, from: a.from, department: a.department,
        detail: notes.isNotEmpty ? '${a.detail}\n\nReview notes: $notes' : a.detail,
        date: a.date, status: HodApprovalStatus.deferred,
      );
      notifyListeners();
    }
  }

  void rejectHod(String id, String approver, String notes) {
    final idx = _hodApprovals.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      final a = _hodApprovals[idx];
      _hodApprovals[idx] = HodApproval(
        id: a.id, type: a.type, from: a.from, department: a.department,
        detail: notes.isNotEmpty ? '${a.detail}\n\nReview notes: $notes' : a.detail,
        date: a.date, status: HodApprovalStatus.rejected,
      );
      notifyListeners();
    }
  }

  void addExam(Exam exam) {
    _exams.add(Exam(
      id: 'e${_examIdCounter++}',
      title: exam.title, subject: exam.subject, classForm: exam.classForm,
      date: exam.date, startTime: exam.startTime, endTime: exam.endTime,
      venue: exam.venue, maxScore: exam.maxScore, status: exam.status,
      resultsStatus: exam.resultsStatus, invigilator: exam.invigilator, term: exam.term,
    ));
    notifyListeners();
  }

  void deleteExam(String id) {
    _exams.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void startExam(String id) {
    final idx = _exams.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      final e = _exams[idx];
      _exams[idx] = Exam(
        id: e.id, title: e.title, subject: e.subject, classForm: e.classForm,
        date: e.date, startTime: e.startTime, endTime: e.endTime, venue: e.venue,
        maxScore: e.maxScore, status: ExamStatus.ongoing, resultsStatus: e.resultsStatus,
        invigilator: e.invigilator, term: e.term,
      );
      notifyListeners();
    }
  }

  void completeExam(String id) {
    final idx = _exams.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      final e = _exams[idx];
      _exams[idx] = Exam(
        id: e.id, title: e.title, subject: e.subject, classForm: e.classForm,
        date: e.date, startTime: e.startTime, endTime: e.endTime, venue: e.venue,
        maxScore: e.maxScore, status: ExamStatus.completed, resultsStatus: e.resultsStatus,
        invigilator: e.invigilator, term: e.term,
      );
      notifyListeners();
    }
  }

  void addTimetable(TimetableEntry entry) {
    _timetables.add(TimetableEntry(
      id: 't${_timetableIdCounter++}',
      classForm: entry.classForm, day: entry.day, period: entry.period,
      startTime: entry.startTime, endTime: entry.endTime, subject: entry.subject,
      teacher: entry.teacher, room: entry.room, status: entry.status,
    ));
    notifyListeners();
  }

  void deleteTimetable(String id) {
    _timetables.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void publishTimetable(String id) {
    final idx = _timetables.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final t = _timetables[idx];
      _timetables[idx] = TimetableEntry(
        id: t.id, classForm: t.classForm, day: t.day, period: t.period,
        startTime: t.startTime, endTime: t.endTime, subject: t.subject,
        teacher: t.teacher, room: t.room, status: TimetableStatus.published,
      );
      notifyListeners();
    }
  }

  // ── Report Cards ──
  void generateReportCards(String classForm, String term, String academicYear) {
    final students = <Map<String, String>>[
      {'name': 'Kwame Asante', 'admNo': '2026/001'},
      {'name': 'Adwoa Frimpong', 'admNo': '2026/006'},
      {'name': 'Yao Mensah', 'admNo': '2026/003'},
    ];
    for (final s in students) {
      _reportCards.add(ReportCard(
        id: 'r${_reportCardIdCounter++}',
        classForm: classForm,
        studentName: s['name']!,
        admNo: s['admNo']!,
        term: term,
        academicYear: academicYear,
        average: 0,
        classPosition: '-',
        conduct: '-',
        attendance: '-',
        remarks: '',
        status: ReportCardStatus.generated,
      ));
    }
    notifyListeners();
  }

  void reviewReportCard(String id, String reviewer) {
    final idx = _reportCards.indexWhere((r) => r.id == id);
    if (idx >= 0) {
      final r = _reportCards[idx];
      _reportCards[idx] = ReportCard(
        id: r.id, classForm: r.classForm, studentName: r.studentName, admNo: r.admNo,
        term: r.term, academicYear: r.academicYear, average: r.average,
        classPosition: r.classPosition, conduct: r.conduct, attendance: r.attendance,
        remarks: r.remarks, status: ReportCardStatus.underReview,
      );
      notifyListeners();
    }
  }

  void releaseReportCard(String id) {
    final idx = _reportCards.indexWhere((r) => r.id == id);
    if (idx >= 0) {
      final r = _reportCards[idx];
      _reportCards[idx] = ReportCard(
        id: r.id, classForm: r.classForm, studentName: r.studentName, admNo: r.admNo,
        term: r.term, academicYear: r.academicYear, average: r.average,
        classPosition: r.classPosition, conduct: r.conduct, attendance: r.attendance,
        remarks: r.remarks, status: ReportCardStatus.released,
      );
      notifyListeners();
    }
  }

  void releaseAllForClass(String classForm) {
    for (var i = 0; i < _reportCards.length; i++) {
      if (_reportCards[i].classForm == classForm && _reportCards[i].status == ReportCardStatus.underReview) {
        final r = _reportCards[i];
        _reportCards[i] = ReportCard(
          id: r.id, classForm: r.classForm, studentName: r.studentName, admNo: r.admNo,
          term: r.term, academicYear: r.academicYear, average: r.average,
          classPosition: r.classPosition, conduct: r.conduct, attendance: r.attendance,
          remarks: r.remarks, status: ReportCardStatus.released,
        );
      }
    }
    notifyListeners();
  }

  void deleteReportCard(String id) {
    _reportCards.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  // ── Transcripts ──
  void generateTranscript(Transcript t) {
    _transcripts.add(Transcript(
      id: 'tr${_transcriptIdCounter++}',
      studentName: t.studentName, admNo: t.admNo, classForm: t.classForm,
      academicYear: t.academicYear, termsCovered: t.termsCovered,
      cumulativeAverage: t.cumulativeAverage, overallPosition: t.overallPosition,
      conduct: t.conduct, attendance: t.attendance,
      status: TranscriptStatus.draft, generatedDate: DateTime.now().toIso8601String().split('T')[0],
    ));
    notifyListeners();
  }

  void approveTranscript(String id, String approver) {
    final idx = _transcripts.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final t = _transcripts[idx];
      _transcripts[idx] = Transcript(
        id: t.id, studentName: t.studentName, admNo: t.admNo, classForm: t.classForm,
        academicYear: t.academicYear, termsCovered: t.termsCovered,
        cumulativeAverage: t.cumulativeAverage, overallPosition: t.overallPosition,
        conduct: t.conduct, attendance: t.attendance, status: TranscriptStatus.approved,
        generatedDate: t.generatedDate, approvedBy: approver,
        approvedDate: DateTime.now().toIso8601String().split('T')[0],
      );
      notifyListeners();
    }
  }

  void rejectTranscript(String id, String reason) {
    final idx = _transcripts.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final t = _transcripts[idx];
      _transcripts[idx] = Transcript(
        id: t.id, studentName: t.studentName, admNo: t.admNo, classForm: t.classForm,
        academicYear: t.academicYear, termsCovered: t.termsCovered,
        cumulativeAverage: t.cumulativeAverage, overallPosition: t.overallPosition,
        conduct: t.conduct, attendance: t.attendance, status: TranscriptStatus.rejected,
        generatedDate: t.generatedDate,
      );
      notifyListeners();
    }
  }

  void releaseTranscript(String id) {
    final idx = _transcripts.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final t = _transcripts[idx];
      _transcripts[idx] = Transcript(
        id: t.id, studentName: t.studentName, admNo: t.admNo, classForm: t.classForm,
        academicYear: t.academicYear, termsCovered: t.termsCovered,
        cumulativeAverage: t.cumulativeAverage, overallPosition: t.overallPosition,
        conduct: t.conduct, attendance: t.attendance, status: TranscriptStatus.released,
        generatedDate: t.generatedDate, approvedBy: t.approvedBy, approvedDate: t.approvedDate,
      );
      notifyListeners();
    }
  }

  void deleteTranscript(String id) {
    _transcripts.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ── Curriculum ──
  void addCurriculum(CurriculumSubject c) {
    final pct = c.syllabusTopics > 0 ? (c.topicsCovered / c.syllabusTopics * 100) : 0.0;
    _curriculum.add(CurriculumSubject(
      id: 'c${_curriculumIdCounter++}',
      subject: c.subject, department: c.department, hod: c.hod, classForm: c.classForm,
      syllabusTopics: c.syllabusTopics, topicsCovered: c.topicsCovered,
      coveragePct: double.parse(pct.toStringAsFixed(1)),
      status: c.status, lastUpdated: DateTime.now().toIso8601String().split('T')[0],
    ));
    notifyListeners();
  }

  void updateCurriculum(String id, Map<String, dynamic> updates) {
    final idx = _curriculum.indexWhere((c) => c.id == id);
    if (idx >= 0) {
      final c = _curriculum[idx];
      final topicsCovered = updates['topicsCovered'] as int? ?? c.topicsCovered;
      final pct = c.syllabusTopics > 0 ? (topicsCovered / c.syllabusTopics * 100) : 0.0;
      _curriculum[idx] = CurriculumSubject(
        id: c.id, subject: c.subject, department: c.department, hod: c.hod,
        classForm: c.classForm, syllabusTopics: c.syllabusTopics,
        topicsCovered: topicsCovered, coveragePct: double.parse(pct.toStringAsFixed(1)),
        status: c.status, lastUpdated: DateTime.now().toIso8601String().split('T')[0],
      );
      notifyListeners();
    }
  }

  void deleteCurriculum(String id) {
    _curriculum.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // ── Calendar ──
  void addCalendarEvent(CalendarEvent e) {
    _calendar.add(CalendarEvent(
      id: 'ev${_calendarIdCounter++}',
      title: e.title, type: e.type, date: e.date, endDate: e.endDate,
      description: e.description, term: e.term,
    ));
    notifyListeners();
  }

  void deleteCalendarEvent(String id) {
    _calendar.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setCurrentTerm(String id) {
    for (var i = 0; i < _terms.length; i++) {
      final t = _terms[i];
      _terms[i] = AcademicTerm(
        id: t.id, term: t.term, academicYear: t.academicYear,
        startDate: t.startDate, endDate: t.endDate, midTermBreak: t.midTermBreak,
        isCurrent: t.id == id,
      );
    }
    notifyListeners();
  }

  // ── PLC Requisitions ──
  void approveRequisition(String id, String approver) {
    final idx = _plcRequisitions.indexWhere((r) => r.id == id);
    if (idx >= 0) {
      final r = _plcRequisitions[idx];
      _plcRequisitions[idx] = PLCRequisition(
        id: r.id, date: r.date, itemName: r.itemName, quantity: r.quantity,
        unit: r.unit, purpose: r.purpose, requestedBy: r.requestedBy,
        status: 'Approved', approvedBy: approver,
        approvedDate: DateTime.now().toIso8601String().split('T')[0], notes: r.notes,
      );
      notifyListeners();
    }
  }

  void rejectRequisition(String id, String approver) {
    final idx = _plcRequisitions.indexWhere((r) => r.id == id);
    if (idx >= 0) {
      final r = _plcRequisitions[idx];
      _plcRequisitions[idx] = PLCRequisition(
        id: r.id, date: r.date, itemName: r.itemName, quantity: r.quantity,
        unit: r.unit, purpose: r.purpose, requestedBy: r.requestedBy,
        status: 'Rejected', approvedBy: approver,
        approvedDate: DateTime.now().toIso8601String().split('T')[0], notes: r.notes,
      );
      notifyListeners();
    }
  }

  // ── SPIP ──
  void addSPIP(SPIP spip) {
    _spips.add(SPIP(
      id: 'spip${_spipIdCounter++}',
      title: spip.title, academicYear: spip.academicYear, planLead: spip.planLead,
      priority: spip.priority, startDate: spip.startDate, endDate: spip.endDate,
      status: SPIPStatus.draft, vision: spip.vision, strengths: spip.strengths,
      weaknesses: spip.weaknesses, rootCauses: spip.rootCauses,
      priorityAreas: spip.priorityAreas, teamMembers: spip.teamMembers,
      goals: [], actionItems: [], milestones: [], progressReviews: [],
    ));
    notifyListeners();
  }

  void updateSPIP(String id, Map<String, dynamic> updates) {
    final idx = _spips.indexWhere((s) => s.id == id);
    if (idx >= 0) {
      final s = _spips[idx];
      _spips[idx] = SPIP(
        id: s.id, title: s.title, academicYear: s.academicYear, planLead: s.planLead,
        priority: s.priority, startDate: s.startDate, endDate: s.endDate,
        status: updates['status'] as SPIPStatus? ?? s.status,
        vision: s.vision, strengths: s.strengths, weaknesses: s.weaknesses,
        rootCauses: s.rootCauses, priorityAreas: s.priorityAreas,
        teamMembers: s.teamMembers, goals: s.goals, actionItems: s.actionItems,
        milestones: s.milestones, progressReviews: s.progressReviews,
      );
      notifyListeners();
    }
  }

  void deleteSPIP(String id) {
    _spips.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void addSPIPGoal(String spipId, SPIPGoal goal) {
    final idx = _spips.indexWhere((s) => s.id == spipId);
    if (idx >= 0) {
      final s = _spips[idx];
      _spips[idx] = SPIP(
        id: s.id, title: s.title, academicYear: s.academicYear, planLead: s.planLead,
        priority: s.priority, startDate: s.startDate, endDate: s.endDate, status: s.status,
        vision: s.vision, strengths: s.strengths, weaknesses: s.weaknesses,
        rootCauses: s.rootCauses, priorityAreas: s.priorityAreas, teamMembers: s.teamMembers,
        goals: [...s.goals, SPIPGoal(
          id: 'g${_spipGoalIdCounter++}',
          title: goal.title, focusArea: goal.focusArea, description: goal.description,
          baseline: goal.baseline, target: goal.target, currentProgress: goal.currentProgress,
          status: goal.status, responsible: goal.responsible, deadline: goal.deadline,
        )],
        actionItems: s.actionItems, milestones: s.milestones, progressReviews: s.progressReviews,
      );
      notifyListeners();
    }
  }

  void updateSPIPGoal(String spipId, String goalId, Map<String, dynamic> updates) {
    final idx = _spips.indexWhere((s) => s.id == spipId);
    if (idx >= 0) {
      final s = _spips[idx];
      final goals = s.goals.map((g) {
        if (g.id != goalId) return g;
        return SPIPGoal(
          id: g.id, title: g.title, focusArea: g.focusArea, description: g.description,
          baseline: g.baseline, target: g.target, currentProgress: g.currentProgress,
          status: updates['status'] as SPIPGoalStatus? ?? g.status,
          responsible: g.responsible, deadline: g.deadline,
        );
      }).toList();
      _spips[idx] = SPIP(
        id: s.id, title: s.title, academicYear: s.academicYear, planLead: s.planLead,
        priority: s.priority, startDate: s.startDate, endDate: s.endDate, status: s.status,
        vision: s.vision, strengths: s.strengths, weaknesses: s.weaknesses,
        rootCauses: s.rootCauses, priorityAreas: s.priorityAreas, teamMembers: s.teamMembers,
        goals: goals, actionItems: s.actionItems, milestones: s.milestones,
        progressReviews: s.progressReviews,
      );
      notifyListeners();
    }
  }

  void addSPIPActionItem(String spipId, SPIPActionItem item) {
    final idx = _spips.indexWhere((s) => s.id == spipId);
    if (idx >= 0) {
      final s = _spips[idx];
      _spips[idx] = SPIP(
        id: s.id, title: s.title, academicYear: s.academicYear, planLead: s.planLead,
        priority: s.priority, startDate: s.startDate, endDate: s.endDate, status: s.status,
        vision: s.vision, strengths: s.strengths, weaknesses: s.weaknesses,
        rootCauses: s.rootCauses, priorityAreas: s.priorityAreas, teamMembers: s.teamMembers,
        goals: s.goals,
        actionItems: [...s.actionItems, SPIPActionItem(
          id: 'a${_spipActionIdCounter++}',
          description: item.description, focusArea: item.focusArea,
          responsible: item.responsible, timeline: item.timeline, completed: false,
        )],
        milestones: s.milestones, progressReviews: s.progressReviews,
      );
      notifyListeners();
    }
  }

  void toggleSPIPActionItem(String spipId, String itemId) {
    final idx = _spips.indexWhere((s) => s.id == spipId);
    if (idx >= 0) {
      final s = _spips[idx];
      final items = s.actionItems.map((a) {
        if (a.id != itemId) return a;
        return SPIPActionItem(
          id: a.id, description: a.description, focusArea: a.focusArea,
          responsible: a.responsible, timeline: a.timeline, completed: !a.completed,
        );
      }).toList();
      _spips[idx] = SPIP(
        id: s.id, title: s.title, academicYear: s.academicYear, planLead: s.planLead,
        priority: s.priority, startDate: s.startDate, endDate: s.endDate, status: s.status,
        vision: s.vision, strengths: s.strengths, weaknesses: s.weaknesses,
        rootCauses: s.rootCauses, priorityAreas: s.priorityAreas, teamMembers: s.teamMembers,
        goals: s.goals, actionItems: items, milestones: s.milestones,
        progressReviews: s.progressReviews,
      );
      notifyListeners();
    }
  }

  void addSPIPMilestone(String spipId, SPIPMilestone m) {
    final idx = _spips.indexWhere((s) => s.id == spipId);
    if (idx >= 0) {
      final s = _spips[idx];
      _spips[idx] = SPIP(
        id: s.id, title: s.title, academicYear: s.academicYear, planLead: s.planLead,
        priority: s.priority, startDate: s.startDate, endDate: s.endDate, status: s.status,
        vision: s.vision, strengths: s.strengths, weaknesses: s.weaknesses,
        rootCauses: s.rootCauses, priorityAreas: s.priorityAreas, teamMembers: s.teamMembers,
        goals: s.goals, actionItems: s.actionItems,
        milestones: [...s.milestones, SPIPMilestone(
          id: 'm${_spipMilestoneIdCounter++}',
          title: m.title, targetDate: m.targetDate, status: SPIPMilestoneStatus.pending,
        )],
        progressReviews: s.progressReviews,
      );
      notifyListeners();
    }
  }

  void addSPIPReview(String spipId, SPIPReview review) {
    final idx = _spips.indexWhere((s) => s.id == spipId);
    if (idx >= 0) {
      final s = _spips[idx];
      _spips[idx] = SPIP(
        id: s.id, title: s.title, academicYear: s.academicYear, planLead: s.planLead,
        priority: s.priority, startDate: s.startDate, endDate: s.endDate, status: s.status,
        vision: s.vision, strengths: s.strengths, weaknesses: s.weaknesses,
        rootCauses: s.rootCauses, priorityAreas: s.priorityAreas, teamMembers: s.teamMembers,
        goals: s.goals, actionItems: s.actionItems, milestones: s.milestones,
        progressReviews: [...s.progressReviews, SPIPReview(
          date: DateTime.now().toIso8601String().split('T')[0],
          recordedBy: review.recordedBy, summary: review.summary, outcomes: review.outcomes,
        )],
      );
      notifyListeners();
    }
  }
}
