import 'package:flutter/foundation.dart';

class ComplianceItem {
  final String id, document, authority, dueDate, status, notes;
  final String? submittedDate, submittedBy;
  const ComplianceItem({required this.id, required this.document, required this.authority, required this.dueDate, required this.status, required this.notes, this.submittedDate, this.submittedBy});

  ComplianceItem copyWith({String? status, String? submittedDate, String? submittedBy, String? notes}) {
    return ComplianceItem(
      id: id, document: document, authority: authority, dueDate: dueDate,
      status: status ?? this.status, notes: notes ?? this.notes,
      submittedDate: submittedDate ?? this.submittedDate,
      submittedBy: submittedBy ?? this.submittedBy,
    );
  }
}

class AdminAnnouncement {
  final String id, title, body, date, priority, audience, postedBy;
  const AdminAnnouncement({required this.id, required this.title, required this.body, required this.date, required this.priority, required this.audience, required this.postedBy});
}

class FacilityIssue {
  final String id, title, location, category, priority, status, reportedDate, reportedBy, description;
  final String? assignedTo, resolvedDate, resolutionNotes;
  const FacilityIssue({required this.id, required this.title, required this.location, required this.category, required this.priority, required this.status, required this.reportedDate, required this.reportedBy, required this.description, this.assignedTo, this.resolvedDate, this.resolutionNotes});

  FacilityIssue copyWith({String? status, String? assignedTo, String? resolvedDate, String? resolutionNotes}) {
    return FacilityIssue(
      id: id, title: title, location: location, category: category,
      priority: priority, reportedDate: reportedDate, reportedBy: reportedBy,
      description: description, status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }
}

class AdminMeeting {
  final String id, title, date, time, location, facilitator, agenda, status;
  final int attendees;
  final String? minutes, keyDecisions, actionItems;
  const AdminMeeting({required this.id, required this.title, required this.date, required this.time, required this.location, required this.facilitator, required this.agenda, required this.status, required this.attendees, this.minutes, this.keyDecisions, this.actionItems});

  AdminMeeting copyWith({String? status, int? attendees, String? minutes, String? keyDecisions, String? actionItems}) {
    return AdminMeeting(
      id: id, title: title, date: date, time: time, location: location,
      facilitator: facilitator, agenda: agenda,
      status: status ?? this.status, attendees: attendees ?? this.attendees,
      minutes: minutes ?? this.minutes, keyDecisions: keyDecisions ?? this.keyDecisions,
      actionItems: actionItems ?? this.actionItems,
    );
  }
}

class TaskAssignment {
  final String id, title, description, assignedTo, department, dueDate, priority, status, assignedBy, notes;
  const TaskAssignment({required this.id, required this.title, required this.description, required this.assignedTo, required this.department, required this.dueDate, required this.priority, required this.status, required this.assignedBy, required this.notes});

  TaskAssignment copyWith({String? status}) {
    return TaskAssignment(
      id: id, title: title, description: description, assignedTo: assignedTo,
      department: department, dueDate: dueDate, priority: priority,
      status: status ?? this.status, assignedBy: assignedBy, notes: notes,
    );
  }
}

class AdminProvider extends ChangeNotifier {
  final List<ComplianceItem> _compliance = [
    ComplianceItem(id: '1', document: 'Termly Enrollment Return', authority: 'GES', dueDate: '2026-07-15', status: 'Submitted', submittedDate: '2026-07-10', submittedBy: 'Registrar', notes: 'Submitted via GES portal.'),
    ComplianceItem(id: '2', document: 'Staff Establishment Report', authority: 'GES', dueDate: '2026-07-20', status: 'In Progress', notes: 'Awaiting updated staff list from HR.'),
    ComplianceItem(id: '3', document: 'School Improvement Plan (SIP)', authority: 'GES', dueDate: '2026-08-01', status: 'Not Started', notes: 'Draft to be prepared by Academic Office.'),
    ComplianceItem(id: '4', document: 'Annual Safety Audit', authority: 'Ghana Education Service', dueDate: '2026-08-15', status: 'Not Started', notes: 'External auditor to be engaged.'),
    ComplianceItem(id: '5', document: 'Free SHS Capitation Report', authority: 'Ministry of Education', dueDate: '2026-07-31', status: 'In Progress', notes: 'Bursary compiling expenditure data.'),
    ComplianceItem(id: '6', document: 'Internal Audit Report — Q3', authority: 'Internal', dueDate: '2026-07-12', status: 'Overdue', notes: 'Audit committee meeting postponed.'),
  ];

