import 'package:flutter/foundation.dart';

class SubjectClass {
  final String id, subject, classForm, hod;
  final int students;
  final bool isElective;
  const SubjectClass({required this.id, required this.subject, required this.classForm, required this.students, required this.hod, required this.isElective});
}

class LessonMaterial {
  final String id, title, type, classForm, subject, topic, description, dateUploaded, uploadedBy;
  const LessonMaterial({required this.id, required this.title, required this.type, required this.classForm, required this.subject, required this.topic, required this.description, required this.dateUploaded, required this.uploadedBy});
}

class AVRecording {
  final String id, title, type, duration, classForm, subject, topic, dateRecorded, recordedBy;
  const AVRecording({required this.id, required this.title, required this.type, required this.duration, required this.classForm, required this.subject, required this.topic, required this.dateRecorded, required this.recordedBy});
}

class LiveSession {
  final String id, subject, classForm, scheduledTime, status, topic, startedBy;
  final int participants;
  const LiveSession({required this.id, required this.subject, required this.classForm, required this.scheduledTime, required this.status, required this.topic, required this.startedBy, required this.participants});
}

class Submission {
  final String id, studentName, admNo, submittedDate, status;
  final double? score;
  final String? feedback;
  const Submission({required this.id, required this.studentName, required this.admNo, required this.submittedDate, required this.status, this.score, this.feedback});
}

class Assignment {
  final String id, title, description, classForm, subject, dueDate, dateCreated, status, createdBy;
  final int maxScore;
  final List<Submission> submissions;
  const Assignment({required this.id, required this.title, required this.description, required this.classForm, required this.subject, required this.dueDate, required this.dateCreated, required this.maxScore, required this.status, required this.createdBy, this.submissions = const []});
}

class GradebookEntry {
  final String id, studentName, admNo, classForm, subject, term, grade;
  final int classwork, classworkMax, homework, homeworkMax, test, testMax, exam, examMax, total, totalMax;
  const GradebookEntry({required this.id, required this.studentName, required this.admNo, required this.classForm, required this.subject, required this.term, required this.classwork, required this.classworkMax, required this.homework, required this.homeworkMax, required this.test, required this.testMax, required this.exam, required this.examMax, required this.total, required this.totalMax, required this.grade});
}

class AttendanceRecord {
  final String id, studentName, admNo, classForm, subject, date, status;
  final String? notes;
  const AttendanceRecord({required this.id, required this.studentName, required this.admNo, required this.classForm, required this.subject, required this.date, required this.status, this.notes});
}

class StudentRosterEntry {
  final String id, name, admNo, classForm, avgScore, attendancePct, lastGrade, guardianName, guardianPhone;
  const StudentRosterEntry({required this.id, required this.name, required this.admNo, required this.classForm, required this.avgScore, required this.attendancePct, required this.lastGrade, required this.guardianName, required this.guardianPhone});
}

class ClassAnnouncement {
  final String id, title, body, classForm, date, postedBy, priority;
  const ClassAnnouncement({required this.id, required this.title, required this.body, required this.classForm, required this.date, required this.postedBy, required this.priority});
}

class LessonPlan {
  final String id, subject, classForm, date, topic, objectives, teachingMethods, resources, activities, assessment, homework, status;
  final String? reflection, fileName, fileUrl;
  const LessonPlan({required this.id, required this.subject, required this.classForm, required this.date, required this.topic, required this.objectives, required this.teachingMethods, required this.resources, required this.activities, required this.assessment, required this.homework, required this.status, this.reflection, this.fileName, this.fileUrl});
}

class TeacherTimetableEntry {
  final String id, day, startTime, endTime, subject, classForm, room;
  final int period;
  const TeacherTimetableEntry({required this.id, required this.day, required this.period, required this.startTime, required this.endTime, required this.subject, required this.classForm, required this.room});
}

class SyllabusTopic {
  final String id, subject, classForm, topic, subTopics;
  final int week;
  final String status;
  final String? dateTaught, notes;
  const SyllabusTopic({required this.id, required this.subject, required this.classForm, required this.topic, required this.subTopics, required this.week, required this.status, this.dateTaught, this.notes});
}

