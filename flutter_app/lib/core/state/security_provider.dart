import 'package:flutter/foundation.dart';

class Guard {
  final String id, name, phone, rank, shift, status;
  final String? assignedGate;
  const Guard({required this.id, required this.name, required this.phone, required this.rank, required this.shift, this.assignedGate, required this.status});
}

class GateLog {
  final String id, date, time, personName, personType, direction, gate, purpose;
  final String? vehiclePlate;
  const GateLog({required this.id, required this.date, required this.time, required this.personName, required this.personType, required this.direction, required this.gate, required this.purpose, this.vehiclePlate});
}

class SecurityIncident {
  final String id, date, time, location, type, severity, description, reportedBy, status, action;
  const SecurityIncident({required this.id, required this.date, required this.time, required this.location, required this.type, required this.severity, required this.description, required this.reportedBy, required this.status, required this.action});
}

class PatrolShift {
  final String id, guardName, gate, shiftStart, shiftEnd, date, status;
  const PatrolShift({required this.id, required this.guardName, required this.gate, required this.shiftStart, required this.shiftEnd, required this.date, required this.status});
}

class PreRegisteredVisitor {
  final String id, visitorName, hostName, purpose, expectedDate, expectedTime, status;
  const PreRegisteredVisitor({required this.id, required this.visitorName, required this.hostName, required this.purpose, required this.expectedDate, required this.expectedTime, required this.status});
}

class ChecklistItem {
  final String id, task, time, guardName, completed, date;
  const ChecklistItem({required this.id, required this.task, required this.time, required this.guardName, required this.completed, required this.date});
}

class SecurityProvider extends ChangeNotifier {
  final List<Guard> _guards = [
    Guard(id: 'g1', name: 'Sgt. Boateng', phone: '024-100-2001', rank: 'Sergeant', shift: 'Night', assignedGate: 'Main Gate', status: 'On Duty'),
    Guard(id: 'g2', name: 'Cpl. Mensah', phone: '024-100-2002', rank: 'Corporal', shift: 'Day', assignedGate: 'Main Gate', status: 'On Duty'),
    Guard(id: 'g3', name: 'Pvt. Owusu', phone: '024-100-2003', rank: 'Private', shift: 'Day', assignedGate: 'Back Gate', status: 'On Duty'),
    Guard(id: 'g4', name: 'Pvt. Tetteh', phone: '024-100-2004', rank: 'Private', shift: 'Night', assignedGate: 'Back Gate', status: 'Off Duty'),
  ];

  final List<GateLog> _gateLogs = [
    GateLog(id: 'gl1', date: '2026-07-13', time: '08:15', personName: 'Mr. Addo', personType: 'Parent', direction: 'In', gate: 'Main Gate', purpose: 'Parent visit'),
    GateLog(id: 'gl2', date: '2026-07-13', time: '07:30', personName: 'Fuel Supplier', personType: 'Visitor', direction: 'In', gate: 'Main Gate', purpose: 'Fuel delivery', vehiclePlate: 'GR-3456-2'),
    GateLog(id: 'gl3', date: '2026-07-13', time: '06:00', personName: 'Mr. Kwabena', personType: 'Staff', direction: 'In', gate: 'Main Gate', purpose: 'Driver report'),
  ];

  final List<SecurityIncident> _incidents = [
    SecurityIncident(id: 'inc1', date: '2026-07-10', time: '22:30', location: 'Back Gate', type: 'Trespass', severity: 'Medium', description: 'Unknown person attempted to enter through back gate', reportedBy: 'Sgt. Boateng', status: 'Investigating', action: 'Person turned away, report filed'),
    SecurityIncident(id: 'inc2', date: '2026-07-08', time: '14:00', location: 'Parking Lot', type: 'Theft', severity: 'Low', description: 'Student reported missing bicycle', reportedBy: 'Cpl. Mensah', status: 'Resolved', action: 'Bicycle found in wrong rack, returned to owner'),
    SecurityIncident(id: 'inc3', date: '2026-07-05', time: '03:00', location: 'Perimeter Wall', type: 'Vandalism', severity: 'High', description: 'Section of perimeter wall damaged', reportedBy: 'Pvt. Tetteh', status: 'Escalated', action: 'Reported to Headmaster, maintenance notified'),
  ];

