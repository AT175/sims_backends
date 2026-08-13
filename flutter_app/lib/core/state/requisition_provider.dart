import 'package:flutter/foundation.dart';

// ── Requisition Models (from RN requisitionStore.ts) ──

class ApprovalRecord {
  final String step, approver, date, action;
  final String? note;
  const ApprovalRecord({
    required this.step, required this.approver, required this.date,
    required this.action, this.note,
  });
}

class Requisition {
  final String id, date, itemName, unit, department, status, requestedBy, priority, notes;
  final int quantity;
  final String? house;
  final List<ApprovalRecord> approvals;
  const Requisition({
    required this.id, required this.date, required this.itemName, required this.quantity,
    required this.unit, required this.department, required this.status,
    required this.requestedBy, required this.priority, required this.notes,
    required this.approvals, this.house,
  });
}

class RequisitionProvider extends ChangeNotifier {
  final List<Requisition> _requisitions = [
    Requisition(id: '1', date: '2026-07-06', itemName: 'Cooking oil', quantity: 5, unit: 'gallons', department: 'Kitchen', status: 'Issued', requestedBy: 'Catering Officer', priority: 'Normal', notes: '', approvals: [ApprovalRecord(step: 'stores', approver: 'Stores Officer', date: '2026-07-06', action: 'issued')]),
    Requisition(id: '2', date: '2026-07-05', itemName: 'Cleaning detergent', quantity: 2, unit: 'cartons', department: 'Cleaning', status: 'Issued', requestedBy: 'Cleaning Supervisor', priority: 'Normal', notes: '', approvals: [ApprovalRecord(step: 'stores', approver: 'Stores Officer', date: '2026-07-05', action: 'issued')]),
    Requisition(id: '3', date: '2026-07-04', itemName: 'Chalk', quantity: 5, unit: 'boxes', department: 'Academic', status: 'Pending', requestedBy: 'Academic Office', priority: 'Normal', notes: 'For mid-sem exams', approvals: []),
    Requisition(id: '4', date: '2026-07-03', itemName: 'First aid supplies', quantity: 10, unit: 'units', department: 'Health Centre', status: 'Pending', requestedBy: 'Nurse Adjei', priority: 'Urgent', notes: 'Running low on bandages', approvals: []),
    Requisition(id: '5', date: '2026-07-02', itemName: 'Diesel', quantity: 50, unit: 'litres', department: 'Transport', status: 'Issued', requestedBy: 'Transport Officer', priority: 'Normal', notes: '', approvals: [ApprovalRecord(step: 'stores', approver: 'Stores Officer', date: '2026-07-02', action: 'issued')]),
    Requisition(id: '6', date: '2026-07-07', itemName: 'Bedsheets', quantity: 20, unit: 'units', department: 'Boarding', status: 'Pending', requestedBy: 'Mr. Owusu', priority: 'Urgent', notes: 'For Aggrey House — damaged sheets', house: 'Aggrey', approvals: []),
    Requisition(id: '7', date: '2026-07-06', itemName: 'Dettol soap', quantity: 10, unit: 'cartons', department: 'Boarding', status: 'Senior Housemaster Approved', requestedBy: 'Mr. Tetteh', priority: 'Normal', notes: 'For Danquah House', house: 'Danquah', approvals: [ApprovalRecord(step: 'senior_housemaster', approver: 'Senior Housemaster', date: '2026-07-06', action: 'approved')]),
  ];

  List<Requisition> get requisitions => List.unmodifiable(_requisitions);
  List<Requisition> get pending => _requisitions.where((r) => r.status == 'Pending').toList();
  List<Requisition> get pendingSeniorHousemaster => _requisitions.where((r) => r.status == 'Pending' && r.department == 'Boarding').toList();
  List<Requisition> get pendingDomestic => _requisitions.where((r) => r.status == 'Senior Housemaster Approved').toList();
  List<Requisition> get pendingStores => _requisitions.where((r) => r.status == 'Domestic Approved').toList();
  List<Requisition> get urgent => _requisitions.where((r) => r.priority == 'Urgent').toList();

