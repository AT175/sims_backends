import 'package:flutter/foundation.dart';

const mealTypes = ['Breakfast', 'Lunch', 'Dinner'];

// ── Bursar Models (from RN bursarStore.ts) ──

class CashTransaction {
  final String id, date, type, category, description, receiptNo, handledBy;
  final double amount, balanceAfter;
  final String? receivedFrom, paidTo;
  const CashTransaction({
    required this.id, required this.date, required this.type, required this.category,
    required this.description, required this.amount, required this.receiptNo,
    required this.balanceAfter, required this.handledBy, this.receivedFrom, this.paidTo,
  });
}

class PocketMoneyTxn {
  final String id, date, type, description, authorizedBy;
  final double amount, balanceAfter;
  const PocketMoneyTxn({
    required this.id, required this.date, required this.type, required this.amount,
    required this.description, required this.balanceAfter, required this.authorizedBy,
  });
}

class StudentAccount {
  final String id, studentName, admNo, className, guardianName, guardianPhone;
  final double balance, totalDeposited, totalWithdrawn;
  final List<PocketMoneyTxn> transactions;
  const StudentAccount({
    required this.id, required this.studentName, required this.admNo, required this.className,
    required this.guardianName, required this.guardianPhone, required this.balance,
    required this.totalDeposited, required this.totalWithdrawn, required this.transactions,
  });
}

class PettyCashEntry {
  final String id, date, description, requestedBy, status, notes;
  final double amount;
  final String? approvedBy, dateApproved, receiptNo;
  const PettyCashEntry({
    required this.id, required this.date, required this.description, required this.amount,
    required this.requestedBy, required this.status, required this.notes,
    this.approvedBy, this.dateApproved, this.receiptNo,
  });
}

class ImprestAccount {
  final String id, holder, department, dateIssued, purpose, status, notes;
  final double amount;
  final double? retiredAmount;
  final String? dateRetired, retirementVoucherNo;
  const ImprestAccount({
    required this.id, required this.holder, required this.department, required this.amount,
    required this.dateIssued, required this.purpose, required this.status, required this.notes,
    this.retiredAmount, this.dateRetired, this.retirementVoucherNo,
  });
}

class ProcurementRequest {
  final String id, date, item, unit, supplier, requestedBy, department, status, notes;
  final int quantity;
  final double estimatedCost;
  final double? actualCost;
  final String? dateDelivered;
  const ProcurementRequest({
    required this.id, required this.date, required this.item, required this.quantity,
    required this.unit, required this.estimatedCost, required this.supplier,
    required this.requestedBy, required this.department, required this.status, required this.notes,
    this.actualCost, this.dateDelivered,
  });
}

class FeedingRecord {
  final String id, date, meal, status, notes;
  final int headcount;
  final double costPerHead, totalCost;
  const FeedingRecord({
    required this.id, required this.date, required this.meal, required this.headcount,
    required this.costPerHead, required this.totalCost, required this.status, required this.notes,
  });
}

class BoardingSupply {
  final String id, item, unit, datePurchased, supplier, house, notes;
  final int quantity;
  final double unitCost, totalCost;
  const BoardingSupply({
    required this.id, required this.item, required this.quantity, required this.unit,
    required this.unitCost, required this.totalCost, required this.datePurchased,
    required this.supplier, required this.house, required this.notes,
  });
}

class BursaryReturnLineItem {
  final String description;
  final double amount;
  final String type;
  const BursaryReturnLineItem({required this.description, required this.amount, required this.type});
}

class BursaryReturn {
  final String id, period, dateFrom, dateTo, status, submittedBy, dateSubmitted, notes;
  final double totalIncome, totalExpense, netBalance;
  final String? approvedBy;
  final List<BursaryReturnLineItem> lineItems;
  const BursaryReturn({
    required this.id, required this.period, required this.dateFrom, required this.dateTo,
    required this.totalIncome, required this.totalExpense, required this.netBalance,
    required this.status, required this.submittedBy, required this.dateSubmitted,
    required this.notes, required this.lineItems, this.approvedBy,
  });
}

// ── Bursar Provider ──

