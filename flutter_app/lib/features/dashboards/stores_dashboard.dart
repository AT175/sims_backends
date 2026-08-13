import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/kitchen_provider.dart';
import '../../core/state/requisition_provider.dart';
import '../../core/widgets/widgets.dart';

// ── Data Models ──

class StoreItem {
  final String id, name, category, unit;
  final int quantity, reorderLevel;
  final double unitCost;
  const StoreItem({required this.id, required this.name, required this.category, required this.quantity, required this.reorderLevel, required this.unit, required this.unitCost});
}

class ReceivedLog {
  final String id, date, itemName, unit, supplier, invoiceNo;
  final int quantity;
  const ReceivedLog({required this.id, required this.date, required this.itemName, required this.quantity, required this.unit, required this.supplier, required this.invoiceNo});
}

class SupplierEntry {
  final String id, name, phone, items;
  final int rating;
  const SupplierEntry({required this.id, required this.name, required this.phone, required this.items, required this.rating});
}

class AuditRecord {
  final String id, date, notes, status;
  final int itemsCounted, discrepancies;
  const AuditRecord({required this.id, required this.date, required this.itemsCounted, required this.discrepancies, required this.status, required this.notes});
}

// ── Provider ──

class StoresProvider extends ChangeNotifier {
  int _idCounter = 100;
  String _nextId() { _idCounter++; return '$_idCounter'; }
  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  final List<StoreItem> _inventory = [
    StoreItem(id: '1', name: 'Maize bags', category: 'Foodstuff', quantity: 120, reorderLevel: 50, unit: 'bags', unitCost: 180),
    StoreItem(id: '2', name: 'Cooking oil', category: 'Foodstuff', quantity: 15, reorderLevel: 20, unit: 'gallons', unitCost: 350),
    StoreItem(id: '3', name: 'Cleaning detergent', category: 'Cleaning', quantity: 8, reorderLevel: 10, unit: 'cartons', unitCost: 120),
    StoreItem(id: '4', name: 'Toilet roll', category: 'Cleaning', quantity: 65, reorderLevel: 30, unit: 'cartons', unitCost: 85),
    StoreItem(id: '5', name: 'Rice', category: 'Foodstuff', quantity: 45, reorderLevel: 25, unit: 'bags', unitCost: 220),
    StoreItem(id: '6', name: 'Chalk', category: 'Stationery', quantity: 12, reorderLevel: 15, unit: 'boxes', unitCost: 25),
    StoreItem(id: '7', name: 'First aid supplies', category: 'Medical', quantity: 12, reorderLevel: 25, unit: 'units', unitCost: 45),
    StoreItem(id: '8', name: 'Diesel', category: 'Fuel', quantity: 200, reorderLevel: 100, unit: 'litres', unitCost: 15),
    StoreItem(id: '9', name: 'Exercise books', category: 'Stationery', quantity: 500, reorderLevel: 200, unit: 'units', unitCost: 3),
    StoreItem(id: '10', name: 'Brooms', category: 'Cleaning', quantity: 5, reorderLevel: 12, unit: 'units', unitCost: 18),
  ];

  final List<ReceivedLog> _received = [
    ReceivedLog(id: '1', date: '2026-07-06', itemName: 'Maize bags', quantity: 50, unit: 'bags', supplier: 'Kumasi Grains Ltd', invoiceNo: 'INV-2401'),
    ReceivedLog(id: '2', date: '2026-07-03', itemName: 'Toilet roll', quantity: 20, unit: 'cartons', supplier: 'Hygiene Co.', invoiceNo: 'INV-2398'),
    ReceivedLog(id: '3', date: '2026-06-28', itemName: 'Rice', quantity: 30, unit: 'bags', supplier: 'Tamale Farms', invoiceNo: 'INV-2385'),
  ];

