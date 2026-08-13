import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/boarding_provider.dart';
import '../../core/state/kitchen_provider.dart';
import '../../core/state/transport_provider.dart';
import '../../core/state/cleaning_provider.dart';
import '../../core/state/requisition_provider.dart';
import '../../core/widgets/widgets.dart';

class DomesticDashboard extends StatelessWidget {
  final String pageKey;
  const DomesticDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'boarding': return const _BoardingPage();
      case 'catering': return const _CateringPage();
      case 'transport': return const _TransportPage();
      case 'cleaning': return const _CleaningPage();
      case 'approvals': return _ApprovalsPage();
      case 'compliance': return _CompliancePage();
      case 'reports': return const _ReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

// ── Helpers ──

Widget _chip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
  );
}

Widget _subTabRow(List<String> tabs, String active, void Function(String) onTap) {
  return Wrap(spacing: AppSpacing.sm, children: tabs.map((t) {
    final isActive = t == active;
    return GestureDetector(
      onTap: () => onTap(t),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(t, style: TextStyle(
          fontSize: AppFontSize.sm, fontWeight: FontWeight.w600,
          color: isActive ? AppColors.textInverse : AppColors.textSecondary,
        )),
      ),
    );
  }).toList());
}

Widget _detailCard({required String title, required String meta, required List<Widget> children, Color? accentColor}) {
  return Container(
    margin: const EdgeInsets.only(bottom: AppSpacing.md),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      border: Border(
        left: accentColor != null ? BorderSide(color: accentColor, width: 3) : BorderSide.none,
        top: BorderSide(color: AppColors.border),
        right: BorderSide(color: AppColors.border),
        bottom: BorderSide(color: AppColors.border),
      ),
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold))),
        ...children,
      ]),
      const SizedBox(height: 4),
      Text(meta, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
    ]),
  );
}

Widget _alertBanner(String text, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Text(text, style: TextStyle(fontSize: AppFontSize.sm, color: color, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _reportBarRow(String label, int pct, int count, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Row(children: [
      SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: AppFontSize.sm))),
      Expanded(child: Container(
        height: 18,
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: (pct / 100).clamp(0.0, 1.0),
          child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.sm))),
        ),
      )),
      const SizedBox(width: AppSpacing.sm),
      SizedBox(width: 50, child: Text('$count', style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600))),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════
