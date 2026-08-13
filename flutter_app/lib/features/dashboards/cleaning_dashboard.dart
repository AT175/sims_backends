import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/cleaning_provider.dart';
import '../../core/state/requisition_provider.dart';
import '../../core/widgets/widgets.dart';

const _areas = ['Assembly Hall', 'Dining Hall', 'Dormitory A', 'Dormitory B', 'Admin Block', 'Grounds', 'Toilets Block A', 'Toilets Block B', 'Library', 'Laboratory'];
const _frequencies = ['Daily', 'Weekly', 'Monthly'];
const _priorities = ['High', 'Medium', 'Low'];
const _issueStatuses = ['Reported', 'Repair Scheduled', 'Fixed'];
const _inspectionResults = ['Passed', 'Needs Attention', 'Failed'];
const _staffStatuses = ['Present', 'Absent', 'On Leave'];
const _rosterStatuses = ['Pending', 'In Progress', 'Completed'];
const _supplyCategories = ['Disinfectant', 'Cleaning Agent', 'Equipment', 'Hygiene', 'PPE', 'Consumables'];
const _supplyUnits = ['gallons', 'cartons', 'units', 'pairs', 'rolls', 'packs', 'boxes', 'litres'];
const _reqUnits = ['gallons', 'cartons', 'units', 'pairs', 'rolls', 'packs', 'boxes', 'litres', 'bottles', 'kg'];

String _today() => DateTime.now().toIso8601String().substring(0, 10);

Color _statusColor(String s) {
  switch (s) {
    case 'Completed': case 'Fixed': case 'Passed': case 'Present': case 'Issued': return AppColors.success;
    case 'In Progress': case 'Repair Scheduled': case 'Needs Attention': return AppColors.warning;
    case 'Pending': case 'Reported': case 'Failed': case 'Absent': return AppColors.danger;
    case 'On Leave': return AppColors.textSecondary;
    default: return AppColors.info;
  }
}

Color _priorityColor(String p) => p == 'High' ? AppColors.danger : p == 'Medium' ? AppColors.warning : AppColors.info;

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

