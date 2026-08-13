import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/kitchen_provider.dart';
import '../../core/state/requisition_provider.dart';
import '../../core/widgets/widgets.dart';

const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const _shifts = ['Morning', 'Afternoon', 'Evening', 'Full day'];
const _roles = ['Head Cook', 'Cook', 'Kitchen Help', 'Server', 'Cleaner'];
const _inspectionAreas = ['Main Kitchen', 'Store room', 'Dining hall', 'Pantry', 'Prep area', 'Wash area'];
const _stockCategories = ['Grains', 'Cooking', 'Produce', 'Protein', 'Condiments', 'Fuel', 'Other'];
const _stockUnits = ['bags', 'gallons', 'crates', 'sacks', 'cartons', 'boxes', 'loads', 'kg', 'litres'];
const _issueTargets = ['Kitchen - Breakfast', 'Kitchen - Lunch', 'Kitchen - Dinner', 'Kitchen - General', 'Store room'];
const _personRoles = ['Student', 'Teacher', 'Staff', 'Headmaster', 'Visitor', 'Medical'];
const _reqUnits = ['bags', 'cartons', 'gallons', 'boxes', 'units', 'litres', 'kg', 'rolls', 'bottles', 'packs'];
const _priorities = ['Low', 'Normal', 'Urgent'];

String _today() => DateTime.now().toIso8601String().substring(0, 10);