// Overview Page
// ═══════════════════════════════════════════════════════════

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final k = context.watch<KitchenProvider>();
    final t = context.watch<TransportProvider>();
    final c = context.watch<CleaningProvider>();
    final r = context.watch<RequisitionProvider>();

    final totalCapacity = b.houses.fold(0, (s, h) => s + h.capacity);
    final totalOccupied = b.houses.fold(0, (s, h) => s + h.occupied);
    final pendingApprovals = r.pendingDomestic;
    final openIssues = c.issues.where((i) => i.status != 'Resolved').toList();
    final pendingTasks = c.tasks.where((t) => !t.done).toList();
    final welfareUnresolved = b.welfare.where((w) => !w.resolved).toList();
    final disciplineEscalated = b.discipline.where((d) => d.escalated).toList();
    final stockAlerts = k.lowStock + k.outOfStock;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Boarding Occupancy', value: '$totalOccupied/$totalCapacity', icon: Icons.bed, color: AppColors.primaryLight),
        StatCard(label: 'Pending Requisitions', value: '${pendingApprovals.length}', icon: Icons.pending_actions, color: pendingApprovals.isNotEmpty ? AppColors.warning : AppColors.success),
        StatCard(label: 'Kitchen Alerts', value: '$stockAlerts', icon: Icons.warning, color: stockAlerts > 0 ? AppColors.danger : AppColors.success),
        StatCard(label: 'Vehicles Active', value: '${t.activeVehicles}', icon: Icons.directions_bus, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.md),
      StatCardGrid(cards: [
        StatCard(label: 'Cleaning Tasks Pending', value: '${pendingTasks.length}', icon: Icons.cleaning_services, color: pendingTasks.isNotEmpty ? AppColors.warning : AppColors.success),
        StatCard(label: 'Maintenance Issues', value: '${openIssues.length}', icon: Icons.build, color: openIssues.isNotEmpty ? AppColors.danger : AppColors.success),
        StatCard(label: 'Welfare Concerns', value: '${welfareUnresolved.length}', icon: Icons.favorite, color: welfareUnresolved.isNotEmpty ? AppColors.warning : AppColors.success),
        StatCard(label: 'Discipline Escalated', value: '${disciplineEscalated.length}', icon: Icons.gavel, color: disciplineEscalated.isNotEmpty ? AppColors.danger : AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Houses Summary', child: AppDataTable(
        columns: ['House', 'Type', 'Occupancy', 'Housemaster'],
        rows: b.houses.map((h) => [
          Text(h.name), Text(h.type), Text('${h.occupied}/${h.capacity}'), Text(h.housemaster),
        ]).toList(),
      )),
      if (pendingApprovals.isNotEmpty)
        _alertBanner('${pendingApprovals.length} requisition(s) awaiting your approval →', AppColors.warning, () => Navigator.pushNamed(context, '/dashboard/approvals')),
      if (welfareUnresolved.isNotEmpty)
        _alertBanner('${welfareUnresolved.length} unresolved welfare concern(s) in boarding →', AppColors.danger, () {}),
      if (stockAlerts > 0)
        _alertBanner('$stockAlerts kitchen stock item(s) need reordering →', AppColors.warning, () {}),
      if (openIssues.isNotEmpty)
        _alertBanner('${openIssues.length} maintenance issue(s) unresolved →', AppColors.danger, () {}),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════
// Boarding Page — 4 sub-tabs
// ═══════════════════════════════════════════════════════════

class _BoardingPage extends StatefulWidget {
  const _BoardingPage();
  @override
  State<_BoardingPage> createState() => _BoardingPageState();
}

class _BoardingPageState extends State<_BoardingPage> {
  String _subTab = 'houses';
  static const _tabs = ['houses', 'rollcall', 'discipline', 'welfare'];

  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final welfareOpen = b.welfare.where((w) => !w.resolved).length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Students', value: '${b.students.length}', icon: Icons.people, color: AppColors.primaryLight),
        StatCard(label: 'Houses', value: '${b.houses.length}', icon: Icons.home, color: AppColors.info),
        StatCard(label: 'Welfare Open', value: '$welfareOpen', icon: Icons.favorite, color: AppColors.warning),
        StatCard(label: 'Discipline Cases', value: '${b.discipline.length}', icon: Icons.gavel, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.md),
      _subTabRow(_tabs, _subTab, (v) => setState(() => _subTab = v)),
      const SizedBox(height: AppSpacing.lg),
      ..._buildSubTab(context, b),
    ]);
  }

  List<Widget> _buildSubTab(BuildContext context, BoardingProvider b) {
    switch (_subTab) {
      case 'houses':
        return [
          SectionCard(title: 'Boarding Houses', child: AppDataTable(
            columns: ['House', 'Type', 'Occupancy', 'Housemaster', 'Phone'],
            rows: b.houses.map((h) => [
              Text(h.name), Text(h.type), Text('${h.occupied}/${h.capacity}'),
              Text(h.housemaster), Text(h.phone),
            ]).toList(),
          )),
          const SizedBox(height: AppSpacing.lg),
          SectionCard(title: 'Room Allocation', child: AppDataTable(
            columns: ['House', 'Room', 'Beds', 'Students'],
            rows: b.rooms.map((r) => [
              Text(r.house), Text(r.room), Text('${r.occupied}/${r.beds}'),
              Text(r.studentNames.join(', ')),
            ]).toList(),
          )),
        ];
      case 'rollcall':
        return [
          SectionCard(title: "Today's Roll Call", child: AppDataTable(
            columns: ['House', 'Student', 'Room', 'Status', 'Notes'],
            rows: b.rollCalls.map((r) => [
              Text(r.house), Text(r.studentName), Text(r.room),
              _chip(r.status, r.status == 'Present' ? AppColors.success : r.status == 'Absent' ? AppColors.danger : AppColors.warning),
              Text(r.notes ?? '—'),
            ]).toList(),
          )),
        ];
      case 'discipline':
        return [
          SectionCard(title: 'Discipline Log', child: Column(children: b.discipline.map((d) {
            final sevColor = d.severity == 'Critical' || d.severity == 'Serious' ? AppColors.danger :
                             d.severity == 'Moderate' ? AppColors.warning : AppColors.success;
            return _detailCard(
              title: '${d.studentName} — ${d.incident}',
              meta: '${d.date} | ${d.house} House | By: ${d.recordedBy}',
              accentColor: sevColor,
              children: [
                _chip(d.severity, sevColor),
                if (d.escalated) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _chip('Escalated', AppColors.danger),
                ],
              ],
            );
          }).toList())),
        ];
      case 'welfare':
        return [
          SectionCard(title: 'Welfare Notes', child: Column(children: b.welfare.map((w) {
            return _detailCard(
              title: '${w.studentName} — ${w.house} House',
              meta: '${w.date} | By: ${w.recordedBy}',
              accentColor: w.resolved ? AppColors.success : AppColors.warning,
              children: [_chip(w.resolved ? 'Resolved' : 'Open', w.resolved ? AppColors.success : AppColors.warning)],
            );
          }).toList())),
        ];
      default:
        return [];
    }
  }
}