class CleaningDashboard extends StatelessWidget {
  final String pageKey;
  const CleaningDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'roster': return const _RosterPage();
      case 'tasks': return const _TasksPage();
      case 'supplies': return const _SuppliesPage();
      case 'requisitions': return const _RequisitionsPage();
      case 'staff': return const _StaffPage();
      case 'maintenance': return const _MaintenancePage();
      case 'inspection': return const _InspectionPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    final req = context.watch<RequisitionProvider>();
    final myReqs = req.getByDepartment('Cleaning');
    final pendingReqs = myReqs.where((r) => r.status == 'Pending').length;
    final cs = c.complianceScore;
    final diningTasks = c.tasks.where((t) => t.area == 'Dining Hall').toList();
    final diningDone = diningTasks.where((t) => t.done).length;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Tasks Today', value: '${c.completedToday}/${c.totalToday}', icon: Icons.task, color: AppColors.primary),
          StatCard(label: 'Compliance', value: '$cs%', icon: Icons.verified, color: cs >= 85 ? AppColors.success : AppColors.warning),
          StatCard(label: 'Staff Present', value: '${c.presentStaff}/${c.staff.length}', icon: Icons.people, color: AppColors.info),
          StatCard(label: 'Open Issues', value: '${c.openIssues}', icon: Icons.report_problem, color: c.openIssues > 0 ? AppColors.danger : AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        StatCardGrid(cards: [
          StatCard(label: 'Low Supplies', value: '${c.lowStockCount}', icon: Icons.inventory, color: c.lowStockCount > 0 ? AppColors.warning : AppColors.success),
          StatCard(label: 'Roster Done', value: '${c.rosterCompleted}/${c.roster.length}', icon: Icons.check_circle, color: AppColors.accent),
          StatCard(label: 'Pending Reqs', value: '$pendingReqs', icon: Icons.pending_actions, color: pendingReqs > 0 ? AppColors.warning : AppColors.info),
          StatCard(label: 'Dining Hall', value: '$diningDone/${diningTasks.length}', icon: Icons.restaurant, color: AppColors.purple),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (c.lowStockCount > 0)
          _alertCard('Supply Alert', '${c.lowStockCount} item(s) need reorder. Check Supply Inventory page.', AppColors.warning),
        if (c.openIssues > 0)
          _alertCard('${c.openIssues} Unresolved Maintenance Issue${c.openIssues > 1 ? 's' : ''}', 'Facility problems need attention. Check Maintenance Issues page.', AppColors.danger),
        if (cs > 0 && cs < 85)
          _alertCard('Compliance Below Target', 'Current inspection average is $cs%. Target is 85%+.', AppColors.warning),
        const SizedBox(height: AppSpacing.md),
        Text('Quick Actions', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _quickBtn(context, '+ Add Task', AppColors.primary, () => _showTaskModal(context, c)),
          _quickBtn(context, '+ Report Issue', AppColors.danger, () => _showIssueModal(context, c)),
          _quickBtn(context, '+ Log Inspection', AppColors.success, () => _showInspectionModal(context, c)),
          _quickBtn(context, '+ Request Supplies', AppColors.info, () => _showReqModal(context, req)),
        ]),
      ]),
    );
  }

  Widget _quickBtn(BuildContext context, String label, Color color, VoidCallback onTap) => ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm)),
    onPressed: onTap,
    child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
  );

  void _showTaskModal(BuildContext context, CleaningProvider c) {
    String area = _areas[0], frequency = _frequencies[0], priority = _priorities[1];
    final taskCtrl = TextEditingController();
    final assignCtrl = TextEditingController();
    _showFormModal(context, 'Add Cleaning Task', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Task Description', taskCtrl, hint: 'e.g. Mop dining hall floor'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Area', area, _areas, (v) => setState(() => area = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Frequency', frequency, _frequencies, (v) => setState(() => frequency = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Assigned To', assignCtrl, hint: 'e.g. Mr. Kofi'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Priority', priority, _priorities, (v) => setState(() => priority = v)),
      ],
    )), () {
      if (taskCtrl.text.isEmpty || assignCtrl.text.isEmpty) return;
      c.addTask(task: taskCtrl.text, area: area, frequency: frequency, assignedTo: assignCtrl.text, priority: priority);
    });
  }

  void _showIssueModal(BuildContext context, CleaningProvider c) {
    String priority = _priorities[1];
    final locCtrl = TextEditingController();
    final issueCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Report Maintenance Issue', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Location', locCtrl, hint: 'e.g. Dorm B toilet'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Issue Description', issueCtrl, hint: 'e.g. Broken pipe'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Priority', priority, _priorities, (v) => setState(() => priority = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes (optional)', notesCtrl, multiline: true),
      ],
    )), () {
      if (locCtrl.text.isEmpty || issueCtrl.text.isEmpty) return;
      c.addIssue(location: locCtrl.text, issue: issueCtrl.text, priority: priority, reportedBy: 'Cleaning Supervisor', notes: notesCtrl.text);
    });
  }

  void _showInspectionModal(BuildContext context, CleaningProvider c) {
    String area = _areas[0], result = _inspectionResults[0];
    final inspectorCtrl = TextEditingController();
    final scoreCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Log Inspection', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Area', area, _areas, (v) => setState(() => area = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Inspector Name', inspectorCtrl, hint: 'e.g. Mr. Tetteh'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Result', result, _inspectionResults, (v) => setState(() => result = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Score (0-100)', scoreCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes (optional)', notesCtrl, multiline: true),
      ],
    )), () {
      final score = int.tryParse(scoreCtrl.text) ?? 0;
      if (inspectorCtrl.text.isEmpty) return;
      c.addInspection(area: area, inspector: inspectorCtrl.text, result: result, score: score, notes: notesCtrl.text);
    });
  }

  void _showReqModal(BuildContext context, RequisitionProvider req) {
    String unit = _reqUnits[0], priority = _priorities[1];
    final itemCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Request Supplies from Stores', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Item Name', itemCtrl, hint: 'e.g. Bleach'),
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
        unit: unit, department: 'Cleaning', status: 'Pending', requestedBy: 'Cleaning Supervisor',
        priority: priority, notes: notesCtrl.text, approvals: [],
      ));
    }, submitLabel: 'Submit to Stores');
  }
}