  final List<SupplierEntry> _suppliers = [
    SupplierEntry(id: '1', name: 'Kumasi Grains Ltd', phone: '024 111 2222', items: 'Maize, Rice, Beans', rating: 5),
    SupplierEntry(id: '2', name: 'Hygiene Co.', phone: '020 333 4444', items: 'Detergent, Toilet roll, Brooms', rating: 4),
    SupplierEntry(id: '3', name: 'Tamale Farms', phone: '027 555 6666', items: 'Rice, Maize', rating: 4),
    SupplierEntry(id: '4', name: 'MediSupply Ghana', phone: '023 777 8888', items: 'First aid, Medical supplies', rating: 5),
    SupplierEntry(id: '5', name: 'Stationery Hub', phone: '024 999 0000', items: 'Chalk, Exercise books, Pens', rating: 3),
  ];

  final List<AuditRecord> _audits = [
    AuditRecord(id: '1', date: '2026-06-30', itemsCounted: 342, discrepancies: 3, status: 'Completed', notes: '2 items over-counted, 1 under-counted. Adjusted.'),
    AuditRecord(id: '2', date: '2026-05-31', itemsCounted: 338, discrepancies: 1, status: 'Completed', notes: '1 missing carton of toilet roll. Written off.'),
  ];

  // ── Getters ──
  List<StoreItem> get inventory => List.unmodifiable(_inventory);
  List<ReceivedLog> get received => List.unmodifiable(_received);
  List<SupplierEntry> get suppliers => List.unmodifiable(_suppliers);
  List<AuditRecord> get audits => List.unmodifiable(_audits);

  List<StoreItem> get lowStockItems => _inventory.where((i) => i.quantity <= i.reorderLevel).toList();
  int get lowStockCount => lowStockItems.length;
  double get totalValue => _inventory.fold(0.0, (s, i) => s + i.quantity * i.unitCost);
  int get categoryCount => _inventory.map((i) => i.category).toSet().length;

  String stockStatus(StoreItem item) {
    if (item.quantity <= item.reorderLevel * 0.5) return 'Critical';
    if (item.quantity <= item.reorderLevel) return 'Low';
    return 'OK';
  }

  // ── Inventory mutations ──
  void addItem({required String name, required String category, required int quantity, required String unit, required int reorderLevel, required double unitCost}) {
    _inventory.add(StoreItem(id: _nextId(), name: name, category: category, quantity: quantity, reorderLevel: reorderLevel, unit: unit, unitCost: unitCost));
    notifyListeners();
  }
  void adjustStock(String id, int delta) {
    final idx = _inventory.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    final i = _inventory[idx];
    _inventory[idx] = StoreItem(id: i.id, name: i.name, category: i.category, quantity: (i.quantity + delta).clamp(0, 999999), reorderLevel: i.reorderLevel, unit: i.unit, unitCost: i.unitCost);
    notifyListeners();
  }
  void restockItem(String id, int qty) {
    adjustStock(id, qty);
    final item = _inventory.firstWhere((i) => i.id == id);
    _received.insert(0, ReceivedLog(id: _nextId(), date: _today(), itemName: item.name, quantity: qty, unit: item.unit, supplier: 'Direct Restock', invoiceNo: 'N/A'));
    notifyListeners();
  }
  void deleteItem(String id) { _inventory.removeWhere((i) => i.id == id); notifyListeners(); }

  // ── Received mutations ──
  void logReceived({required String itemName, required int quantity, required String unit, required String supplier, String invoiceNo = 'N/A'}) {
    _received.insert(0, ReceivedLog(id: _nextId(), date: _today(), itemName: itemName, quantity: quantity, unit: unit, supplier: supplier, invoiceNo: invoiceNo));
    final invItem = _inventory.firstWhere((i) => i.name.toLowerCase() == itemName.toLowerCase(), orElse: () => StoreItem(id: '', name: '', category: '', quantity: 0, reorderLevel: 0, unit: '', unitCost: 0));
    if (invItem.id.isNotEmpty) {
      adjustStock(invItem.id, quantity);
    }
    notifyListeners();
  }
  void deleteReceived(String id) { _received.removeWhere((r) => r.id == id); notifyListeners(); }

