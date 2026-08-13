import 'package:flutter/foundation.dart';

class PtaWard {
  final String id, name, className, house, attendance, avgScore, feesStatus;
  const PtaWard({required this.id, required this.name, required this.className, required this.house, required this.attendance, required this.avgScore, required this.feesStatus});
}

class PtaAnnouncement {
  final String id, title, body, date, author;
  const PtaAnnouncement({required this.id, required this.title, required this.body, required this.date, required this.author});
}

class FundraisingProject {
  final String id, project, description;
  final double targetAmount, raisedAmount;
  const FundraisingProject({required this.id, required this.project, required this.targetAmount, required this.raisedAmount, this.description = ''});
}

class PtaMeeting {
  final String id, date, time, topic, location, rsvp;
  const PtaMeeting({required this.id, required this.date, required this.time, required this.topic, required this.location, required this.rsvp});
}

class ParentDirectoryEntry {
  final String id, name, phone, ptaRole, wardNames;
  const ParentDirectoryEntry({required this.id, required this.name, required this.phone, required this.ptaRole, required this.wardNames});
}

class PtaFeedback {
  final String id, date, subject, body, status;
  final String? response;
  const PtaFeedback({required this.id, required this.date, required this.subject, required this.body, required this.status, this.response});
}

class PtaDue {
  final String id, term, dueDate;
  final double amount, amountPaid;
  final String status;
  final String? paidDate, method;
  const PtaDue({required this.id, required this.term, required this.amount, required this.amountPaid, required this.status, required this.dueDate, this.paidDate, this.method});
}

class PtaTransaction {
  final String id, type, category, description, date, method, recordedBy;
  final double amount;
  const PtaTransaction({required this.id, required this.type, required this.category, required this.description, required this.amount, required this.date, required this.method, required this.recordedBy});
}

class PtaBudget {
  final String id, name, term;
  final double allocated, spent;
  const PtaBudget({required this.id, required this.name, required this.allocated, required this.spent, required this.term});
}

class PtaProvider extends ChangeNotifier {
  final List<PtaWard> wards = [
    PtaWard(id: '1', name: 'Kwame Asante', className: 'SHS2 Sci A', house: 'Aggrey', attendance: '92.5%', avgScore: '75.7%', feesStatus: 'Cleared'),
    PtaWard(id: '2', name: 'Adwoa Asante', className: 'SHS1 Arts B', house: 'Mensah', attendance: '96%', avgScore: '81.2%', feesStatus: 'Cleared'),
  ];

  final List<PtaAnnouncement> announcements = [
    PtaAnnouncement(id: '1', title: 'Term 3 Mid-Semester Exam Schedule', body: 'Exams begin July 15. Please ensure your ward is prepared.', date: '2026-07-05', author: 'Headmaster'),
    PtaAnnouncement(id: '2', title: 'PTA General Meeting - July 20', body: 'All parents are invited to the general meeting at 10am in the assembly hall.', date: '2026-07-03', author: 'PTA Chairman'),
    PtaAnnouncement(id: '3', title: 'Visiting day rescheduled', body: 'Visiting day moved from July 7 to July 14.', date: '2026-06-28', author: 'Headmaster'),
  ];

  final List<FundraisingProject> fundraising = [
    FundraisingProject(id: '1', project: 'New Library Books', targetAmount: 15000, raisedAmount: 9200),
    FundraisingProject(id: '2', project: 'School Bus Fund', targetAmount: 80000, raisedAmount: 45000),
    FundraisingProject(id: '3', project: 'ICT Lab Upgrade', targetAmount: 30000, raisedAmount: 12500),
  ];

  final List<PtaMeeting> meetings = [
    PtaMeeting(id: '1', date: '2026-07-20', time: '10:00 AM', topic: 'General Meeting - Term 3 Review', location: 'Assembly Hall', rsvp: 'Not Responded'),
    PtaMeeting(id: '2', date: '2026-08-15', time: '2:00 PM', topic: 'Executive Committee Meeting', location: 'Staff Common Room', rsvp: 'Not Responded'),
    PtaMeeting(id: '3', date: '2026-09-05', time: '10:00 AM', topic: 'New Academic Year Planning', location: 'Assembly Hall', rsvp: 'Not Responded'),
  ];

