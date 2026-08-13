import 'package:flutter/foundation.dart';
import 'app_models.dart';

/// Bursary store — fees, payroll, expenditure, budget, invoices.
class BursaryProvider extends ChangeNotifier {
  final List<FeeRecord> _fees = [
    FeeRecord(id: '1', studentName: 'Kwame Asante', admNo: '2026/001', className: 'SHS2 Sci A', term: 'Term 3 2025/2026', feeType: 'Tuition', amountDue: 1200, amountPaid: 1200, balance: 0, status: FeeStatus.cleared, guardianName: 'Mr. Kofi Asante', guardianPhone: '024-555-1001', lastPaymentDate: '2026-01-10'),
    FeeRecord(id: '2', studentName: 'Ama Owusu', admNo: '2026/002', className: 'SHS1 Arts B', term: 'Term 3 2025/2026', feeType: 'Tuition', amountDue: 1200, amountPaid: 600, balance: 600, status: FeeStatus.partial, guardianName: 'Mrs. Akosua Owusu', guardianPhone: '027-555-1002', lastPaymentDate: '2026-02-15'),
    FeeRecord(id: '3', studentName: 'Yao Mensah', admNo: '2026/003', className: 'SHS3 Bus A', term: 'Term 3 2025/2026', feeType: 'Tuition', amountDue: 1200, amountPaid: 900, balance: 300, status: FeeStatus.partial, guardianName: 'Mr. Daniel Mensah', guardianPhone: '020-555-1003', lastPaymentDate: '2026-03-01'),
    FeeRecord(id: '4', studentName: 'Efua Darko', admNo: '2025/145', className: 'SHS2 Sci B', term: 'Term 3 2025/2026', feeType: 'Tuition', amountDue: 1200, amountPaid: 1200, balance: 0, status: FeeStatus.cleared, guardianName: 'Mrs. Grace Darko', guardianPhone: '055-555-1004', lastPaymentDate: '2026-01-12'),
    FeeRecord(id: '5', studentName: 'Kofi Boateng', admNo: '2025/146', className: 'SHS3 Sci A', term: 'Term 3 2025/2026', feeType: 'Tuition', amountDue: 1200, amountPaid: 0, balance: 1200, status: FeeStatus.owing, guardianName: 'Mr. Samuel Boateng', guardianPhone: '024-555-1005'),
    FeeRecord(id: '6', studentName: 'Adwoa Frimpong', admNo: '2025/147', className: 'SHS1 Sci A', term: 'Term 3 2025/2026', feeType: 'Tuition', amountDue: 1200, amountPaid: 1200, balance: 0, status: FeeStatus.cleared, guardianName: 'Mr. Yaw Frimpong', guardianPhone: '027-555-1006', lastPaymentDate: '2026-01-20'),
    FeeRecord(id: '7', studentName: 'Kojo Addo', admNo: '2024/098', className: 'SHS3 Arts A', term: 'Term 3 2025/2026', feeType: 'Tuition', amountDue: 1200, amountPaid: 0, balance: 1200, status: FeeStatus.owing, guardianName: 'Mr. Peter Addo', guardianPhone: '020-555-1007'),
    FeeRecord(id: '8', studentName: 'Ama Owusu', admNo: '2026/002', className: 'SHS1 Arts B', term: 'Term 3 2025/2026', feeType: 'Boarding', amountDue: 800, amountPaid: 800, balance: 0, status: FeeStatus.cleared, guardianName: 'Mrs. Akosua Owusu', guardianPhone: '027-555-1002', lastPaymentDate: '2026-01-15'),
  ];