  final List<PatrolShift> _patrolShifts = [
    PatrolShift(id: 'ps1', guardName: 'Sgt. Boateng', gate: 'Main Gate', shiftStart: '18:00', shiftEnd: '06:00', date: '2026-07-13', status: 'Active'),
    PatrolShift(id: 'ps2', guardName: 'Cpl. Mensah', gate: 'Main Gate', shiftStart: '06:00', shiftEnd: '18:00', date: '2026-07-13', status: 'Active'),
    PatrolShift(id: 'ps3', guardName: 'Pvt. Owusu', gate: 'Back Gate', shiftStart: '06:00', shiftEnd: '18:00', date: '2026-07-13', status: 'Active'),
  ];

  final List<PreRegisteredVisitor> _visitors = [
    PreRegisteredVisitor(id: 'v1', visitorName: 'Mr. Addo', hostName: 'Headmaster', purpose: 'Parent meeting', expectedDate: '2026-07-13', expectedTime: '10:00', status: 'Expected'),
    PreRegisteredVisitor(id: 'v2', visitorName: 'Fuel Supplier', hostName: 'Bursar', purpose: 'Fuel delivery', expectedDate: '2026-07-13', expectedTime: '07:30', status: 'Checked In'),
  ];

  final List<ChecklistItem> _checklist = [
    ChecklistItem(id: 'c1', task: 'Perimeter wall inspection', time: '06:00', guardName: 'Cpl. Mensah', completed: 'Yes', date: '2026-07-13'),
    ChecklistItem(id: 'c2', task: 'Gate lock check', time: '06:15', guardName: 'Cpl. Mensah', completed: 'Yes', date: '2026-07-13'),
    ChecklistItem(id: 'c3', task: 'Dormitory perimeter', time: '06:30', guardName: 'Pvt. Owusu', completed: 'Yes', date: '2026-07-13'),
    ChecklistItem(id: 'c4', task: 'Kitchen area check', time: '07:00', guardName: 'Cpl. Mensah', completed: 'Pending', date: '2026-07-13'),
  ];

  List<Guard> get guards => List.unmodifiable(_guards);
  List<GateLog> get gateLogs => List.unmodifiable(_gateLogs);
  List<SecurityIncident> get incidents => List.unmodifiable(_incidents);
  List<PatrolShift> get patrolShifts => List.unmodifiable(_patrolShifts);
  List<PreRegisteredVisitor> get visitors => List.unmodifiable(_visitors);
  List<ChecklistItem> get checklist => List.unmodifiable(_checklist);

  int get openIncidents => _incidents.where((i) => i.status != 'Resolved').length;
  int get onDutyGuards => _guards.where((g) => g.status == 'On Duty').length;
  int get activeIncidentsCount => _incidents.where((i) => i.status != 'Resolved').length;
  int get criticalIncidentsCount => _incidents.where((i) => i.severity == 'High' || i.severity == 'Critical').length;
  int get expectedVisitorsCount => _visitors.where((v) => v.status == 'Expected').length;
  int get pendingChecklistCount => _checklist.where((c) => c.completed == 'Pending').length;
  int get completedChecklistCount => _checklist.where((c) => c.completed == 'Yes').length;
  int get checklistProgress => _checklist.isEmpty ? 0 : ((_checklist.where((c) => c.completed == 'Yes').length / _checklist.length * 100).round());

  static int _idCounter = 100;
  String _nextId() => (++_idCounter).toString();
  String _today() => DateTime.now().toIso8601String().substring(0, 10);
  String _nowTime() => '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';

  // ── Gate Log ──
  void addGateLog({required String personName, required String personType, required String direction, required String gate, required String purpose, String? vehiclePlate}) {
    _gateLogs.insert(0, GateLog(
      id: _nextId(), date: _today(), time: _nowTime(),
      personName: personName, personType: personType, direction: direction,
      gate: gate, purpose: purpose, vehiclePlate: vehiclePlate,
    ));
    notifyListeners();
  }

  void updateGateLogDirection(String id, String newDirection) {
    final idx = _gateLogs.indexWhere((g) => g.id == id);
    if (idx < 0) return;
    final g = _gateLogs[idx];
    _gateLogs[idx] = GateLog(
      id: g.id, date: g.date, time: g.time, personName: g.personName,
      personType: g.personType, direction: newDirection, gate: g.gate,
      purpose: g.purpose, vehiclePlate: g.vehiclePlate,
    );
    notifyListeners();
  }