Color _statusColor(String s) {
  switch (s) {
    case 'Active': case 'Passed': case 'Disbursed': case 'Issued': return AppColors.success;
    case 'On Leave': case 'Pending': case 'Upcoming': return AppColors.warning;
    case 'Sick': case 'Failed': case 'Rejected': return AppColors.danger;
    case 'Action Needed': case 'Approved': return AppColors.info;
    default: return AppColors.primary;
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

void _showFormModal(BuildContext context, String title, Widget formContent, VoidCallback onSubmit, {String submitLabel = 'Save'}) {
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

class CateringDashboard extends StatelessWidget {
  final String pageKey;
  const CateringDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'menu': return const _MenuPage();
      case 'customMenu': return const _CustomMenuPage();
      case 'stock': return const _StockPage();
      case 'requisition': return const _RequisitionPage();
      case 'finance': return const _FinancePage();
      case 'headcount': return const _HeadcountPage();
      case 'staff': return const _StaffPage();
      case 'hygiene': return const _HygienePage();
      case 'cost': return const _CostPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    final req = context.watch<RequisitionProvider>();
    final myReqs = req.getByDepartment('Kitchen');
    final pendingReqs = myReqs.where((r) => r.status == 'Pending').length;
    final hc = k.latestHeadcount;
    final todayMeals = hc != null ? hc.breakfast + hc.lunch + hc.dinner : 0;
    final cs = k.complianceScore;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: "Today's Meals", value: '$todayMeals', icon: Icons.restaurant, color: AppColors.primary),
          StatCard(label: 'Avg Daily', value: '${k.avgHeadcount}', icon: Icons.trending_up, color: AppColors.info),
          StatCard(label: 'Active Staff', value: '${k.activeStaff}', icon: Icons.person, color: AppColors.success),
          StatCard(label: 'Hygiene Score', value: '$cs%', icon: Icons.cleaning_services, color: cs >= 85 ? AppColors.success : AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        StatCardGrid(cards: [
          StatCard(label: 'Pending Reqs', value: '$pendingReqs', icon: Icons.pending_actions, color: AppColors.warning),
          StatCard(label: 'Meal Cost', value: 'GHS ${k.avgCostPerServing.toStringAsFixed(2)}', icon: Icons.payments, color: AppColors.purple),
          StatCard(label: 'Menu Days', value: '${k.menu.length}', icon: Icons.calendar_today, color: AppColors.primary),
          StatCard(label: 'Inspections', value: '${k.inspections.length}', icon: Icons.fact_check, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Recent Headcount', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...k.headcount.take(3).map((h) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Text(h.date, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
            const SizedBox(width: AppSpacing.md),
            Text('B: ${h.breakfast}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            const SizedBox(width: AppSpacing.sm),
            Text('L: ${h.lunch}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            const SizedBox(width: AppSpacing.sm),
            Text('D: ${h.dinner}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
          ]),
        )),
        const SizedBox(height: AppSpacing.md),
        if (cs < 85) _alertCard('Hygiene Compliance Alert', 'Current compliance score is $cs%. Target is 85%+. Schedule an inspection.', AppColors.danger),
        if (pendingReqs > 0) _alertCard('$pendingReqs Pending Requisition${pendingReqs > 1 ? 's' : ''}', 'Awaiting Stores approval. Check the Requisition page for details.', AppColors.warning),
        if (k.outOfStock > 0 || k.lowStock > 0)
          _alertCard('Kitchen Stock Alert', '${k.outOfStock} item(s) OUT OF STOCK, ${k.lowStock} item(s) running low \u2014 check Kitchen Stock page.', k.outOfStock > 0 ? AppColors.danger : AppColors.warning),
        if (k.pendingFinReqs > 0)
          _alertCard('${k.pendingFinReqs} Pending Financial Request${k.pendingFinReqs > 1 ? 's' : ''}', 'GHS ${k.totalFinRequested.toStringAsFixed(0)} awaiting Bursar approval.', AppColors.info),
      ]),
    );
  }
}

class _MenuPage extends StatelessWidget {
  const _MenuPage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    final missingDays = _days.where((d) => !k.menu.any((m) => m.day == d)).toList();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Days Planned', value: '${k.menu.length}', icon: Icons.calendar_today, color: AppColors.primary),
          StatCard(label: 'Missing Days', value: '${missingDays.length}', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Custom Menus', value: '${k.activeCustomMenus.length}', icon: Icons.restaurant_menu, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Menu Day', () => _showMenuModal(context, k)),
        const SizedBox(height: AppSpacing.md),
        Text('Quick Templates', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _templateChip(context, 'Local Delights', k),
          _templateChip(context, 'Continental Mix', k),
          _templateChip(context, 'Budget Saver', k),
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...k.menu.map((m) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(m.day, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.primary))),
              GestureDetector(onTap: () => _showMenuModal(context, k, editing: m), child: Text('Edit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Remove menu for ${m.day}?', () => k.deleteMenuDay(m.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
            Text('Breakfast: ${m.breakfast.isEmpty ? '\u2014' : m.breakfast}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
            Text('Lunch: ${m.lunch.isEmpty ? '\u2014' : m.lunch}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
            Text('Dinner: ${m.dinner.isEmpty ? '\u2014' : m.dinner}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
          ]),
        )),
      ]),
    );
  }

  Widget _templateChip(BuildContext context, String name, KitchenProvider k) {
    final templates = {
      'Local Delights': ('Hausa koko + bread', 'Jollof rice + chicken', 'Banku + tilapia'),
      'Continental Mix': ('Tea + eggs + sausages', 'Fried rice + salad', 'Spaghetti + sauce'),
      'Budget Saver': ('Porridge + bread', 'Waakye + egg', 'Konkonte + groundnut soup'),
    };
    final tpl = templates[name]!;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.surfaceAlt, foregroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm)),
      onPressed: () {
        final usedDays = k.menu.map((m) => m.day).toSet();
        final nextDay = _days.firstWhere((d) => !usedDays.contains(d), orElse: () => '');
        if (nextDay.isEmpty) return;
        k.addMenuDay(day: nextDay, breakfast: tpl.$1, lunch: tpl.$2, dinner: tpl.$3);
      },
      child: Text(name, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
    );
  }

  void _showMenuModal(BuildContext context, KitchenProvider k, {MenuDay? editing}) {
    String day = editing?.day ?? _days.firstWhere((d) => !k.menu.any((m) => m.day == d), orElse: () => _days[0]);
    final bfCtrl = TextEditingController(text: editing?.breakfast ?? '');
    final lunchCtrl = TextEditingController(text: editing?.lunch ?? '');
    final dinnerCtrl = TextEditingController(text: editing?.dinner ?? '');
    _showFormModal(context, editing != null ? 'Edit Menu Day' : 'Add Menu Day', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Day', day, _days.where((d) => !k.menu.any((m) => m.day == d) || d == day).toList(), (v) => setState(() => day = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Breakfast', bfCtrl, hint: 'e.g. Porridge + bread'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Lunch', lunchCtrl, hint: 'e.g. Jollof rice + chicken'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Dinner', dinnerCtrl, hint: 'e.g. Banku + tilapia'),
      ],
    )), () {
      if (editing != null) {
        k.updateMenuDay(editing.id, day: day, breakfast: bfCtrl.text, lunch: lunchCtrl.text, dinner: dinnerCtrl.text);
      } else {
        k.addMenuDay(day: day, breakfast: bfCtrl.text, lunch: lunchCtrl.text, dinner: dinnerCtrl.text);
      }
    });
  }
}