// ═══════════════════════════════════════════════════════════
// Catering Page — 3 sub-tabs
// ═══════════════════════════════════════════════════════════

class _CateringPage extends StatefulWidget {
  const _CateringPage();
  @override
  State<_CateringPage> createState() => _CateringPageState();
}

class _CateringPageState extends State<_CateringPage> {
  String _subTab = 'stock';
  static const _tabs = ['stock', 'menu', 'issues'];

  @override
  Widget build(BuildContext context) {
    final k = context.watch<KitchenProvider>();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Stock Items', value: '${k.stock.length}', icon: Icons.inventory_2, color: AppColors.primaryLight),
        StatCard(label: 'Low Stock', value: '${k.lowStock}', icon: Icons.warning, color: AppColors.warning),
        StatCard(label: 'Out of Stock', value: '${k.outOfStock}', icon: Icons.error, color: AppColors.danger),
        StatCard(label: 'Custom Menus', value: '${k.activeCustomMenus.length}', icon: Icons.restaurant_menu, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.md),
      _subTabRow(_tabs, _subTab, (v) => setState(() => _subTab = v)),
      const SizedBox(height: AppSpacing.lg),
      ..._buildSubTab(context, k),
    ]);
  }

  List<Widget> _buildSubTab(BuildContext context, KitchenProvider k) {
    switch (_subTab) {
      case 'stock':
        return [
          SectionCard(title: 'Kitchen Stock Levels', child: AppDataTable(
            columns: ['Item', 'Quantity', 'Reorder Level', 'Category', 'Status'],
            rows: k.stock.map((s) => [
              Text(s.name), Text('${s.quantity} ${s.unit}'), Text('${s.reorderLevel} ${s.unit}'),
              Text(s.category),
              _chip(s.quantity == 0 ? 'OUT' : s.quantity <= s.reorderLevel ? 'LOW' : 'OK',
                    s.quantity == 0 ? AppColors.danger : s.quantity <= s.reorderLevel ? AppColors.warning : AppColors.success),
            ]).toList(),
          )),
        ];
      case 'menu':
        return [
          SectionCard(title: 'Weekly Menu', child: AppDataTable(
            columns: ['Day', 'Breakfast', 'Lunch', 'Dinner'],
            rows: k.menu.map((m) => [
              Text(m.day), Text(m.breakfast), Text(m.lunch), Text(m.dinner),
            ]).toList(),
          )),
          const SizedBox(height: AppSpacing.lg),
          SectionCard(title: 'Special Dietary Menus', child: Column(children: k.customMenus.map((c) {
            return _detailCard(
              title: '${c.personName} (${c.personRole})',
              meta: 'Reason: ${c.reason} | Day: ${c.day}',
              accentColor: c.active ? AppColors.success : AppColors.textLight,
              children: [_chip(c.active ? 'Active' : 'Inactive', c.active ? AppColors.success : AppColors.textLight)],
            );
          }).toList())),
        ];
      case 'issues':
        return [
          SectionCard(title: 'Kitchen Issue Log', child: AppDataTable(
            columns: ['Date', 'Item', 'Issued To', 'Purpose'],
            rows: k.issues.map((i) => [
              Text(i.date), Text('${i.itemName} (${i.quantity} ${i.unit})'),
              Text(i.issuedTo), Text(i.purpose),
            ]).toList(),
          )),
        ];
      default:
        return [];
    }
  }
}

