import 'package:flutter/foundation.dart';

class CleaningTask {
  final String id, task, area, frequency, assignedTo, date, priority;
  final bool done;
  const CleaningTask({required this.id, required this.task, required this.area, required this.frequency, required this.assignedTo, required this.date, required this.priority, required this.done});
}

class MaintenanceIssue {
  final String id, date, location, issue, priority, status, reportedBy, notes;
  const MaintenanceIssue({required this.id, required this.date, required this.location, required this.issue, required this.priority, required this.status, required this.reportedBy, required this.notes});
}

class InspectionReport {
  final String id, date, area, inspector, result, notes;
  final int score;
  const InspectionReport({required this.id, required this.date, required this.area, required this.inspector, required this.result, required this.score, required this.notes});
}

class CleaningStaff {
  final String id, name, role, area, phone, status;
  final bool todayCheckedIn;
  const CleaningStaff({required this.id, required this.name, required this.role, required this.area, required this.phone, required this.status, required this.todayCheckedIn});
}

class CleaningSupply {
  final String id, name, unit, category;
  final int quantity, reorderLevel;
  const CleaningSupply({required this.id, required this.name, required this.unit, required this.category, required this.quantity, required this.reorderLevel});
}

class DutyRosterEntry {
  final String id, area, assignedTo, frequency, time, status;
  const DutyRosterEntry({required this.id, required this.area, required this.assignedTo, required this.frequency, required this.time, required this.status});
}

class CleaningProvider extends ChangeNotifier {
  int _idCounter = 200;
  String _nextId() { _idCounter++; return '$_idCounter'; }
  String _today() => DateTime.now().toIso8601String().split('T')[0];

  final List<CleaningTask> _tasks = [
    CleaningTask(id: '1', task: 'Assembly hall swept & mopped', area: 'Assembly Hall', frequency: 'Daily', assignedTo: 'Mr. Kofi', date: '2026-07-08', priority: 'High', done: true),
    CleaningTask(id: '2', task: 'Dining hall cleaned after breakfast', area: 'Dining Hall', frequency: 'Daily', assignedTo: 'Ms. Esi', date: '2026-07-08', priority: 'High', done: true),
    CleaningTask(id: '3', task: 'Dining hall cleaned after lunch', area: 'Dining Hall', frequency: 'Daily', assignedTo: 'Ms. Esi', date: '2026-07-08', priority: 'High', done: false),
    CleaningTask(id: '4', task: 'Dormitory A toilets cleaned', area: 'Dormitory A', frequency: 'Daily', assignedTo: 'Mr. Yaw', date: '2026-07-08', priority: 'High', done: true),
    CleaningTask(id: '5', task: 'Dormitory B toilets cleaned', area: 'Dormitory B', frequency: 'Daily', assignedTo: 'Mr. Yaw', date: '2026-07-08', priority: 'High', done: false),
    CleaningTask(id: '6', task: 'Admin block windows cleaned', area: 'Admin Block', frequency: 'Weekly', assignedTo: 'Ms. Adjoa', date: '2026-07-08', priority: 'Medium', done: false),
    CleaningTask(id: '7', task: 'Waste bins emptied', area: 'Grounds', frequency: 'Daily', assignedTo: 'Mr. Samuel', date: '2026-07-08', priority: 'Medium', done: true),
    CleaningTask(id: '8', task: 'Library floor vacuumed', area: 'Library', frequency: 'Daily', assignedTo: 'Ms. Adjoa', date: '2026-07-08', priority: 'Low', done: false),
    CleaningTask(id: '9', task: 'Laboratory surfaces disinfected', area: 'Laboratory', frequency: 'Daily', assignedTo: 'Mr. Kofi', date: '2026-07-08', priority: 'High', done: false),
    CleaningTask(id: '10', task: 'Toilets Block A disinfected', area: 'Toilets Block A', frequency: 'Daily', assignedTo: 'Mr. Yaw', date: '2026-07-08', priority: 'High', done: true),
  ];