class _CustomMenuPage extends StatelessWidget {
  const _CustomMenuPage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total', value: '${k.customMenus.length}', icon: Icons.restaurant_menu, color: AppColors.primary),
          StatCard(label: 'Active', value: '${k.activeCustomMenus.length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Inactive', value: '${k.customMenus.where((c) => !c.active).length}', icon: Icons.pause_circle, color: AppColors.textSecondary),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Special Diet Menu', () => _showCustomMenuModal(context, k)),
        const SizedBox(height: AppSpacing.lg),
        ...k.customMenus.map((c) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: c.active ? AppColors.success : AppColors.textSecondary, width: 4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.personName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                Text('${c.personRole} | ${c.reason}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Day: ${c.day}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('B: ${c.breakfast.isEmpty ? '\u2014' : c.breakfast}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
                Text('L: ${c.lunch.isEmpty ? '\u2014' : c.lunch}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
                Text('D: ${c.dinner.isEmpty ? '\u2014' : c.dinner}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
              ])),
              _chip(c.active ? 'Active' : 'Inactive', c.active ? AppColors.success : AppColors.textSecondary),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              GestureDetector(onTap: () => k.toggleCustomMenu(c.id), child: Text(c.active ? 'Deactivate' : 'Activate', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _showCustomMenuModal(context, k, editing: c), child: Text('Edit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Remove special diet menu for ${c.personName}?', () => k.deleteCustomMenu(c.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showCustomMenuModal(BuildContext context, KitchenProvider k, {CustomMenu? editing}) {
    String role = editing?.personRole ?? _personRoles[0];
    String day = editing?.day ?? _days[0];
    final nameCtrl = TextEditingController(text: editing?.personName ?? '');
    final reasonCtrl = TextEditingController(text: editing?.reason ?? '');
    final bfCtrl = TextEditingController(text: editing?.breakfast ?? '');
    final lunchCtrl = TextEditingController(text: editing?.lunch ?? '');
    final dinnerCtrl = TextEditingController(text: editing?.dinner ?? '');
    _showFormModal(context, editing != null ? 'Edit Special Diet' : 'Add Special Diet Menu', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Person Name', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Role', role, _personRoles, (v) => setState(() => role = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Dietary Reason', reasonCtrl, hint: 'e.g. Lactose intolerant, Diabetic'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Day', day, _days, (v) => setState(() => day = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Breakfast', bfCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Lunch', lunchCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Dinner', dinnerCtrl),
      ],
    )), () {
      if (nameCtrl.text.isEmpty || reasonCtrl.text.isEmpty) return;
      if (editing != null) {
        k.updateCustomMenu(editing.id, personName: nameCtrl.text, personRole: role, reason: reasonCtrl.text, day: day, breakfast: bfCtrl.text, lunch: lunchCtrl.text, dinner: dinnerCtrl.text);
      } else {
        k.addCustomMenu(personName: nameCtrl.text, personRole: role, reason: reasonCtrl.text, day: day, breakfast: bfCtrl.text, lunch: lunchCtrl.text, dinner: dinnerCtrl.text);
      }
    });
  }
}

class _StockPage extends StatelessWidget {
  const _StockPage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Items', value: '${k.stock.length}', icon: Icons.inventory_2, color: AppColors.primary),
          StatCard(label: 'Low Stock', value: '${k.lowStock}', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Out of Stock', value: '${k.outOfStock}', icon: Icons.error, color: AppColors.danger),
          StatCard(label: 'Issues Logged', value: '${k.issues.length}', icon: Icons.receipt, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _showStockModal(context, k), child: Text('+ Add Stock'))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white), onPressed: () => _showIssueModal(context, k), child: Text('+ Issue Item'))),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Kitchen Stock', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...k.stock.map((s) {
          final isLow = s.quantity > 0 && s.quantity <= s.reorderLevel;
          final isOut = s.quantity == 0;
          final pct = (s.reorderLevel > 0 ? (s.quantity / (s.reorderLevel * 2)).clamp(0.0, 1.0) : 1.0);
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: isOut ? AppColors.danger : isLow ? AppColors.warning : AppColors.success, width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                  Text('${s.category} | ${s.quantity} ${s.unit} (reorder: ${s.reorderLevel})', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                ])),
                _chip(isOut ? 'Out' : isLow ? 'Low' : 'OK', isOut ? AppColors.danger : isLow ? AppColors.warning : AppColors.success),
              ]),
              const SizedBox(height: AppSpacing.xs),
              Container(height: 6, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: pct, child: Container(decoration: BoxDecoration(color: isOut ? AppColors.danger : isLow ? AppColors.warning : AppColors.success, borderRadius: BorderRadius.circular(AppRadius.sm))))),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(onTap: () => _showRestockModal(context, k, s.id, s.name, s.quantity, s.unit), child: Text('Restock', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.success, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _showStockModal(context, k, editing: s), child: Text('Edit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Remove ${s.name}?', () => k.deleteStockItem(s.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          );
        }),
        const SizedBox(height: AppSpacing.lg),
        Text('Recent Issues', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...k.issues.take(5).map((i) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${i.date} \u2014 ${i.itemName}', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('${i.quantity} ${i.unit} -> ${i.issuedTo}${i.purpose.isNotEmpty ? ' | ${i.purpose}' : ''}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
          ]),
        )),
      ]),
    );
  }

  void _showStockModal(BuildContext context, KitchenProvider k, {KitchenStockItem? editing}) {
    String category = editing?.category ?? _stockCategories[0];
    String unit = editing?.unit ?? _stockUnits[0];
    final nameCtrl = TextEditingController(text: editing?.name ?? '');
    final qtyCtrl = TextEditingController(text: editing != null ? '${editing.quantity}' : '');
    final reorderCtrl = TextEditingController(text: editing != null ? '${editing.reorderLevel}' : '');
    _showFormModal(context, editing != null ? 'Edit Stock Item' : 'Add Stock Item', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Item Name', nameCtrl, hint: 'e.g. Maize bags'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Category', category, _stockCategories, (v) => setState(() => category = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Quantity', qtyCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Unit', unit, _stockUnits, (v) => setState(() => unit = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Reorder Level', reorderCtrl, keyboardType: TextInputType.number),
      ],
    )), () {
      final qty = int.tryParse(qtyCtrl.text) ?? 0;
      final reorder = int.tryParse(reorderCtrl.text) ?? 0;
      if (nameCtrl.text.isEmpty) return;
      if (editing != null) {
        k.updateStockItem(editing.id, name: nameCtrl.text, quantity: qty, unit: unit, reorderLevel: reorder, category: category);
      } else {
        k.addStockItem(name: nameCtrl.text, quantity: qty, unit: unit, reorderLevel: reorder, category: category);
      }
    });
  }

  void _showIssueModal(BuildContext context, KitchenProvider k) {
    String itemName = k.stock.isNotEmpty ? k.stock.first.name : '';
    String unit = k.stock.isNotEmpty ? k.stock.first.unit : _stockUnits[0];
    String issuedTo = _issueTargets[0];
    final qtyCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    _showFormModal(context, 'Issue Item for Meal Prep', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Item', itemName, k.stock.map((s) => s.name).toList(), (v) {
          final item = k.stock.firstWhere((s) => s.name == v);
          setState(() { itemName = v; unit = item.unit; });
        }),
        const SizedBox(height: AppSpacing.sm),
        _formField('Quantity to Issue', qtyCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Unit', unit, _stockUnits, (v) => setState(() => unit = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Issue To', issuedTo, _issueTargets, (v) => setState(() => issuedTo = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose (optional)', purposeCtrl),
      ],
    )), () {
      final qty = int.tryParse(qtyCtrl.text) ?? 0;
      if (itemName.isEmpty || qty <= 0) return;
      k.issueItem(itemName: itemName, quantity: qty, unit: unit, issuedTo: issuedTo, purpose: purposeCtrl.text);
    });
  }

  void _showRestockModal(BuildContext context, KitchenProvider k, String id, String name, int currentQty, String unit) {
    final qtyCtrl = TextEditingController();
    _showFormModal(context, 'Restock $name', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current: $currentQty $unit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Quantity to Add', qtyCtrl, keyboardType: TextInputType.number),
      ],
    ), () {
      final qty = int.tryParse(qtyCtrl.text) ?? 0;
      if (qty <= 0) return;
      k.restockItem(id, qty);
    });
  }
}

