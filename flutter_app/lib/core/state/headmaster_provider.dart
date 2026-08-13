import 'package:flutter/foundation.dart';

// ── Types (mirrors RN headmasterStore.ts) ──

enum HmApprovalStatus { pending, approved, rejected }
enum DisciplineSeverity { minor, serious, critical }
enum DisciplineStatus { open, escalated, resolved }
enum BroadcastAudience { everyone, allStaff, teachingStaff, nonTeachingStaff, allStudents, parents }
enum BroadcastPriority { normal, important, urgent }

extension HmApprovalStatusX on HmApprovalStatus {
  String get label => switch (this) {
    HmApprovalStatus.pending => 'Pending',
    HmApprovalStatus.approved => 'Approved',
    HmApprovalStatus.rejected => 'Rejected',
  };
}

extension DisciplineSeverityX on DisciplineSeverity {
  String get label => switch (this) {
    DisciplineSeverity.minor => 'minor',
    DisciplineSeverity.serious => 'serious',
    DisciplineSeverity.critical => 'critical',
  };
}

extension DisciplineStatusX on DisciplineStatus {
  String get label => switch (this) {
    DisciplineStatus.open => 'Open',
    DisciplineStatus.escalated => 'Escalated',
    DisciplineStatus.resolved => 'Resolved',
  };
}

extension BroadcastAudienceX on BroadcastAudience {
  String get label => switch (this) {
    BroadcastAudience.everyone => 'Everyone',
    BroadcastAudience.allStaff => 'All Staff',
    BroadcastAudience.teachingStaff => 'Teaching Staff',
    BroadcastAudience.nonTeachingStaff => 'Non-Teaching Staff',
    BroadcastAudience.allStudents => 'All Students',
    BroadcastAudience.parents => 'Parents',
  };
}

extension BroadcastPriorityX on BroadcastPriority {
  String get label => switch (this) {
    BroadcastPriority.normal => 'Normal',
    BroadcastPriority.important => 'Important',
    BroadcastPriority.urgent => 'Urgent',
  };
}

class HmApproval {
  final String id;
  final String category;
  final String requester;
  final String department;
  final String date;
  final String details;
  final HmApprovalStatus status;
  final String? reviewedBy;
  final String? reviewDate;
  final String? reviewNotes;

  const HmApproval({
    required this.id,
    required this.category,
    required this.requester,
    required this.department,
    required this.date,
    required this.details,
    required this.status,
    this.reviewedBy,
    this.reviewDate,
    this.reviewNotes,
  });

  HmApproval copyWith({
    HmApprovalStatus? status,
    String? reviewedBy,
    String? reviewDate,
    String? reviewNotes,
  }) => HmApproval(
    id: id, category: category, requester: requester, department: department,
    date: date, details: details, status: status ?? this.status,
    reviewedBy: reviewedBy ?? this.reviewedBy,
    reviewDate: reviewDate ?? this.reviewDate,
    reviewNotes: reviewNotes ?? this.reviewNotes,
  );
}

class HmDisciplineCase {
  final String id;
  final String student;
  final String house;
  final String incident;
  final String date;
  final DisciplineSeverity severity;
  final DisciplineStatus status;
  final String reportedBy;
  final String? resolutionNotes;
  final String? resolvedDate;

  const HmDisciplineCase({
    required this.id,
    required this.student,
    required this.house,
    required this.incident,
    required this.date,
    required this.severity,
    required this.status,
    required this.reportedBy,
    this.resolutionNotes,
    this.resolvedDate,
  });

  HmDisciplineCase copyWith({
    DisciplineStatus? status,
    String? resolutionNotes,
    String? resolvedDate,
  }) => HmDisciplineCase(
    id: id, student: student, house: house, incident: incident, date: date,
    severity: severity, status: status ?? this.status, reportedBy: reportedBy,
    resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    resolvedDate: resolvedDate ?? this.resolvedDate,
  );
}

class HmBroadcast {
  final String id;
  final String title;
  final String body;
  final BroadcastAudience audience;
  final BroadcastPriority priority;
  final String date;
  final String postedBy;

  const HmBroadcast({
    required this.id,
    required this.title,
    required this.body,
    required this.audience,
    required this.priority,
    required this.date,
    required this.postedBy,
  });
}

// ── Provider ──