class BursarProvider extends ChangeNotifier {
  final List<CashTransaction> _cashTransactions = [
    CashTransaction(id: '1', date: '2026-07-10', type: 'Income', category: 'Fees', description: 'Fee payment — Kwame Asante', amount: 500, receivedFrom: 'Mr. Kofi Asante (Parent)', paidTo: '', receiptNo: 'CSH-2001', balanceAfter: 12500, handledBy: 'Bursar'),
    CashTransaction(id: '2', date: '2026-07-10', type: 'Income', category: 'Pocket Money', description: 'Pocket money deposit — Ama Owusu', amount: 100, receivedFrom: 'Mrs. Owusu (Parent)', paidTo: '', receiptNo: 'CSH-2002', balanceAfter: 12600, handledBy: 'Bursar'),
    CashTransaction(id: '3', date: '2026-07-09', type: 'Expense', category: 'Feeding', description: 'Foodstuff purchase — Day 5', amount: 850, receivedFrom: '', paidTo: 'Makola Market Vendor', receiptNo: 'CSH-2003', balanceAfter: 12000, handledBy: 'Bursar'),
    CashTransaction(id: '4', date: '2026-07-09', type: 'Expense', category: 'Boarding Supplies', description: 'Mattress replacement — House 1', amount: 450, receivedFrom: '', paidTo: 'Bedding Ghana Ltd', receiptNo: 'CSH-2004', balanceAfter: 11150, handledBy: 'Bursar'),
    CashTransaction(id: '5', date: '2026-07-08', type: 'Income', category: 'Fees', description: 'Fee payment — Yao Mensah', amount: 300, receivedFrom: 'Mr. Daniel Mensah (Parent)', paidTo: '', receiptNo: 'CSH-2005', balanceAfter: 11600, handledBy: 'Bursar'),
    CashTransaction(id: '6', date: '2026-07-08', type: 'Expense', category: 'Stationery', description: 'Office supplies — registry forms', amount: 120, receivedFrom: '', paidTo: 'Stationery World', receiptNo: 'CSH-2006', balanceAfter: 11300, handledBy: 'Bursar'),
    CashTransaction(id: '7', date: '2026-07-07', type: 'Expense', category: 'Utilities', description: 'Water bill — July', amount: 600, receivedFrom: '', paidTo: 'Ghana Water Co.', receiptNo: 'CSH-2007', balanceAfter: 11180, handledBy: 'Bursar'),
  ];