  void deleteGateLog(String id) {
    _gateLogs.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  // ── Incidents ──
  void addIncident({required String type, required String location, required String description, required String severity, required String reportedBy, String action = ''}) {
    _incidents.insert(0, SecurityIncident(
      id: _nextId(), date: _today(), time: _nowTime(),
      type: type, location: location, description: description,
      severity: severity, reportedBy: reportedBy, status: 'Reported', action: action,
    ));
    notifyListeners();
  }

  void updateIncidentStatus(String id, String newStatus) {
    final idx = _incidents.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    final i = _incidents[idx];
    _incidents[idx] = SecurityIncident(
      id: i.id, date: i.date, time: i.time, location: i.location,
      type: i.type, severity: i.severity, description: i.description,
      reportedBy: i.reportedBy, status: newStatus, action: i.action,
    );
    notifyListeners();
  }

  void deleteIncident(String id) {
    _incidents.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  // ── Patrol Shifts ──
  void addPatrolShift({required String guardName, required String gate, required String shiftStart, required String shiftEnd, String status = 'Active'}) {
    _patrolShifts.insert(0, PatrolShift(
      id: _nextId(), guardName: guardName, gate: gate,
      shiftStart: shiftStart, shiftEnd: shiftEnd, date: _today(), status: status,
    ));
    notifyListeners();
  }

  void togglePatrolShift(String id) {
    final idx = _patrolShifts.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final p = _patrolShifts[idx];
    final newStatus = p.status == 'Completed' ? 'Active' : 'Completed';
    _patrolShifts[idx] = PatrolShift(
      id: p.id, guardName: p.guardName, gate: p.gate,
      shiftStart: p.shiftStart, shiftEnd: p.shiftEnd, date: p.date, status: newStatus,
    );
    notifyListeners();
  }

  void deletePatrolShift(String id) {
    _patrolShifts.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ── Visitors ──
  void addVisitor({required String visitorName, required String hostName, required String purpose, required String expectedDate, required String expectedTime, String status = 'Expected'}) {
    _visitors.insert(0, PreRegisteredVisitor(
      id: _nextId(), visitorName: visitorName, hostName: hostName,
      purpose: purpose, expectedDate: expectedDate, expectedTime: expectedTime, status: status,
    ));
    notifyListeners();
  }

  void updateVisitorStatus(String id, String newStatus) {
    final idx = _visitors.indexWhere((v) => v.id == id);
    if (idx < 0) return;
    final v = _visitors[idx];
    _visitors[idx] = PreRegisteredVisitor(
      id: v.id, visitorName: v.visitorName, hostName: v.hostName,
      purpose: v.purpose, expectedDate: v.expectedDate, expectedTime: v.expectedTime, status: newStatus,
    );
    notifyListeners();
  }

  void deleteVisitor(String id) {
    _visitors.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  // ── Checklist ──
  void toggleChecklistItem(String id, String guardName) {
    final idx = _checklist.indexWhere((c) => c.id == id);
    if (idx < 0) return;
    final c = _checklist[idx];
    _checklist[idx] = ChecklistItem(
      id: c.id, task: c.task, time: c.time, guardName: guardName,
      completed: c.completed == 'Yes' ? 'Pending' : 'Yes', date: c.date,
    );
    notifyListeners();
  }

  void addChecklistItem({required String task, required String time, required String guardName}) {
    _checklist.insert(0, ChecklistItem(
      id: _nextId(), task: task, time: time, guardName: guardName,
      completed: 'Pending', date: _today(),
    ));
    notifyListeners();
  }

  void deleteChecklistItem(String id) {
    _checklist.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // ── Guards ──
  void addGuard({required String name, required String phone, required String rank, required String shift, String? assignedGate, String status = 'On Duty'}) {
    _guards.insert(0, Guard(
      id: _nextId(), name: name, phone: phone, rank: rank,
      shift: shift, assignedGate: assignedGate, status: status,
    ));
    notifyListeners();
  }

  void toggleGuardStatus(String id) {
    final idx = _guards.indexWhere((g) => g.id == id);
    if (idx < 0) return;
    final g = _guards[idx];
    _guards[idx] = Guard(
      id: g.id, name: g.name, phone: g.phone, rank: g.rank,
      shift: g.shift, assignedGate: g.assignedGate,
      status: g.status == 'On Duty' ? 'Off Duty' : 'On Duty',
    );
    notifyListeners();
  }

  void deleteGuard(String id) {
    _guards.removeWhere((g) => g.id == id);
    notifyListeners();
  }
}