class HeadmasterProvider extends ChangeNotifier {
  final List<HmApproval> _approvals = [
    HmApproval(id: '1', category: 'Procurement', requester: 'Stores Unit', department: 'Stores', date: '2026-07-04', details: 'Bulk purchase of textbooks and lab equipment for Term 3.', status: HmApprovalStatus.pending),
    HmApproval(id: '2', category: 'Budget Revision', requester: 'Bursary', department: 'Bursary', date: '2026-07-03', details: 'Revise Term 3 catering budget upward by GH₵5,000 due to price increases.', status: HmApprovalStatus.pending),
    HmApproval(id: '3', category: 'Discipline Escalation', requester: 'Aggrey House', department: 'Boarding', date: '2026-07-02', details: 'Repeated bullying incident requiring headmaster review for possible suspension.', status: HmApprovalStatus.pending),
  ];

  final List<HmDisciplineCase> _disciplineCases = [
    HmDisciplineCase(id: '1', student: 'Kwame Asante', house: 'Aggrey', incident: 'Bullying', date: '2026-07-05', severity: DisciplineSeverity.serious, status: DisciplineStatus.escalated, reportedBy: 'Housemaster'),
    HmDisciplineCase(id: '2', student: 'Ama Owusu', house: 'Mensah', incident: 'Repeated lateness', date: '2026-07-03', severity: DisciplineSeverity.minor, status: DisciplineStatus.open, reportedBy: 'Class Prefect'),
  ];

  final List<HmBroadcast> _broadcasts = [
    HmBroadcast(id: '1', title: 'Term 3 Mid-Semester Exam Schedule', body: 'All students should note the revised exam dates starting July 15.', audience: BroadcastAudience.allStudents, priority: BroadcastPriority.important, date: '2026-07-05', postedBy: 'Headmaster'),
  ];

  List<HmApproval> get approvals => List.unmodifiable(_approvals);
  List<HmDisciplineCase> get disciplineCases => List.unmodifiable(_disciplineCases);
  List<HmBroadcast> get broadcasts => List.unmodifiable(_broadcasts);

  List<HmApproval> getPendingApprovals() => _approvals.where((a) => a.status == HmApprovalStatus.pending).toList();
  int get pendingApprovalsCount => _approvals.where((a) => a.status == HmApprovalStatus.pending).length;

  int _idCounter = 100;
  String _nextId() => (++_idCounter).toString();
  String _todayISO() => DateTime.now().toIso8601String().substring(0, 10);

  void addApproval({required String category, required String requester, required String department, required String details}) {
    _approvals.insert(0, HmApproval(
      id: _nextId(), category: category, requester: requester, department: department,
      date: _todayISO(), details: details, status: HmApprovalStatus.pending,
    ));
    notifyListeners();
  }

  void reviewApproval(String id, HmApprovalStatus status, String reviewedBy, [String? notes]) {
    final idx = _approvals.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      _approvals[idx] = _approvals[idx].copyWith(
        status: status, reviewedBy: reviewedBy, reviewDate: _todayISO(), reviewNotes: notes,
      );
      notifyListeners();
    }
  }

  void addDisciplineCase({required String student, required String house, required String incident, required DisciplineSeverity severity, required String reportedBy}) {
    _disciplineCases.insert(0, HmDisciplineCase(
      id: _nextId(), student: student, house: house, incident: incident,
      date: _todayISO(), severity: severity, status: DisciplineStatus.open, reportedBy: reportedBy,
    ));
    notifyListeners();
  }

  void escalateDisciplineCase(String id) {
    final idx = _disciplineCases.indexWhere((d) => d.id == id);
    if (idx >= 0) {
      _disciplineCases[idx] = _disciplineCases[idx].copyWith(status: DisciplineStatus.escalated);
      notifyListeners();
    }
  }

  void resolveDisciplineCase(String id, String notes) {
    final idx = _disciplineCases.indexWhere((d) => d.id == id);
    if (idx >= 0) {
      _disciplineCases[idx] = _disciplineCases[idx].copyWith(
        status: DisciplineStatus.resolved, resolutionNotes: notes, resolvedDate: _todayISO(),
      );
      notifyListeners();
    }
  }

  void addBroadcast({required String title, required String body, required BroadcastAudience audience, required BroadcastPriority priority, required String postedBy}) {
    _broadcasts.insert(0, HmBroadcast(
      id: _nextId(), title: title, body: body, audience: audience,
      priority: priority, date: _todayISO(), postedBy: postedBy,
    ));
    notifyListeners();
  }

  void deleteApproval(String id) { _approvals.removeWhere((a) => a.id == id); notifyListeners(); }
  void deleteDisciplineCase(String id) { _disciplineCases.removeWhere((d) => d.id == id); notifyListeners(); }
  void deleteBroadcast(String id) { _broadcasts.removeWhere((b) => b.id == id); notifyListeners(); }
}