class _RequisitionPage extends StatelessWidget {
  const _RequisitionPage();
  @override
  Widget build(BuildContext context) {
    final req = context.watch<RequisitionProvider>();
    final myReqs = req.getByDepartment('Kitchen');
    final pending = myReqs.where((r) => r.status == 'Pending').length;
    final issued = myReqs.where((r) => r.status == 'Issued').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Requests', value: '${myReqs.length}', icon: Icons.pending_actions, color: AppColors.primary),
          StatCard(label: 'Pending', value: '$pending', icon: Icons.hourglass_empty, color: AppColors.warning),
          StatCard(label: 'Issued', value: '$issued', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ New Requisition to Stores', () => _showReqModal(context, req)),
        const SizedBox(height: AppSpacing.lg),
        if (myReqs.isEmpty)
          Text('No requisitions yet. Tap above to request items from Stores.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...myReqs.map((r) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.itemName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                  Text('${r.date} | ${r.quantity} ${r.unit} | Priority: ${r.priority}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  if (r.notes.isNotEmpty) Text(r.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                ])),
                _chip(r.status, _statusColor(r.status)),
              ]),
            ]),
          )),
      ]),
    );
  }

  void _showReqModal(BuildContext context, RequisitionProvider req) {
    String unit = _reqUnits[0];
    String priority = _priorities[1];
    final itemCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'New Requisition to Stores', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Item Name', itemCtrl, hint: 'e.g. Cooking oil'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Quantity', qtyCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Unit', unit, _reqUnits, (v) => setState(() => unit = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Priority', priority, _priorities, (v) => setState(() => priority = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes (optional)', notesCtrl, multiline: true),
      ],
    )), () {
      if (itemCtrl.text.isEmpty || qtyCtrl.text.isEmpty) return;
      req.addRequisition(Requisition(
        id: '', date: _today(), itemName: itemCtrl.text, quantity: int.tryParse(qtyCtrl.text) ?? 0,
        unit: unit, department: 'Kitchen', status: 'Pending', requestedBy: 'Catering Officer',
        priority: priority, notes: notesCtrl.text, approvals: [],
      ));
    }, submitLabel: 'Submit to Stores');
  }
}