// ═══════════════════════════════════════════════════════════
// Transport Page — 4 sub-tabs
// ═══════════════════════════════════════════════════════════

class _TransportPage extends StatefulWidget {
  const _TransportPage();
  @override
  State<_TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<_TransportPage> {
  String _subTab = 'fleet';
  static const _tabs = ['fleet', 'maintenance', 'trips', 'drivers'];

  @override
  Widget build(BuildContext context) {
    final t = context.watch<TransportProvider>();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Vehicles', value: '${t.vehicles.length}', icon: Icons.directions_bus, color: AppColors.primaryLight),
        StatCard(label: 'Active', value: '${t.activeVehicles}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'In Maintenance', value: '${t.maintenanceVehicles}', icon: Icons.build, color: AppColors.warning),
        StatCard(label: 'Drivers On Duty', value: '${t.onDutyDrivers}', icon: Icons.badge, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.md),
      _subTabRow(_tabs, _subTab, (v) => setState(() => _subTab = v)),
      const SizedBox(height: AppSpacing.lg),
      ..._buildSubTab(context, t),
    ]);
  }

  List<Widget> _buildSubTab(BuildContext context, TransportProvider t) {
    switch (_subTab) {
      case 'fleet':
        return [
          SectionCard(title: 'Vehicle Fleet', child: AppDataTable(
            columns: ['Plate', 'Type', 'Status', 'Driver', 'Insurance Exp.'],
            rows: t.vehicles.map((v) => [
              Text(v.plate), Text(v.type),
              _chip(v.status, v.status == 'Active' ? AppColors.success : AppColors.warning),
              Text(v.assignedDriver ?? '—'), Text(v.insuranceExpiry),
            ]).toList(),
          )),
        ];
      case 'maintenance':
        return [
          StatCardGrid(cards: [
            StatCard(label: 'Upcoming/Scheduled', value: '${t.upcomingMaintenance.length}', icon: Icons.schedule, color: AppColors.warning),
            StatCard(label: 'In Progress', value: '${t.inProgressMaintenance.length}', icon: Icons.build_circle, color: AppColors.danger),
          ]),
          const SizedBox(height: AppSpacing.md),
          SectionCard(title: 'Maintenance Records', child: Column(children: t.maintenance.map((m) {
            final statusColor = m.status == 'Completed' ? AppColors.success :
                                m.status == 'In Progress' ? AppColors.danger :
                                m.status == 'Scheduled' ? AppColors.info : AppColors.warning;
            return _detailCard(
              title: '${m.vehiclePlate} — ${m.type}',
              meta: 'Due: ${m.dueDate}${m.cost != null ? ' | Cost: GHC ${m.cost!.toStringAsFixed(0)}' : ''}',
              accentColor: statusColor,
              children: [_chip(m.status, statusColor)],
            );
          }).toList())),
        ];
      case 'trips':
        return [
          SectionCard(title: 'Trip Logs', child: AppDataTable(
            columns: ['Date', 'Vehicle', 'Driver', 'Route', 'Mileage', 'Purpose'],
            rows: t.trips.map((tr) => [
              Text(tr.date), Text(tr.vehiclePlate), Text(tr.driverName),
              Text(tr.route), Text('${tr.mileage} km'), Text(tr.purpose),
            ]).toList(),
          )),
        ];
      case 'drivers':
        return [
          SectionCard(title: 'Drivers', child: AppDataTable(
            columns: ['Name', 'Phone', 'License', 'Assigned Vehicle', 'Status'],
            rows: t.drivers.map((d) => [
              Text(d.name), Text(d.phone), Text('Class ${d.license} (exp: ${d.licenseExpiry})'),
              Text(d.assignedVehicle),
              _chip(d.status, d.status == 'On Duty' ? AppColors.success : AppColors.textLight),
            ]).toList(),
          )),
        ];
      default:
        return [];
    }
  }
}