  final List<AdminAnnouncement> _announcements = [
    AdminAnnouncement(id: '1', title: 'Staff General Meeting — July 12', body: 'All staff are required to attend the general meeting on Friday, July 12 at 3:00pm in the main hall.', date: '2026-07-08', priority: 'Urgent', audience: 'All Staff', postedBy: 'Asst. Headmaster (Admin)'),
    AdminAnnouncement(id: '2', title: 'Compliance Deadline Reminder', body: 'Several GES compliance reports are due this month. Department heads should submit their inputs by July 18.', date: '2026-07-06', priority: 'Important', audience: 'All Staff', postedBy: 'Asst. Headmaster (Admin)'),
    AdminAnnouncement(id: '3', title: 'Facility Maintenance Window', body: 'Scheduled maintenance will take place July 15-19. Please report any outstanding facility issues to the admin office.', date: '2026-07-04', priority: 'Normal', audience: 'All Staff', postedBy: 'Admin Office'),
  ];

  final List<FacilityIssue> _facilities = [
    FacilityIssue(id: '1', title: 'Broken classroom door — Room B12', location: 'Block B, Room 12', category: 'Building', priority: 'Medium', status: 'Assigned', reportedDate: '2026-07-05', reportedBy: 'Mr. Mensah', assignedTo: 'Maintenance Team', description: 'Door hinge broken, door cannot close properly.'),
    FacilityIssue(id: '2', title: 'Electrical fault in Science Lab', location: 'Science Block, Lab 2', category: 'Electrical', priority: 'High', status: 'In Progress', reportedDate: '2026-07-03', reportedBy: 'Mr. Adjei', assignedTo: 'Electrician', description: 'Power outlets not working at demonstration bench.'),
    FacilityIssue(id: '3', title: 'Leaking pipe in boys washroom', location: 'Block A, Ground Floor', category: 'Plumbing', priority: 'High', status: 'Reported', reportedDate: '2026-07-08', reportedBy: 'Cleaning Supervisor', description: 'Water leaking from pipe joint.'),
    FacilityIssue(id: '4', title: 'Damaged desks — SHS1 Sci A', location: 'Block C, Room 5', category: 'Furniture', priority: 'Low', status: 'Reported', reportedDate: '2026-07-06', reportedBy: 'Mr. Owusu', description: '5 desks with broken legs need repair.'),
    FacilityIssue(id: '5', title: 'Projector not working — ICT Lab', location: 'ICT Block, Lab 1', category: 'Equipment', priority: 'Medium', status: 'Resolved', reportedDate: '2026-06-28', reportedBy: 'Mr. Owusu', assignedTo: 'ICT Technician', resolvedDate: '2026-07-02', resolutionNotes: 'Lamp replaced. Projector tested and working.', description: 'Projector lamp burned out during lesson.'),
  ];

  final List<AdminMeeting> _meetings = [
    AdminMeeting(id: '1', title: 'Term 3 Mid-Term Review', date: '2026-07-12', time: '15:00', location: 'Main Hall', facilitator: 'Headmaster', agenda: 'Academic performance review, Compliance deadlines, Budget status, Facility maintenance, Staff welfare', status: 'Scheduled', attendees: 0),
    AdminMeeting(id: '2', title: 'Department Heads Strategy Meeting', date: '2026-07-15', time: '14:00', location: 'Conference Room', facilitator: 'Asst. Headmaster (Admin)', agenda: 'Department budget submissions, Staff appraisal progress, Term 3 preparation', status: 'Scheduled', attendees: 0),
    AdminMeeting(id: '3', title: 'End of Term 2 Staff Meeting', date: '2026-06-20', time: '15:00', location: 'Main Hall', facilitator: 'Headmaster', agenda: 'Term 2 review, Exam results analysis, Holiday schedule', status: 'Completed', attendees: 62, minutes: 'Term 2 exams completed with 92% pass rate.', keyDecisions: 'Term 2 exams passed; appraisal timeline approved.', actionItems: 'HODs to submit term reports by June 25.'),
  ];

  final List<TaskAssignment> _tasks = [
    TaskAssignment(id: '1', title: 'Compile Staff Establishment Report', description: 'Gather updated staff list for GES submission.', assignedTo: 'Registrar', department: 'Registry', dueDate: '2026-07-18', priority: 'Urgent', status: 'In Progress', assignedBy: 'Asst. Headmaster (Admin)', notes: 'GES deadline July 20.'),
    TaskAssignment(id: '2', title: 'Prepare Safety Audit RFP', description: 'Draft request for proposal for external safety auditor.', assignedTo: 'Admin Officer', department: 'Administration', dueDate: '2026-07-25', priority: 'Normal', status: 'Pending', assignedBy: 'Asst. Headmaster (Admin)', notes: 'Audit due August 15.'),
    TaskAssignment(id: '3', title: 'Submit Capitation Report Data', description: 'Compile expenditure data for Free SHS capitation report.', assignedTo: 'Accountant', department: 'Finance', dueDate: '2026-07-20', priority: 'Urgent', status: 'In Progress', assignedBy: 'Asst. Headmaster (Admin)', notes: 'MoE deadline July 31.'),
    TaskAssignment(id: '4', title: 'Repair Science Lab Electrical Fault', description: 'Fix power outlets at demonstration bench in Lab 2.', assignedTo: 'Maintenance Team', department: 'Maintenance', dueDate: '2026-07-10', priority: 'High', status: 'In Progress', assignedBy: 'Asst. Headmaster (Admin)', notes: 'Electrician contacted, awaiting parts.'),
    TaskAssignment(id: '5', title: 'Update Staff Directory', description: 'Add new staff entries and update contact information.', assignedTo: 'HR Officer', department: 'Administration', dueDate: '2026-07-15', priority: 'Normal', status: 'Pending', assignedBy: 'Asst. Headmaster (Admin)', notes: ''),
  ];