class _RosterPage extends StatelessWidget {
  const _RosterPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Duties', value: '${c.roster.length}', icon: Icons.schedule, color: AppColors.primary),
          StatCard(label: 'Completed', value: '${c.rosterCompleted}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'In Progress', value: '${c.rosterInProgress}', icon: Icons.autorenew, color: AppColors.warning),
          StatCard(label: 'Pending', value: '${c.rosterPending}', icon: Icons.pending, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Roster Entry', () => _showRosterModal(context, c)),
        const SizedBox(height: AppSpacing.lg),
        ...c.roster.map((r) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(r.status), width: 4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.area, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                Text('${r.assignedTo} | ${r.frequency} | ${r.time}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ])),
              GestureDetector(onTap: () {
                final idx = _rosterStatuses.indexOf(r.status);
                c.updateRosterStatus(r.id, _rosterStatuses[(idx + 1) % _rosterStatuses.length]);
              }, child: _chip(r.status, _statusColor(r.status))),
            ]),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(onTap: () => _confirmDelete(context, 'Remove roster entry for ${r.area}?', () => c.deleteRosterEntry(r.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]),
    );
  }

  void _showRosterModal(BuildContext context, CleaningProvider c) {
    String area = _areas[0];
    final assignCtrl = TextEditingController();
    final freqCtrl = TextEditingController(text: 'Daily');
    final timeCtrl = TextEditingController();
    _showFormModal(context, 'Add Roster Entry', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Area', area, _areas, (v) => setState(() => area = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Assigned To', assignCtrl, hint: 'e.g. Mr. Kofi + 2'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Frequency', freqCtrl, hint: 'e.g. Daily'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Time', timeCtrl, hint: 'e.g. 06:00 - 07:00'),
      ],
    )), () {
      if (assignCtrl.text.isEmpty || timeCtrl.text.isEmpty) return;
      c.addRosterEntry(area: area, assignedTo: assignCtrl.text, frequency: freqCtrl.text, time: timeCtrl.text);
    });
  }
}

class _TasksPage extends StatelessWidget {
  const _TasksPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    final today = c.todayTasks;
    final areasWithTasks = _areas.where((a) => today.any((t) => t.area == a)).toList();
    return _TasksContent(c: c, today: today, areasWithTasks: areasWithTasks);
  }
}

class _TasksContent extends StatefulWidget {
  final CleaningProvider c;
  final List<CleaningTask> today;
  final List<String> areasWithTasks;
  const _TasksContent({required this.c, required this.today, required this.areasWithTasks});

  @override
  State<_TasksContent> createState() => _TasksContentState();
}

class _TasksContentState extends State<_TasksContent> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    final today = widget.today;
    final filtered = _filter == 'All' ? today : today.where((t) => t.area == _filter).toList();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: "Today's Tasks", value: '${c.totalToday}', icon: Icons.task, color: AppColors.primary),
          StatCard(label: 'Completed', value: '${c.completedToday}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Pending', value: '${c.totalToday - c.completedToday}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Rate', value: '${c.taskCompletionRate}%', icon: Icons.trending_up, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Task', () => _showTaskModal(context, c)),
        const SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [
          _filterChip('All (${today.length})', _filter == 'All', () => setState(() => _filter = 'All')),
          ...widget.areasWithTasks.map((a) => _filterChip(a, _filter == a, () => setState(() => _filter = a))),
        ]),
        const SizedBox(height: AppSpacing.md),
        if (filtered.isEmpty)
          Text('No tasks for this filter.', style: TextStyle(color: AppColors.textLight))
        else
          ...filtered.map((t) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(children: [
              GestureDetector(onTap: () => c.toggleTask(t.id), child: Container(
                width: 22, height: 22, margin: const EdgeInsets.only(right: AppSpacing.md),
                decoration: BoxDecoration(
                  color: t.done ? AppColors.success : Colors.transparent,
                  border: Border.all(color: t.done ? AppColors.success : AppColors.border, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: t.done ? Icon(Icons.check, size: 14, color: Colors.white) : null,
              )),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.task, style: TextStyle(fontSize: AppFontSize.md, color: t.done ? AppColors.textSecondary : AppColors.text, decoration: t.done ? TextDecoration.lineThrough : TextDecoration.none)),
                Text('${t.area} | ${t.assignedTo} | ${t.frequency}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              ])),
              _chip(t.priority, _priorityColor(t.priority)),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(onTap: () => _confirmDelete(context, 'Remove this task?', () => c.deleteTask(t.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          )),
      ]),
    );
  }

  Widget _filterChip(String label, bool active, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceAlt,
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: TextStyle(fontSize: AppFontSize.xs, color: active ? Colors.white : AppColors.textSecondary, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
    ),
  );

  void _showTaskModal(BuildContext context, CleaningProvider c) {
    String area = _areas[0], frequency = _frequencies[0], priority = _priorities[1];
    final taskCtrl = TextEditingController();
    final assignCtrl = TextEditingController();
    _showFormModal(context, 'Add Cleaning Task', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Task Description', taskCtrl, hint: 'e.g. Mop dining hall floor'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Area', area, _areas, (v) => setState(() => area = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Frequency', frequency, _frequencies, (v) => setState(() => frequency = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Assigned To', assignCtrl, hint: 'e.g. Mr. Kofi'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Priority', priority, _priorities, (v) => setState(() => priority = v)),
      ],
    )), () {
      if (taskCtrl.text.isEmpty || assignCtrl.text.isEmpty) return;
      c.addTask(task: taskCtrl.text, area: area, frequency: frequency, assignedTo: assignCtrl.text, priority: priority);
    });
  }
}