class RemedialStudent {
  final String id, studentName, admNo, classForm, subject, area, intervention, dateStarted, progress, notes;
  const RemedialStudent({required this.id, required this.studentName, required this.admNo, required this.classForm, required this.subject, required this.area, required this.intervention, required this.dateStarted, required this.progress, required this.notes});
}

class TeacherProvider extends ChangeNotifier {
  int _idCounter = 200;
  String _nextId() => 'tch-${++_idCounter}';
  String _todayISO() => DateTime.now().toIso8601String().substring(0, 10);

  List<SubjectClass> subjects = [
    SubjectClass(id: 'tch-1', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', students: 38, hod: 'Mr. Mensah', isElective: true),
    SubjectClass(id: 'tch-2', subject: 'Elective Mathematics', classForm: 'SHS2 Sci B', students: 35, hod: 'Mr. Mensah', isElective: true),
    SubjectClass(id: 'tch-3', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', students: 42, hod: 'Mr. Mensah', isElective: false),
  ];

  List<LessonMaterial> materials = [
    LessonMaterial(id: 'tch-10', title: 'Quadratic Equations', type: 'Note', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', topic: 'Ch. 5', description: 'Complete notes on solving quadratics', dateUploaded: '2026-07-01', uploadedBy: 'Teacher'),
    LessonMaterial(id: 'tch-11', title: 'Differentiation Rules', type: 'Slide', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', topic: 'Ch. 6', description: 'Power rule, product rule, quotient rule', dateUploaded: '2026-07-03', uploadedBy: 'Teacher'),
    LessonMaterial(id: 'tch-12', title: 'Indices & Logarithms', type: 'Past Q', classForm: 'SHS1 Sci A', subject: 'Core Mathematics', topic: 'Ch. 3', description: 'WASSCE past questions with solutions', dateUploaded: '2026-06-28', uploadedBy: 'Teacher'),
  ];

  List<AVRecording> avRecordings = [
    AVRecording(id: 'tch-20', title: 'Quadratic Formula Walkthrough', type: 'Video', duration: '12:30', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', topic: 'Quadratic equations', dateRecorded: '2026-07-02', recordedBy: 'Teacher'),
    AVRecording(id: 'tch-21', title: 'Logarithms Explained', type: 'Audio', duration: '08:15', classForm: 'SHS1 Sci A', subject: 'Core Mathematics', topic: 'Indices & Logarithms', dateRecorded: '2026-06-30', recordedBy: 'Teacher'),
  ];

  List<LiveSession> liveSessions = [
    LiveSession(id: 'tch-30', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', scheduledTime: '2026-07-11 14:00', status: 'Scheduled', topic: 'Integration by substitution', startedBy: '', participants: 0),
    LiveSession(id: 'tch-31', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', scheduledTime: '2026-07-12 10:00', status: 'Scheduled', topic: 'Surds and rationalization', startedBy: '', participants: 0),
    LiveSession(id: 'tch-32', subject: 'Elective Mathematics', classForm: 'SHS2 Sci B', scheduledTime: '2026-07-05 14:00', status: 'Ended', topic: 'Limits and continuity', startedBy: 'Teacher', participants: 33),
  ];

  List<Assignment> assignments = [
    Assignment(id: 'tch-40', title: 'Quadratic Eq. Exercise 3', description: 'Solve all questions on page 45, including word problems', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', dueDate: '2026-07-10', dateCreated: '2026-07-05', maxScore: 20, status: 'Published', createdBy: 'Teacher', submissions: [
      Submission(id: 'sub-1', studentName: 'Kwame Asante', admNo: '2026/001', submittedDate: '2026-07-08', status: 'Graded', score: 18, feedback: 'Good work on word problems'),
      Submission(id: 'sub-2', studentName: 'Grace Opoku', admNo: '2026/002', submittedDate: '2026-07-09', status: 'Submitted'),
    ]),
    Assignment(id: 'tch-41', title: 'Indices Practice Set', description: 'Simplify and evaluate all expressions in Exercise 2.3', classForm: 'SHS1 Sci A', subject: 'Core Mathematics', dueDate: '2026-07-08', dateCreated: '2026-07-03', maxScore: 15, status: 'Published', createdBy: 'Teacher', submissions: [
      Submission(id: 'sub-3', studentName: 'Samuel Aidoo', admNo: '2026/003', submittedDate: '2026-07-07', status: 'Submitted'),
    ]),
    Assignment(id: 'tch-42', title: 'Mid-Sem Quiz', description: 'Covers chapters 1-6. 50 marks, 1 hour.', classForm: 'SHS2 Sci B', subject: 'Elective Mathematics', dueDate: '2026-07-12', dateCreated: '2026-07-06', maxScore: 50, status: 'Published', createdBy: 'Teacher'),
  ];

  List<GradebookEntry> gradebook = [
    GradebookEntry(id: 'tch-50', studentName: 'Kwame Asante', admNo: '2026/001', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', term: 'Term 3 2025/2026', classwork: 8, classworkMax: 10, homework: 9, homeworkMax: 10, test: 17, testMax: 20, exam: 72, examMax: 100, total: 106, totalMax: 140, grade: 'A1'),
    GradebookEntry(id: 'tch-51', studentName: 'Grace Opoku', admNo: '2026/002', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', term: 'Term 3 2025/2026', classwork: 7, classworkMax: 10, homework: 8, homeworkMax: 10, test: 15, testMax: 20, exam: 65, examMax: 100, total: 95, totalMax: 140, grade: 'B3'),
    GradebookEntry(id: 'tch-52', studentName: 'Samuel Aidoo', admNo: '2026/003', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', term: 'Term 3 2025/2026', classwork: 9, classworkMax: 10, homework: 10, homeworkMax: 10, test: 18, testMax: 20, exam: 85, examMax: 100, total: 122, totalMax: 140, grade: 'A1'),
  ];

  List<AttendanceRecord> attendance = [
    AttendanceRecord(id: 'tch-60', studentName: 'Kwame Asante', admNo: '2026/001', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', date: '2026-07-07', status: 'Present'),
    AttendanceRecord(id: 'tch-61', studentName: 'Grace Opoku', admNo: '2026/002', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', date: '2026-07-07', status: 'Present'),
    AttendanceRecord(id: 'tch-62', studentName: 'Samuel Aidoo', admNo: '2026/003', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', date: '2026-07-07', status: 'Late'),
    AttendanceRecord(id: 'tch-63', studentName: 'Daniel Osei', admNo: '2026/004', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', date: '2026-07-07', status: 'Absent'),
  ];

  List<StudentRosterEntry> roster = [
    StudentRosterEntry(id: 'tch-70', name: 'Kwame Asante', admNo: '2026/001', classForm: 'SHS2 Sci A', avgScore: '75.7%', attendancePct: '92%', lastGrade: 'B1', guardianName: 'Mr. Kofi Asante', guardianPhone: '024-555-1001'),
    StudentRosterEntry(id: 'tch-71', name: 'Grace Opoku', admNo: '2026/002', classForm: 'SHS2 Sci A', avgScore: '67.8%', attendancePct: '88%', lastGrade: 'B3', guardianName: 'Mrs. Grace Opoku', guardianPhone: '027-555-1002'),
    StudentRosterEntry(id: 'tch-72', name: 'Samuel Aidoo', admNo: '2026/003', classForm: 'SHS2 Sci A', avgScore: '87.1%', attendancePct: '96%', lastGrade: 'A1', guardianName: 'Mr. Samuel Aidoo', guardianPhone: '020-555-1003'),
    StudentRosterEntry(id: 'tch-73', name: 'Daniel Osei', admNo: '2026/004', classForm: 'SHS2 Sci A', avgScore: '45.2%', attendancePct: '71%', lastGrade: 'D7', guardianName: 'Mrs. Adwoa Osei', guardianPhone: '055-555-1004'),
  ];

  List<ClassAnnouncement> announcements = [
    ClassAnnouncement(id: 'tch-80', title: 'Reminder: Assignment due Jul 10', body: 'Quadratic Equations Exercise 3 is due this Friday.', classForm: 'SHS2 Sci A', date: '2026-07-06', postedBy: 'Teacher', priority: 'Important'),
    ClassAnnouncement(id: 'tch-81', title: 'Extra tutorial Saturday 9am', body: 'I will hold an extra tutorial session on Saturday from 9am to 12pm in the Math lab.', classForm: 'SHS1 Sci A', date: '2026-07-04', postedBy: 'Teacher', priority: 'Normal'),
  ];

  List<LessonPlan> lessonPlans = [
    LessonPlan(id: 'tch-90', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', date: '2026-07-08', topic: 'Integration by substitution', objectives: 'Students should be able to integrate composite functions using substitution', teachingMethods: 'Direct instruction + guided practice', resources: 'Whiteboard, textbook Ch.7, prepared examples', activities: '1. Review chain rule\n2. Introduce substitution method\n3. Worked examples\n4. Practice exercises', assessment: 'Exit ticket: 2 integration problems', homework: 'Exercise 7.2 Q1-10', status: 'Planned'),
    LessonPlan(id: 'tch-91', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', date: '2026-07-07', topic: 'Surds and rationalization', objectives: 'Students should be able to simplify surds and rationalize denominators', teachingMethods: 'Discovery + pair work', resources: 'Whiteboard, worksheets', activities: '1. Define surds\n2. Simplification rules\n3. Rationalization\n4. Pair practice', assessment: 'Oral questioning', homework: 'Exercise 3.4 Q1-8', status: 'Taught', reflection: 'Students struggled with rationalization of binomial denominators. Will review next lesson.'),
  ];

  List<TeacherTimetableEntry> timetable = [
    TeacherTimetableEntry(id: 'tch-100', day: 'Monday', period: 1, startTime: '08:00', endTime: '08:40', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', room: 'M1'),
    TeacherTimetableEntry(id: 'tch-101', day: 'Monday', period: 2, startTime: '08:40', endTime: '09:20', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', room: 'M1'),
    TeacherTimetableEntry(id: 'tch-102', day: 'Monday', period: 4, startTime: '10:00', endTime: '10:40', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', room: 'M2'),
    TeacherTimetableEntry(id: 'tch-103', day: 'Tuesday', period: 3, startTime: '09:20', endTime: '10:00', subject: 'Elective Mathematics', classForm: 'SHS2 Sci B', room: 'M1'),
    TeacherTimetableEntry(id: 'tch-104', day: 'Wednesday', period: 1, startTime: '08:00', endTime: '08:40', subject: 'Elective Mathematics', classForm: 'SHS2 Sci B', room: 'M1'),
    TeacherTimetableEntry(id: 'tch-105', day: 'Friday', period: 3, startTime: '09:20', endTime: '10:00', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', room: 'M2'),
  ];

  List<SyllabusTopic> syllabus = [
    SyllabusTopic(id: 'tch-110', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', topic: 'Differentiation', subTopics: 'Power rule, product rule, quotient rule, chain rule', week: 1, status: 'Completed', dateTaught: '2026-06-28'),
    SyllabusTopic(id: 'tch-111', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', topic: 'Applications of Differentiation', subTopics: 'Max/min problems, rates of change', week: 2, status: 'Completed', dateTaught: '2026-07-05'),
    SyllabusTopic(id: 'tch-112', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', topic: 'Integration', subTopics: 'Indefinite integrals, substitution method', week: 3, status: 'In Progress', notes: 'Started substitution method today'),
    SyllabusTopic(id: 'tch-113', subject: 'Elective Mathematics', classForm: 'SHS2 Sci A', topic: 'Applications of Integration', subTopics: 'Area under curve, volume of revolution', week: 4, status: 'Not Started'),
    SyllabusTopic(id: 'tch-115', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', topic: 'Indices & Logarithms', subTopics: 'Laws of indices, logarithmic functions', week: 1, status: 'Completed', dateTaught: '2026-06-28'),
    SyllabusTopic(id: 'tch-116', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', topic: 'Surds', subTopics: 'Simplification, rationalization', week: 2, status: 'Completed', dateTaught: '2026-07-07'),
    SyllabusTopic(id: 'tch-117', subject: 'Core Mathematics', classForm: 'SHS1 Sci A', topic: 'Sets & Operations', subTopics: 'Set notation, Venn diagrams', week: 3, status: 'In Progress'),
  ];

  List<RemedialStudent> remedial = [
    RemedialStudent(id: 'tch-120', studentName: 'Daniel Osei', admNo: '2026/004', classForm: 'SHS2 Sci A', subject: 'Elective Mathematics', area: 'Factoring quadratics', intervention: 'After-school practice sessions, simplified worksheets', dateStarted: '2026-07-01', progress: 'Improving', notes: 'Showing improvement in simple factoring.'),
  ];

  int get totalStudents => subjects.fold(0, (s, c) => s + c.students);
  int get publishedAssignments => assignments.where((a) => a.status == 'Published').length;

  List<Submission> get pendingGrading => assignments.fold([], (list, a) => list..addAll(a.submissions.where((s) => s.status == 'Submitted' || s.status == 'Late')));

  List<TeacherTimetableEntry> getTodayTimetable(String day) => timetable.where((t) => t.day == day).toList()..sort((a, b) => a.period.compareTo(b.period));

  List<GradebookEntry> getGradebookForClass(String classForm, String subject) => gradebook.where((g) => g.classForm == classForm && g.subject == subject).toList();

  List<AttendanceRecord> getAttendanceForDate(String classForm, String date) => attendance.where((a) => a.classForm == classForm && a.date == date).toList();

  ({int present, int absent, int late, int excused}) getAttendanceStats(String classForm) {
    final records = attendance.where((a) => a.classForm == classForm);
    return (
      present: records.where((a) => a.status == 'Present').length,
      absent: records.where((a) => a.status == 'Absent').length,
      late: records.where((a) => a.status == 'Late').length,
      excused: records.where((a) => a.status == 'Excused').length,
    );
  }

  ({int pct, int completed, int total}) getSyllabusProgress(String subject, String classForm) {
    final topics = syllabus.where((s) => s.subject == subject && s.classForm == classForm).toList();
    final completed = topics.where((t) => t.status == 'Completed').length;
    final total = topics.length;
    return (pct: total > 0 ? (completed / total * 100).round() : 0, completed: completed, total: total);
  }

  void addMaterial({required String title, required String type, required String classForm, required String subject, required String topic, String description = '', String uploadedBy = 'Teacher'}) {
    materials.insert(0, LessonMaterial(id: _nextId(), title: title, type: type, classForm: classForm, subject: subject, topic: topic, description: description, dateUploaded: _todayISO(), uploadedBy: uploadedBy));
    notifyListeners();
  }

  void deleteMaterial(String id) { materials.removeWhere((m) => m.id == id); notifyListeners(); }

  void addAV({required String title, required String type, required String duration, required String classForm, required String subject, required String topic, String recordedBy = 'Teacher'}) {
    avRecordings.insert(0, AVRecording(id: _nextId(), title: title, type: type, duration: duration, classForm: classForm, subject: subject, topic: topic, dateRecorded: _todayISO(), recordedBy: recordedBy));
    notifyListeners();
  }

  void deleteAV(String id) { avRecordings.removeWhere((a) => a.id == id); notifyListeners(); }

  void scheduleLiveSession({required String subject, required String classForm, required String scheduledTime, required String topic}) {
    liveSessions.insert(0, LiveSession(id: _nextId(), subject: subject, classForm: classForm, scheduledTime: scheduledTime, status: 'Scheduled', topic: topic, startedBy: '', participants: 0));
    notifyListeners();
  }

  void startLiveSession(String id, String teacherName) {
    final i = liveSessions.indexWhere((s) => s.id == id);
    if (i >= 0) liveSessions[i] = LiveSession(id: liveSessions[i].id, subject: liveSessions[i].subject, classForm: liveSessions[i].classForm, scheduledTime: liveSessions[i].scheduledTime, status: 'Live', topic: liveSessions[i].topic, startedBy: teacherName, participants: liveSessions[i].participants);
    notifyListeners();
  }

  void endLiveSession(String id) {
    final i = liveSessions.indexWhere((s) => s.id == id);
    if (i >= 0) liveSessions[i] = LiveSession(id: liveSessions[i].id, subject: liveSessions[i].subject, classForm: liveSessions[i].classForm, scheduledTime: liveSessions[i].scheduledTime, status: 'Ended', topic: liveSessions[i].topic, startedBy: liveSessions[i].startedBy, participants: liveSessions[i].participants);
    notifyListeners();
  }

  void cancelLiveSession(String id) { liveSessions.removeWhere((s) => s.id == id); notifyListeners(); }

  void addAssignment({required String title, String description = '', required String classForm, required String subject, required String dueDate, int maxScore = 20, String createdBy = 'Teacher'}) {
    assignments.insert(0, Assignment(id: _nextId(), title: title, description: description, classForm: classForm, subject: subject, dueDate: dueDate, dateCreated: _todayISO(), maxScore: maxScore, status: 'Draft', createdBy: createdBy, submissions: const []));
    notifyListeners();
  }

  void publishAssignment(String id) {
    final i = assignments.indexWhere((a) => a.id == id);
    if (i >= 0) assignments[i] = Assignment(id: assignments[i].id, title: assignments[i].title, description: assignments[i].description, classForm: assignments[i].classForm, subject: assignments[i].subject, dueDate: assignments[i].dueDate, dateCreated: assignments[i].dateCreated, maxScore: assignments[i].maxScore, status: 'Published', createdBy: assignments[i].createdBy, submissions: assignments[i].submissions);
    notifyListeners();
  }

  void closeAssignment(String id) {
    final i = assignments.indexWhere((a) => a.id == id);
    if (i >= 0) assignments[i] = Assignment(id: assignments[i].id, title: assignments[i].title, description: assignments[i].description, classForm: assignments[i].classForm, subject: assignments[i].subject, dueDate: assignments[i].dueDate, dateCreated: assignments[i].dateCreated, maxScore: assignments[i].maxScore, status: 'Closed', createdBy: assignments[i].createdBy, submissions: assignments[i].submissions);
    notifyListeners();
  }

  void deleteAssignment(String id) { assignments.removeWhere((a) => a.id == id); notifyListeners(); }

  void gradeSubmission(String assignmentId, String submissionId, double score, String feedback) {
    final ai = assignments.indexWhere((a) => a.id == assignmentId);
    if (ai < 0) return;
    final subs = List<Submission>.from(assignments[ai].submissions);
    final si = subs.indexWhere((s) => s.id == submissionId);
    if (si < 0) return;
    subs[si] = Submission(id: subs[si].id, studentName: subs[si].studentName, admNo: subs[si].admNo, submittedDate: subs[si].submittedDate, status: 'Graded', score: score, feedback: feedback);
    assignments[ai] = Assignment(id: assignments[ai].id, title: assignments[ai].title, description: assignments[ai].description, classForm: assignments[ai].classForm, subject: assignments[ai].subject, dueDate: assignments[ai].dueDate, dateCreated: assignments[ai].dateCreated, maxScore: assignments[ai].maxScore, status: assignments[ai].status, createdBy: assignments[ai].createdBy, submissions: subs);
    notifyListeners();
  }

  void addAnnouncement({required String title, String body = '', required String classForm, String priority = 'Normal', String postedBy = 'Teacher'}) {
    announcements.insert(0, ClassAnnouncement(id: _nextId(), title: title, body: body, classForm: classForm, date: _todayISO(), postedBy: postedBy, priority: priority));
    notifyListeners();
  }

  void deleteAnnouncement(String id) { announcements.removeWhere((a) => a.id == id); notifyListeners(); }

  void addLessonPlan({required String subject, required String classForm, required String date, required String topic, String objectives = '', String teachingMethods = '', String resources = '', String activities = '', String assessment = '', String homework = '', String? fileName, String? fileUrl}) {
    lessonPlans.insert(0, LessonPlan(id: _nextId(), subject: subject, classForm: classForm, date: date, topic: topic, objectives: objectives, teachingMethods: teachingMethods, resources: resources, activities: activities, assessment: assessment, homework: homework, status: 'Planned', fileName: fileName, fileUrl: fileUrl));
    notifyListeners();
  }

  void deleteLessonPlan(String id) { lessonPlans.removeWhere((l) => l.id == id); notifyListeners(); }

  void markLessonTaught(String id, String reflection) {
    final i = lessonPlans.indexWhere((l) => l.id == id);
    if (i >= 0) lessonPlans[i] = LessonPlan(id: lessonPlans[i].id, subject: lessonPlans[i].subject, classForm: lessonPlans[i].classForm, date: lessonPlans[i].date, topic: lessonPlans[i].topic, objectives: lessonPlans[i].objectives, teachingMethods: lessonPlans[i].teachingMethods, resources: lessonPlans[i].resources, activities: lessonPlans[i].activities, assessment: lessonPlans[i].assessment, homework: lessonPlans[i].homework, status: 'Taught', reflection: reflection, fileName: lessonPlans[i].fileName, fileUrl: lessonPlans[i].fileUrl));
    notifyListeners();
  }

  void addSyllabusTopic({required String subject, required String classForm, required String topic, String subTopics = '', int week = 1}) {
    syllabus.insert(0, SyllabusTopic(id: _nextId(), subject: subject, classForm: classForm, topic: topic, subTopics: subTopics, week: week, status: 'Not Started'));
    notifyListeners();
  }

  void updateSyllabusTopic(String id, {String? status, String? dateTaught, String? notes}) {
    final i = syllabus.indexWhere((s) => s.id == id);
    if (i < 0) return;
    syllabus[i] = SyllabusTopic(id: syllabus[i].id, subject: syllabus[i].subject, classForm: syllabus[i].classForm, topic: syllabus[i].topic, subTopics: syllabus[i].subTopics, week: syllabus[i].week, status: status ?? syllabus[i].status, dateTaught: dateTaught ?? syllabus[i].dateTaught, notes: notes ?? syllabus[i].notes);
    notifyListeners();
  }

  void deleteSyllabusTopic(String id) { syllabus.removeWhere((s) => s.id == id); notifyListeners(); }

  void addRemedialStudent({required String studentName, String admNo = '', required String classForm, required String subject, required String area, String intervention = '', String notes = ''}) {
    remedial.insert(0, RemedialStudent(id: _nextId(), studentName: studentName, admNo: admNo, classForm: classForm, subject: subject, area: area, intervention: intervention, dateStarted: _todayISO(), progress: 'Just Started', notes: notes));
    notifyListeners();
  }

  void updateRemedialProgress(String id, String progress, String notes) {
    final i = remedial.indexWhere((r) => r.id == id);
    if (i < 0) return;
    remedial[i] = RemedialStudent(id: remedial[i].id, studentName: remedial[i].studentName, admNo: remedial[i].admNo, classForm: remedial[i].classForm, subject: remedial[i].subject, area: remedial[i].area, intervention: remedial[i].intervention, dateStarted: remedial[i].dateStarted, progress: progress, notes: notes);
    notifyListeners();
  }

  void deleteRemedialStudent(String id) { remedial.removeWhere((r) => r.id == id); notifyListeners(); }

  void markAttendance(List<AttendanceRecord> records) {
    for (final rec in records) {
      final existing = attendance.indexWhere((a) => a.studentName == rec.studentName && a.date == rec.date && a.classForm == rec.classForm);
      if (existing >= 0) {
        attendance[existing] = AttendanceRecord(id: attendance[existing].id, studentName: rec.studentName, admNo: rec.admNo, classForm: rec.classForm, subject: rec.subject, date: rec.date, status: rec.status);
      } else {
        attendance.add(AttendanceRecord(id: _nextId(), studentName: rec.studentName, admNo: rec.admNo, classForm: rec.classForm, subject: rec.subject, date: rec.date, status: rec.status));
      }
    }
    notifyListeners();
  }
}
