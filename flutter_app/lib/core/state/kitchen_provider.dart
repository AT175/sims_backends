import 'package:flutter/foundation.dart';

class KitchenStockItem {
  final String id, name, unit, category;
  final int quantity, reorderLevel;
  const KitchenStockItem({required this.id, required this.name, required this.quantity, required this.unit, required this.reorderLevel, required this.category});
}

class KitchenIssueLog {
  final String id, date, itemName, issuedTo, purpose;
  final int quantity;
  final String unit;
  const KitchenIssueLog({required this.id, required this.date, required this.itemName, required this.quantity, required this.unit, required this.issuedTo, required this.purpose});
}

class MenuDay {
  final String id, day, breakfast, lunch, dinner;
  const MenuDay({required this.id, required this.day, required this.breakfast, required this.lunch, required this.dinner});
}

class CustomMenu {
  final String id, personName, personRole, reason, day, breakfast, lunch, dinner;
  final bool active;
  const CustomMenu({required this.id, required this.personName, required this.personRole, required this.reason, required this.day, required this.breakfast, required this.lunch, required this.dinner, required this.active});
}

class KitchenFinancialReq {
  final String id, date, purpose, requestedBy, status, notes;
  final double amount;
  const KitchenFinancialReq({required this.id, required this.date, required this.amount, required this.purpose, required this.requestedBy, required this.status, required this.notes});
}

class HeadcountEntry {
  final String id, date;
  final int breakfast, lunch, dinner;
  const HeadcountEntry({required this.id, required this.date, required this.breakfast, required this.lunch, required this.dinner});
}

class StaffMember {
  final String id, name, role, shift, status, phone;
  final int attendancePresent, attendanceTotal;
  const StaffMember({required this.id, required this.name, required this.role, required this.shift, required this.status, required this.phone, required this.attendancePresent, required this.attendanceTotal});
}

class InspectionRecord {
  final String id, date, area, inspector, result, notes;
  final int score;
  const InspectionRecord({required this.id, required this.date, required this.area, required this.inspector, required this.result, required this.score, required this.notes});
}

class CostEstimate {
  final String id, meal, date;
  final int servings, totalCost;
  final double costPerServing;
  const CostEstimate({required this.id, required this.meal, required this.date, required this.servings, required this.costPerServing, required this.totalCost});
}

class KitchenProvider extends ChangeNotifier {
  int _idCounter = 200;
  String _nextId() { _idCounter++; return '$_idCounter'; }
  String _today() => DateTime.now().toIso8601String().split('T')[0];

  final List<KitchenStockItem> _stock = [
    KitchenStockItem(id: '1', name: 'Maize bags', quantity: 80, unit: 'bags', reorderLevel: 30, category: 'Grains'),
    KitchenStockItem(id: '2', name: 'Rice', quantity: 35, unit: 'bags', reorderLevel: 20, category: 'Grains'),
    KitchenStockItem(id: '3', name: 'Cooking oil', quantity: 12, unit: 'gallons', reorderLevel: 15, category: 'Cooking'),
    KitchenStockItem(id: '4', name: 'Tomatoes', quantity: 8, unit: 'crates', reorderLevel: 10, category: 'Produce'),
    KitchenStockItem(id: '5', name: 'Onions', quantity: 6, unit: 'sacks', reorderLevel: 8, category: 'Produce'),
    KitchenStockItem(id: '6', name: 'Chicken', quantity: 20, unit: 'cartons', reorderLevel: 10, category: 'Protein'),
    KitchenStockItem(id: '7', name: 'Fish (tilapia)', quantity: 15, unit: 'boxes', reorderLevel: 10, category: 'Protein'),
    KitchenStockItem(id: '8', name: 'Salt', quantity: 5, unit: 'bags', reorderLevel: 3, category: 'Condiments'),
    KitchenStockItem(id: '9', name: 'Pepper', quantity: 4, unit: 'sacks', reorderLevel: 5, category: 'Produce'),
    KitchenStockItem(id: '10', name: 'Firewood', quantity: 25, unit: 'loads', reorderLevel: 15, category: 'Fuel'),
  ];