class _SuppliesPage extends StatelessWidget {
  const _SuppliesPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    final req = context.watch<RequisitionProvider>();
    final pendingReqs = req.getByDepartment('Cleaning').where((r) => r.status == 'Pending').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Supply Items', value: '${c.supplies.length}', icon: Icons.inventory_2, color: AppColors.primary),
          StatCard(label: 'Low Stock', value: '${c.lowStockCount}', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Categories', value: '${c.supplies.map((s) => s.category).toSet().length}', icon: Icons.category, color: AppColors.info),
          StatCard(label: 'Pending Reqs', value: '$pendingReqs', icon: Icons.pending_actions, color: AppColors.accent),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (c.lowStockCount > 0)
          _alertCard('Low Stock Alert', '${c.lowStockCount} item(s) need reorder. Use "Request from Stores" to submit.', AppColors.warning),
        Row(children: [
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _showSupplyModal(context, c), child: Text('+ Add Supply'))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white), onPressed: () => _showReqModal(context, req), child: Text('+ Request from Stores'))),
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...c.supplies.map((s) {
          final isLow = s.quantity <= s.reorderLevel;
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
                GestureDetector(onTap: () => _showRestockModal(context, c, s.id, s.name, s.quantity, s.unit), child: Text('+ Restock', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.success, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _showSupplyModal(context, c, editing: s), child: Text('Edit', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Remove ${s.name}?', () => c.deleteSupply(s.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          );
        }),
      ]),
    );
  }

  void _showSupplyModal(BuildContext context, CleaningProvider c, {CleaningSupply? editing}) {
    String category = editing?.category ?? _supplyCategories[0];
    String unit = editing?.unit ?? _supplyUnits[0];
    final nameCtrl = TextEditingController(text: editing?.name ?? '');
    final qtyCtrl = TextEditingController(text: editing != null ? '${editing.quantity}' : '');
    final reorderCtrl = TextEditingController(text: editing != null ? '${editing.reorderLevel}' : '');
    _showFormModal(context, editing != null ? 'Edit Supply Item' : 'Add Supply Item', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Supply Name', nameCtrl, hint: 'e.g. Bleach'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Category', category, _supplyCategories, (v) => setState(() => category = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Quantity', qtyCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Unit', unit, _supplyUnits, (v) => setState(() => unit = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Reorder Level', reorderCtrl, keyboardType: TextInputType.number),
      ],
    )), () {
      final qty = int.tryParse(qtyCtrl.text) ?? 0;
      final reorder = int.tryParse(reorderCtrl.text) ?? 0;
      if (nameCtrl.text.isEmpty) return;
      if (editing != null) {
        c.updateSupply(editing.id, name: nameCtrl.text, quantity: qty, unit: unit, reorderLevel: reorder, category: category);
      } else {
        c.addSupply(name: nameCtrl.text, quantity: qty, unit: unit, reorderLevel: reorder, category: category);
      }
    });
  }

  void _showRestockModal(BuildContext context, CleaningProvider c, String id, String name, int currentQty, String unit) {
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
      c.restockSupply(id, qty);
    });
  }

  void _showReqModal(BuildContext context, RequisitionProvider req) {
    String unit = _reqUnits[0], priority = _priorities[1];
    final itemCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Request Supplies from Stores', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Item Name', itemCtrl, hint: 'e.g. Bleach'),
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
        unit: unit, department: 'Cleaning', status: 'Pending', requestedBy: 'Cleaning Supervisor',
        priority: priority, notes: notesCtrl.text, approvals: [],
      ));
    }, submitLabel: 'Submit to Stores');
  }
}

