import 'package:flutter/foundation.dart';

class BoardingHouse {
  final String id, name, type, housemaster, phone;
  final int capacity, occupied;
  final String since;
  const BoardingHouse({required this.id, required this.name, required this.type, required this.housemaster, required this.phone, required this.capacity, required this.occupied, required this.since});
}

class BoardingStudent {
  final String id, admNo, name, className, house, room;
  final String? bed;
  const BoardingStudent({required this.id, required this.admNo, required this.name, required this.className, required this.house, required this.room, this.bed});
}

class Room {
  final String id, house, room;
  final int beds, occupied;
  final List<String> studentNames;
  const Room({required this.id, required this.house, required this.room, required this.beds, required this.occupied, required this.studentNames});
}

class RollCallEntry {
  final String id, date, house, studentName, room, status, recordedBy;
  final String? notes;
  const RollCallEntry({required this.id, required this.date, required this.house, required this.studentName, required this.room, required this.status, required this.recordedBy, this.notes});
}

class DisciplineLog {
  final String id, date, house, studentName, incident, severity, actionTaken, recordedBy;
  final bool escalated;
  const DisciplineLog({required this.id, required this.date, required this.house, required this.studentName, required this.incident, required this.severity, required this.actionTaken, required this.recordedBy, required this.escalated});
}

class WelfareNote {
  final String id, date, house, studentName, note, recordedBy;
  final bool resolved;
  const WelfareNote({required this.id, required this.date, required this.house, required this.studentName, required this.note, required this.recordedBy, required this.resolved});
}

class Exeat {
  final String id, exeatNo, date, studentName, admissionNo, house, className, reason, reasonDetail, destination, departureDate, returnDate, guardianName, guardianPhone, transportMode, status, issuedBy, approvedBy;
  const Exeat({required this.id, required this.exeatNo, required this.date, required this.studentName, required this.admissionNo, required this.house, required this.className, required this.reason, required this.reasonDetail, required this.destination, required this.departureDate, required this.returnDate, required this.guardianName, required this.guardianPhone, required this.transportMode, required this.status, required this.issuedBy, required this.approvedBy});
}

class BoardingProvider extends ChangeNotifier {
  List<BoardingHouse> houses = [
    BoardingHouse(id: 'h1', name: 'Aggrey', type: 'Boys', housemaster: 'Mr. Owusu', phone: '024-111-2222', capacity: 220, occupied: 210, since: 'Sep 2024'),
    BoardingHouse(id: 'h2', name: 'Danquah', type: 'Boys', housemaster: 'Mr. Tetteh', phone: '027-333-4444', capacity: 230, occupied: 215, since: 'Sep 2023'),
  ];

  List<BoardingStudent> students = [
    BoardingStudent(id: 's1', admNo: '2026/001', name: 'Kwame Asante', className: 'SHS2 Sci A', house: 'Aggrey', room: 'A-12', bed: '1'),
    BoardingStudent(id: 's2', admNo: '2026/003', name: 'Yao Mensah', className: 'SHS3 Bus A', house: 'Aggrey', room: 'B-05', bed: '2'),
    BoardingStudent(id: 's3', admNo: '2026/015', name: 'Daniel Osei', className: 'SHS1 Sci A', house: 'Aggrey', room: 'C-08', bed: '1'),
    BoardingStudent(id: 's4', admNo: '2026/022', name: 'Patrick Agyei', className: 'SHS2 Arts B', house: 'Aggrey', room: 'A-14', bed: '3'),
    BoardingStudent(id: 's5', admNo: '2026/051', name: 'Ekow Mensah', className: 'SHS2 Arts A', house: 'Danquah', room: 'D-10', bed: '1'),
    BoardingStudent(id: 's6', admNo: '2026/055', name: 'Bernard Asiedu', className: 'SHS1 Sci B', house: 'Danquah', room: 'D-11', bed: '2'),
  ];