  final List<StudentAccount> _studentAccounts = [
    StudentAccount(id: '1', studentName: 'Kwame Asante', admNo: '2026/001', className: 'SHS2 Sci A', guardianName: 'Mr. Kofi Asante', guardianPhone: '024-555-1001', balance: 150, totalDeposited: 300, totalWithdrawn: 150, transactions: [
      PocketMoneyTxn(id: 't1', date: '2026-07-01', type: 'Deposit', amount: 200, description: 'Opening deposit', balanceAfter: 200, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't2', date: '2026-07-05', type: 'Withdrawal', amount: 50, description: 'Personal effects', balanceAfter: 150, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't3', date: '2026-07-10', type: 'Deposit', amount: 100, description: 'Top-up from parent', balanceAfter: 250, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't4', date: '2026-07-10', type: 'Withdrawal', amount: 100, description: 'Snacks & toiletries', balanceAfter: 150, authorizedBy: 'Bursar'),
    ]),
    StudentAccount(id: '2', studentName: 'Ama Owusu', admNo: '2026/002', className: 'SHS1 Arts B', guardianName: 'Mrs. Akosua Owusu', guardianPhone: '027-555-1002', balance: 80, totalDeposited: 200, totalWithdrawn: 120, transactions: [
      PocketMoneyTxn(id: 't5', date: '2026-07-02', type: 'Deposit', amount: 150, description: 'Opening deposit', balanceAfter: 150, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't6', date: '2026-07-06', type: 'Withdrawal', amount: 70, description: 'Toiletries', balanceAfter: 80, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't7', date: '2026-07-10', type: 'Deposit', amount: 50, description: 'Pocket money top-up', balanceAfter: 130, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't8', date: '2026-07-10', type: 'Withdrawal', amount: 50, description: 'Snacks', balanceAfter: 80, authorizedBy: 'Bursar'),
    ]),
    StudentAccount(id: '3', studentName: 'Yao Mensah', admNo: '2026/003', className: 'SHS3 Bus A', guardianName: 'Mr. Daniel Mensah', guardianPhone: '020-555-1003', balance: 25, totalDeposited: 100, totalWithdrawn: 75, transactions: [
      PocketMoneyTxn(id: 't9', date: '2026-07-03', type: 'Deposit', amount: 100, description: 'Opening deposit', balanceAfter: 100, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't10', date: '2026-07-07', type: 'Withdrawal', amount: 75, description: 'Photocopy & printing', balanceAfter: 25, authorizedBy: 'Bursar'),
    ]),
    StudentAccount(id: '4', studentName: 'Efua Darko', admNo: '2025/145', className: 'SHS2 Sci B', guardianName: 'Mrs. Grace Darko', guardianPhone: '055-555-1004', balance: 200, totalDeposited: 250, totalWithdrawn: 50, transactions: [
      PocketMoneyTxn(id: 't11', date: '2026-07-01', type: 'Deposit', amount: 200, description: 'Opening deposit', balanceAfter: 200, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't12', date: '2026-07-08', type: 'Withdrawal', amount: 50, description: 'Medical — paracetamol', balanceAfter: 150, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't13', date: '2026-07-09', type: 'Deposit', amount: 50, description: 'Top-up', balanceAfter: 200, authorizedBy: 'Bursar'),
    ]),
    StudentAccount(id: '5', studentName: 'Kofi Boateng', admNo: '2025/146', className: 'SHS3 Sci A', guardianName: 'Mr. Samuel Boateng', guardianPhone: '024-555-1005', balance: 0, totalDeposited: 50, totalWithdrawn: 50, transactions: [
      PocketMoneyTxn(id: 't14', date: '2026-07-04', type: 'Deposit', amount: 50, description: 'Opening deposit', balanceAfter: 50, authorizedBy: 'Bursar'),
      PocketMoneyTxn(id: 't15', date: '2026-07-06', type: 'Withdrawal', amount: 50, description: 'Transport — town pass', balanceAfter: 0, authorizedBy: 'Bursar'),
    ]),
  ];

  final List<PettyCashEntry> _pettyCash = [
    PettyCashEntry(id: '1', date: '2026-07-10', description: 'Taxi fare for registry errand', amount: 30, requestedBy: 'Registry Clerk', status: 'Approved', approvedBy: 'Bursar', dateApproved: '2026-07-10', notes: 'Urgent document delivery to GES', receiptNo: 'PC-001'),
    PettyCashEntry(id: '2', date: '2026-07-09', description: 'Photocopying exam scripts', amount: 45, requestedBy: 'Academic Office', status: 'Disbursed', approvedBy: 'Bursar', dateApproved: '2026-07-09', notes: '150 copies @ 30p', receiptNo: 'PC-002'),
    PettyCashEntry(id: '3', date: '2026-07-10', description: 'Cleaning materials — emergency', amount: 60, requestedBy: 'Cleaning Supervisor', status: 'Requested', notes: 'Disinfectant and mops'),
    PettyCashEntry(id: '4', date: '2026-07-08', description: 'First aid supplies', amount: 35, requestedBy: 'Health Centre', status: 'Disbursed', approvedBy: 'Bursar', dateApproved: '2026-07-08', notes: 'Bandages, antiseptic', receiptNo: 'PC-003'),
  ];