  // ── Supplier mutations ──
  void addSupplier({required String name, required String phone, required String items, required int rating}) {
    _suppliers.add(SupplierEntry(id: _nextId(), name: name, phone: phone, items: items, rating: rating));
    notifyListeners();
  }
  void deleteSupplier(String id) { _suppliers.removeWhere((s) => s.id == id); notifyListeners(); }

  // ── Audit mutations ──
  void addAudit({required int itemsCounted, required int discrepancies, required String notes}) {
    _audits.insert(0, AuditRecord(id: _nextId(), date: _today(), itemsCounted: itemsCounted, discrepancies: discrepancies, status: 'Completed', notes: notes));
    notifyListeners();
  }
  void deleteAudit(String id) { _audits.removeWhere((a) => a.id == id); notifyListeners(); }

  // ── Issue from inventory (for requisition issue) ──
  void deductStockForRequisition(String itemName, int qty) {
    final idx = _inventory.indexWhere((i) => i.name.toLowerCase() == itemName.toLowerCase());
    if (idx >= 0) {
      final i = _inventory[idx];
      _inventory[idx] = StoreItem(id: i.id, name: i.name, category: i.category, quantity: (i.quantity - qty).clamp(0, 999999), reorderLevel: i.reorderLevel, unit: i.unit, unitCost: i.unitCost);
      notifyListeners();
    }
  }
}

// ── Constants ──

const _categories = ['Foodstuff', 'Cleaning', 'Stationery', 'Medical', 'Fuel', 'Maintenance', 'Other'];
const _units = ['bags', 'cartons', 'gallons', 'boxes', 'units', 'litres', 'kg', 'rolls'];

String _today() => DateTime.now().toIso8601String().substring(0, 10);

Color _statusColor(String s) {
  switch (s) {
    case 'Critical': return AppColors.danger;
    case 'Low': return AppColors.warning;
    case 'OK': case 'Completed': case 'Issued': case 'Received': return AppColors.success;
    case 'Pending': return AppColors.warning;
    case 'Rejected': return AppColors.danger;
    case 'Domestic Approved': return AppColors.purple;
    case 'Senior Housemaster Approved': return AppColors.primaryLight;
    default: return AppColors.info;
  }
}

Widget _chip(String text, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
  child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
);

Widget _actionBtn(BuildContext context, String label, VoidCallback onPressed, {Color? color}) => SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: color ?? AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2)),
    onPressed: onPressed,
    child: Text(label, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600)),
  ),
);

Widget _pickerChips(String label, String selected, List<String> options, ValueChanged<String> onSelected) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: options.map((o) => GestureDetector(
      onTap: () => onSelected(o),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected == o ? AppColors.primary : Colors.transparent,
          border: Border.all(color: selected == o ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(o, style: TextStyle(fontSize: AppFontSize.sm, color: selected == o ? Colors.white : AppColors.textSecondary, fontWeight: selected == o ? FontWeight.w600 : FontWeight.normal)),
      ),
    )).toList()),
  ],
);

Widget _formField(String label, TextEditingController ctrl, {String? hint, TextInputType? keyboardType, bool multiline = false}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    TextField(
      controller: ctrl, keyboardType: keyboardType, maxLines: multiline ? 3 : 1,
      decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
    ),
  ],
);

void _showFormModal(BuildContext context, String title, Widget formContent, VoidCallback onSubmit, {String submitLabel = 'Submit'}) {
  showModalBottomSheet(
    context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
              GestureDetector(onTap: () => Navigator.pop(ctx), child: Icon(Icons.close, color: AppColors.textLight)),
            ]),
            const SizedBox(height: AppSpacing.md),
            formContent,
            const SizedBox(height: AppSpacing.lg),
            Row(children: [
              Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel'))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                onPressed: () { onSubmit(); Navigator.pop(ctx); },
                child: Text(submitLabel),
              )),
            ]),
          ]),
        ),
      ),
    ),
  );
}