  List<Room> rooms = [
    Room(id: 'r1', house: 'Aggrey', room: 'A-12', beds: 4, occupied: 4, studentNames: ['K. Asante', 'S. Tuffour', 'P. Agyei', 'J. Mensah']),
    Room(id: 'r2', house: 'Aggrey', room: 'B-05', beds: 4, occupied: 3, studentNames: ['Y. Mensah', 'K. Baah', 'D. Osei']),
    Room(id: 'r3', house: 'Aggrey', room: 'C-08', beds: 2, occupied: 1, studentNames: ['D. Osei']),
    Room(id: 'r4', house: 'Danquah', room: 'D-10', beds: 4, occupied: 3, studentNames: ['E. Mensah', 'B. Asiedu', 'K. Frimpong']),
    Room(id: 'r5', house: 'Danquah', room: 'D-11', beds: 4, occupied: 2, studentNames: ['B. Asiedu', 'A. Boateng']),
  ];

  List<RollCallEntry> rollCalls = [
    RollCallEntry(id: 'rc1', date: '2026-07-13', house: 'Aggrey', studentName: 'Kwame Asante', room: 'A-12', status: 'Present', recordedBy: 'Mr. Owusu'),
    RollCallEntry(id: 'rc2', date: '2026-07-13', house: 'Aggrey', studentName: 'Yao Mensah', room: 'B-05', status: 'Present', recordedBy: 'Mr. Owusu'),
    RollCallEntry(id: 'rc3', date: '2026-07-13', house: 'Aggrey', studentName: 'Daniel Osei', room: 'C-08', status: 'Absent', recordedBy: 'Mr. Owusu'),
    RollCallEntry(id: 'rc4', date: '2026-07-13', house: 'Aggrey', studentName: 'Patrick Agyei', room: 'A-14', status: 'Excused', notes: 'Medical appointment', recordedBy: 'Mr. Owusu'),
    RollCallEntry(id: 'rc5', date: '2026-07-13', house: 'Danquah', studentName: 'Ekow Mensah', room: 'D-10', status: 'Present', recordedBy: 'Mr. Tetteh'),
  ];

  List<DisciplineLog> discipline = [
    DisciplineLog(id: 'd1', date: '2026-07-05', house: 'Aggrey', studentName: 'Kwame Asante', incident: 'Bullying', severity: 'Serious', actionTaken: 'Escalated to Headmaster', recordedBy: 'Mr. Owusu', escalated: true),
    DisciplineLog(id: 'd2', date: '2026-07-01', house: 'Aggrey', studentName: 'Daniel Osei', incident: 'Late return from town', severity: 'Minor', actionTaken: 'Warning given', recordedBy: 'Mr. Owusu', escalated: false),
    DisciplineLog(id: 'd3', date: '2026-06-28', house: 'Danquah', studentName: 'Ekow Mensah', incident: 'Fighting in dormitory', severity: 'Moderate', actionTaken: 'Counselling referral', recordedBy: 'Mr. Tetteh', escalated: false),
  ];

  List<WelfareNote> welfare = [
    WelfareNote(id: 'w1', date: '2026-07-05', house: 'Aggrey', studentName: 'Patrick Agyei', note: 'Homesick, spoke with guardian. Monitoring mood.', recordedBy: 'Mr. Owusu', resolved: false),
    WelfareNote(id: 'w2', date: '2026-07-03', house: 'Aggrey', studentName: 'Daniel Osei', note: 'Skipping meals, monitoring eating habits.', recordedBy: 'Mr. Owusu', resolved: false),
    WelfareNote(id: 'w3', date: '2026-06-30', house: 'Danquah', studentName: 'Bernard Asiedu', note: 'Exam stress, referred to counselling unit.', recordedBy: 'Mr. Tetteh', resolved: true),
  ];