  // ── Getters ──
  List<ComplianceItem> get compliance => _compliance;
  List<AdminAnnouncement> get announcements => _announcements;
  List<FacilityIssue> get facilities => _facilities;
  List<AdminMeeting> get meetings => _meetings;
  List<TaskAssignment> get tasks => _tasks;

  int get overdueCompliance => _compliance.where((c) => c.status == 'Overdue').length;
  int get openFacilities => _facilities.where((f) => f.status != 'Resolved').length;
  int get pendingTasks => _tasks.where((t) => t.status == 'Pending').length;
  int get scheduledMeetings => _meetings.where((m) => m.status == 'Scheduled').length;

  // ── Compliance CRUD ──
  int _idCounter = 100;
  String _nextId() => 'adm-${_idCounter++}';
  String _todayISO() => DateTime.now().toIso8601String().split('T')[0];

  void addCompliance(ComplianceItem item) {
    _compliance.add(ComplianceItem(
      id: _nextId(), document: item.document, authority: item.authority,
      dueDate: item.dueDate, status: 'Not Started', notes: item.notes,
    ));
    notifyListeners();
  }

  void updateCompliance(String id, {String? status, String? notes}) {
    final idx = _compliance.indexWhere((c) => c.id == id);
    if (idx >= 0) {
      _compliance[idx] = _compliance[idx].copyWith(
        status: status,
        notes: notes,
        submittedDate: status == 'Submitted' ? _todayISO() : null,
        submittedBy: status == 'Submitted' ? 'Asst. Headmaster (Admin)' : null,
      );
      notifyListeners();
    }
  }

  void deleteCompliance(String id) {
    _compliance.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // ── Announcement CRUD ──
  void addAnnouncement(AdminAnnouncement a) {
    _announcements.insert(0, AdminAnnouncement(
      id: _nextId(), title: a.title, body: a.body, date: _todayISO(),
      priority: a.priority, audience: a.audience, postedBy: a.postedBy,
    ));
    notifyListeners();
  }

  void deleteAnnouncement(String id) {
    _announcements.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // ── Facility CRUD ──
  void addFacility(FacilityIssue f) {
    _facilities.insert(0, FacilityIssue(
      id: _nextId(), title: f.title, location: f.location, category: f.category,
      priority: f.priority, status: 'Reported', reportedDate: _todayISO(),
      reportedBy: f.reportedBy, description: f.description,
      assignedTo: f.assignedTo,
    ));
    notifyListeners();
  }

  void updateFacility(String id, {String? status, String? assignedTo}) {
    final idx = _facilities.indexWhere((f) => f.id == id);
    if (idx >= 0) {
      _facilities[idx] = _facilities[idx].copyWith(
        status: status,
        assignedTo: assignedTo,
        resolvedDate: status == 'Resolved' ? _todayISO() : null,
      );
      notifyListeners();
    }
  }

  void deleteFacility(String id) {
    _facilities.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  // ── Meeting CRUD ──
  void addMeeting(AdminMeeting m) {
    _meetings.add(AdminMeeting(
      id: _nextId(), title: m.title, date: m.date, time: m.time,
      location: m.location, facilitator: m.facilitator, agenda: m.agenda,
      status: 'Scheduled', attendees: 0,
    ));
    notifyListeners();
  }

  void completeMeeting(String id, String minutes, String decisions, String actions, int attendees) {
    final idx = _meetings.indexWhere((m) => m.id == id);
    if (idx >= 0) {
      _meetings[idx] = _meetings[idx].copyWith(
        status: 'Completed', attendees: attendees,
        minutes: minutes, keyDecisions: decisions, actionItems: actions,
      );
      notifyListeners();
    }
  }

  void cancelMeeting(String id) {
    final idx = _meetings.indexWhere((m) => m.id == id);
    if (idx >= 0) {
      _meetings[idx] = _meetings[idx].copyWith(status: 'Cancelled');
      notifyListeners();
    }
  }

  void deleteMeeting(String id) {
    _meetings.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // ── Task CRUD ──
  void addTask(TaskAssignment t) {
    _tasks.insert(0, TaskAssignment(
      id: _nextId(), title: t.title, description: t.description,
      assignedTo: t.assignedTo, department: t.department, dueDate: t.dueDate,
      priority: t.priority, status: 'Pending', assignedBy: t.assignedBy, notes: t.notes,
    ));
    notifyListeners();
  }

  void updateTaskStatus(String id, String status) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      _tasks[idx] = _tasks[idx].copyWith(status: status);
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