Widget _alertCard(String title, String subtitle, Color color) => Container(
  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
  padding: const EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: color, width: 4))),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: color)),
    Text(subtitle, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
  ]),
);

void _confirmDelete(BuildContext context, String message, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Delete'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
        TextButton(style: TextButton.styleFrom(foregroundColor: AppColors.danger), onPressed: () { onConfirm(); Navigator.pop(ctx); }, child: Text('Delete')),
      ],
    ),
  );
}

// ── Dashboard ──

class StoresDashboard extends StatelessWidget {
  final String pageKey;
  const StoresDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'inventory': return const _InventoryPage();
      case 'received': return const _ReceivedPage();
      case 'requisition': return const _RequisitionPage();
      case 'kitchenIssues': return const _KitchenIssuePage();
      case 'suppliers': return const _SuppliersPage();
      case 'audit': return const _AuditPage();
      case 'alerts': return const _AlertsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StoresProvider>();
    final req = context.watch<RequisitionProvider>();
    final pendingReqs = req.pending.length;
    final readyToIssue = req.pendingStores.length;
    final lowStock = s.lowStockItems;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Items', value: '${s.inventory.length}', icon: Icons.inventory, color: AppColors.primary),
          StatCard(label: 'Low Stock', value: '${s.lowStockCount}', icon: Icons.warning, color: AppColors.danger),
          StatCard(label: 'Inventory Value', value: 'GHS ${s.totalValue.toStringAsFixed(0)}', icon: Icons.payments, color: AppColors.success),
          StatCard(label: 'Pending Reqs', value: '$pendingReqs', icon: Icons.pending_actions, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        StatCardGrid(cards: [
          StatCard(label: 'Ready to Issue', value: '$readyToIssue', icon: Icons.check_circle, color: AppColors.purple),
          StatCard(label: 'Suppliers', value: '${s.suppliers.length}', icon: Icons.local_shipping, color: AppColors.info),
          StatCard(label: 'Goods Received', value: '${s.received.length}', icon: Icons.inbox, color: AppColors.purple),
          StatCard(label: 'Categories', value: '${s.categoryCount}', icon: Icons.category, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Low-Stock Summary', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (lowStock.isEmpty)
          Text('All items are above reorder levels.', style: TextStyle(color: AppColors.textLight, fontStyle: FontStyle.italic))
        else
          ...lowStock.map((item) {
            final st = s.stockStatus(item);
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(st), width: 4))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(item.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text))),
                  _chip(st, _statusColor(st)),
                ]),
                Text('Current: ${item.quantity} ${item.unit} | Reorder at: ${item.reorderLevel} ${item.unit}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Shortfall: ${item.reorderLevel - item.quantity} ${item.unit}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600)),
              ]),
            );
          }),
        const SizedBox(height: AppSpacing.lg),
        Text('Recent Goods Received', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...s.received.take(3).map((item) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Text('${item.itemName} - ${item.date} | ${item.quantity} ${item.unit} | ${item.supplier}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        )),
      ]),
    );
  }
}