  final List<MaintenanceIssue> _issues = [
    MaintenanceIssue(id: '1', date: '2026-07-05', location: 'Dorm B toilet', issue: 'Broken pipe', priority: 'High', status: 'Reported', reportedBy: 'Mr. Yaw', notes: 'Water leaking continuously, needs plumber'),
    MaintenanceIssue(id: '2', date: '2026-07-03', location: 'Dining hall', issue: 'Cracked window', priority: 'Low', status: 'Repair Scheduled', reportedBy: 'Ms. Esi', notes: 'Window pane cracked, glass dangerous'),
    MaintenanceIssue(id: '3', date: '2026-06-28', location: 'Assembly hall', issue: 'Faulty light', priority: 'Medium', status: 'Fixed', reportedBy: 'Mr. Kofi', notes: 'Light fixed by maintenance team'),
  ];

  final List<InspectionReport> _inspections = [
    InspectionReport(id: '1', date: '2026-07-05', area: 'Dormitories', inspector: 'Mr. Tetteh', result: 'Passed', score: 92, notes: 'Generally clean, minor issues in Block B'),
    InspectionReport(id: '2', date: '2026-07-03', area: 'Dining Hall', inspector: 'Mrs. Adjei', result: 'Passed', score: 88, notes: 'Good standard, floor needs more attention'),
    InspectionReport(id: '3', date: '2026-06-28', area: 'Toilets (Block A)', inspector: 'Mr. Tetteh', result: 'Needs Attention', score: 65, notes: 'Soap dispensers empty, floor wet'),
  ];

  final List<CleaningStaff> _staff = [
    CleaningStaff(id: '1', name: 'Mr. Kofi', role: 'Senior Cleaner', area: 'Assembly Hall + Lab', phone: '024 111 2222', status: 'Present', todayCheckedIn: true),
    CleaningStaff(id: '2', name: 'Ms. Esi', role: 'Cleaner', area: 'Dining Hall', phone: '024 333 4444', status: 'Present', todayCheckedIn: true),
    CleaningStaff(id: '3', name: 'Mr. Yaw', role: 'Cleaner', area: 'Dormitories', phone: '024 555 6666', status: 'Present', todayCheckedIn: false),
    CleaningStaff(id: '4', name: 'Ms. Adjoa', role: 'Cleaner', area: 'Admin Block + Library', phone: '024 777 8888', status: 'Present', todayCheckedIn: true),
    CleaningStaff(id: '5', name: 'Mr. Samuel', role: 'Groundskeeper', area: 'Grounds', phone: '024 999 0000', status: 'On Leave', todayCheckedIn: false),
    CleaningStaff(id: '6', name: 'Mr. Daniel', role: 'Cleaner', area: 'Toilets', phone: '020 111 3333', status: 'Present', todayCheckedIn: false),
  ];

  final List<CleaningSupply> _supplies = [
    CleaningSupply(id: '1', name: 'Bleach', quantity: 15, unit: 'gallons', reorderLevel: 8, category: 'Disinfectant'),
    CleaningSupply(id: '2', name: 'Detergent', quantity: 6, unit: 'cartons', reorderLevel: 10, category: 'Cleaning Agent'),
    CleaningSupply(id: '3', name: 'Mops', quantity: 12, unit: 'units', reorderLevel: 6, category: 'Equipment'),
    CleaningSupply(id: '4', name: 'Brooms', quantity: 8, unit: 'units', reorderLevel: 5, category: 'Equipment'),
    CleaningSupply(id: '5', name: 'Dustbins', quantity: 20, unit: 'units', reorderLevel: 10, category: 'Equipment'),
    CleaningSupply(id: '6', name: 'Soap dispensers refill', quantity: 4, unit: 'cartons', reorderLevel: 8, category: 'Hygiene'),
    CleaningSupply(id: '7', name: 'Toilet paper rolls', quantity: 45, unit: 'rolls', reorderLevel: 30, category: 'Hygiene'),
    CleaningSupply(id: '8', name: 'Gloves (pairs)', quantity: 18, unit: 'pairs', reorderLevel: 12, category: 'PPE'),
    CleaningSupply(id: '9', name: 'Dettol', quantity: 5, unit: 'gallons', reorderLevel: 6, category: 'Disinfectant'),
    CleaningSupply(id: '10', name: 'Trash bags', quantity: 30, unit: 'packs', reorderLevel: 15, category: 'Consumables'),
  ];