// ═══════════════════════════════════════════════════════════
// Cleaning Page — 4 sub-tabs
// ═══════════════════════════════════════════════════════════

class _CleaningPage extends StatefulWidget {
  const _CleaningPage();
  @override
  State<_CleaningPage> createState() => _CleaningPageState();
}

class _CleaningPageState extends State<_CleaningPage> {
  String _subTab = 'tasks';
  static const _tabs = ['tasks', 'issues', 'inspections', 'staff'];

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    final pendingTasks = c.tasks.where((t) => !t.done).toList();
    final openIssues = c.issues.where((i) => i.status != 'Fixed').toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Tasks Pending', value: '${pendingTasks.length}', icon: Icons.cleaning_services, color: pendingTasks.isNotEmpty ? AppColors.warning : AppColors.success),
        StatCard(label: 'Maintenance Issues', value: '${openIssues.length}', icon: Icons.build, color: openIssues.isNotEmpty ? AppColors.danger : AppColors.success),
        StatCard(label: 'Staff Present', value: '${c.staff.where((s) => s.status == 'Present').length}', icon: Icons.people, color: AppColors.info),
        StatCard(label: 'Compliance Score', value: '${c.complianceScore}%', icon: Icons.verified, color: c.complianceScore >= 80 ? AppColors.success : c.complianceScore >= 60 ? AppColors.warning : AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.md),
      _subTabRow(_tabs, _subTab, (v) => setState(() => _subTab = v)),
      const SizedBox(height: AppSpacing.lg),
      ..._buildSubTab(context, c),
    ]);
  }

  List<Widget> _buildSubTab(BuildContext context, CleaningProvider c) {
    switch (_subTab) {
      case 'tasks':
        return [
          SectionCard(title: 'Cleaning Tasks', child: AppDataTable(
            columns: ['Task', 'Area', 'Frequency', 'Assigned To', 'Status'],
            rows: c.tasks.map((t) => [
              Text(t.task), Text(t.area), Text(t.frequency), Text(t.assignedTo),
              _chip(t.done ? 'Done' : 'Pending', t.done ? AppColors.success : AppColors.warning),
            ]).toList(),
          )),
        ];
      case 'issues':
        return [
          SectionCard(title: 'Maintenance Issues', child: Column(children: c.issues.map((i) {
            final statusColor = i.status == 'Resolved' ? AppColors.success :
                                i.status == 'Assigned' ? AppColors.info : AppColors.danger;
            return _detailCard(
              title: '${i.issue} — ${i.location}',
              meta: '${i.date} | Priority: ${i.priority} | By: ${i.reportedBy}',
              accentColor: statusColor,
              children: [_chip(i.status, statusColor)],
            );
          }).toList())),
        ];
      case 'inspections':
        return [
          SectionCard(title: 'Inspection Reports', child: AppDataTable(
            columns: ['Date', 'Area', 'Inspector', 'Result', 'Notes'],
            rows: c.inspections.map((i) => [
              Text(i.date), Text(i.area), Text(i.inspector),
              _chip(i.result, i.result == 'Passed' ? AppColors.success : i.result == 'Needs Attention' ? AppColors.warning : AppColors.danger),
              Text(i.notes),
            ]).toList(),
          )),
        ];
      case 'staff':
        return [
          SectionCard(title: 'Cleaning Staff', child: AppDataTable(
            columns: ['Name', 'Phone', 'Role', 'Area', 'Status'],
            rows: c.staff.map((s) => [
              Text(s.name), Text(s.phone), Text(s.role), Text(s.area),
              _chip(s.status, s.status == 'Present' ? AppColors.success : AppColors.danger),
            ]).toList(),
          )),
          const SizedBox(height: AppSpacing.lg),
          SectionCard(title: 'Duty Roster', child: AppDataTable(
            columns: ['Area', 'Assigned To', 'Frequency', 'Time', 'Status'],
            rows: c.roster.map((r) => [
              Text(r.area), Text(r.assignedTo), Text(r.frequency), Text(r.time),
              _chip(r.status, r.status == 'Completed' ? AppColors.success : r.status == 'In Progress' ? AppColors.info : AppColors.warning),
            ]).toList(),
          )),
        ];
      default:
        return [];
    }
  }
}