  final List<ImprestAccount> _imprest = [
    ImprestAccount(id: '1', holder: 'Catering Officer', department: 'Kitchen', amount: 5000, dateIssued: '2026-07-01', purpose: 'Weekly foodstuff purchase', status: 'Active', notes: 'Imprest for Week 1-2 food supplies'),
    ImprestAccount(id: '2', holder: 'Transport Officer', department: 'Transport', amount: 2000, dateIssued: '2026-07-01', purpose: 'Fuel and minor repairs', status: 'Active', notes: 'Diesel for school buses'),
    ImprestAccount(id: '3', holder: 'Domestic Bursar', department: 'Domestic', amount: 3000, dateIssued: '2026-06-15', purpose: 'Boarding supplies replenishment', status: 'Pending Retirement', retiredAmount: 2850, notes: 'Awaiting retirement voucher'),
    ImprestAccount(id: '4', holder: 'Science HOD', department: 'Science Lab', amount: 1500, dateIssued: '2026-06-01', purpose: 'Lab consumables', status: 'Retired', retiredAmount: 1500, dateRetired: '2026-06-30', retirementVoucherNo: 'RV-001', notes: 'Fully retired'),
  ];

  final List<ProcurementRequest> _procurement = [
    ProcurementRequest(id: '1', date: '2026-07-09', item: 'Rice (50kg bags)', quantity: 10, unit: 'bags', estimatedCost: 4000, actualCost: 3850, supplier: 'Ghana Grains Ltd', requestedBy: 'Catering Officer', department: 'Kitchen', status: 'Delivered', dateDelivered: '2026-07-10', notes: 'Delivered in good condition'),
    ProcurementRequest(id: '2', date: '2026-07-08', item: 'Mattresses (double)', quantity: 20, unit: 'units', estimatedCost: 9000, supplier: 'Bedding Ghana Ltd', requestedBy: 'Domestic Bursar', department: 'Domestic', status: 'Ordered', notes: 'For House 1 replacement'),
    ProcurementRequest(id: '3', date: '2026-07-07', item: 'Chemistry reagents', quantity: 5, unit: 'sets', estimatedCost: 750, supplier: 'LabTech Services', requestedBy: 'Science HOD', department: 'Science Lab', status: 'Approved', notes: 'For SHS2 practicals'),
    ProcurementRequest(id: '4', date: '2026-07-10', item: 'Cleaning supplies (bulk)', quantity: 1, unit: 'cartons', estimatedCost: 500, supplier: 'CleanCo Ltd', requestedBy: 'Cleaning Supervisor', department: 'Cleaning', status: 'Requisitioned', notes: 'Detergents, disinfectants, mops'),
    ProcurementRequest(id: '5', date: '2026-07-05', item: 'Diesel (for buses)', quantity: 200, unit: 'litres', estimatedCost: 1600, actualCost: 1580, supplier: 'Goil', requestedBy: 'Transport Officer', department: 'Transport', status: 'Delivered', dateDelivered: '2026-07-06', notes: '200L diesel for 3 buses'),
  ];

  final List<FeedingRecord> _feeding = [
    FeedingRecord(id: '1', date: '2026-07-10', meal: 'Breakfast', headcount: 480, costPerHead: 5, totalCost: 2400, status: 'Served', notes: 'Porridge + bread'),
    FeedingRecord(id: '2', date: '2026-07-10', meal: 'Lunch', headcount: 475, costPerHead: 12, totalCost: 5700, status: 'Served', notes: 'Jollof rice + chicken'),
    FeedingRecord(id: '3', date: '2026-07-10', meal: 'Dinner', headcount: 470, costPerHead: 10, totalCost: 4700, status: 'Served', notes: 'Banku + tilapia'),
    FeedingRecord(id: '4', date: '2026-07-09', meal: 'Breakfast', headcount: 482, costPerHead: 5, totalCost: 2410, status: 'Served', notes: 'Tea + eggs'),
    FeedingRecord(id: '5', date: '2026-07-09', meal: 'Lunch', headcount: 478, costPerHead: 12, totalCost: 5736, status: 'Served', notes: 'Fufu + goat soup'),
    FeedingRecord(id: '6', date: '2026-07-09', meal: 'Dinner', headcount: 472, costPerHead: 10, totalCost: 4720, status: 'Served', notes: 'Rice + stew'),
  ];