  final List<KitchenIssueLog> _issues = [
    KitchenIssueLog(id: '1', date: '2026-07-08', itemName: 'Maize bags', quantity: 10, unit: 'bags', issuedTo: 'Kitchen - Breakfast', purpose: 'Porridge preparation'),
    KitchenIssueLog(id: '2', date: '2026-07-08', itemName: 'Cooking oil', quantity: 2, unit: 'gallons', issuedTo: 'Kitchen - Lunch', purpose: 'Jollof rice'),
    KitchenIssueLog(id: '3', date: '2026-07-07', itemName: 'Rice', quantity: 8, unit: 'bags', issuedTo: 'Kitchen - Lunch', purpose: 'Waakye preparation'),
    KitchenIssueLog(id: '4', date: '2026-07-07', itemName: 'Chicken', quantity: 5, unit: 'cartons', issuedTo: 'Kitchen - Dinner', purpose: 'Chicken stew'),
  ];

  final List<MenuDay> _menu = [
    MenuDay(id: 'm1', day: 'Monday', breakfast: 'Porridge + bread', lunch: 'Jollof rice + chicken', dinner: 'Banku + tilapia'),
    MenuDay(id: 'm2', day: 'Tuesday', breakfast: 'Tea + eggs', lunch: 'Fufu + goat soup', dinner: 'Rice + stew'),
    MenuDay(id: 'm3', day: 'Wednesday', breakfast: 'Hausa koko + koko bread', lunch: 'Kenkey + fried fish', dinner: 'Yam + garden egg stew'),
    MenuDay(id: 'm4', day: 'Thursday', breakfast: 'Tea + bread', lunch: 'Waakye + egg', dinner: 'Tuo zaafi + ayoyo'),
    MenuDay(id: 'm5', day: 'Friday', breakfast: 'Porridge + bread', lunch: 'Plain rice + chicken stew', dinner: 'Konkonte + groundnut soup'),
  ];

  final List<CustomMenu> _customMenus = [
    CustomMenu(id: 'c1', personName: 'Kwame Asante', personRole: 'Student', reason: 'Lactose intolerant', day: 'Monday', breakfast: 'Tea (no milk) + bread', lunch: 'Jollof rice (no butter)', dinner: 'Banku + tilapia', active: true),
    CustomMenu(id: 'c2', personName: 'Mr. Osei', personRole: 'Teacher', reason: 'Diabetic diet', day: 'Tuesday', breakfast: 'Plain tea + eggs', lunch: 'Fufu + light soup (no palm oil)', dinner: 'Grilled chicken + salad', active: true),
    CustomMenu(id: 'c3', personName: 'Ama Owusu', personRole: 'Student', reason: 'Vegetarian', day: 'Wednesday', breakfast: 'Hausa koko + bread', lunch: 'Kenkey + garden egg stew (no fish)', dinner: 'Yam + vegetable stew', active: true),
  ];

  final List<KitchenFinancialReq> _financialReqs = [
    KitchenFinancialReq(id: 'f1', date: '2026-07-06', amount: 5000, purpose: 'Weekly foodstuff purchase', requestedBy: 'Catering Officer', status: 'Approved', notes: 'For week 2 supplies'),
    KitchenFinancialReq(id: 'f2', date: '2026-07-01', amount: 2500, purpose: 'Cooking gas refill', requestedBy: 'Catering Officer', status: 'Disbursed', notes: ''),
  ];

  final List<HeadcountEntry> _headcount = [
    HeadcountEntry(id: '1', date: '2026-07-06', breakfast: 832, lunch: 838, dinner: 825),
    HeadcountEntry(id: '2', date: '2026-07-05', breakfast: 830, lunch: 835, dinner: 820),
    HeadcountEntry(id: '3', date: '2026-07-04', breakfast: 828, lunch: 833, dinner: 818),
    HeadcountEntry(id: '4', date: '2026-07-03', breakfast: 825, lunch: 830, dinner: 815),
  ];

  final List<StaffMember> _staff = [
    StaffMember(id: '1', name: 'Madam Akos', role: 'Head Cook', shift: 'Full day', status: 'Active', phone: '024 111 2222', attendancePresent: 22, attendanceTotal: 24),
    StaffMember(id: '2', name: 'Mr. Kofi', role: 'Cook', shift: 'Morning', status: 'Active', phone: '020 333 4444', attendancePresent: 20, attendanceTotal: 24),
    StaffMember(id: '3', name: 'Ms. Esi', role: 'Kitchen Help', shift: 'Evening', status: 'Active', phone: '027 555 6666', attendancePresent: 21, attendanceTotal: 24),
    StaffMember(id: '4', name: 'Mr. Yaw', role: 'Cook', shift: 'Full day', status: 'On Leave', phone: '023 777 8888', attendancePresent: 15, attendanceTotal: 24),
  ];