// ═══════════════════════════════════════════════════════════
// Approvals Page
// ═══════════════════════════════════════════════════════════

class _ApprovalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RequisitionProvider>();
    final pending = r.pendingDomestic;
    final allBoardingReqs = r.getByDepartment('Boarding');

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Pending', value: '${pending.length}', icon: Icons.pending, color: pending.isNotEmpty ? AppColors.warning : AppColors.success),
        StatCard(label: 'Urgent', value: '${pending.where((r) => r.priority == 'Urgent').length}', icon: Icons.priority_high, color: AppColors.danger),
        StatCard(label: 'Normal', value: '${pending.where((r) => r.priority == 'Normal').length}', icon: Icons.drag_handle, color: AppColors.info),
        StatCard(label: 'Low', value: '${pending.where((r) => r.priority == 'Low').length}', icon: Icons.low_priority, color: AppColors.textSecondary),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Requisition Approvals',
        child: pending.isEmpty
          ? const Text('No pending approvals. All caught up!', style: TextStyle(color: AppColors.textSecondary))
          : Column(children: pending.map((req) {
              final accentColor = req.priority == 'Urgent' ? AppColors.danger : AppColors.warning;
              final shApproval = req.approvals.where((a) => a.step == 'senior_housemaster').firstOrNull;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: accentColor, width: 3),
                    top: BorderSide(color: AppColors.border),
                    right: BorderSide(color: AppColors.border),
                    bottom: BorderSide(color: AppColors.border),
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text('${req.itemName} — ${req.quantity} ${req.unit}',
                      style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold))),
                    _chip(req.priority, accentColor),
                  ]),
                  const SizedBox(height: 4),
                  Text('From: ${req.requestedBy}${req.house != null ? ' | ${req.house} House' : ''}',
                    style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                  Text('Date: ${req.date} | Priority: ${req.priority}',
                    style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                  if (req.notes.isNotEmpty)
                    Text('Notes: ${req.notes}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                  if (shApproval != null)
                    Text('Senior Housemaster: ${shApproval.approver} on ${shApproval.date}',
                      style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  Row(children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: AppColors.textInverse),
                      onPressed: () {
                        context.read<RequisitionProvider>().approveByDomestic(req.id, 'Asst. Headmaster (Domestic)');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${req.itemName} approved and forwarded to Stores.')));
                      },
                      child: const Text('Approve & Forward to Stores'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                      onPressed: () {
                        context.read<RequisitionProvider>().rejectRequisition(req.id, 'domestic', 'Asst. Headmaster (Domestic)');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${req.itemName} requisition rejected.')));
                      },
                      child: const Text('Send Back'),
                    ),
                  ]),
                ]),
              );
            }).toList()),
      ),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'All Boarding Requisitions', child: AppDataTable(
        columns: ['Item', 'Date', 'Requested By', 'House', 'Status'],
        rows: allBoardingReqs.map((req) {
          final statusColor = req.status == 'Received' ? AppColors.success :
                              req.status == 'Issued' ? AppColors.info :
                              req.status == 'Domestic Approved' ? AppColors.purple :
                              req.status == 'Senior Housemaster Approved' ? AppColors.primaryLight :
                              req.status == 'Rejected' ? AppColors.danger : AppColors.warning;
          return [
            Text('${req.itemName} — ${req.quantity} ${req.unit}'),
            Text(req.date), Text(req.requestedBy), Text(req.house ?? '—'),
            _chip(req.status, statusColor),
          ];
        }).toList(),
      )),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════