  final List<BoardingSupply> _boardingSupplies = [
    BoardingSupply(id: '1', item: 'Mattresses (double)', quantity: 5, unit: 'units', unitCost: 450, totalCost: 2250, datePurchased: '2026-07-09', supplier: 'Bedding Ghana Ltd', house: 'House 1 (Boys)', notes: 'Replacement of worn-out mattresses'),
    BoardingSupply(id: '2', item: 'Bed sheets (sets)', quantity: 20, unit: 'sets', unitCost: 80, totalCost: 1600, datePurchased: '2026-07-05', supplier: 'Textile House', house: 'House 3 (Girls)', notes: 'New intake supplies'),
    BoardingSupply(id: '3', item: 'Buckets', quantity: 30, unit: 'pieces', unitCost: 25, totalCost: 750, datePurchased: '2026-07-03', supplier: 'Plastic World', house: 'House 2 (Boys)', notes: 'For new students'),
    BoardingSupply(id: '4', item: 'Detergent (cartons)', quantity: 4, unit: 'cartons', unitCost: 120, totalCost: 480, datePurchased: '2026-07-07', supplier: 'CleanCo Ltd', house: 'House 4 (Girls)', notes: 'Monthly cleaning supplies'),
    BoardingSupply(id: '5', item: 'Mosquito nets', quantity: 50, unit: 'pieces', unitCost: 35, totalCost: 1750, datePurchased: '2026-07-01', supplier: 'Health Supplies Ltd', house: 'All Houses', notes: 'Malaria prevention'),
  ];

  final List<BursaryReturn> _returns = [
    BursaryReturn(id: '1', period: 'Daily', dateFrom: '2026-07-10', dateTo: '2026-07-10', totalIncome: 600, totalExpense: 850, netBalance: -250, status: 'Submitted', submittedBy: 'Bursar', dateSubmitted: '2026-07-10', notes: 'Day 10 returns', lineItems: [
      BursaryReturnLineItem(description: 'Fee payment — Kwame Asante', amount: 500, type: 'Income'),
      BursaryReturnLineItem(description: 'Pocket money deposit — Ama Owusu', amount: 100, type: 'Income'),
      BursaryReturnLineItem(description: 'Foodstuff purchase — Day 5', amount: 850, type: 'Expense'),
    ]),
    BursaryReturn(id: '2', period: 'Daily', dateFrom: '2026-07-09', dateTo: '2026-07-09', totalIncome: 300, totalExpense: 1170, netBalance: -870, status: 'Approved', submittedBy: 'Bursar', dateSubmitted: '2026-07-09', approvedBy: 'Accountant', notes: 'Day 9 returns', lineItems: [
      BursaryReturnLineItem(description: 'Fee payment — Yao Mensah', amount: 300, type: 'Income'),
      BursaryReturnLineItem(description: 'Mattress replacement — House 1', amount: 450, type: 'Expense'),
      BursaryReturnLineItem(description: 'Office supplies', amount: 120, type: 'Expense'),
      BursaryReturnLineItem(description: 'Water bill — July', amount: 600, type: 'Expense'),
    ]),
    BursaryReturn(id: '3', period: 'Weekly', dateFrom: '2026-07-04', dateTo: '2026-07-10', totalIncome: 900, totalExpense: 3170, netBalance: -2270, status: 'Draft', submittedBy: 'Bursar', dateSubmitted: '', notes: 'Week 2 summary — pending submission', lineItems: [
      BursaryReturnLineItem(description: 'Total fees collected', amount: 800, type: 'Income'),
      BursaryReturnLineItem(description: 'Pocket money deposits', amount: 100, type: 'Income'),
      BursaryReturnLineItem(description: 'Feeding costs', amount: 1700, type: 'Expense'),
      BursaryReturnLineItem(description: 'Boarding supplies', amount: 450, type: 'Expense'),
      BursaryReturnLineItem(description: 'Utilities', amount: 600, type: 'Expense'),
      BursaryReturnLineItem(description: 'Miscellaneous', amount: 420, type: 'Expense'),
    ]),
  ];

  double _cashBalance = 12500;