class _FinancePage extends StatelessWidget {
  const _FinancePage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    final pending = k.financialReqs.where((r) => r.status == 'Pending').toList();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Requests', value: '${k.financialReqs.length}', icon: Icons.receipt_long, color: AppColors.primary),
          StatCard(label: 'Pending', value: '${k.pendingFinReqs}', icon: Icons.hourglass_empty, color: AppColors.warning),
          StatCard(label: 'Pending Amount', value: 'GHS ${k.totalFinRequested.toStringAsFixed(0)}', icon: Icons.pending, color: AppColors.info),
          StatCard(label: 'Disbursed', value: 'GHS ${k.totalFinDisbursed.toStringAsFixed(0)}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ New Financial Request', () => _showFinanceModal(context, k)),
        const SizedBox(height: AppSpacing.lg),
        if (pending.isNotEmpty) ...[
          Text('Pending Approval', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...pending.map((f) => _financeCard(context, k, f)),
          const SizedBox(height: AppSpacing.lg),
        ],
        Text('All Financial Requests', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (k.financialReqs.isEmpty)
          Text('No financial requests yet.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...k.financialReqs.map((f) => _financeCard(context, k, f)),
      ]),
    );
  }

  Widget _financeCard(BuildContext context, KitchenProvider k, KitchenFinancialReq f) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(f.status), width: 4))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f.purpose, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('${f.date} | GHS ${f.amount.toStringAsFixed(0)} | By ${f.requestedBy}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            if (f.notes.isNotEmpty) Text(f.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
          ])),
          _chip(f.status, _statusColor(f.status)),
        ]),
        const SizedBox(height: AppSpacing.sm),
        Row(children: [
          if (f.status == 'Pending') ...[
            GestureDetector(onTap: () => k.updateFinancialReqStatus(f.id, 'Approved'), child: Text('Approve', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.success, fontWeight: FontWeight.w600))),
            const SizedBox(width: AppSpacing.md),
            GestureDetector(onTap: () => k.updateFinancialReqStatus(f.id, 'Rejected'), child: Text('Reject', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            const SizedBox(width: AppSpacing.md),
          ],
          if (f.status == 'Approved') ...[
            GestureDetector(onTap: () => k.updateFinancialReqStatus(f.id, 'Disbursed'), child: Text('Mark Disbursed', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.success, fontWeight: FontWeight.w600))),
            const SizedBox(width: AppSpacing.md),
          ],
          GestureDetector(onTap: () => _confirmDelete(context, 'Delete this financial request?', () => k.deleteFinancialReq(f.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
        ]),
      ]),
    );
  }

  void _showFinanceModal(BuildContext context, KitchenProvider k) {
    final amountCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'New Financial Request', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formField('Amount (GHS)', amountCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose', purposeCtrl, hint: 'e.g. Weekly foodstuff purchase'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes (optional)', notesCtrl, multiline: true),
      ],
    ), () {
      final amt = double.tryParse(amountCtrl.text) ?? 0;
      if (amt <= 0 || purposeCtrl.text.isEmpty) return;
      k.submitFinancialReq(amount: amt, purpose: purposeCtrl.text, requestedBy: 'Catering Officer', notes: notesCtrl.text);
    });
  }
}