class _InventoryPage extends StatelessWidget {
  const _InventoryPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StoresProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Items', value: '${s.inventory.length}', icon: Icons.inventory, color: AppColors.primary),
          StatCard(label: 'Low Stock', value: '${s.lowStockCount}', icon: Icons.warning, color: AppColors.danger),
          StatCard(label: 'Inventory Value', value: 'GHS ${s.totalValue.toStringAsFixed(0)}', icon: Icons.payments, color: AppColors.success),
          StatCard(label: 'Categories', value: '${s.categoryCount}', icon: Icons.category, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _showItemModal(context, s), child: Text('+ Add Item'))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white), onPressed: () => _showRestockModal(context, s), child: Text('Restock'))),
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...s.inventory.map((item) {
          final st = s.stockStatus(item);
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                  Text('${item.category} | ${item.quantity} ${item.unit} | Reorder: ${item.reorderLevel} | GHS ${item.unitCost}/${item.unit}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                ])),
                _chip(st, _statusColor(st)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                _stockBtn(context, '-1', () => s.adjustStock(item.id, -1)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm), child: Text('${item.quantity}', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text))),
                _stockBtn(context, '+1', () => s.adjustStock(item.id, 1)),
                const SizedBox(width: AppSpacing.xs),
                _stockBtn(context, '+10', () => s.adjustStock(item.id, 10)),
                const Spacer(),
                GestureDetector(onTap: () => _confirmDelete(context, 'Remove ${item.name} from inventory?', () => s.deleteItem(item.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          );
        }),
      ]),
    );
  }

  Widget _stockBtn(BuildContext context, String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs), decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.primary))),
  );

  void _showItemModal(BuildContext context, StoresProvider s) {
    String category = _categories[0], unit = _units[0];
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final reorderCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    _showFormModal(context, 'Add Inventory Item', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Item Name', nameCtrl, hint: 'e.g. Maize bags'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Category', category, _categories, (v) => setState(() => category = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Quantity', qtyCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Unit', unit, _units, (v) => setState(() => unit = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Reorder Level', reorderCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Unit Cost (GHS)', costCtrl, keyboardType: TextInputType.number),
      ],
    )), () {
      final qty = int.tryParse(qtyCtrl.text) ?? 0;
      final reorder = int.tryParse(reorderCtrl.text) ?? 0;
      final cost = double.tryParse(costCtrl.text) ?? 0;
      if (nameCtrl.text.isEmpty) return;
      s.addItem(name: nameCtrl.text, category: category, quantity: qty, unit: unit, reorderLevel: reorder, unitCost: cost);
    });
  }

  void _showRestockModal(BuildContext context, StoresProvider s) {
    String? selectedId;
    final qtyCtrl = TextEditingController();
    _showFormModal(context, 'Restock Item', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Select Item', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: s.inventory.map((item) => GestureDetector(
          onTap: () => setState(() => selectedId = item.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: selectedId == item.id ? AppColors.primary : Colors.transparent,
              border: Border.all(color: selectedId == item.id ? AppColors.primary : AppColors.border),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(item.name, style: TextStyle(fontSize: AppFontSize.sm, color: selectedId == item.id ? Colors.white : AppColors.textSecondary, fontWeight: selectedId == item.id ? FontWeight.w600 : FontWeight.normal)),
          ),
        )).toList()),
        const SizedBox(height: AppSpacing.sm),
        _formField('Quantity to Add', qtyCtrl, keyboardType: TextInputType.number),
      ],
    )), () {
      final qty = int.tryParse(qtyCtrl.text) ?? 0;
      if (selectedId == null || qty <= 0) return;
      s.restockItem(selectedId!, qty);
    });
  }
}

class _ReceivedPage extends StatelessWidget {
  const _ReceivedPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StoresProvider>();
    final thisMonth = s.received.where((r) => r.date.startsWith(_today().substring(0, 7))).length;
    final suppliersUsed = s.received.map((r) => r.supplier).toSet().length;
    final totalItems = s.received.fold(0, (sum, r) => sum + r.quantity);
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Entries', value: '${s.received.length}', icon: Icons.inbox, color: AppColors.primary),
          StatCard(label: 'This Month', value: '$thisMonth', icon: Icons.calendar_today, color: AppColors.info),
          StatCard(label: 'Suppliers Used', value: '$suppliersUsed', icon: Icons.local_shipping, color: AppColors.success),
          StatCard(label: 'Total Items', value: '$totalItems', icon: Icons.inventory_2, color: AppColors.purple),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Log Goods Received', () => _showReceivedModal(context, s)),
        const SizedBox(height: AppSpacing.lg),
        ...s.received.map((item) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.itemName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${item.date} | ${item.quantity} ${item.unit} | ${item.supplier} | ${item.invoiceNo}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete this received log entry?', () => s.deleteReceived(item.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]),
    );
  }

  void _showReceivedModal(BuildContext context, StoresProvider s) {
    String unit = _units[0];
    final itemCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final supplierCtrl = TextEditingController();
    final invoiceCtrl = TextEditingController();
    _showFormModal(context, 'Log Goods Received', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Item Name', itemCtrl, hint: 'e.g. Maize bags'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Quantity', qtyCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Unit', unit, _units, (v) => setState(() => unit = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Supplier', supplierCtrl, hint: 'e.g. Kumasi Grains Ltd'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Invoice No. (optional)', invoiceCtrl, hint: 'e.g. INV-2402'),
      ],
    )), () {
      final qty = int.tryParse(qtyCtrl.text) ?? 0;
      if (itemCtrl.text.isEmpty || supplierCtrl.text.isEmpty || qty <= 0) return;
      s.logReceived(itemName: itemCtrl.text, quantity: qty, unit: unit, supplier: supplierCtrl.text, invoiceNo: invoiceCtrl.text.isEmpty ? 'N/A' : invoiceCtrl.text);
    });
  }
}