  final List<PayrollEntry> _payroll = [
    PayrollEntry(id: '1', staffName: 'J. Mensah', position: 'Senior Teacher', department: 'Mathematics', grossSalary: 4200, deductions: 630, netSalary: 3570, payPeriod: 'July 2026', status: PayrollStatus.processed, ssfContribution: 420, taxDeduction: 210),
    PayrollEntry(id: '2', staffName: 'G. Adjei', position: 'HOD Science', department: 'Science', grossSalary: 4800, deductions: 720, netSalary: 4080, payPeriod: 'July 2026', status: PayrollStatus.processed, ssfContribution: 480, taxDeduction: 240),
    PayrollEntry(id: '3', staffName: 'F. Boateng', position: 'Teacher (English)', department: 'English', grossSalary: 3600, deductions: 540, netSalary: 3060, payPeriod: 'July 2026', status: PayrollStatus.pending, ssfContribution: 360, taxDeduction: 180),
    PayrollEntry(id: '4', staffName: 'A. Tetteh', position: 'Accountant', department: 'Finance', grossSalary: 4500, deductions: 675, netSalary: 3825, payPeriod: 'July 2026', status: PayrollStatus.pending, ssfContribution: 450, taxDeduction: 225),
    PayrollEntry(id: '5', staffName: 'R. Amponsah', position: 'Asst. Headmaster', department: 'Administration', grossSalary: 5500, deductions: 825, netSalary: 4675, payPeriod: 'July 2026', status: PayrollStatus.processed, ssfContribution: 550, taxDeduction: 275),
    PayrollEntry(id: '6', staffName: 'D. Asante', position: 'Counsellor', department: 'Counselling', grossSalary: 3800, deductions: 570, netSalary: 3230, payPeriod: 'July 2026', status: PayrollStatus.pending, ssfContribution: 380, taxDeduction: 190),
  ];

  final List<ExpenditureRecord> _expenditure = [
    ExpenditureRecord(id: '1', date: '2026-07-06', category: ExpenditureCategory.utilities, description: 'Electricity bill — July', amount: 3200, vendor: 'ECG', paymentMethod: 'Bank Transfer', authorizedBy: 'Headmaster', receiptNo: 'ECG-2026-07', notes: 'Monthly electricity'),
    ExpenditureRecord(id: '2', date: '2026-07-05', category: ExpenditureCategory.stores, description: 'Cleaning supplies bulk purchase', amount: 850, vendor: 'CleanCo Ltd', paymentMethod: 'Cheque', authorizedBy: 'Accountant', receiptNo: 'CC-045', notes: 'Detergents, disinfectants'),
    ExpenditureRecord(id: '3', date: '2026-07-04', category: ExpenditureCategory.repairs, description: 'Science lab equipment repair', amount: 1400, vendor: 'LabTech Services', paymentMethod: 'Cash', authorizedBy: 'HOD Science', notes: 'Microscope and centrifuge repair'),
    ExpenditureRecord(id: '4', date: '2026-07-03', category: ExpenditureCategory.transport, description: 'School bus fuel — Week 1', amount: 1800, vendor: 'Goil', paymentMethod: 'Card', authorizedBy: 'Transport Officer', receiptNo: 'GOIL-W1', notes: 'Diesel for 3 buses'),
    ExpenditureRecord(id: '5', date: '2026-07-02', category: ExpenditureCategory.equipment, description: 'New desktop computers (5 units)', amount: 15000, vendor: 'CompuGhana', paymentMethod: 'Bank Transfer', authorizedBy: 'Headmaster', receiptNo: 'CG-2026-07', notes: 'ICT lab upgrade'),
    ExpenditureRecord(id: '6', date: '2026-06-28', category: ExpenditureCategory.misc, description: 'Sports day logistics', amount: 1200, vendor: 'Various', paymentMethod: 'Cash', authorizedBy: 'Sports Coach', notes: 'Refreshments, medals, decorations'),
  ];