class _HeadcountPage extends StatelessWidget {
  const _HeadcountPage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    final hc = k.latestHeadcount;
    final todayTotal = hc != null ? hc.breakfast + hc.lunch + hc.dinner : 0;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Latest Date', value: hc?.date ?? '\u2014', icon: Icons.calendar_today, color: AppColors.primary),
          StatCard(label: 'Today Total', value: '$todayTotal', icon: Icons.restaurant, color: AppColors.info),
          StatCard(label: 'Avg Daily', value: '${k.avgHeadcount}', icon: Icons.trending_up, color: AppColors.success),
          StatCard(label: 'Records', value: '${k.headcount.length}', icon: Icons.list_alt, color: AppColors.purple),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Log Headcount', () => _showHeadcountModal(context, k)),
        const SizedBox(height: AppSpacing.lg),
        ...k.headcount.map((h) {
          final total = h.breakfast + h.lunch + h.dinner;
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(h.date, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text))),
                Text('Total: $total', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ]),
              const SizedBox(height: AppSpacing.xs),
              Row(children: [
                _mealChip('Breakfast', h.breakfast, AppColors.warning),
                const SizedBox(width: AppSpacing.sm),
                _mealChip('Lunch', h.lunch, AppColors.info),
                const SizedBox(width: AppSpacing.sm),
                _mealChip('Dinner', h.dinner, AppColors.purple),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(onTap: () => _showHeadcountModal(context, k, editing: h), child: Text('Edit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Delete headcount for ${h.date}?', () => k.deleteHeadcount(h.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          );
        }),
      ]),
    );
  }

  Widget _mealChip(String meal, int count, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text('$meal: $count', style: TextStyle(fontSize: AppFontSize.sm, color: color, fontWeight: FontWeight.w600)),
  );

  void _showHeadcountModal(BuildContext context, KitchenProvider k, {HeadcountEntry? editing}) {
    final dateCtrl = TextEditingController(text: editing?.date ?? _today());
    final bfCtrl = TextEditingController(text: editing != null ? '${editing.breakfast}' : '');
    final lunchCtrl = TextEditingController(text: editing != null ? '${editing.lunch}' : '');
    final dinnerCtrl = TextEditingController(text: editing != null ? '${editing.dinner}' : '');
    _showFormModal(context, editing != null ? 'Edit Headcount' : 'Log Headcount', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formField('Date', dateCtrl, hint: 'YYYY-MM-DD'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Breakfast Count', bfCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Lunch Count', lunchCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Dinner Count', dinnerCtrl, keyboardType: TextInputType.number),
      ],
    ), () {
      final bf = int.tryParse(bfCtrl.text) ?? 0;
      final ln = int.tryParse(lunchCtrl.text) ?? 0;
      final dn = int.tryParse(dinnerCtrl.text) ?? 0;
      if (dateCtrl.text.isEmpty) return;
      if (editing != null) {
        k.updateHeadcount(editing.id, date: dateCtrl.text, breakfast: bf, lunch: ln, dinner: dn);
      } else {
        k.addHeadcount(date: dateCtrl.text, breakfast: bf, lunch: ln, dinner: dn);
      }
    });
  }
}