class _RequisitionPage extends StatelessWidget {
  const _RequisitionPage();
  @override
  Widget build(BuildContext context) {
    final req = context.watch<RequisitionProvider>();
    final s = context.watch<StoresProvider>();
    final all = req.requisitions;
    final readyToIssue = req.pendingStores;
    final issued = all.where((r) => r.status == 'Issued' || r.status == 'Received').length;
    final rejected = all.where((r) => r.status == 'Rejected').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total', value: '${all.length}', icon: Icons.pending_actions, color: AppColors.primary),
          StatCard(label: 'Ready to Issue', value: '${readyToIssue.length}', icon: Icons.check_circle, color: AppColors.warning),
          StatCard(label: 'Issued', value: '$issued', icon: Icons.inventory, color: AppColors.success),
          StatCard(label: 'Rejected', value: '$rejected', icon: Icons.cancel, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Requisition / Issue Log', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        Text('Issue items after approval from Senior Housemaster and Asst. Headmaster (Domestic)', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.lg),
        ...all.map((item) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.itemName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('${item.date} | ${item.quantity} ${item.unit} | ${item.department} | By ${item.requestedBy}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                if (item.house != null) Text('House: ${item.house}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                if (item.notes.isNotEmpty) Text(item.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
                if (item.approvals.isNotEmpty) Text('Approvals: ${item.approvals.map((a) => '${a.step}: ${a.action}').join(' -> ')}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
              ])),
              _chip(item.status, _statusColor(item.status)),
            ]),
            if (item.priority == 'Urgent')
              Padding(padding: const EdgeInsets.only(top: AppSpacing.xs), child: _chip('URGENT', AppColors.danger)),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              if (item.status == 'Domestic Approved')
                GestureDetector(onTap: () {
                  s.deductStockForRequisition(item.itemName, item.quantity);
                  req.issueByStores(item.id, 'Stores Officer');
                }, child: Container(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs), decoration: BoxDecoration(border: Border.all(color: AppColors.success, width: 1.5), borderRadius: BorderRadius.circular(AppRadius.sm)), child: Text('Issue & Deduct Stock', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.success, fontWeight: FontWeight.w600))))
              else if (item.status != 'Issued' && item.status != 'Received' && item.status != 'Rejected')
                Text('Awaiting approvals before issuance', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
              const Spacer(),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete this requisition?', () => req.deleteRequisition(item.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          ]),
        )),
      ]),
    );
  }
}