// Compliance Page
// ═══════════════════════════════════════════════════════════

class _CompliancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CleaningProvider>();
    final t = context.watch<TransportProvider>();
    final k = context.watch<KitchenProvider>();
    final openIssues = c.issues.where((i) => i.status != 'Resolved').toList();
    final stockAlerts = [...k.outOfStockList, ...k.lowStockList];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Cleaning Compliance', value: '${c.complianceScore}%', icon: Icons.verified, color: c.complianceScore >= 80 ? AppColors.success : c.complianceScore >= 60 ? AppColors.warning : AppColors.danger),
        StatCard(label: 'Insurance Expiring', value: '${t.expiringInsurance.length}', icon: Icons.schedule, color: t.expiringInsurance.isNotEmpty ? AppColors.warning : AppColors.success),
        StatCard(label: 'Kitchen Stock Alerts', value: '${stockAlerts.length}', icon: Icons.warning, color: stockAlerts.isNotEmpty ? AppColors.danger : AppColors.success),
        StatCard(label: 'Open Maintenance', value: '${openIssues.length}', icon: Icons.build, color: openIssues.isNotEmpty ? AppColors.danger : AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Cleaning Inspections', child: AppDataTable(
        columns: ['Date', 'Area', 'Inspector', 'Result', 'Notes'],
        rows: c.inspections.map((i) => [
          Text(i.date), Text(i.area), Text(i.inspector),
          _chip(i.result, i.result == 'Passed' ? AppColors.success : i.result == 'Needs Attention' ? AppColors.warning : AppColors.danger),
          Text(i.notes),
        ]).toList(),
      )),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Vehicle Insurance & Roadworthiness', child: AppDataTable(
        columns: ['Plate', 'Type', 'Insurance Exp.', 'Roadworthiness Exp.', 'Status'],
        rows: t.vehicles.map((v) => [
          Text(v.plate), Text(v.type), Text(v.insuranceExpiry),
          Text(v.roadworthinessExpiry),
          _chip(v.status, v.status == 'Active' ? AppColors.success : AppColors.warning),
        ]).toList(),
      )),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Kitchen Stock Alerts', child: stockAlerts.isEmpty
        ? const Text('All kitchen stock items are at healthy levels.', style: TextStyle(color: AppColors.textSecondary))
        : AppDataTable(
            columns: ['Item', 'Current', 'Reorder At', 'Status'],
            rows: stockAlerts.map((s) => [
              Text(s.name), Text('${s.quantity} ${s.unit}'), Text('${s.reorderLevel} ${s.unit}'),
              _chip(s.quantity == 0 ? 'OUT OF STOCK' : 'LOW STOCK', s.quantity == 0 ? AppColors.danger : AppColors.warning),
            ]).toList(),
          ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════
// Reports Page
// ═══════════════════════════════════════════════════════════

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final k = context.watch<KitchenProvider>();
    final t = context.watch<TransportProvider>();
    final c = context.watch<CleaningProvider>();

    final totalCapacity = b.houses.fold(0, (s, h) => s + h.capacity);
    final totalOccupied = b.houses.fold(0, (s, h) => s + h.occupied);
    final lowStock = k.lowStockList;
    final outOfStock = k.outOfStockList;
    final okStock = k.stock.where((s) => s.quantity > s.reorderLevel).length;
    final okStockPct = k.stock.isNotEmpty ? ((okStock / k.stock.length) * 100).round() : 100;
    final lowStockPct = k.stock.isNotEmpty ? ((lowStock.length / k.stock.length) * 100).round() : 0;
    final outOfStockPct = k.stock.isNotEmpty ? ((outOfStock.length / k.stock.length) * 100).round() : 0;
    final completedTasks = c.tasks.where((t) => t.done).length;
    final pendingTasks = c.tasks.where((t) => !t.done).length;
    final completedPct = c.tasks.isNotEmpty ? ((completedTasks / c.tasks.length) * 100).round() : 0;
    final pendingPct = c.tasks.isNotEmpty ? ((pendingTasks / c.tasks.length) * 100).round() : 0;
    final openCleaningIssues = c.issues.where((i) => i.status != 'Resolved').length;
    final openIssuesPct = c.issues.isNotEmpty ? ((openCleaningIssues / c.issues.length) * 100).round() : 0;
    final unresolvedWelfare = b.welfare.where((w) => !w.resolved).length;
    final unresolvedWelfarePct = b.welfare.isNotEmpty ? ((unresolvedWelfare / b.welfare.length) * 100).round() : 0;
    final escalatedDiscipline = b.discipline.where((d) => d.escalated).length;
    final escalatedPct = b.discipline.isNotEmpty ? ((escalatedDiscipline / b.discipline.length) * 100).round() : 0;

    final reports = [
      ('Overview', '${b.houses.length} houses, ${k.stock.length} stock items, ${t.vehicles.length} vehicles', AppColors.primary),
      ('Boarding Occupancy', '${b.students.length} students, $totalOccupied/$totalCapacity occupancy', AppColors.info),
      ('Catering & Meal', '${k.stock.length} stock items, ${k.issues.length} issues logged, ${lowStock.length + outOfStock.length} alerts', AppColors.success),
      ('Transport Log', '${t.vehicles.length} vehicles, ${t.trips.length} trips, GHC ${t.totalFuelCost.toStringAsFixed(0)} fuel', AppColors.warning),
      ('Cleaning & Compliance', '${c.tasks.length} tasks, ${c.inspections.length} inspections, ${c.complianceScore}% compliance', AppColors.purple),
      ('Welfare & Discipline', '$unresolvedWelfare open welfare, ${b.discipline.length} discipline, $escalatedDiscipline escalated', AppColors.danger),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionCard(title: 'Domestic Operations Reports', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Generate printable PDF reports across all domestic operations', style: TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm)),
        const SizedBox(height: AppSpacing.md),
        ...reports.map((r) {
          final (name, desc, color) = r;
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(children: [
              Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
                Text(desc, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
              ])),
              Icon(Icons.picture_as_pdf, size: 20, color: color),
            ]),
          );
        }),
      ])),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Boarding Occupancy by House', child: Column(children: b.houses.map((h) {
        final pct = h.capacity > 0 ? ((h.occupied / h.capacity) * 100).round() : 0;
        final color = pct >= 95 ? AppColors.danger : pct >= 80 ? AppColors.warning : AppColors.success;
        return _reportBarRow(h.name, pct, h.occupied, color);
      }).toList())),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Kitchen Stock Status', child: Column(children: [
        _reportBarRow('OK', okStockPct, okStock, AppColors.success),
        _reportBarRow('Low Stock', lowStockPct, lowStock.length, AppColors.warning),
        _reportBarRow('Out of Stock', outOfStockPct, outOfStock.length, AppColors.danger),
      ])),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Vehicle Status', child: Column(children: ['Active', 'Maintenance', 'Retired'].map((st) {
        final count = t.vehicles.where((v) => v.status == st).length;
        final pct = t.vehicles.isNotEmpty ? ((count / t.vehicles.length) * 100).round() : 0;
        final color = st == 'Active' ? AppColors.success : st == 'Maintenance' ? AppColors.warning : AppColors.textLight;
        return _reportBarRow(st, pct, count, color);
      }).toList())),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Cleaning Task Completion', child: Column(children: [
        _reportBarRow('Completed', completedPct, completedTasks, AppColors.success),
        _reportBarRow('Pending', pendingPct, pendingTasks, AppColors.warning),
        _reportBarRow('Open Issues', openIssuesPct, openCleaningIssues, AppColors.danger),
      ])),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Welfare & Discipline', child: Column(children: [
        _reportBarRow('Unresolved Welfare', unresolvedWelfarePct, unresolvedWelfare, AppColors.warning),
        _reportBarRow('Escalated Discipline', escalatedPct, escalatedDiscipline, AppColors.danger),
      ])),
    ]);
  }
}