  // ── Getters ──
  List<CashTransaction> get cashTransactions => List.unmodifiable(_cashTransactions);
  List<StudentAccount> get studentAccounts => List.unmodifiable(_studentAccounts);
  List<PettyCashEntry> get pettyCash => List.unmodifiable(_pettyCash);
  List<ImprestAccount> get imprest => List.unmodifiable(_imprest);
  List<ProcurementRequest> get procurement => List.unmodifiable(_procurement);
  List<FeedingRecord> get feeding => List.unmodifiable(_feeding);
  List<BoardingSupply> get boardingSupplies => List.unmodifiable(_boardingSupplies);
  List<BursaryReturn> get returns => List.unmodifiable(_returns);

  double get cashBalance => _cashBalance;
  double get totalIncome => _cashTransactions.where((t) => t.type == 'Income').fold(0.0, (s, t) => s + t.amount);
  double get totalExpense => _cashTransactions.where((t) => t.type == 'Expense').fold(0.0, (s, t) => s + t.amount);
  double get pettyCashBalance => _pettyCash.where((p) => p.status == 'Disbursed').fold(0.0, (s, p) => s + p.amount);
  double get pettyCashRequested => _pettyCash.where((p) => p.status == 'Requested').fold(0.0, (s, p) => s + p.amount);
  double get feedingTotalCost => _feeding.fold(0.0, (s, f) => s + f.totalCost);
  List<({String meal, double total, int count})> get feedingCostByMeal {
    return mealTypes.map((meal) {
      final items = _feeding.where((f) => f.meal == meal).toList();
      return (meal: meal, total: items.fold(0.0, (s, f) => s + f.totalCost), count: items.length);
    }).where((m) => m.count > 0).toList();
  }
  double get boardingSupplyTotal => _boardingSupplies.fold(0.0, (s, b) => s + b.totalCost);
  double get activeImprestTotal => _imprest.where((i) => i.status == 'Active').fold(0.0, (s, i) => s + i.amount);
  int get pendingProcurement => _procurement.where((p) => p.status == 'Requisitioned' || p.status == 'Approved').length;
  int get pendingReturns => _returns.where((r) => r.status == 'Draft').length;
  int get pendingPettyCash => _pettyCash.where((p) => p.status == 'Requested').length;

  static int _idCounter = 100;
  String _nextId() => (++_idCounter).toString();
  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  // ── Cash Book ──
  void recordCashTransaction({required String type, required String category, required String description, required double amount, String? receivedFrom, String? paidTo, required String handledBy}) {
    _cashBalance += type == 'Income' ? amount : -amount;
    _cashTransactions.insert(0, CashTransaction(
      id: _nextId(), date: _today(), type: type, category: category, description: description,
      amount: amount, receiptNo: 'CSH-${2000 + _cashTransactions.length + 1}',
      balanceAfter: _cashBalance, handledBy: handledBy, receivedFrom: receivedFrom, paidTo: paidTo,
    ));
    notifyListeners();
  }

  // ── Student Accounts ──
  void depositPocketMoney(String id, double amount, String description, String authorizedBy) {
    final idx = _studentAccounts.indexWhere((a) => a.id == id);
    if (idx < 0) return;
    final a = _studentAccounts[idx];
    final newBalance = a.balance + amount;
    final txn = PocketMoneyTxn(id: 't${_nextId()}', date: _today(), type: 'Deposit', amount: amount, description: description, balanceAfter: newBalance, authorizedBy: authorizedBy);
    _studentAccounts[idx] = StudentAccount(
      id: a.id, studentName: a.studentName, admNo: a.admNo, className: a.className,
      guardianName: a.guardianName, guardianPhone: a.guardianPhone, balance: newBalance,
      totalDeposited: a.totalDeposited + amount, totalWithdrawn: a.totalWithdrawn,
      transactions: [...a.transactions, txn],
    );
    notifyListeners();
  }

  void withdrawPocketMoney(String id, double amount, String description, String authorizedBy) {
    final idx = _studentAccounts.indexWhere((a) => a.id == id);
    if (idx < 0) return;
    final a = _studentAccounts[idx];
    if (a.balance < amount) return;
    final newBalance = a.balance - amount;
    final txn = PocketMoneyTxn(id: 't${_nextId()}', date: _today(), type: 'Withdrawal', amount: amount, description: description, balanceAfter: newBalance, authorizedBy: authorizedBy);
    _studentAccounts[idx] = StudentAccount(
      id: a.id, studentName: a.studentName, admNo: a.admNo, className: a.className,
      guardianName: a.guardianName, guardianPhone: a.guardianPhone, balance: newBalance,
      totalDeposited: a.totalDeposited, totalWithdrawn: a.totalWithdrawn + amount,
      transactions: [...a.transactions, txn],
    );
    notifyListeners();
  }