  final List<DutyRosterEntry> _roster = [
    DutyRosterEntry(id: '1', area: 'Assembly Hall', assignedTo: 'Mr. Kofi + 2', frequency: 'Daily', time: '06:00 - 07:00', status: 'Completed'),
    DutyRosterEntry(id: '2', area: 'Dining Hall', assignedTo: 'Ms. Esi + 3', frequency: 'Daily (3x)', time: 'After each meal', status: 'In Progress'),
    DutyRosterEntry(id: '3', area: 'Dormitories (A)', assignedTo: 'Mr. Yaw', frequency: 'Daily', time: '07:00 - 09:00', status: 'Completed'),
    DutyRosterEntry(id: '4', area: 'Administration Block', assignedTo: 'Ms. Adjoa', frequency: 'Daily', time: '06:00 - 08:00', status: 'Completed'),
    DutyRosterEntry(id: '5', area: 'Grounds/Lawns', assignedTo: 'Mr. Samuel + 2', frequency: 'Weekly', time: 'Saturdays', status: 'Pending'),
    DutyRosterEntry(id: '6', area: 'Toilets Block A', assignedTo: 'Mr. Daniel', frequency: 'Daily', time: '06:00 - 08:00', status: 'In Progress'),
    DutyRosterEntry(id: '7', area: 'Toilets Block B', assignedTo: 'Mr. Daniel', frequency: 'Daily', time: '08:00 - 10:00', status: 'Pending'),
    DutyRosterEntry(id: '8', area: 'Library', assignedTo: 'Ms. Adjoa', frequency: 'Daily', time: '10:00 - 11:00', status: 'Pending'),
  ];

  // ── Getters ──
  List<CleaningTask> get tasks => List.unmodifiable(_tasks);
  List<MaintenanceIssue> get issues => List.unmodifiable(_issues);
  List<InspectionReport> get inspections => List.unmodifiable(_inspections);
  List<CleaningStaff> get staff => List.unmodifiable(_staff);
  List<CleaningSupply> get supplies => List.unmodifiable(_supplies);
  List<DutyRosterEntry> get roster => List.unmodifiable(_roster);

  List<CleaningTask> get todayTasks => _tasks.where((t) => t.date == _today()).toList();
  int get completedToday => todayTasks.where((t) => t.done).length;
  int get totalToday => todayTasks.length;
  int get taskCompletionRate => totalToday > 0 ? ((completedToday / totalToday) * 100).round() : 0;
  int get presentStaff => _staff.where((s) => s.status == 'Present').length;
  int get checkedInStaff => _staff.where((s) => s.todayCheckedIn).length;
  List<CleaningSupply> get lowStockSuppliesList => _supplies.where((s) => s.quantity <= s.reorderLevel).toList();
  int get lowStockCount => lowStockSuppliesList.length;
  int get openIssues => _issues.where((i) => i.status != 'Fixed').length;
  int get complianceScore => _inspections.isNotEmpty ? (_inspections.fold(0, (s, i) => s + i.score) ~/ _inspections.length) : 0;
  int get rosterPending => _roster.where((r) => r.status == 'Pending').length;
  int get rosterInProgress => _roster.where((r) => r.status == 'In Progress').length;
  int get rosterCompleted => _roster.where((r) => r.status == 'Completed').length;