  final List<InspectionRecord> _inspections = [
    InspectionRecord(id: '1', date: '2026-07-01', area: 'Main Kitchen', inspector: 'Mrs. Adjei', result: 'Passed', score: 95, notes: 'Clean, well organized'),
    InspectionRecord(id: '2', date: '2026-06-28', area: 'Store room', inspector: 'Mr. Tetteh', result: 'Action Needed', score: 72, notes: 'Reorganize dry goods, check expiry dates'),
    InspectionRecord(id: '3', date: '2026-06-15', area: 'Dining hall', inspector: 'Mrs. Adjei', result: 'Passed', score: 90, notes: 'Good condition'),
  ];

  final List<CostEstimate> _costs = [
    CostEstimate(id: '1', meal: 'Jollof rice + chicken', servings: 838, costPerServing: 8.5, totalCost: 7123, date: '2026-07-06'),
    CostEstimate(id: '2', meal: 'Fufu + goat soup', servings: 835, costPerServing: 12.0, totalCost: 10020, date: '2026-07-05'),
    CostEstimate(id: '3', meal: 'Waakye + egg', servings: 833, costPerServing: 6.5, totalCost: 5415, date: '2026-07-04'),
  ];

  // ── Getters ──
  List<KitchenStockItem> get stock => List.unmodifiable(_stock);
  List<KitchenIssueLog> get issues => List.unmodifiable(_issues);
  List<MenuDay> get menu => List.unmodifiable(_menu);
  List<CustomMenu> get customMenus => List.unmodifiable(_customMenus);
  List<KitchenFinancialReq> get financialReqs => List.unmodifiable(_financialReqs);
  List<HeadcountEntry> get headcount => List.unmodifiable(_headcount);
  List<StaffMember> get staff => List.unmodifiable(_staff);
  List<InspectionRecord> get inspections => List.unmodifiable(_inspections);
  List<CostEstimate> get costs => List.unmodifiable(_costs);

  int get lowStock => _stock.where((s) => s.quantity > 0 && s.quantity <= s.reorderLevel).length;
  int get outOfStock => _stock.where((s) => s.quantity == 0).length;
  List<KitchenStockItem> get lowStockList => _stock.where((s) => s.quantity > 0 && s.quantity <= s.reorderLevel).toList();
  List<KitchenStockItem> get outOfStockList => _stock.where((s) => s.quantity == 0).toList();
  List<CustomMenu> get activeCustomMenus => _customMenus.where((c) => c.active).toList();

  HeadcountEntry? get latestHeadcount => _headcount.isNotEmpty ? _headcount.first : null;
  int get avgHeadcount => _headcount.isNotEmpty ? (_headcount.fold(0, (s, h) => s + h.breakfast + h.lunch + h.dinner) ~/ _headcount.length) : 0;
  int get activeStaff => _staff.where((s) => s.status == 'Active').length;
  int get complianceScore => _inspections.isNotEmpty ? (_inspections.fold(0, (s, i) => s + i.score) ~/ _inspections.length) : 0;
  int get totalMealCost => _costs.fold(0, (s, c) => s + c.totalCost);
  double get avgCostPerServing => _costs.isNotEmpty ? (_costs.fold(0.0, (s, c) => s + c.costPerServing) / _costs.length) : 0.0;
  int get pendingFinReqs => _financialReqs.where((r) => r.status == 'Pending').length;
  double get totalFinRequested => _financialReqs.where((r) => r.status == 'Pending').fold(0.0, (s, r) => s + r.amount);
  double get totalFinDisbursed => _financialReqs.where((r) => r.status == 'Disbursed').fold(0.0, (s, r) => s + r.amount);