  final List<Exeat> _exeats = [
    Exeat(id: 'exeat-1', exeatNo: 'EX/2026/0001', date: '2026-07-07', studentName: 'Kwame Asante', admissionNo: '2026/001', house: 'Aggrey', className: 'SHS2 Sci A', reason: 'Medical', reasonDetail: 'Hospital appointment for eye checkup', destination: 'Korle-Bu Teaching Hospital', departureDate: '2026-07-08', returnDate: '2026-07-09', guardianName: 'Mr. K. Asante Sr.', guardianPhone: '024-111-2222', transportMode: 'Private Car', status: 'Approved', issuedBy: 'Mr. Owusu', approvedBy: 'Senior Housemaster'),
    Exeat(id: 'exeat-2', exeatNo: 'EX/2026/0002', date: '2026-07-07', studentName: 'Ama Mensah', admissionNo: '2026/045', house: 'Mensah', className: 'SHS1 Arts B', reason: 'Family Emergency', reasonDetail: 'Father hospitalised', destination: 'Home — Kumasi', departureDate: '2026-07-07', returnDate: '2026-07-10', guardianName: 'Mrs. Mensah', guardianPhone: '020-333-4444', transportMode: 'Private Car', status: 'Pending', issuedBy: 'Mrs. Adjei', approvedBy: ''),
    Exeat(id: 'exeat-3', exeatNo: 'EX/2026/0003', date: '2026-07-06', studentName: 'Yaw Tetteh', admissionNo: '2026/078', house: 'Danquah', className: 'SHS3 Bus A', reason: 'Funeral', reasonDetail: "Grandmother's funeral", destination: 'Home — Cape Coast', departureDate: '2026-07-06', returnDate: '2026-07-08', guardianName: 'Mr. Tetteh Sr.', guardianPhone: '027-555-6666', transportMode: 'Taxi', status: 'Checked Out', issuedBy: 'Mr. Tetteh', approvedBy: 'Senior Housemaster'),
  ];

  List<Exeat> get exeats => List.unmodifiable(_exeats);

  void approveExeat(String id, String approvedBy) {
    final idx = _exeats.indexWhere((e) => e.id == id && e.status == 'Pending');
    if (idx >= 0) {
      final e = _exeats[idx];
      _exeats[idx] = Exeat(
        id: e.id, exeatNo: e.exeatNo, date: e.date, studentName: e.studentName,
        admissionNo: e.admissionNo, house: e.house, className: e.className,
        reason: e.reason, reasonDetail: e.reasonDetail, destination: e.destination,
        departureDate: e.departureDate, returnDate: e.returnDate,
        guardianName: e.guardianName, guardianPhone: e.guardianPhone,
        transportMode: e.transportMode, status: 'Approved', issuedBy: e.issuedBy, approvedBy: approvedBy,
      );
      notifyListeners();
    }
  }

  void rejectExeat(String id, String approvedBy) {
    final idx = _exeats.indexWhere((e) => e.id == id && (e.status == 'Pending' || e.status == 'Approved'));
    if (idx >= 0) {
      final e = _exeats[idx];
      _exeats[idx] = Exeat(
        id: e.id, exeatNo: e.exeatNo, date: e.date, studentName: e.studentName,
        admissionNo: e.admissionNo, house: e.house, className: e.className,
        reason: e.reason, reasonDetail: e.reasonDetail, destination: e.destination,
        departureDate: e.departureDate, returnDate: e.returnDate,
        guardianName: e.guardianName, guardianPhone: e.guardianPhone,
        transportMode: e.transportMode, status: 'Rejected', issuedBy: e.issuedBy, approvedBy: approvedBy,
      );
      notifyListeners();
    }
  }

  void checkOutExeat(String id, String checkedOutBy) {
    final idx = _exeats.indexWhere((e) => e.id == id && e.status == 'Approved');
    if (idx >= 0) {
      final e = _exeats[idx];
      _exeats[idx] = Exeat(
        id: e.id, exeatNo: e.exeatNo, date: e.date, studentName: e.studentName,
        admissionNo: e.admissionNo, house: e.house, className: e.className,
        reason: e.reason, reasonDetail: e.reasonDetail, destination: e.destination,
        departureDate: e.departureDate, returnDate: e.returnDate,
        guardianName: e.guardianName, guardianPhone: e.guardianPhone,
        transportMode: e.transportMode, status: 'Checked Out', issuedBy: e.issuedBy, approvedBy: e.approvedBy,
      );
      notifyListeners();
    }
  }