  // ── Petty Cash ──
  void addPettyCashEntry({required String description, required double amount, required String requestedBy, required String notes}) {
    _pettyCash.insert(0, PettyCashEntry(
      id: _nextId(), date: _today(), description: description, amount: amount,
      requestedBy: requestedBy, status: 'Requested', notes: notes,
    ));
    notifyListeners();
  }

  void approvePettyCash(String id, String approver) {
    final idx = _pettyCash.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final p = _pettyCash[idx];
    _pettyCash[idx] = PettyCashEntry(
      id: p.id, date: p.date, description: p.description, amount: p.amount,
      requestedBy: p.requestedBy, status: 'Approved', approvedBy: approver,
      dateApproved: _today(), notes: p.notes, receiptNo: p.receiptNo,
    );
    notifyListeners();
  }

  void rejectPettyCash(String id) {
    final idx = _pettyCash.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final p = _pettyCash[idx];
    _pettyCash[idx] = PettyCashEntry(
      id: p.id, date: p.date, description: p.description, amount: p.amount,
      requestedBy: p.requestedBy, status: 'Rejected', approvedBy: p.approvedBy,
      dateApproved: p.dateApproved, notes: p.notes, receiptNo: p.receiptNo,
    );
    notifyListeners();
  }

  void disbursePettyCash(String id) {
    final idx = _pettyCash.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final p = _pettyCash[idx];
    _pettyCash[idx] = PettyCashEntry(
      id: p.id, date: p.date, description: p.description, amount: p.amount,
      requestedBy: p.requestedBy, status: 'Disbursed', approvedBy: p.approvedBy ?? 'Bursar',
      dateApproved: p.dateApproved ?? _today(), notes: p.notes,
      receiptNo: p.receiptNo ?? 'PC-${_pettyCash.length + 10}',
    );
    notifyListeners();
  }

  // ── Imprest ──
  void retireImprest(String id, double retiredAmount, String voucherNo) {
    final idx = _imprest.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    final i = _imprest[idx];
    _imprest[idx] = ImprestAccount(
      id: i.id, holder: i.holder, department: i.department, amount: i.amount,
      dateIssued: i.dateIssued, purpose: i.purpose, status: 'Retired', notes: i.notes,
      retiredAmount: retiredAmount, dateRetired: _today(), retirementVoucherNo: voucherNo,
    );
    notifyListeners();
  }

  // ── Procurement ──
  void addProcurement({required String item, required int quantity, required String unit, required double estimatedCost, required String supplier, required String requestedBy, required String department, required String notes}) {
    _procurement.insert(0, ProcurementRequest(
      id: _nextId(), date: _today(), item: item, quantity: quantity, unit: unit,
      estimatedCost: estimatedCost, supplier: supplier, requestedBy: requestedBy,
      department: department, status: 'Requisitioned', notes: notes,
    ));
    notifyListeners();
  }

  void approveProcurement(String id) {
    _updateProcurementStatus(id, 'Approved');
  }

  void rejectProcurement(String id) {
    _updateProcurementStatus(id, 'Rejected');
  }

  void orderProcurement(String id) {
    _updateProcurementStatus(id, 'Ordered');
  }

  void deliverProcurement(String id, double actualCost) {
    final idx = _procurement.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final p = _procurement[idx];
    _procurement[idx] = ProcurementRequest(
      id: p.id, date: p.date, item: p.item, quantity: p.quantity, unit: p.unit,
      estimatedCost: p.estimatedCost, actualCost: actualCost, supplier: p.supplier,
      requestedBy: p.requestedBy, department: p.department, status: 'Delivered',
      dateDelivered: _today(), notes: p.notes,
    );
    notifyListeners();
  }