class _RequisitionsPage extends StatelessWidget {
  const _RequisitionsPage();
  @override
  Widget build(BuildContext context) {
    final req = context.watch<RequisitionProvider>();
    final myReqs = req.getByDepartment('Cleaning');
    final pending = myReqs.where((r) => r.status == 'Pending').length;
    final issued = myReqs.where((r) => r.status == 'Issued').length;
    final rejected = myReqs.where((r) => r.status == 'Rejected').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Requests', value: '${myReqs.length}', icon: Icons.pending_actions, color: AppColors.primary),
          StatCard(label: 'Pending', value: '$pending', icon: Icons.hourglass_empty, color: AppColors.warning),
          StatCard(label: 'Issued', value: '$issued', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Rejected', value: '$rejected', icon: Icons.cancel, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Request Supplies from Stores', () => _showReqModal(context, req)),
        const SizedBox(height: AppSpacing.lg),
        if (myReqs.isEmpty)
          Text('No supply requests yet. Tap above to request from Stores.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...myReqs.map((r) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.itemName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('${r.date} | ${r.quantity} ${r.unit} | Priority: ${r.priority}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                if (r.notes.isNotEmpty) Text(r.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
              ])),
              _chip(r.status, _statusColor(r.status)),
            ]),
          )),
      ]),
    );
  }

  void _showReqModal(BuildContext context, RequisitionProvider req) {
    String unit = _reqUnits[0], priority = _priorities[1];
    final itemCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Request Supplies from Stores', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Item Name', itemCtrl, hint: 'e.g. Bleach'),
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
        unit: unit, department: 'Cleaning', status: 'Pending', requestedBy: 'Cleaning Supervisor',
        priority: priority, notes: notesCtrl.text, approvals: [],
      ));
    }, submitLabel: 'Submit to Stores');
  }
}

class _StaffPage extends StatelessWidget {
  const _StaffPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Staff', value: '${c.staff.length}', icon: Icons.people, color: AppColors.primary),
          StatCard(label: 'Present', value: '${c.presentStaff}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Checked In', value: '${c.checkedInStaff}', icon: Icons.login, color: AppColors.info),
          StatCard(label: 'On Leave', value: '${c.staff.where((s) => s.status == "On Leave").length}', icon: Icons.beach_access, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...c.staff.map((s) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(s.status), width: 4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                Text('${s.role} | ${s.area} | ${s.phone}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ])),
              GestureDetector(onTap: () {
                final idx = _staffStatuses.indexOf(s.status);
                c.updateStaffStatus(s.id, _staffStatuses[(idx + 1) % _staffStatuses.length]);
              }, child: _chip(s.status, _statusColor(s.status))),
            ]),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: s.todayCheckedIn ? AppColors.success : AppColors.surfaceAlt,
                  foregroundColor: s.todayCheckedIn ? Colors.white : AppColors.textSecondary,
                  side: s.todayCheckedIn ? null : BorderSide(color: AppColors.border, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                ),
                onPressed: () => c.toggleCheckIn(s.id),
                child: Text(s.todayCheckedIn ? '\u2713 Checked In' : 'Check In', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        )),
      ]),
    );
  }
}