  final List<BudgetItem> _budgetItems = [
    BudgetItem(id: '1', department: 'Academic', allocated: 45000, spent: 28000, remaining: 17000, term: 'Term 3 2025/2026', status: BudgetStatus.active, notes: 'Teaching materials, exam printing'),
    BudgetItem(id: '2', department: 'Domestic/Boarding', allocated: 80000, spent: 52000, remaining: 28000, term: 'Term 3 2025/2026', status: BudgetStatus.active, notes: 'Food, boarding supplies, utilities'),
    BudgetItem(id: '3', department: 'Administration', allocated: 30000, spent: 18500, remaining: 11500, term: 'Term 3 2025/2026', status: BudgetStatus.active, notes: 'Office supplies, communications'),
    BudgetItem(id: '4', department: 'Sports & Clubs', allocated: 15000, spent: 4200, remaining: 10800, term: 'Term 3 2025/2026', status: BudgetStatus.active, notes: 'Equipment, fixtures, competitions'),
    BudgetItem(id: '5', department: 'Science Lab', allocated: 20000, spent: 8500, remaining: 11500, term: 'Term 3 2025/2026', status: BudgetStatus.active, notes: 'Chemicals, apparatus, consumables'),
    BudgetItem(id: '6', department: 'ICT', allocated: 25000, spent: 15000, remaining: 10000, term: 'Term 3 2025/2026', status: BudgetStatus.active, notes: 'Computers, software, internet'),
  ];

  final List<Invoice> _invoices = [
    Invoice(id: '1', invoiceNo: 'INV-2026/101', studentName: 'Kofi Boateng', admNo: '2025/146', className: 'SHS3 Sci A', guardianName: 'Mr. Samuel Boateng', term: 'Term 3 2025/2026', items: [
      InvoiceItem(description: 'Tuition Fee', amount: 1200), InvoiceItem(description: 'Boarding Fee', amount: 800), InvoiceItem(description: 'Examination Fee', amount: 150),
    ], totalAmount: 2150, amountPaid: 0, balance: 2150, status: InvoiceStatus.overdue, dateIssued: '2026-01-15', dueDate: '2026-02-15', issuedBy: 'Accountant'),
    Invoice(id: '2', invoiceNo: 'INV-2026/102', studentName: 'Kojo Addo', admNo: '2024/098', className: 'SHS3 Arts A', guardianName: 'Mr. Peter Addo', term: 'Term 3 2025/2026', items: [
      InvoiceItem(description: 'Tuition Fee', amount: 1200), InvoiceItem(description: 'Examination Fee', amount: 150),
    ], totalAmount: 1350, amountPaid: 0, balance: 1350, status: InvoiceStatus.overdue, dateIssued: '2026-01-15', dueDate: '2026-02-15', issuedBy: 'Accountant'),
    Invoice(id: '3', invoiceNo: 'INV-2026/103', studentName: 'Ama Owusu', admNo: '2026/002', className: 'SHS1 Arts B', guardianName: 'Mrs. Akosua Owusu', term: 'Term 3 2025/2026', items: [
      InvoiceItem(description: 'Tuition Fee', amount: 1200), InvoiceItem(description: 'Boarding Fee', amount: 800),
    ], totalAmount: 2000, amountPaid: 1400, balance: 600, status: InvoiceStatus.issued, dateIssued: '2026-01-15', dueDate: '2026-03-15', issuedBy: 'Accountant'),
  ];