  final List<ParentDirectoryEntry> directory = [
    ParentDirectoryEntry(id: '1', name: 'Mr. Asante', phone: '024-XXX-XXXX', ptaRole: 'Member', wardNames: 'Kwame, Adwoa'),
    ParentDirectoryEntry(id: '2', name: 'Mrs. Owusu', phone: '027-XXX-XXXX', ptaRole: 'Class Rep (SHS1)', wardNames: 'Kofi'),
    ParentDirectoryEntry(id: '3', name: 'Mr. Mensah', phone: '020-XXX-XXXX', ptaRole: 'Treasurer', wardNames: 'Ama'),
  ];

  final List<PtaFeedback> feedback = [
    PtaFeedback(id: '1', date: '2026-07-02', subject: 'Suggestion: more library hours', body: 'The library closes too early. Could it stay open until 6pm?', status: 'Received'),
    PtaFeedback(id: '2', date: '2026-06-15', subject: 'Compliment: good exam organization', body: 'The mid-term exams were very well organized.', status: 'Acknowledged', response: 'Thank you for your kind words.'),
  ];

  final List<PtaDue> dues = [
    PtaDue(id: '1', term: 'Term 3 2025/2026', amount: 200, amountPaid: 200, status: 'Paid', dueDate: '2026-01-15', paidDate: '2026-01-10', method: 'Mobile Money'),
    PtaDue(id: '2', term: 'Term 1 2026/2027', amount: 200, amountPaid: 0, status: 'Owing', dueDate: '2026-09-15'),
  ];

  final List<PtaTransaction> transactions = [
    PtaTransaction(id: '1', type: 'Income', category: 'PTA Dues', description: 'Term 3 dues collection', amount: 400, date: '2026-01-10', method: 'Mobile Money', recordedBy: 'PTA Treasurer'),
    PtaTransaction(id: '2', type: 'Income', category: 'Fundraising', description: 'Library Books fund contribution', amount: 800, date: '2026-05-10', method: 'Cash', recordedBy: 'PTA Treasurer'),
    PtaTransaction(id: '3', type: 'Income', category: 'Donation', description: 'Anonymous donor - Bus Fund', amount: 5000, date: '2026-04-15', method: 'Bank Transfer', recordedBy: 'PTA Chairman'),
    PtaTransaction(id: '4', type: 'Expense', category: 'Events', description: 'General Meeting refreshments', amount: 350, date: '2026-03-20', method: 'Cash', recordedBy: 'PTA Treasurer'),
    PtaTransaction(id: '5', type: 'Expense', category: 'Logistics', description: 'Printing and stationery for PTA', amount: 120, date: '2026-02-05', method: 'Cash', recordedBy: 'PTA Secretary'),
    PtaTransaction(id: '6', type: 'Expense', category: 'Venue Hire', description: 'Hall rental for AGM', amount: 200, date: '2026-03-18', method: 'Bank Transfer', recordedBy: 'PTA Treasurer'),
  ];

  final List<PtaBudget> budgets = [
    PtaBudget(id: '1', name: 'Events & Meetings', allocated: 2000, spent: 550, term: '2025/2026'),
    PtaBudget(id: '2', name: 'Logistics & Stationery', allocated: 800, spent: 120, term: '2025/2026'),
    PtaBudget(id: '3', name: 'Welfare Support', allocated: 1500, spent: 0, term: '2025/2026'),
    PtaBudget(id: '4', name: 'Project Fund', allocated: 5000, spent: 0, term: '2025/2026'),
  ];

  double get totalIncome => transactions.where((t) => t.type == 'Income').fold(0, (s, t) => s + t.amount);
  double get totalExpense => transactions.where((t) => t.type == 'Expense').fold(0, (s, t) => s + t.amount);
  double get totalRaised => fundraising.fold(0, (s, f) => s + f.raisedAmount);
  double get totalTarget => fundraising.fold(0, (s, f) => s + f.targetAmount);
}
