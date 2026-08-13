import 'package:flutter/foundation.dart';

class StudentProfile {
  final String admNo, name, className, house, gender, dateOfBirth, guardianName, guardianPhone, programme;
  final String? photoUrl;
  const StudentProfile({required this.admNo, required this.name, required this.className, required this.house, required this.gender, required this.dateOfBirth, required this.guardianName, required this.guardianPhone, required this.programme, this.photoUrl});
}

class StudentTimetableEntry {
  final String day, subject, classForm, room, startTime, endTime;
  final int period;
  const StudentTimetableEntry({required this.day, required this.subject, required this.classForm, required this.room, required this.startTime, required this.endTime, required this.period});
}

class StudentAssignment {
  final String id, title, subject, classForm, dueDate, maxScore, status;
  final int? score;
  final String? submittedDate;
  const StudentAssignment({required this.id, required this.title, required this.subject, required this.classForm, required this.dueDate, required this.maxScore, required this.status, this.score, this.submittedDate});
}

class StudentResult {
  final String exam, subject, grade, score, maxScore, remarks;
  const StudentResult({required this.exam, required this.subject, required this.grade, required this.score, required this.maxScore, required this.remarks});
}

class StudentAttendance {
  final String term, totalDays, present, absent, late, percentage;
  const StudentAttendance({required this.term, required this.totalDays, required this.present, required this.absent, required this.late, required this.percentage});
}

class StudentFeeRecord {
  final String term, feeType, amountDue, amountPaid, balance, status, dueDate;
  const StudentFeeRecord({required this.term, required this.feeType, required this.amountDue, required this.amountPaid, required this.balance, required this.status, required this.dueDate});
}

class StudentLibraryBook {
  final String bookTitle, author, borrowDate, dueDate, status;
  const StudentLibraryBook({required this.bookTitle, required this.author, required this.borrowDate, required this.dueDate, required this.status});
}

class StudentElection {
  final String title, date, status, result;
  const StudentElection({required this.title, required this.date, required this.status, required this.result});
}

class StudentFeedback {
  final String id, date, subject, body, status, response;
  const StudentFeedback({required this.id, required this.date, required this.subject, required this.body, required this.status, required this.response});
}

class StudentProvider extends ChangeNotifier {
  final profile = StudentProfile(
    admNo: '2026/001', name: 'Kwame Asante', className: 'SHS2 Sci A', house: 'Opoku Ware House',
    gender: 'Male', dateOfBirth: '2008-05-12', guardianName: 'Mr. Kofi Asante', guardianPhone: '024-555-1001',
    programme: 'Science',
  );

  final List<StudentTimetableEntry> timetable = [
    StudentTimetableEntry(day: 'Monday', period: 1, subject: 'Mathematics', classForm: 'SHS2 Sci A', room: 'A12', startTime: '08:00', endTime: '08:40'),
    StudentTimetableEntry(day: 'Monday', period: 2, subject: 'English', classForm: 'SHS2 Sci A', room: 'A12', startTime: '08:40', endTime: '09:20'),
    StudentTimetableEntry(day: 'Monday', period: 3, subject: 'Physics', classForm: 'SHS2 Sci A', room: 'Lab 1', startTime: '09:20', endTime: '10:00'),
    StudentTimetableEntry(day: 'Monday', period: 4, subject: 'Chemistry', classForm: 'SHS2 Sci A', room: 'Lab 2', startTime: '10:20', endTime: '11:00'),
    StudentTimetableEntry(day: 'Monday', period: 5, subject: 'Biology', classForm: 'SHS2 Sci A', room: 'Lab 3', startTime: '11:00', endTime: '11:40'),
    StudentTimetableEntry(day: 'Tuesday', period: 1, subject: 'Mathematics', classForm: 'SHS2 Sci A', room: 'A12', startTime: '08:00', endTime: '08:40'),
    StudentTimetableEntry(day: 'Tuesday', period: 2, subject: 'ICT', classForm: 'SHS2 Sci A', room: 'ICT Lab', startTime: '08:40', endTime: '09:20'),
  ];