  final List<PaymentReceipt> _receipts = [];
  final List<BudgetSubmission> _budgetSubmissions = [
    BudgetSubmission(id: 'bs1', department: 'Science Lab', submittedBy: 'G. Adjei', supervisorName: 'R. Amponsah', dateSubmitted: '2026-07-05', totalRequested: 5800, status: 'Accountant Approved', justification: 'Lab chemicals and apparatus for Term 3 practicals', items: [
      BudgetSubmissionItem(description: 'Chemistry reagents set', quantity: 10, unitCost: 250, total: 2500),
      BudgetSubmissionItem(description: 'Physics apparatus', quantity: 5, unitCost: 400, total: 2000),
      BudgetSubmissionItem(description: 'Biology specimens', quantity: 1, unitCost: 1300, total: 1300),
    ], supervisorNotes: 'Essential for WASSCE preparation', accountantNotes: 'Approved — allocate from Science Lab budget'),
    BudgetSubmission(id: 'bs2', department: 'Sports & Clubs', submittedBy: 'C. Dankwah', supervisorName: 'R. Amponsah', dateSubmitted: '2026-07-08', totalRequested: 6700, status: 'Pending Accountant', justification: 'Sports equipment and inter-house competition logistics', items: [
      BudgetSubmissionItem(description: 'Football jerseys', quantity: 20, unitCost: 80, total: 1600),
      BudgetSubmissionItem(description: 'Athletics equipment', quantity: 1, unitCost: 3000, total: 3000),
      BudgetSubmissionItem(description: 'Inter-house logistics', quantity: 1, unitCost: 2100, total: 2100),
    ], supervisorNotes: 'Sports day is approaching', accountantNotes: ''),
    BudgetSubmission(id: 'bs3', department: 'Domestic/Boarding', submittedBy: 'Domestic Bursar', supervisorName: 'R. Amponsah', dateSubmitted: '2026-07-09', totalRequested: 21500, status: 'Pending Supervisor', justification: 'Boarding supplies and dormitory repairs', items: [
      BudgetSubmissionItem(description: 'Mattresses (double)', quantity: 40, unitCost: 250, total: 10000),
      BudgetSubmissionItem(description: 'Bedding sets', quantity: 80, unitCost: 75, total: 6000),
      BudgetSubmissionItem(description: 'Dormitory repairs', quantity: 1, unitCost: 5500, total: 5500),
    ], supervisorNotes: '', accountantNotes: ''),
    BudgetSubmission(id: 'bs4', department: 'ICT', submittedBy: 'M. Owusu', supervisorName: 'R. Amponsah', dateSubmitted: '2026-07-07', totalRequested: 7000, status: 'Supervisor Approved', justification: 'Network infrastructure upgrade and software licenses', items: [
      BudgetSubmissionItem(description: 'Network switches', quantity: 4, unitCost: 800, total: 3200),
      BudgetSubmissionItem(description: 'Software licenses', quantity: 1, unitCost: 2000, total: 2000),
      BudgetSubmissionItem(description: 'Cabling & accessories', quantity: 1, unitCost: 1800, total: 1800),
    ], supervisorNotes: 'Urgent — network is unstable', accountantNotes: ''),
    BudgetSubmission(id: 'bs5', department: 'Library', submittedBy: 'L. Frimpong', supervisorName: 'R. Amponsah', dateSubmitted: '2026-07-10', totalRequested: 7000, status: 'Pending Supervisor', justification: 'New textbooks and reference materials', items: [
      BudgetSubmissionItem(description: 'Core textbooks', quantity: 200, unitCost: 20, total: 4000),
      BudgetSubmissionItem(description: 'Reference encyclopedias', quantity: 1, unitCost: 2000, total: 2000),
      BudgetSubmissionItem(description: 'Library shelving', quantity: 2, unitCost: 500, total: 1000),
    ], supervisorNotes: '', accountantNotes: ''),
  ];

  List<FeeRecord> get fees => List.unmodifiable(_fees);
  List<PayrollEntry> get payroll => List.unmodifiable(_payroll);
  List<ExpenditureRecord> get expenditure => List.unmodifiable(_expenditure);
  List<BudgetItem> get budgetItems => List.unmodifiable(_budgetItems);
  List<Invoice> get invoices => List.unmodifiable(_invoices);
  List<PaymentReceipt> get receipts => List.unmodifiable(_receipts);
  List<BudgetSubmission> get budgetSubmissions => List.unmodifiable(_budgetSubmissions);