class _MaintenancePage extends StatelessWidget {
  const _MaintenancePage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    final scheduled = c.issues.where((i) => i.status == 'Repair Scheduled').length;
    final fixed = c.issues.where((i) => i.status == 'Fixed').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Issues', value: '${c.issues.length}', icon: Icons.report_problem, color: AppColors.primary),
          StatCard(label: 'Open', value: '${c.openIssues}', icon: Icons.error, color: AppColors.danger),
          StatCard(label: 'Scheduled', value: '$scheduled', icon: Icons.build, color: AppColors.warning),
          StatCard(label: 'Fixed', value: '$fixed', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Report Issue', () => _showIssueModal(context, c), color: AppColors.danger),
        const SizedBox(height: AppSpacing.lg),
        if (c.issues.isEmpty)
          Text('No maintenance issues reported.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...c.issues.map((i) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(i.status), width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(i.issue, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                  Text('${i.date} | ${i.location} | By: ${i.reportedBy}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  if (i.notes.isNotEmpty) Text(i.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
                ])),
                _chip(i.priority, _priorityColor(i.priority)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(onTap: () {
                  final idx = _issueStatuses.indexOf(i.status);
                  c.updateIssueStatus(i.id, _issueStatuses[(idx + 1) % _issueStatuses.length]);
                }, child: _chip(i.status, _statusColor(i.status))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Remove this issue?', () => c.deleteIssue(i.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          )),
      ]),
    );
  }

  void _showIssueModal(BuildContext context, CleaningProvider c) {
    String priority = _priorities[1];
    final locCtrl = TextEditingController();
    final issueCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Report Maintenance Issue', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Location', locCtrl, hint: 'e.g. Dorm B toilet'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Issue Description', issueCtrl, hint: 'e.g. Broken pipe'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Priority', priority, _priorities, (v) => setState(() => priority = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes (optional)', notesCtrl, multiline: true),
      ],
    )), () {
      if (locCtrl.text.isEmpty || issueCtrl.text.isEmpty) return;
      c.addIssue(location: locCtrl.text, issue: issueCtrl.text, priority: priority, reportedBy: 'Cleaning Supervisor', notes: notesCtrl.text);
    });
  }
}

class _InspectionPage extends StatelessWidget {
  const _InspectionPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    final cs = c.complianceScore;
    final passed = c.inspections.where((i) => i.result == 'Passed').length;
    final needsAttn = c.inspections.where((i) => i.result == 'Needs Attention').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Inspections', value: '${c.inspections.length}', icon: Icons.fact_check, color: AppColors.primary),
          StatCard(label: 'Avg Score', value: '$cs%', icon: Icons.verified, color: cs >= 85 ? AppColors.success : AppColors.warning),
          StatCard(label: 'Passed', value: '$passed', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Needs Attention', value: '$needsAttn', icon: Icons.warning, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Log Inspection', () => _showInspectionModal(context, c), color: AppColors.success),
        const SizedBox(height: AppSpacing.lg),
        if (cs > 0 && cs < 85) _alertCard('Compliance Below Target', 'Current inspection average is $cs%. Target is 85%+.', AppColors.warning),
        if (c.inspections.isEmpty)
          Text('No inspections logged yet.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...c.inspections.map((i) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(i.result), width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(i.area, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                  Text('${i.date} | Inspector: ${i.inspector} | Score: ${i.score}%', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  if (i.notes.isNotEmpty) Text(i.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
                ])),
                _chip(i.result, _statusColor(i.result)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(onTap: () => _confirmDelete(context, 'Remove inspection for ${i.area}?', () => c.deleteInspection(i.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          )),
      ]),
    );
  }

  void _showInspectionModal(BuildContext context, CleaningProvider c) {
    String area = _areas[0], result = _inspectionResults[0];
    final inspectorCtrl = TextEditingController();
    final scoreCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Log Inspection', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Area', area, _areas, (v) => setState(() => area = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Inspector Name', inspectorCtrl, hint: 'e.g. Mr. Tetteh'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Result', result, _inspectionResults, (v) => setState(() => result = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Score (0-100)', scoreCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes (optional)', notesCtrl, multiline: true),
      ],
    )), () {
      final score = int.tryParse(scoreCtrl.text) ?? 0;
      if (inspectorCtrl.text.isEmpty) return;
      c.addInspection(area: area, inspector: inspectorCtrl.text, result: result, score: score, notes: notesCtrl.text);
    });
  }
}