  final List<StudentAssignment> assignments = [
    StudentAssignment(id: 'a1', title: 'Algebra Worksheet 5', subject: 'Mathematics', classForm: 'SHS2 Sci A', dueDate: '2026-07-15', maxScore: '20', status: 'Submitted', score: 18, submittedDate: '2026-07-14'),
    StudentAssignment(id: 'a2', title: 'Essay: Climate Change', subject: 'English', classForm: 'SHS2 Sci A', dueDate: '2026-07-18', maxScore: '30', status: 'Pending'),
    StudentAssignment(id: 'a3', title: 'Lab Report: Acids & Bases', subject: 'Chemistry', classForm: 'SHS2 Sci A', dueDate: '2026-07-12', maxScore: '25', status: 'Graded', score: 22, submittedDate: '2026-07-11'),
    StudentAssignment(id: 'a4', title: 'Newton\'s Laws Problems', subject: 'Physics', classForm: 'SHS2 Sci A', dueDate: '2026-07-20', maxScore: '20', status: 'Pending'),
  ];

  final List<StudentResult> results = [
    StudentResult(exam: 'Mid-Term 3', subject: 'Mathematics', grade: 'A1', score: '88', maxScore: '100', remarks: 'Excellent'),
    StudentResult(exam: 'Mid-Term 3', subject: 'English', grade: 'B2', score: '75', maxScore: '100', remarks: 'Very Good'),
    StudentResult(exam: 'Mid-Term 3', subject: 'Physics', grade: 'A1', score: '92', maxScore: '100', remarks: 'Excellent'),
    StudentResult(exam: 'Mid-Term 3', subject: 'Chemistry', grade: 'B3', score: '70', maxScore: '100', remarks: 'Good'),
    StudentResult(exam: 'Mid-Term 3', subject: 'Biology', grade: 'A1', score: '85', maxScore: '100', remarks: 'Excellent'),
    StudentResult(exam: 'Mid-Term 3', subject: 'ICT', grade: 'A1', score: '90', maxScore: '100', remarks: 'Excellent'),
  ];

  final List<StudentAttendance> attendance = [
    StudentAttendance(term: 'Term 3 2025/2026', totalDays: '60', present: '57', absent: '2', late: '1', percentage: '95.0%'),
  ];

  final List<StudentFeeRecord> fees = [
    StudentFeeRecord(term: 'Term 3 2025/2026', feeType: 'Tuition', amountDue: '1200', amountPaid: '1200', balance: '0', status: 'Cleared', dueDate: '2026-01-31'),
    StudentFeeRecord(term: 'Term 3 2025/2026', feeType: 'Boarding', amountDue: '800', amountPaid: '800', balance: '0', status: 'Cleared', dueDate: '2026-01-31'),
  ];

  final List<StudentLibraryBook> libraryBooks = [
    StudentLibraryBook(bookTitle: 'Advanced Mathematics', author: 'B. Adjei', borrowDate: '2026-07-01', dueDate: '2026-07-15', status: 'Borrowed'),
    StudentLibraryBook(bookTitle: 'Organic Chemistry', author: 'R. Morrison', borrowDate: '2026-06-20', dueDate: '2026-07-05', status: 'Returned'),
  ];

  final List<StudentElection> elections = [
    StudentElection(title: 'SRC President 2026/2027', date: '2026-09-15', status: 'Upcoming', result: '—'),
  ];

  final List<StudentFeedback> feedback = [
    StudentFeedback(id: 'f1', date: '2026-07-05', subject: 'Library hours', body: 'Request for extended library hours during exam week.', status: 'Acknowledged', response: 'Under consideration by Academic Office.'),
  ];

  int get pendingAssignments => assignments.where((a) => a.status == 'Pending').length;
  String get avgScore {
    final graded = results.where((r) => r.score.isNotEmpty).toList();
    if (graded.isEmpty) return '—';
    final total = graded.fold(0, (s, r) => s + int.parse(r.score));
    return '${(total / graded.length).toStringAsFixed(1)}%';
  }
}