  double get totalCollected => _fees.fold(0, (sum, f) => sum + f.amountPaid);
  double get totalOutstanding => _fees.fold(0, (sum, f) => sum + f.balance);
  double get totalPayrollGross => _payroll.fold(0, (sum, p) => sum + p.grossSalary);
  double get totalPayrollNet => _payroll.fold(0, (sum, p) => sum + p.netSalary);
  double get totalExpenditure => _expenditure.fold(0, (sum, e) => sum + e.amount);
  double get totalBudgetAllocated => _budgetItems.fold(0, (sum, b) => sum + b.allocated);
  double get totalBudgetSpent => _budgetItems.fold(0, (sum, b) => sum + b.spent);
  double get totalBudgetRemaining => _budgetItems.fold(0, (sum, b) => sum + b.remaining);
  int get overdueInvoiceCount => _invoices.where((i) => i.status == InvoiceStatus.overdue).length;

  List<PayrollEntry> get processedPayroll => _payroll.where((p) => p.status == PayrollStatus.processed).toList();
  List<Invoice> get overdueInvoices => _invoices.where((i) => i.status == InvoiceStatus.overdue).toList();
  List<BudgetSubmission> get pendingBudgetSubmissions => _budgetSubmissions.where((b) => b.status == 'Pending Accountant' || b.status == 'Supervisor Approved').toList();
  List<BudgetSubmission> get approvedBudgetSubmissions => _budgetSubmissions.where((b) => b.status == 'Accountant Approved').toList();
  double get totalPayrollDeductions => _payroll.fold(0, (sum, p) => sum + p.deductions);

  static int _idCounter = 100;
  String _nextId() => (++_idCounter).toString();
  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  void payPayroll(String id) {
    final idx = _payroll.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final p = _payroll[idx];
    _payroll[idx] = PayrollEntry(
      id: p.id, staffName: p.staffName, position: p.position, department: p.department,
      grossSalary: p.grossSalary, deductions: p.deductions, netSalary: p.netSalary,
      payPeriod: p.payPeriod, status: PayrollStatus.paid,
      ssfContribution: p.ssfContribution, taxDeduction: p.taxDeduction,
    );
    notifyListeners();
  }

  void processPayroll(String id) {
    final idx = _payroll.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    final p = _payroll[idx];
    _payroll[idx] = PayrollEntry(
      id: p.id, staffName: p.staffName, position: p.position, department: p.department,
      grossSalary: p.grossSalary, deductions: p.deductions, netSalary: p.netSalary,
      payPeriod: p.payPeriod, status: PayrollStatus.processed,
      ssfContribution: p.ssfContribution, taxDeduction: p.taxDeduction,
    );
    notifyListeners();
  }

  void recordPayment(String feeId, double amount, String method, String receivedBy, String notes) {
    final idx = _fees.indexWhere((f) => f.id == feeId);
    if (idx < 0) return;
    final f = _fees[idx];
    final newPaid = f.amountPaid + amount;
    final newBalance = f.amountDue - newPaid;
    final newStatus = newBalance <= 0 ? FeeStatus.cleared : (newPaid > 0 ? FeeStatus.partial : FeeStatus.owing);
    _fees[idx] = FeeRecord(
      id: f.id, studentName: f.studentName, admNo: f.admNo, className: f.className,
      term: f.term, feeType: f.feeType, amountDue: f.amountDue, amountPaid: newPaid,
      balance: newBalance, status: newStatus, guardianName: f.guardianName,
      guardianPhone: f.guardianPhone, lastPaymentDate: _today(),
    );
    _receipts.insert(0, PaymentReceipt(
      id: _nextId(), receiptNo: 'RCP-${2026}-${_receipts.length + 1}', feeId: feeId,
      studentName: f.studentName, admNo: f.admNo, amount: amount, method: method,
      date: _today(), receivedBy: receivedBy, notes: notes,
    ));
    notifyListeners();
  }