  void checkInExeat(String id, String checkedInBy) {
    final idx = _exeats.indexWhere((e) => e.id == id && e.status == 'Checked Out');
    if (idx >= 0) {
      final e = _exeats[idx];
      _exeats[idx] = Exeat(
        id: e.id, exeatNo: e.exeatNo, date: e.date, studentName: e.studentName,
        admissionNo: e.admissionNo, house: e.house, className: e.className,
        reason: e.reason, reasonDetail: e.reasonDetail, destination: e.destination,
        departureDate: e.departureDate, returnDate: e.returnDate,
        guardianName: e.guardianName, guardianPhone: e.guardianPhone,
        transportMode: e.transportMode, status: 'Checked In', issuedBy: e.issuedBy, approvedBy: e.approvedBy,
      );
      notifyListeners();
    }
  }

  void expireOverdueExeats() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    bool changed = false;
    for (int i = 0; i < _exeats.length; i++) {
      final e = _exeats[i];
      if (e.status == 'Approved' && e.returnDate.compareTo(today) < 0) {
        _exeats[i] = Exeat(
          id: e.id, exeatNo: e.exeatNo, date: e.date, studentName: e.studentName,
          admissionNo: e.admissionNo, house: e.house, className: e.className,
          reason: e.reason, reasonDetail: e.reasonDetail, destination: e.destination,
          departureDate: e.departureDate, returnDate: e.returnDate,
          guardianName: e.guardianName, guardianPhone: e.guardianPhone,
          transportMode: e.transportMode, status: 'Expired', issuedBy: e.issuedBy, approvedBy: e.approvedBy,
        );
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  // ── ID generator ──
  int _counter = 100;
  String _genId() => 'bd-${++_counter}-${DateTime.now().millisecondsSinceEpoch}';
  String _todayISO() => DateTime.now().toIso8601String().split('T')[0];

  // ── Students ──
  void addStudent(BoardingStudent s) {
    students.add(BoardingStudent(
      id: _genId(), admNo: s.admNo, name: s.name, className: s.className,
      house: s.house, room: s.room, bed: s.bed,
    ));
    notifyListeners();
  }

  void deleteStudent(String id) {
    students.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  List<BoardingStudent> getStudentsByHouse(String house) =>
      students.where((s) => s.house == house).toList();

  // ── Rooms ──
  void addRoom(Room r) {
    rooms.add(Room(
      id: _genId(), house: r.house, room: r.room, beds: r.beds,
      occupied: r.occupied, studentNames: r.studentNames,
    ));
    notifyListeners();
  }

  void deleteRoom(String id) {
    rooms.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  List<Room> getRoomsByHouse(String house) => rooms.where((r) => r.house == house).toList();

  // ── Roll Call ──
  void addRollCall(RollCallEntry rc) {
    rollCalls.insert(0, RollCallEntry(
      id: _genId(), date: rc.date, house: rc.house, studentName: rc.studentName,
      room: rc.room, status: rc.status, notes: rc.notes, recordedBy: rc.recordedBy,
    ));
    notifyListeners();
  }

  void updateRollCallStatus(String id, String status) {
    final idx = rollCalls.indexWhere((r) => r.id == id);
    if (idx >= 0) {
      final r = rollCalls[idx];
      rollCalls[idx] = RollCallEntry(
        id: r.id, date: r.date, house: r.house, studentName: r.studentName,
        room: r.room, status: status, notes: r.notes, recordedBy: r.recordedBy,
      );
      notifyListeners();
    }
  }

  void deleteRollCall(String id) {
    rollCalls.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  List<RollCallEntry> getTodayRollCalls(String house) {
    final today = _todayISO();
    return rollCalls.where((r) => r.date == today && r.house == house).toList();
  }

  void startRollCall(String house, String recordedBy) {
    final today = _todayISO();
    final existing = rollCalls.where((r) => r.date == today && r.house == house);
    if (existing.isNotEmpty) return;
    final houseStudents = students.where((s) => s.house == house);
    for (final s in houseStudents) {
      rollCalls.insert(0, RollCallEntry(
        id: _genId(), date: today, house: house, studentName: s.name,
        room: s.room, status: 'Absent', recordedBy: recordedBy,
      ));
    }
    notifyListeners();
  }

  // ── Discipline ──
  void addDiscipline(DisciplineLog d) {
    discipline.insert(0, DisciplineLog(
      id: _genId(), date: d.date, house: d.house, studentName: d.studentName,
      incident: d.incident, severity: d.severity, actionTaken: d.actionTaken,
      recordedBy: d.recordedBy, escalated: d.escalated,
    ));
    notifyListeners();
  }

  void deleteDiscipline(String id) {
    discipline.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  List<DisciplineLog> getDisciplineByHouse(String house) =>
      discipline.where((d) => d.house == house).toList();

  // ── Welfare ──
  void addWelfare(WelfareNote w) {
    welfare.insert(0, WelfareNote(
      id: _genId(), date: w.date, house: w.house, studentName: w.studentName,
      note: w.note, recordedBy: w.recordedBy, resolved: w.resolved,
    ));
    notifyListeners();
  }

  void deleteWelfare(String id) {
    welfare.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  void resolveWelfare(String id) {
    final idx = welfare.indexWhere((w) => w.id == id);
    if (idx >= 0) {
      final w = welfare[idx];
      welfare[idx] = WelfareNote(
        id: w.id, date: w.date, house: w.house, studentName: w.studentName,
        note: w.note, recordedBy: w.recordedBy, resolved: true,
      );
      notifyListeners();
    }
  }

  List<WelfareNote> getWelfareByHouse(String house) =>
      welfare.where((w) => w.house == house).toList();

  // ── House Assignment ──
  void assignHousemaster(String houseId, String housemasterName, String phone) {
    final idx = houses.indexWhere((h) => h.id == houseId);
    if (idx >= 0) {
      final h = houses[idx];
      houses[idx] = BoardingHouse(
        id: h.id, name: h.name, type: h.type, housemaster: housemasterName,
        phone: phone, capacity: h.capacity, occupied: h.occupied, since: h.since,
      );
      notifyListeners();
    }
  }

  BoardingHouse? getHouseByHousemaster(String housemasterName) {
    for (final h in houses) {
      if (h.housemaster == housemasterName) return h;
    }
    return null;
  }

  // ── Computed getters ──
  int get totalBoarders => students.length;
  int get presentToday => rollCalls.where((r) => r.status == 'Present').length;
  int get absentToday => rollCalls.where((r) => r.status == 'Absent').length;
  int get pendingExeats => exeats.where((e) => e.status == 'Pending').length;
  int get openWelfare => welfare.where((w) => !w.resolved).length;

  void escalateDiscipline(String id) {
    final idx = discipline.indexWhere((d) => d.id == id);
    if (idx >= 0) {
      final d = discipline[idx];
      discipline[idx] = DisciplineLog(
        id: d.id, date: d.date, house: d.house, studentName: d.studentName,
        incident: d.incident, severity: d.severity, actionTaken: 'Escalated to Headmaster',
        recordedBy: d.recordedBy, escalated: true,
      );
      notifyListeners();
    }
  }

  void resolveDiscipline(String id, String resolution) {
    final idx = discipline.indexWhere((d) => d.id == id);
    if (idx >= 0) {
      final d = discipline[idx];
      discipline[idx] = DisciplineLog(
        id: d.id, date: d.date, house: d.house, studentName: d.studentName,
        incident: d.incident, severity: d.severity, actionTaken: resolution,
        recordedBy: d.recordedBy, escalated: false,
      );
      notifyListeners();
    }
  }
}