class _KitchenIssuePage extends StatelessWidget {
  const _KitchenIssuePage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    final lowStock = k.lowStockList;
    final outOfStock = k.outOfStockList;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Issues', value: '${k.issues.length}', icon: Icons.list, color: AppColors.primary),
          StatCard(label: 'Kitchen Stock', value: '${k.stock.length}', icon: Icons.inventory_2, color: AppColors.info),
          StatCard(label: 'Low Stock', value: '${lowStock.length}', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Out of Stock', value: '${outOfStock.length}', icon: Icons.error, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Items Issued to Kitchen', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        Text('Track all stock issued from stores to the kitchen for meal preparation', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.lg),
        if (outOfStock.isNotEmpty || lowStock.isNotEmpty)
          _alertCard('Kitchen Stock Alerts', '${outOfStock.map((s) => 'OUT: ${s.name}').join(', ')}${lowStock.isNotEmpty ? ' | ' : ''}${lowStock.map((s) => 'LOW: ${s.name} - ${s.quantity} ${s.unit} left').join(', ')}', AppColors.danger),
        const SizedBox(height: AppSpacing.sm),
        ...k.issues.map((i) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(i.itemName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${i.date} | ${i.quantity} ${i.unit} | ${i.issuedTo} | ${i.purpose}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
          ]),
        )),
      ]),
    );
  }
}

class _SuppliersPage extends StatelessWidget {
  const _SuppliersPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StoresProvider>();
    final topRated = s.suppliers.where((sup) => sup.rating >= 4).length;
    final avgRating = s.suppliers.isNotEmpty ? (s.suppliers.fold(0.0, (sum, sup) => sum + sup.rating) / s.suppliers.length).toStringAsFixed(1) : '0.0';
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Suppliers', value: '${s.suppliers.length}', icon: Icons.local_shipping, color: AppColors.primary),
          StatCard(label: 'Top Rated', value: '$topRated', icon: Icons.star, color: AppColors.success),
          StatCard(label: 'Avg Rating', value: avgRating, icon: Icons.trending_up, color: AppColors.accent),
          StatCard(label: 'Categories', value: '${s.suppliers.map((sup) => sup.items.split(',').map((e) => e.trim())).expand((e) => e).toSet().length}', icon: Icons.category, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Supplier', () => _showSupplierModal(context, s)),
        const SizedBox(height: AppSpacing.lg),
        ...s.suppliers.map((item) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(22)), child: Center(child: Text(item.name[0], style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: Colors.white)))),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text(item.phone, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ])),
              Row(children: List.generate(5, (idx) => Text(idx < item.rating ? '\u2605' : '\u2606', style: TextStyle(fontSize: AppFontSize.sm, color: idx < item.rating ? AppColors.accent : AppColors.textLight)))),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Text('Supplies: ${item.items}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            GestureDetector(onTap: () => _confirmDelete(context, 'Remove ${item.name}?', () => s.deleteSupplier(item.id)), child: Text('Remove', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]),
    );
  }

  void _showSupplierModal(BuildContext context, StoresProvider s) {
    int rating = 3;
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final itemsCtrl = TextEditingController();
    _showFormModal(context, 'Add Supplier', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Supplier Name', nameCtrl, hint: 'e.g. Kumasi Grains Ltd'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Phone', phoneCtrl, hint: 'e.g. 024 111 2222', keyboardType: TextInputType.phone),
        const SizedBox(height: AppSpacing.sm),
        _formField('Items Supplied', itemsCtrl, hint: 'e.g. Maize, Rice, Beans'),
        const SizedBox(height: AppSpacing.sm),
        Text('Rating', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        Row(children: List.generate(5, (idx) => GestureDetector(
          onTap: () => setState(() => rating = idx + 1),
          child: Text(idx < rating ? '\u2605' : '\u2606', style: TextStyle(fontSize: AppFontSize.xxl, color: idx < rating ? AppColors.accent : AppColors.textLight)),
        ))),
      ],
    )), () {
      if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) return;
      s.addSupplier(name: nameCtrl.text, phone: phoneCtrl.text, items: itemsCtrl.text.isEmpty ? 'General supplies' : itemsCtrl.text, rating: rating);
    });
  }
}