  void recordExpenditure({required String category, required String description, required double amount, required String vendor, String paymentMethod = 'Cash', required String authorizedBy, String notes = ''}) {
    _expenditure.insert(0, ExpenditureRecord(
      id: _nextId(), date: _today(), category: _parseCategory(category),
      description: description, amount: amount, vendor: vendor, paymentMethod: paymentMethod, authorizedBy: authorizedBy, notes: notes,
    ));
    notifyListeners();
  }

  void cancelInvoice(String id) {
    final idx = _invoices.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    final inv = _invoices[idx];
    _invoices[idx] = Invoice(
      id: inv.id, invoiceNo: inv.invoiceNo, studentName: inv.studentName, admNo: inv.admNo,
      className: inv.className, guardianName: inv.guardianName, term: inv.term, items: inv.items,
      totalAmount: inv.totalAmount, amountPaid: inv.amountPaid, balance: inv.balance,
      status: InvoiceStatus.cancelled, dateIssued: inv.dateIssued, dueDate: inv.dueDate, issuedBy: inv.issuedBy,
    );
    notifyListeners();
  }

  ExpenditureCategory _parseCategory(String s) {
    switch (s) {
      case 'Utilities': return ExpenditureCategory.utilities;
      case 'Stores': return ExpenditureCategory.stores;
      case 'Repairs': return ExpenditureCategory.repairs;
      case 'Salaries': return ExpenditureCategory.salaries;
      case 'Transport': return ExpenditureCategory.transport;
      case 'Equipment': return ExpenditureCategory.equipment;
      case 'Capital': return ExpenditureCategory.capital;
      default: return ExpenditureCategory.misc;
    }
  }

  List<Map<String, dynamic>> getExpenditureByCategory() {
    final cats = <String, double>{};
    for (final e in _expenditure) {
      final name = e.category.name[0].toUpperCase() + e.category.name.substring(1);
      cats[name] = (cats[name] ?? 0) + e.amount;
    }
    return cats.entries.map((e) => {'category': e.key, 'total': e.value}).toList();
  }

  void approveBudgetSubmissionAccountant(String id, String notes) {
    final idx = _budgetSubmissions.indexWhere((b) => b.id == id);
    if (idx < 0) return;
    final b = _budgetSubmissions[idx];
    _budgetSubmissions[idx] = BudgetSubmission(
      id: b.id, department: b.department, submittedBy: b.submittedBy,
      supervisorName: b.supervisorName, dateSubmitted: b.dateSubmitted,
      totalRequested: b.totalRequested, status: 'Accountant Approved',
      justification: b.justification, items: b.items,
      supervisorNotes: b.supervisorNotes, accountantNotes: notes,
    );
    notifyListeners();
  }

  void rejectBudgetSubmission(String id, String notes) {
    final idx = _budgetSubmissions.indexWhere((b) => b.id == id);
    if (idx < 0) return;
    final b = _budgetSubmissions[idx];
    _budgetSubmissions[idx] = BudgetSubmission(
      id: b.id, department: b.department, submittedBy: b.submittedBy,
      supervisorName: b.supervisorName, dateSubmitted: b.dateSubmitted,
      totalRequested: b.totalRequested, status: 'Rejected',
      justification: b.justification, items: b.items,
      supervisorNotes: b.supervisorNotes, accountantNotes: notes,
    );
    notifyListeners();
  }

  void disburseBudgetSubmission(String id, String disbursedBy) {
    final idx = _budgetSubmissions.indexWhere((b) => b.id == id);
    if (idx < 0) return;
    final b = _budgetSubmissions[idx];
    _budgetSubmissions[idx] = BudgetSubmission(
      id: b.id, department: b.department, submittedBy: b.submittedBy,
      supervisorName: b.supervisorName, dateSubmitted: b.dateSubmitted,
      totalRequested: b.totalRequested, status: 'Disbursed',
      justification: b.justification, items: b.items,
      supervisorNotes: b.supervisorNotes, accountantNotes: b.accountantNotes,
    );
    notifyListeners();
  }
}