  List<Requisition> getByDepartment(String dept) => _requisitions.where((r) => r.department == dept).toList();
  List<Requisition> getByHouse(String house) => _requisitions.where((r) => r.house == house).toList();
  List<Requisition> getPendingForHouse(String house) => _requisitions.where((r) => r.status == 'Issued' && r.house == house).toList();

  int get pendingCount => pending.length;
  int get urgentCount => urgent.length;

  void addRequisition(Requisition r) {
    _requisitions.add(Requisition(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      date: r.date, itemName: r.itemName, quantity: r.quantity, unit: r.unit,
      department: r.department, status: 'Pending', requestedBy: r.requestedBy,
      priority: r.priority, notes: r.notes, approvals: [],
    ));
    notifyListeners();
  }

  String _todayISO() => DateTime.now().toIso8601String().split('T')[0];

  Requisition _copyWith(Requisition r, {String? status, List<ApprovalRecord>? approvals}) =>
    Requisition(
      id: r.id, date: r.date, itemName: r.itemName, quantity: r.quantity, unit: r.unit,
      department: r.department, status: status ?? r.status, requestedBy: r.requestedBy,
      priority: r.priority, notes: r.notes, house: r.house, approvals: approvals ?? r.approvals,
    );

  void approveBySeniorHousemaster(String id, String approver, [String? note]) {
    final idx = _requisitions.indexWhere((r) => r.id == id && r.status == 'Pending' && r.department == 'Boarding');
    if (idx >= 0) {
      _requisitions[idx] = _copyWith(_requisitions[idx],
        status: 'Senior Housemaster Approved',
        approvals: [..._requisitions[idx].approvals, ApprovalRecord(step: 'senior_housemaster', approver: approver, date: _todayISO(), action: 'approved', note: note)],
      );
      notifyListeners();
    }
  }

  void approveByDomestic(String id, String approver, [String? note]) {
    final idx = _requisitions.indexWhere((r) => r.id == id && r.status == 'Senior Housemaster Approved');
    if (idx >= 0) {
      _requisitions[idx] = _copyWith(_requisitions[idx],
        status: 'Domestic Approved',
        approvals: [..._requisitions[idx].approvals, ApprovalRecord(step: 'domestic', approver: approver, date: _todayISO(), action: 'approved', note: note)],
      );
      notifyListeners();
    }
  }

  void rejectRequisition(String id, String step, String approver, [String? note]) {
    final idx = _requisitions.indexWhere((r) => r.id == id);
    if (idx >= 0) {
      _requisitions[idx] = _copyWith(_requisitions[idx],
        status: 'Rejected',
        approvals: [..._requisitions[idx].approvals, ApprovalRecord(step: step, approver: approver, date: _todayISO(), action: 'rejected', note: note)],
      );
      notifyListeners();
    }
  }

  void issueByStores(String id, String approver, [String? note]) {
    final idx = _requisitions.indexWhere((r) => r.id == id && r.status == 'Domestic Approved');
    if (idx >= 0) {
      _requisitions[idx] = _copyWith(_requisitions[idx],
        status: 'Issued',
        approvals: [..._requisitions[idx].approvals, ApprovalRecord(step: 'stores', approver: approver, date: _todayISO(), action: 'issued', note: note)],
      );
      notifyListeners();
    }
  }

  void receiveByHouse(String id, String approver, [String? note]) {
    final idx = _requisitions.indexWhere((r) => r.id == id && r.status == 'Issued');
    if (idx >= 0) {
      _requisitions[idx] = _copyWith(_requisitions[idx],
        status: 'Received',
        approvals: [..._requisitions[idx].approvals, ApprovalRecord(step: 'house', approver: approver, date: _todayISO(), action: 'received', note: note)],
      );
      notifyListeners();
    }
  }

  void deleteRequisition(String id) {
    _requisitions.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