class _StaffPage extends StatelessWidget {
  const _StaffPage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Staff', value: '${k.staff.length}', icon: Icons.people, color: AppColors.primary),
          StatCard(label: 'Active', value: '${k.activeStaff}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'On Leave', value: '${k.staff.where((s) => s.status == "On Leave").length}', icon: Icons.beach_access, color: AppColors.warning),
          StatCard(label: 'Sick', value: '${k.staff.where((s) => s.status == "Sick").length}', icon: Icons.sick, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Staff Member', () => _showStaffModal(context, k)),
        const SizedBox(height: AppSpacing.lg),
        ...k.staff.map((s) {
          final attRate = s.attendanceTotal > 0 ? (s.attendancePresent / s.attendanceTotal * 100).round() : 0;
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(s.status), width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                  Text('${s.role} | ${s.shift} | ${s.phone}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('Attendance: $attRate% (${s.attendancePresent}/${s.attendanceTotal})', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                ])),
                _chip(s.status, _statusColor(s.status)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(onTap: () => k.toggleStaffStatus(s.id), child: Text('Cycle Status', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => k.markAttendance(s.id, true), child: Text('Present', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.success, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => k.markAttendance(s.id, false), child: Text('Absent', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _showStaffModal(context, k, editing: s), child: Text('Edit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Remove ${s.name}?', () => k.deleteStaff(s.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          );
        }),
      ]),
    );
  }

  void _showStaffModal(BuildContext context, KitchenProvider k, {StaffMember? editing}) {
    String role = editing?.role ?? _roles[0];
    String shift = editing?.shift ?? _shifts[0];
    final nameCtrl = TextEditingController(text: editing?.name ?? '');
    final phoneCtrl = TextEditingController(text: editing?.phone ?? '');
    _showFormModal(context, editing != null ? 'Edit Staff Member' : 'Add Staff Member', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Name', nameCtrl, hint: 'e.g. Madam Akos'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Role', role, _roles, (v) => setState(() => role = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Shift', shift, _shifts, (v) => setState(() => shift = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Phone', phoneCtrl, hint: 'e.g. 024 111 2222', keyboardType: TextInputType.phone),
      ],
    )), () {
      if (nameCtrl.text.isEmpty) return;
      if (editing != null) {
        k.updateStaff(editing.id, name: nameCtrl.text, role: role, shift: shift, phone: phoneCtrl.text);
      } else {
        k.addStaff(name: nameCtrl.text, role: role, shift: shift, phone: phoneCtrl.text);
      }
    });
  }
}

class _HygienePage extends StatelessWidget {
  const _HygienePage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    final cs = k.complianceScore;
    final failed = k.inspections.where((i) => i.result == 'Failed').length;
    final actionNeeded = k.inspections.where((i) => i.result == 'Action Needed').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Inspections', value: '${k.inspections.length}', icon: Icons.fact_check, color: AppColors.primary),
          StatCard(label: 'Compliance', value: '$cs%', icon: Icons.verified, color: cs >= 85 ? AppColors.success : AppColors.warning),
          StatCard(label: 'Action Needed', value: '$actionNeeded', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Failed', value: '$failed', icon: Icons.error, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Log Inspection', () => _showInspectionModal(context, k)),
        const SizedBox(height: AppSpacing.lg),
        if (cs < 85) _alertCard('Compliance Below Target', 'Current average score is $cs%. Target is 85%+. Review failed/action needed inspections.', AppColors.danger),
        ...k.inspections.map((i) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(i.result), width: 4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${i.area} \u2014 ${i.date}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('Inspector: ${i.inspector} | Score: ${i.score}/100', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                if (i.notes.isNotEmpty) Text(i.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
              ])),
              _chip(i.result, _statusColor(i.result)),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              GestureDetector(onTap: () => _showInspectionModal(context, k, editing: i), child: Text('Edit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete inspection record for ${i.area}?', () => k.deleteInspection(i.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showInspectionModal(BuildContext context, KitchenProvider k, {InspectionRecord? editing}) {
    String area = editing?.area ?? _inspectionAreas[0];
    final inspectorCtrl = TextEditingController(text: editing?.inspector ?? '');
    final scoreCtrl = TextEditingController(text: editing != null ? '${editing.score}' : '');
    final notesCtrl = TextEditingController(text: editing?.notes ?? '');
    _showFormModal(context, editing != null ? 'Edit Inspection' : 'Log Inspection', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Area', area, _inspectionAreas, (v) => setState(() => area = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Inspector', inspectorCtrl, hint: 'e.g. Mrs. Adjei'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Score (0-100)', scoreCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, multiline: true),
      ],
    )), () {
      final score = int.tryParse(scoreCtrl.text) ?? 0;
      if (inspectorCtrl.text.isEmpty) return;
      if (editing != null) {
        k.updateInspection(editing.id, area: area, inspector: inspectorCtrl.text, score: score, notes: notesCtrl.text);
      } else {
        k.addInspection(area: area, inspector: inspectorCtrl.text, score: score, notes: notesCtrl.text);
      }
    });
  }
}

class _CostPage extends StatelessWidget {
  const _CostPage();
  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();
    final hc = k.latestHeadcount;
    final estDailyCost = hc != null ? (hc.breakfast + hc.lunch + hc.dinner) * k.avgCostPerServing : 0.0;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Estimates', value: '${k.costs.length}', icon: Icons.calculate, color: AppColors.primary),
          StatCard(label: 'Avg Cost/Serving', value: 'GHS ${k.avgCostPerServing.toStringAsFixed(2)}', icon: Icons.payments, color: AppColors.info),
          StatCard(label: 'Total Meal Cost', value: 'GHS ${k.totalMealCost}', icon: Icons.account_balance_wallet, color: AppColors.purple),
          StatCard(label: 'Est. Daily Cost', value: 'GHS ${estDailyCost.toStringAsFixed(0)}', icon: Icons.trending_up, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ New Cost Estimate', () => _showCostModal(context, k)),
        const SizedBox(height: AppSpacing.lg),
        ...k.costs.map((c) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.meal, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('${c.date} | ${c.servings} servings | GHS ${c.costPerServing.toStringAsFixed(2)}/serving', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Total: GHS ${c.totalCost}', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ])),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              GestureDetector(onTap: () => _showCostModal(context, k, editing: c), child: Text('Edit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete cost estimate for ${c.meal}?', () => k.deleteCost(c.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showCostModal(BuildContext context, KitchenProvider k, {CostEstimate? editing}) {
    final mealCtrl = TextEditingController(text: editing?.meal ?? '');
    final servingsCtrl = TextEditingController(text: editing != null ? '${editing.servings}' : '');
    final costCtrl = TextEditingController(text: editing != null ? editing.costPerServing.toStringAsFixed(2) : '');
    _showFormModal(context, editing != null ? 'Edit Cost Estimate' : 'New Cost Estimate', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formField('Meal Description', mealCtrl, hint: 'e.g. Jollof rice + chicken'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Servings', servingsCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Cost per Serving (GHS)', costCtrl, keyboardType: TextInputType.number),
      ],
    ), () {
      final servings = int.tryParse(servingsCtrl.text) ?? 0;
      final cps = double.tryParse(costCtrl.text) ?? 0;
      if (mealCtrl.text.isEmpty || servings <= 0 || cps <= 0) return;
      if (editing != null) {
        k.updateCost(editing.id, meal: mealCtrl.text, servings: servings, costPerServing: cps);
      } else {
        k.addCost(meal: mealCtrl.text, servings: servings, costPerServing: cps);
      }
    });
  }
}