  // ── Stock mutations ──
  void addStockItem({required String name, required int quantity, required String unit, required int reorderLevel, required String category}) {
    _stock.add(KitchenStockItem(id: _nextId(), name: name, quantity: quantity, unit: unit, reorderLevel: reorderLevel, category: category));
    notifyListeners();
  }
  void updateStockItem(String id, {required String name, required int quantity, required String unit, required int reorderLevel, required String category}) {
    final idx = _stock.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    _stock[idx] = KitchenStockItem(id: id, name: name, quantity: quantity, unit: unit, reorderLevel: reorderLevel, category: category);
    notifyListeners();
  }
  void deleteStockItem(String id) { _stock.removeWhere((s) => s.id == id); notifyListeners(); }
  void restockItem(String id, int qty) {
    final idx = _stock.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _stock[idx];
    _stock[idx] = KitchenStockItem(id: s.id, name: s.name, quantity: s.quantity + qty, unit: s.unit, reorderLevel: s.reorderLevel, category: s.category);
    notifyListeners();
  }
  void issueItem({required String itemName, required int quantity, required String unit, required String issuedTo, required String purpose}) {
    _issues.insert(0, KitchenIssueLog(id: _nextId(), date: _today(), itemName: itemName, quantity: quantity, unit: unit, issuedTo: issuedTo, purpose: purpose));
    final idx = _stock.indexWhere((s) => s.name == itemName);
    if (idx >= 0) {
      final s = _stock[idx];
      _stock[idx] = KitchenStockItem(id: s.id, name: s.name, quantity: (s.quantity - quantity).clamp(0, 999999), unit: s.unit, reorderLevel: s.reorderLevel, category: s.category);
    }
    notifyListeners();
  }

  // ── Menu mutations ──
  void addMenuDay({required String day, required String breakfast, required String lunch, required String dinner}) {
    _menu.add(MenuDay(id: _nextId(), day: day, breakfast: breakfast, lunch: lunch, dinner: dinner));
    notifyListeners();
  }
  void updateMenuDay(String id, {required String day, required String breakfast, required String lunch, required String dinner}) {
    final idx = _menu.indexWhere((m) => m.id == id);
    if (idx < 0) return;
    _menu[idx] = MenuDay(id: id, day: day, breakfast: breakfast, lunch: lunch, dinner: dinner);
    notifyListeners();
  }
  void deleteMenuDay(String id) { _menu.removeWhere((m) => m.id == id); notifyListeners(); }

  // ── Custom menu mutations ──
  void addCustomMenu({required String personName, required String personRole, required String reason, required String day, required String breakfast, required String lunch, required String dinner}) {
    _customMenus.add(CustomMenu(id: _nextId(), personName: personName, personRole: personRole, reason: reason, day: day, breakfast: breakfast, lunch: lunch, dinner: dinner, active: true));
    notifyListeners();
  }
  void updateCustomMenu(String id, {required String personName, required String personRole, required String reason, required String day, required String breakfast, required String lunch, required String dinner}) {
    final idx = _customMenus.indexWhere((c) => c.id == id);
    if (idx < 0) return;
    final c = _customMenus[idx];
    _customMenus[idx] = CustomMenu(id: id, personName: personName, personRole: personRole, reason: reason, day: day, breakfast: breakfast, lunch: lunch, dinner: dinner, active: c.active);
    notifyListeners();
  }
  void deleteCustomMenu(String id) { _customMenus.removeWhere((c) => c.id == id); notifyListeners(); }
  void toggleCustomMenu(String id) {
    final idx = _customMenus.indexWhere((c) => c.id == id);
    if (idx < 0) return;
    final c = _customMenus[idx];
    _customMenus[idx] = CustomMenu(id: c.id, personName: c.personName, personRole: c.personRole, reason: c.reason, day: c.day, breakfast: c.breakfast, lunch: c.lunch, dinner: c.dinner, active: !c.active);
    notifyListeners();
  }

  // ── Financial req mutations ──
  void submitFinancialReq({required double amount, required String purpose, required String requestedBy, String notes = ''}) {
    _financialReqs.insert(0, KitchenFinancialReq(id: _nextId(), date: _today(), amount: amount, purpose: purpose, requestedBy: requestedBy, status: 'Pending', notes: notes));
    notifyListeners();
  }
  void updateFinancialReqStatus(String id, String newStatus) {
    final idx = _financialReqs.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    final r = _financialReqs[idx];
    _financialReqs[idx] = KitchenFinancialReq(id: r.id, date: r.date, amount: r.amount, purpose: r.purpose, requestedBy: r.requestedBy, status: newStatus, notes: r.notes);
    notifyListeners();
  }
  void deleteFinancialReq(String id) { _financialReqs.removeWhere((r) => r.id == id); notifyListeners(); }