class _AuditPage extends StatelessWidget {
  const _AuditPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StoresProvider>();
    final completed = s.audits.where((a) => a.status == 'Completed').length;
    final totalDiscrepancies = s.audits.fold(0, (sum, a) => sum + a.discrepancies);
    final lastAudit = s.audits.isNotEmpty ? s.audits.first.date : 'None';
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Audits', value: '${s.audits.length}', icon: Icons.fact_check, color: AppColors.primary),
          StatCard(label: 'Completed', value: '$completed', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Discrepancies', value: '$totalDiscrepancies', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Last Audit', value: lastAudit, icon: Icons.event, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Start New Audit', () => _showAuditModal(context, s)),
        const SizedBox(height: AppSpacing.lg),
        ...s.audits.map((item) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.date, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('${item.itemsCounted} items counted | ${item.discrepancies} discrepancies', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ])),
              _chip(item.status, _statusColor(item.status)),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Text(item.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
            const SizedBox(height: AppSpacing.xs),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete this audit record?', () => s.deleteAudit(item.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]),
    );
  }

  void _showAuditModal(BuildContext context, StoresProvider s) {
    final countedCtrl = TextEditingController();
    final discrepCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Start New Audit', Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Items Counted', countedCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Discrepancies Found', discrepCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, multiline: true),
      ],
    ), () {
      final counted = int.tryParse(countedCtrl.text) ?? 0;
      final discrep = int.tryParse(discrepCtrl.text) ?? 0;
      if (countedCtrl.text.isEmpty) return;
      s.addAudit(itemsCounted: counted, discrepancies: discrep, notes: notesCtrl.text.isEmpty ? 'No notes.' : notesCtrl.text);
    });
  }
}

class _AlertsPage extends StatelessWidget {
  const _AlertsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StoresProvider>();
    final req = context.watch<RequisitionProvider>();
    final lowStock = s.lowStockItems;
    final critical = lowStock.where((i) => i.quantity <= i.reorderLevel * 0.5).length;
    final low = lowStock.where((i) => i.quantity > i.reorderLevel * 0.5).length;
    final healthy = s.inventory.length - lowStock.length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Alerts', value: '${lowStock.length}', icon: Icons.warning, color: AppColors.danger),
          StatCard(label: 'Critical', value: '$critical', icon: Icons.error, color: AppColors.danger),
          StatCard(label: 'Low', value: '$low', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Healthy', value: '$healthy', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Low-Stock Alerts', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        Text('Items below reorder threshold - auto-detected from inventory', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.lg),
        if (lowStock.isEmpty)
          Text('All items are above reorder levels.', style: TextStyle(color: AppColors.textLight, fontStyle: FontStyle.italic))
        else
          ...lowStock.map((item) {
            final st = s.stockStatus(item);
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(st), width: 4))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(item.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text))),
                  _chip(st, _statusColor(st)),
                ]),
                Text('Current: ${item.quantity} ${item.unit} | Reorder at: ${item.reorderLevel} ${item.unit}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Shortfall: ${item.reorderLevel - item.quantity} ${item.unit}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.sm),
                Row(children: [
                  GestureDetector(onTap: () {
                    final reorderQty = item.reorderLevel * 2 - item.quantity;
                    req.addRequisition(Requisition(
                      id: '', date: _today(), itemName: item.name, quantity: reorderQty, unit: item.unit,
                      department: 'Stores', status: 'Pending', requestedBy: 'Auto - Low Stock Alert',
                      priority: 'Urgent', notes: 'Auto-generated from low-stock alert', approvals: [],
                    ));
                  }, child: Container(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm), decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.md)), child: Text('Create Requisition', style: TextStyle(fontSize: AppFontSize.sm, color: Colors.white, fontWeight: FontWeight.w600)))),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(onTap: () => s.restockItem(item.id, item.reorderLevel * 2 - item.quantity), child: Container(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm), decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(AppRadius.md)), child: Text('Quick Restock', style: TextStyle(fontSize: AppFontSize.sm, color: Colors.white, fontWeight: FontWeight.w600)))),
                ]),
              ]),
            );
          }),
      ]),
    );
  }
}
