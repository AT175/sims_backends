import 'package:flutter/foundation.dart';

class ParentWard {
  final String admNo, name, className, house, gender;
  final String attendancePct, avgScore, feesStatus, lastGrade;
  final String? healthAlert;
  const ParentWard({required this.admNo, required this.name, required this.className, required this.house, required this.gender, required this.attendancePct, required this.avgScore, required this.feesStatus, required this.lastGrade, this.healthAlert});
}

class ParentAcademicReport {
  final String term, subject, grade, score, maxScore, remarks, classAvg;
  const ParentAcademicReport({required this.term, required this.subject, required this.grade, required this.score, required this.maxScore, required this.remarks, required this.classAvg});
}

class ParentAttendance {
  final String term, totalDays, present, absent, late, percentage;
  const ParentAttendance({required this.term, required this.totalDays, required this.present, required this.absent, required this.late, required this.percentage});
}

class ParentExeat {
  final String exeatNo, studentName, reason, departureDate, returnDate, status;
  const ParentExeat({required this.exeatNo, required this.studentName, required this.reason, required this.departureDate, required this.returnDate, required this.status});
}

class ParentDiscipline {
  final String date, studentName, incident, action, severity;
  const ParentDiscipline({required this.date, required this.studentName, required this.incident, required this.action, required this.severity});
}

class ParentAnnouncement {
  final String title, date, author, body;
  const ParentAnnouncement({required this.title, required this.date, required this.author, required this.body});
}

class ParentMeeting {
  final String date, time, topic, location, rsvp;
  const ParentMeeting({required this.date, required this.time, required this.topic, required this.location, required this.rsvp});
}

class ParentPayment {
  final String date, description, amount, method, term, status;
  const ParentPayment({required this.date, required this.description, required this.amount, required this.method, required this.term, required this.status});
}

class ParentFundraising {
  final String project, targetAmount, raisedAmount, myContribution;
  const ParentFundraising({required this.project, required this.targetAmount, required this.raisedAmount, required this.myContribution});
}

class ParentDirectoryEntry {
  final String name, phone, wardName, wardClass;
  const ParentDirectoryEntry({required this.name, required this.phone, required this.wardName, required this.wardClass});
}

class ParentProvider extends ChangeNotifier {
  final List<ParentWard> wards = [
    ParentWard(admNo: '2026/001', name: 'Kwame Asante', className: 'SHS2 Sci A', house: 'Opoku Ware House', gender: 'Male', attendancePct: '95%', avgScore: '85.7%', feesStatus: 'Cleared', lastGrade: 'A1', healthAlert: null),
    ParentWard(admNo: '2026/003', name: 'Yao Mensah', className: 'SHS3 Bus A', house: 'Butler House', gender: 'Male', attendancePct: '92%', avgScore: '78.3%', feesStatus: 'Partial', lastGrade: 'B2', healthAlert: 'Asthma (mild)'),
  ];

  final List<ParentAcademicReport> academicReports = [
    ParentAcademicReport(term: 'Term 3 2025/2026', subject: 'Mathematics', grade: 'A1', score: '88', maxScore: '100', remarks: 'Excellent', classAvg: '72'),
    ParentAcademicReport(term: 'Term 3 2025/2026', subject: 'English', grade: 'B2', score: '75', maxScore: '100', remarks: 'Very Good', classAvg: '68'),
    ParentAcademicReport(term: 'Term 3 2025/2026', subject: 'Physics', grade: 'A1', score: '92', maxScore: '100', remarks: 'Excellent', classAvg: '70'),
    ParentAcademicReport(term: 'Term 3 2025/2026', subject: 'Chemistry', grade: 'B3', score: '70', maxScore: '100', remarks: 'Good', classAvg: '65'),
  ];

  final List<ParentAttendance> attendance = [
    ParentAttendance(term: 'Term 3 2025/2026', totalDays: '60', present: '57', absent: '2', late: '1', percentage: '95.0%'),
  ];

  final List<ParentExeat> exeats = [
    ParentExeat(exeatNo: 'EX-2026-015', studentName: 'Kwame Asante', reason: 'Family event', departureDate: '2026-06-20', returnDate: '2026-06-22', status: 'Approved'),
  ];

  final List<ParentDiscipline> discipline = [
    ParentDiscipline(date: '2026-05-10', studentName: 'Yao Mensah', incident: 'Late to class (3rd time)', action: 'Warning', severity: 'Minor'),
  ];

  final List<ParentAnnouncement> announcements = [
    ParentAnnouncement(title: 'PTA Meeting Scheduled', date: '2026-07-20', author: 'Headmaster', body: 'Dear parents, the next PTA meeting will be held on 25th July at 10am in the main hall.'),
    ParentAnnouncement(title: 'Mid-term Exams', date: '2026-07-08', author: 'Academic Office', body: 'Mid-term examinations begin on 5th August. Students should prepare accordingly.'),
  ];

  final List<ParentMeeting> meetings = [
    ParentMeeting(date: '2026-07-25', time: '10:00', topic: 'General PTA Meeting', location: 'Main Hall', rsvp: 'Pending'),
  ];

  final List<ParentPayment> payments = [
    ParentPayment(date: '2026-01-10', description: 'Tuition - Term 3', amount: '1200', method: 'Bank Transfer', term: 'Term 3 2025/2026', status: 'Completed'),
    ParentPayment(date: '2026-01-15', description: 'Boarding - Term 3', amount: '800', method: 'Cash', term: 'Term 3 2025/2026', status: 'Completed'),
  ];

  final List<ParentFundraising> fundraising = [
    ParentFundraising(project: 'School Bus Fund', targetAmount: '50000', raisedAmount: '32000', myContribution: '500'),
    ParentFundraising(project: 'ICT Lab Upgrade', targetAmount: '30000', raisedAmount: '12000', myContribution: '200'),
  ];

  final List<ParentDirectoryEntry> directory = [
    ParentDirectoryEntry(name: 'Mr. Kofi Asante', phone: '024-555-1001', wardName: 'Kwame Asante', wardClass: 'SHS2 Sci A'),
    ParentDirectoryEntry(name: 'Mrs. Akosua Owusu', phone: '027-555-1002', wardName: 'Ama Owusu', wardClass: 'SHS1 Arts B'),
    ParentDirectoryEntry(name: 'Mr. Daniel Mensah', phone: '020-555-1003', wardName: 'Yao Mensah', wardClass: 'SHS3 Bus A'),
  ];
}