  // ── Headcount mutations ──
  void addHeadcount({required String date, required int breakfast, required int lunch, required int dinner}) {
    _headcount.insert(0, HeadcountEntry(id: _nextId(), date: date, breakfast: breakfast, lunch: lunch, dinner: dinner));
    notifyListeners();
  }
  void updateHeadcount(String id, {required String date, required int breakfast, required int lunch, required int dinner}) {
    final idx = _headcount.indexWhere((h) => h.id == id);
    if (idx < 0) return;
    _headcount[idx] = HeadcountEntry(id: id, date: date, breakfast: breakfast, lunch: lunch, dinner: dinner);
    notifyListeners();
  }
  void deleteHeadcount(String id) { _headcount.removeWhere((h) => h.id == id); notifyListeners(); }

  // ── Staff mutations ──
  void addStaff({required String name, required String role, required String shift, required String phone}) {
    _staff.add(StaffMember(id: _nextId(), name: name, role: role, shift: shift, status: 'Active', phone: phone, attendancePresent: 0, attendanceTotal: 0));
    notifyListeners();
  }
  void updateStaff(String id, {required String name, required String role, required String shift, required String phone}) {
    final idx = _staff.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _staff[idx];
    _staff[idx] = StaffMember(id: id, name: name, role: role, shift: shift, status: s.status, phone: phone, attendancePresent: s.attendancePresent, attendanceTotal: s.attendanceTotal);
    notifyListeners();
  }
  void toggleStaffStatus(String id) {
    final idx = _staff.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _staff[idx];
    final next = s.status == 'Active' ? 'On Leave' : s.status == 'On Leave' ? 'Sick' : 'Active';
    _staff[idx] = StaffMember(id: s.id, name: s.name, role: s.role, shift: s.shift, status: next, phone: s.phone, attendancePresent: s.attendancePresent, attendanceTotal: s.attendanceTotal);
    notifyListeners();
  }
  void markAttendance(String id, bool present) {
    final idx = _staff.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _staff[idx];
    _staff[idx] = StaffMember(id: s.id, name: s.name, role: s.role, shift: s.shift, status: s.status, phone: s.phone, attendancePresent: s.attendancePresent + (present ? 1 : 0), attendanceTotal: s.attendanceTotal + 1);
    notifyListeners();
  }
  void deleteStaff(String id) { _staff.removeWhere((s) => s.id == id); notifyListeners(); }

  // ── Inspection mutations ──
  void addInspection({required String area, required String inspector, required int score, required String notes}) {
    final result = score >= 85 ? 'Passed' : score >= 60 ? 'Action Needed' : 'Failed';
    _inspections.insert(0, InspectionRecord(id: _nextId(), date: _today(), area: area, inspector: inspector, result: result, score: score, notes: notes));
    notifyListeners();
  }
  void updateInspection(String id, {required String area, required String inspector, required int score, required String notes}) {
    final idx = _inspections.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    final result = score >= 85 ? 'Passed' : score >= 60 ? 'Action Needed' : 'Failed';
    final i = _inspections[idx];
    _inspections[idx] = InspectionRecord(id: id, date: i.date, area: area, inspector: inspector, result: result, score: score, notes: notes);
    notifyListeners();
  }
  void deleteInspection(String id) { _inspections.removeWhere((i) => i.id == id); notifyListeners(); }

  // ── Cost estimate mutations ──
  void addCost({required String meal, required int servings, required double costPerServing}) {
    _costs.insert(0, CostEstimate(id: _nextId(), meal: meal, servings: servings, costPerServing: costPerServing, totalCost: (servings * costPerServing).round(), date: _today()));
    notifyListeners();
  }
  void updateCost(String id, {required String meal, required int servings, required double costPerServing}) {
    final idx = _costs.indexWhere((c) => c.id == id);
    if (idx < 0) return;
    final c = _costs[idx];
    _costs[idx] = CostEstimate(id: id, meal: meal, servings: servings, costPerServing: costPerServing, totalCost: (servings * costPerServing).round(), date: c.date);
    notifyListeners();
  }
  void deleteCost(String id) { _costs.removeWhere((c) => c.id == id); notifyListeners(); }
}