  void _updateProcurementStatus(String id, String status) {
    final idx = _procurement.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final p = _procurement[idx];
    _procurement[idx] = ProcurementRequest(
      id: p.id, date: p.date, item: p.item, quantity: p.quantity, unit: p.unit,
      estimatedCost: p.estimatedCost, actualCost: p.actualCost, supplier: p.supplier,
      requestedBy: p.requestedBy, department: p.department, status: status,
      dateDelivered: p.dateDelivered, notes: p.notes,
    );
    notifyListeners();
  }

  // ── Feeding ──
  void addFeedingRecord({required String date, required String meal, required int headcount, required double costPerHead, required String notes}) {
    _feeding.insert(0, FeedingRecord(
      id: _nextId(), date: date, meal: meal, headcount: headcount,
      costPerHead: costPerHead, totalCost: headcount * costPerHead, status: 'Served', notes: notes,
    ));
    notifyListeners();
  }

  // ── Boarding Supplies ──
  void addBoardingSupply({required String item, required int quantity, required String unit, required double unitCost, required String datePurchased, required String supplier, required String house, required String notes}) {
    _boardingSupplies.insert(0, BoardingSupply(
      id: _nextId(), item: item, quantity: quantity, unit: unit, unitCost: unitCost,
      totalCost: quantity * unitCost, datePurchased: datePurchased, supplier: supplier,
      house: house, notes: notes,
    ));
    notifyListeners();
  }

  // ── Returns ──
  void generateReturn(String period, String dateFrom, String dateTo) {
    final income = _cashTransactions.where((t) => t.type == 'Income' && t.date.compareTo(dateFrom) >= 0 && t.date.compareTo(dateTo) <= 0).fold(0.0, (s, t) => s + t.amount);
    final expense = _cashTransactions.where((t) => t.type == 'Expense' && t.date.compareTo(dateFrom) >= 0 && t.date.compareTo(dateTo) <= 0).fold(0.0, (s, t) => s + t.amount);
    _returns.insert(0, BursaryReturn(
      id: _nextId(), period: period, dateFrom: dateFrom, dateTo: dateTo,
      totalIncome: income, totalExpense: expense, netBalance: income - expense,
      status: 'Draft', submittedBy: 'Bursar', dateSubmitted: '', notes: 'Generated from cash transactions',
      lineItems: [],
    ));
    notifyListeners();
  }

  void submitReturn(String id) {
    final idx = _returns.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    final r = _returns[idx];
    _returns[idx] = BursaryReturn(
      id: r.id, period: r.period, dateFrom: r.dateFrom, dateTo: r.dateTo,
      totalIncome: r.totalIncome, totalExpense: r.totalExpense, netBalance: r.netBalance,
      status: 'Submitted', submittedBy: r.submittedBy, dateSubmitted: _today(),
      notes: r.notes, lineItems: r.lineItems, approvedBy: r.approvedBy,
    );
    notifyListeners();
  }

  void approveReturn(String id, String approvedBy) {
    final idx = _returns.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    final r = _returns[idx];
    _returns[idx] = BursaryReturn(
      id: r.id, period: r.period, dateFrom: r.dateFrom, dateTo: r.dateTo,
      totalIncome: r.totalIncome, totalExpense: r.totalExpense, netBalance: r.netBalance,
      status: 'Approved', submittedBy: r.submittedBy, dateSubmitted: r.dateSubmitted,
      notes: r.notes, lineItems: r.lineItems, approvedBy: approvedBy,
    );
    notifyListeners();
  }

  void rejectReturn(String id) {
    final idx = _returns.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    final r = _returns[idx];
    _returns[idx] = BursaryReturn(
      id: r.id, period: r.period, dateFrom: r.dateFrom, dateTo: r.dateTo,
      totalIncome: r.totalIncome, totalExpense: r.totalExpense, netBalance: r.netBalance,
      status: 'Rejected', submittedBy: r.submittedBy, dateSubmitted: r.dateSubmitted,
      notes: r.notes, lineItems: r.lineItems, approvedBy: r.approvedBy,
    );
    notifyListeners();
  }
}