  // ── Task mutations ──
  void addTask({required String task, required String area, required String frequency, required String assignedTo, required String priority}) {
    _tasks.insert(0, CleaningTask(id: _nextId(), task: task, area: area, frequency: frequency, assignedTo: assignedTo, date: _today(), priority: priority, done: false));
    notifyListeners();
  }
  void toggleTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx < 0) return;
    final t = _tasks[idx];
    _tasks[idx] = CleaningTask(id: t.id, task: t.task, area: t.area, frequency: t.frequency, assignedTo: t.assignedTo, date: t.date, priority: t.priority, done: !t.done);
    notifyListeners();
  }
  void deleteTask(String id) { _tasks.removeWhere((t) => t.id == id); notifyListeners(); }

  // ── Issue mutations ──
  void addIssue({required String location, required String issue, required String priority, required String reportedBy, String notes = ''}) {
    _issues.insert(0, MaintenanceIssue(id: _nextId(), date: _today(), location: location, issue: issue, priority: priority, status: 'Reported', reportedBy: reportedBy, notes: notes));
    notifyListeners();
  }
  void updateIssueStatus(String id, String newStatus) {
    final idx = _issues.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    final i = _issues[idx];
    _issues[idx] = MaintenanceIssue(id: i.id, date: i.date, location: i.location, issue: i.issue, priority: i.priority, status: newStatus, reportedBy: i.reportedBy, notes: i.notes);
    notifyListeners();
  }
  void deleteIssue(String id) { _issues.removeWhere((i) => i.id == id); notifyListeners(); }

  // ── Inspection mutations ──
  void addInspection({required String area, required String inspector, required String result, required int score, String notes = ''}) {
    _inspections.insert(0, InspectionReport(id: _nextId(), date: _today(), area: area, inspector: inspector, result: result, score: score, notes: notes));
    notifyListeners();
  }
  void deleteInspection(String id) { _inspections.removeWhere((i) => i.id == id); notifyListeners(); }

  // ── Staff mutations ──
  void toggleCheckIn(String id) {
    final idx = _staff.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _staff[idx];
    _staff[idx] = CleaningStaff(id: s.id, name: s.name, role: s.role, area: s.area, phone: s.phone, status: s.status, todayCheckedIn: !s.todayCheckedIn);
    notifyListeners();
  }
  void updateStaffStatus(String id, String newStatus) {
    final idx = _staff.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _staff[idx];
    _staff[idx] = CleaningStaff(id: s.id, name: s.name, role: s.role, area: s.area, phone: s.phone, status: newStatus, todayCheckedIn: s.todayCheckedIn);
    notifyListeners();
  }

  // ── Supply mutations ──
  void addSupply({required String name, required int quantity, required String unit, required int reorderLevel, required String category}) {
    _supplies.add(CleaningSupply(id: _nextId(), name: name, quantity: quantity, unit: unit, reorderLevel: reorderLevel, category: category));
    notifyListeners();
  }
  void updateSupply(String id, {required String name, required int quantity, required String unit, required int reorderLevel, required String category}) {
    final idx = _supplies.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    _supplies[idx] = CleaningSupply(id: id, name: name, quantity: quantity, unit: unit, reorderLevel: reorderLevel, category: category);
    notifyListeners();
  }
  void deleteSupply(String id) { _supplies.removeWhere((s) => s.id == id); notifyListeners(); }
  void restockSupply(String id, int qty) {
    final idx = _supplies.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _supplies[idx];
    _supplies[idx] = CleaningSupply(id: s.id, name: s.name, quantity: s.quantity + qty, unit: s.unit, reorderLevel: s.reorderLevel, category: s.category);
    notifyListeners();
  }

  // ── Roster mutations ──
  void updateRosterStatus(String id, String newStatus) {
    final idx = _roster.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    final r = _roster[idx];
    _roster[idx] = DutyRosterEntry(id: r.id, area: r.area, assignedTo: r.assignedTo, frequency: r.frequency, time: r.time, status: newStatus);
    notifyListeners();
  }
  void addRosterEntry({required String area, required String assignedTo, required String frequency, required String time}) {
    _roster.add(DutyRosterEntry(id: _nextId(), area: area, assignedTo: assignedTo, frequency: frequency, time: time, status: 'Pending'));
    notifyListeners();
  }
  void deleteRosterEntry(String id) { _roster.removeWhere((r) => r.id == id); notifyListeners(); }
}
