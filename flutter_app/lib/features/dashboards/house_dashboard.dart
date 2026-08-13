import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/boarding_provider.dart';
import '../../core/state/requisition_provider.dart';
import '../../core/widgets/widgets.dart';

class HouseDashboard extends StatelessWidget {
  final String pageKey;
  const HouseDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'roster': return const _RosterPage();
      case 'rooms': return const _RoomsPage();
      case 'rollcall': return const _RollCallPage();
      case 'discipline': return const _DisciplinePage();
      case 'welfare': return const _WelfarePage();
      case 'exeats': return const _ExeatsPage();
      case 'requisitions': return const _RequisitionsPage();
      case 'reports': return const _ReportsPage();
      case 'assignments': return const _AssignmentsPage();
      case 'approvals': return const _ApprovalsPage();
      case 'houses': return const _HousesPage();
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

Color _statusColor(String s) {
  switch (s) {
    case 'Present': return AppColors.success;
    case 'Absent': return AppColors.danger;
    case 'Excused': return AppColors.info;
    case 'Late': return AppColors.warning;
    case 'Minor': return AppColors.textSecondary;
    case 'Moderate': return AppColors.warning;
    case 'Serious':
    case 'Critical': return AppColors.danger;
    default: return AppColors.primary;
  }
}

Color _severityColor(String s) =>
    s == 'Critical' || s == 'Serious' ? AppColors.danger : s == 'Moderate' ? AppColors.warning : AppColors.textSecondary;

Widget _alertBanner(String title, List<String> items, Color color) {
  return Container(
    margin: const EdgeInsets.only(bottom: AppSpacing.md),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border(left: BorderSide(color: color, width: 4), top: BorderSide(color: AppColors.border), right: BorderSide(color: AppColors.border), bottom: BorderSide(color: AppColors.border)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: color)),
      const SizedBox(height: 4),
      ...items.map((t) => Padding(padding: const EdgeInsets.only(bottom: 2), child: Text(t, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)))),
    ]),
  );
}

Widget _detailCard({required String title, required String meta, required List<Widget> children, Color? accentColor}) {
  return Container(
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border(
        left: BorderSide(color: accentColor ?? AppColors.primary, width: 4),
        top: BorderSide(color: AppColors.border),
        right: BorderSide(color: AppColors.border),
        bottom: BorderSide(color: AppColors.border),
      ),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold))),
        ...children,
      ]),
      const SizedBox(height: 4),
      Text(meta, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
    ]),
  );
}

Widget _reportBarRow(String label, int count, int total, Color color) {
  final pct = total > 0 ? (count / total * 100).round() : 0;
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Row(children: [
      SizedBox(width: 120, child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
      const SizedBox(width: AppSpacing.sm),
      Expanded(child: Container(height: 8, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(4)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: pct / 100, child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)))))),
      const SizedBox(width: AppSpacing.sm),
      SizedBox(width: 50, child: Text('$count', style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
    ]),
  );
}

const _rollCallStatuses = ['Present', 'Absent', 'Excused', 'Late'];
const _disciplineSeverities = ['Minor', 'Moderate', 'Serious', 'Critical'];

String _todayISO() => DateTime.now().toIso8601String().split('T')[0];

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final today = _todayISO();
    final todayRollCalls = b.rollCalls.where((r) => r.date == today).toList();
    final present = todayRollCalls.where((r) => r.status == 'Present').length;
    final escalated = b.discipline.where((d) => d.escalated).toList();
    final unresolvedWelfare = b.welfare.where((w) => !w.resolved).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Students', value: '${b.students.length}', icon: Icons.school, color: AppColors.primary),
        StatCard(label: 'Present Today', value: '$present', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Escalated', value: '${escalated.length}', icon: Icons.priority_high, color: escalated.isNotEmpty ? AppColors.danger : AppColors.success),
        StatCard(label: 'Welfare Open', value: '${unresolvedWelfare.length}', icon: Icons.health_and_safety, color: unresolvedWelfare.isNotEmpty ? AppColors.warning : AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),

      if (escalated.isNotEmpty)
        _alertBanner('Escalated Discipline (${escalated.length})',
          escalated.map((d) => '${d.house} — ${d.studentName}: ${d.incident} (${d.severity})').toList(),
          AppColors.danger),

      if (unresolvedWelfare.isNotEmpty)
        _alertBanner('Unresolved Welfare (${unresolvedWelfare.length})',
          unresolvedWelfare.map((w) => '${w.house} — ${w.studentName}: ${w.note.length > 50 ? '${w.note.substring(0, 50)}...' : w.note}').toList(),
          AppColors.warning),

      Text('House Summary', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      ...b.houses.map((h) {
        final hStudents = b.students.where((s) => s.house == h.name).length;
        final hPresent = todayRollCalls.where((r) => r.house == h.name && r.status == 'Present').length;
        final hAbsent = todayRollCalls.where((r) => r.house == h.name && r.status == 'Absent').length;
        return _detailCard(
          title: '${h.name} House (${h.type})',
          meta: 'Housemaster: ${h.housemaster} | ${h.occupied}/${h.capacity} capacity | Students: $hStudents | Present: $hPresent | Absent: $hAbsent',
          accentColor: AppColors.primary,
          children: [],
        );
      }),

      const SizedBox(height: AppSpacing.lg),
      Text('Quick Actions', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
        ElevatedButton.icon(onPressed: () => _showStudentDialog(context), icon: const Icon(Icons.person_add, size: 18), label: const Text('Add Student'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary)),
        ElevatedButton.icon(onPressed: () => _showDisciplineDialog(context), icon: const Icon(Icons.gavel, size: 18), label: const Text('Log Incident'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger)),
        ElevatedButton.icon(onPressed: () => _showWelfareDialog(context), icon: const Icon(Icons.note_add, size: 18), label: const Text('Welfare Note'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.info)),
        ElevatedButton.icon(onPressed: () => _showAssignDialog(context), icon: const Icon(Icons.admin_panel_settings, size: 18), label: const Text('Assign Housemaster'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple)),
      ]),
    ]);
  }
}

class _RosterPage extends StatelessWidget {
  const _RosterPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    return SectionCard(title: 'House Roster', child: AppDataTable(
      columns: ['Adm No', 'Name', 'Class', 'House', 'Room', 'Bed'],
      rows: b.students.map((s) => [
        Text(s.admNo), Text(s.name), Text(s.className), Text(s.house),
        Text(s.room), Text(s.bed ?? '—'),
      ]).toList(),
    ));
  }
}

class _RoomsPage extends StatelessWidget {
  const _RoomsPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    return SectionCard(title: 'Room Allocation', child: AppDataTable(
      columns: ['House', 'Room', 'Beds', 'Occupied', 'Students'],
      rows: b.rooms.map((r) => [
        Text(r.house), Text(r.room), Text('${r.beds}'), Text('${r.occupied}'),
        Text(r.studentNames.join(', ')),
      ]).toList(),
    ));
  }
}

class _RollCallPage extends StatelessWidget {
  const _RollCallPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final today = _todayISO();
    final todayRollCalls = b.rollCalls.where((r) => r.date == today).toList();
    final present = todayRollCalls.where((r) => r.status == 'Present').length;
    final absent = todayRollCalls.where((r) => r.status == 'Absent').length;
    final excused = todayRollCalls.where((r) => r.status == 'Excused').length;
    final late = todayRollCalls.where((r) => r.status == 'Late').length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Present', value: '$present', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Absent', value: '$absent', icon: Icons.cancel, color: AppColors.danger),
        StatCard(label: 'Excused', value: '$excused', icon: Icons.info, color: AppColors.info),
        StatCard(label: 'Late', value: '$late', icon: Icons.schedule, color: AppColors.warning),
      ]),
      const SizedBox(height: AppSpacing.lg),
      ...b.houses.map((h) {
        final hRollCalls = todayRollCalls.where((r) => r.house == h.name).toList();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('${h.name} House (${hRollCalls.length})', style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const Spacer(),
            if (hRollCalls.isEmpty)
              TextButton(onPressed: () => b.startRollCall(h.name, 'Senior Housemaster'), child: const Text('Start Roll Call')),
          ]),
          const SizedBox(height: AppSpacing.sm),
          ...hRollCalls.map((r) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.studentName, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600)),
                Text('Room: ${r.room}${r.notes != null && r.notes!.isNotEmpty ? ' | ${r.notes}' : ''}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ])),
              Row(children: _rollCallStatuses.map((st) =>
                Padding(padding: const EdgeInsets.only(left: AppSpacing.xs), child: GestureDetector(
                  onTap: () => b.updateRollCallStatus(r.id, st),
                  child: Text(st, style: TextStyle(fontSize: AppFontSize.xs, color: r.status == st ? _statusColor(st) : AppColors.textLight, fontWeight: r.status == st ? FontWeight.bold : FontWeight.normal)),
                )),
              ).toList()),
            ]),
          )),
          const SizedBox(height: AppSpacing.md),
        ]);
      }),
    ]);
  }
}

class _DisciplinePage extends StatelessWidget {
  const _DisciplinePage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final escalated = b.discipline.where((d) => d.escalated).toList();
    final serious = b.discipline.where((d) => d.severity == 'Serious' || d.severity == 'Critical').length;
    final resolved = b.discipline.where((d) => d.actionTaken != 'Pending').length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total', value: '${b.discipline.length}', icon: Icons.gavel, color: AppColors.primary),
        StatCard(label: 'Escalated', value: '${escalated.length}', icon: Icons.priority_high, color: AppColors.danger),
        StatCard(label: 'Serious+', value: '$serious', icon: Icons.warning, color: AppColors.warning),
        StatCard(label: 'Resolved', value: '$resolved', icon: Icons.check_circle, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),
      ElevatedButton.icon(
        onPressed: () => _showDisciplineDialog(context),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Log Incident'),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('All Discipline Logs', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      ...b.discipline.map((d) => _detailCard(
        title: '${d.house} — ${d.studentName}: ${d.incident}',
        meta: '${d.date} | By ${d.recordedBy} | Action: ${d.actionTaken}',
        accentColor: _severityColor(d.severity),
        children: [
          _chip(d.severity, _severityColor(d.severity)),
          if (d.escalated) _chip('Escalated', AppColors.danger),
          const SizedBox(width: AppSpacing.sm),
          if (!d.escalated) TextButton(onPressed: () => b.escalateDiscipline(d.id), child: const Text('Escalate')),
          TextButton(onPressed: () => b.deleteDiscipline(d.id), child: Text('Delete', style: TextStyle(color: AppColors.danger))),
        ],
      )),
    ]);
  }
}

class _WelfarePage extends StatelessWidget {
  const _WelfarePage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final unresolved = b.welfare.where((w) => !w.resolved).toList();
    final resolved = b.welfare.where((w) => w.resolved).length;
    final studentCount = b.welfare.map((w) => w.studentName).toSet().length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total', value: '${b.welfare.length}', icon: Icons.note, color: AppColors.primary),
        StatCard(label: 'Unresolved', value: '${unresolved.length}', icon: Icons.warning, color: AppColors.danger),
        StatCard(label: 'Resolved', value: '$resolved', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Students', value: '$studentCount', icon: Icons.school, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),
      ElevatedButton.icon(
        onPressed: () => _showWelfareDialog(context),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Welfare Note'),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.info),
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('All Welfare Notes', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      ...b.welfare.map((w) => _detailCard(
        title: '${w.house} — ${w.studentName}',
        meta: '${w.date} | By ${w.recordedBy}',
        accentColor: w.resolved ? AppColors.success : AppColors.warning,
        children: [
          _chip(w.resolved ? 'Resolved' : 'Active', w.resolved ? AppColors.success : AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          if (!w.resolved) TextButton(onPressed: () => b.resolveWelfare(w.id), child: const Text('Resolve')),
          TextButton(onPressed: () => b.deleteWelfare(w.id), child: Text('Delete', style: TextStyle(color: AppColors.danger))),
        ],
      )),
    ]);
  }
}

class _ExeatsPage extends StatelessWidget {
  const _ExeatsPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final pending = b.exeats.where((e) => e.status == 'Pending').toList();
    final approved = b.exeats.where((e) => e.status == 'Approved' || e.status == 'Checked Out').length;
    final active = b.exeats.where((e) => e.status == 'Checked Out').length;
    final rejected = b.exeats.where((e) => e.status == 'Rejected').length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Pending', value: '${pending.length}', icon: Icons.pending, color: pending.isNotEmpty ? AppColors.warning : AppColors.success),
        StatCard(label: 'Approved', value: '$approved', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Active', value: '$active', icon: Icons.directions_run, color: AppColors.info),
        StatCard(label: 'Rejected', value: '$rejected', icon: Icons.cancel, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),
      Text('Exeat Approvals', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.xs),
      Text('Student exeat requests from housemasters — approve to generate a gate pass', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.md),
      if (pending.isEmpty)
        Text('No pending exeat requests.', style: TextStyle(color: AppColors.textLight, fontSize: AppFontSize.md))
      else
        ...pending.map((e) => _detailCard(
          title: '${e.studentName} (${e.admissionNo})',
          meta: '${e.exeatNo} | ${e.house} House | Issued by ${e.issuedBy}\nReason: ${e.reason} — ${e.reasonDetail}\nDestination: ${e.destination}\nDeparture: ${e.departureDate} | Return: ${e.returnDate}\nGuardian: ${e.guardianName} (${e.guardianPhone}) | Transport: ${e.transportMode}',
          accentColor: AppColors.warning,
          children: [
            TextButton(onPressed: () => b.approveExeat(e.id, 'Senior Housemaster'), child: const Text('Approve')),
            TextButton(onPressed: () => b.rejectExeat(e.id, 'Senior Housemaster'), child: Text('Reject', style: TextStyle(color: AppColors.danger))),
          ],
        )),
      const SizedBox(height: AppSpacing.lg),
      Text('All Exeats', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      ...b.exeats.where((e) => e.status != 'Pending').map((e) => _detailCard(
        title: '${e.studentName} (${e.admissionNo})',
        meta: '${e.exeatNo} | ${e.house} | ${e.date}\nDeparture: ${e.departureDate} | Return: ${e.returnDate}${e.approvedBy.isNotEmpty ? '\nApproved by: ${e.approvedBy}' : ''}',
        accentColor: e.status == 'Rejected' ? AppColors.danger : e.status == 'Checked Out' ? AppColors.info : e.status == 'Checked In' ? AppColors.success : AppColors.primaryLight,
        children: [_chip(e.status, e.status == 'Checked In' ? AppColors.success : e.status == 'Checked Out' ? AppColors.info : e.status == 'Rejected' ? AppColors.danger : AppColors.primaryLight)],
      )),
    ]);
  }
}

class _RequisitionsPage extends StatelessWidget {
  const _RequisitionsPage();
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'Requisitions', child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.inventory_2, size: 48, color: AppColors.textLight),
        const SizedBox(height: AppSpacing.sm),
        Text('No pending requisitions', style: TextStyle(color: AppColors.textSecondary)),
      ]),
    ));
  }
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final today = _todayISO();
    final todayRollCalls = b.rollCalls.where((r) => r.date == today).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Reports & Analytics', style: const TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.xs),
      Text('Cross-house boarding data insights', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),
      StatCardGrid(cards: [
        StatCard(label: 'Students', value: '${b.students.length}', icon: Icons.school, color: AppColors.primary),
        StatCard(label: 'Present', value: '${todayRollCalls.where((r) => r.status == 'Present').length}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Discipline', value: '${b.discipline.length}', icon: Icons.gavel, color: AppColors.danger),
        StatCard(label: 'Welfare', value: '${b.welfare.length}', icon: Icons.note, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),

      SectionCard(title: 'Roll Call by House', child: Column(children: b.houses.map((h) {
        final hRollCalls = todayRollCalls.where((r) => r.house == h.name).toList();
        final hPresent = hRollCalls.where((r) => r.status == 'Present').length;
        return _reportBarRow(h.name, hPresent, hRollCalls.length, AppColors.success);
      }).toList())),

      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Discipline by Severity', child: Column(children: _disciplineSeverities.map((sev) {
        final count = b.discipline.where((d) => d.severity == sev).length;
        return _reportBarRow(sev, count, b.discipline.length, _severityColor(sev));
      }).toList())),

      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Discipline by House', child: Column(children: b.houses.map((h) {
        final count = b.discipline.where((d) => d.house == h.name).length;
        return _reportBarRow(h.name, count, b.discipline.length, AppColors.danger);
      }).toList())),

      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Welfare by House', child: Column(children: b.houses.map((h) {
        final count = b.welfare.where((w) => w.house == h.name).length;
        return _reportBarRow(h.name, count, b.welfare.length, AppColors.warning);
      }).toList())),
    ]);
  }
}

// ── House Assignments (Senior Housemaster) ──

class _AssignmentsPage extends StatelessWidget {
  const _AssignmentsPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final assigned = b.houses.where((h) => h.housemaster.isNotEmpty && h.housemaster != 'Unassigned').length;
    final unassigned = b.houses.length - assigned;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Houses', value: '${b.houses.length}', icon: Icons.home, color: AppColors.primary),
        StatCard(label: 'Assigned', value: '$assigned', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Unassigned', value: '$unassigned', icon: Icons.error_outline, color: AppColors.danger),
        StatCard(label: 'Total Students', value: '${b.students.length}', icon: Icons.school, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),
      ElevatedButton.icon(
        onPressed: () => _showAssignDialog(context),
        icon: const Icon(Icons.admin_panel_settings, size: 18),
        label: const Text('Assign Housemaster'),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
      ),
      const SizedBox(height: AppSpacing.lg),
      Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: AppColors.info, width: 4))),
        child: Text('Assign a housemaster to each house. When a user logs in with the Housemaster/Housemistress role, their display name is matched against the housemaster name to determine which house dashboard they see.',
          style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.info)),
      ),
      ...b.houses.map((h) {
        final hStudents = b.students.where((s) => s.house == h.name).length;
        final isAssigned = h.housemaster.isNotEmpty && h.housemaster != 'Unassigned';
        return _detailCard(
          title: '${h.name} House (${h.type})',
          meta: 'Housemaster: ${h.housemaster}${h.phone.isNotEmpty ? ' | Phone: ${h.phone}' : ''}\nStudents: $hStudents | Capacity: ${h.occupied}/${h.capacity}',
          accentColor: isAssigned ? AppColors.success : AppColors.danger,
          children: [
            _chip(isAssigned ? 'Assigned' : 'Unassigned', isAssigned ? AppColors.success : AppColors.danger),
            const SizedBox(width: AppSpacing.sm),
            TextButton(onPressed: () => _showAssignDialog(context, houseId: h.id, housemasterName: h.housemaster, phone: h.phone), child: Text(isAssigned ? 'Reassign' : 'Assign')),
          ],
        );
      }),
    ]);
  }
}

// ── Requisition Approvals (Senior Housemaster) ──

class _ApprovalsPage extends StatelessWidget {
  const _ApprovalsPage();
  @override
  Widget build(BuildContext context) {
    final req = context.watch<RequisitionProvider>();
    final pending = req.pendingSeniorHousemaster;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Pending', value: '${pending.length}', icon: Icons.pending, color: pending.isNotEmpty ? AppColors.warning : AppColors.success),
        StatCard(label: 'Urgent', value: '${pending.where((r) => r.priority == 'Urgent').length}', icon: Icons.priority_high, color: AppColors.danger),
        StatCard(label: 'Normal', value: '${pending.where((r) => r.priority == 'Normal').length}', icon: Icons.info_outline, color: AppColors.info),
        StatCard(label: 'Low', value: '${pending.where((r) => r.priority == 'Low').length}', icon: Icons.low_priority, color: AppColors.textLight),
      ]),
      const SizedBox(height: AppSpacing.lg),
      Text('Requisition Approvals', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.xs),
      Text('Requisitions from housemasters awaiting your approval before forwarding to Asst. Headmaster (Domestic)', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.md),
      if (pending.isEmpty)
        Text('No pending requisitions. All caught up!', style: TextStyle(color: AppColors.textLight, fontSize: AppFontSize.md))
      else
        ...pending.map((r) => _detailCard(
          title: '${r.itemName} — ${r.quantity} ${r.unit}',
          meta: 'From: ${r.requestedBy}${r.house != null ? ' | ${r.house} House' : ''}\nDate: ${r.date} | Priority: ${r.priority}${r.notes.isNotEmpty ? '\nNotes: ${r.notes}' : ''}',
          accentColor: r.priority == 'Urgent' ? AppColors.danger : AppColors.warning,
          children: [
            _chip(r.priority, r.priority == 'Urgent' ? AppColors.danger : r.priority == 'Normal' ? AppColors.info : AppColors.textLight),
            const SizedBox(width: AppSpacing.sm),
            TextButton(onPressed: () {
              req.approveBySeniorHousemaster(r.id, 'Senior Housemaster');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${r.itemName} approved and forwarded to Asst. Headmaster (Domestic).')));
            }, child: const Text('Approve & Forward')),
            TextButton(onPressed: () {
              req.rejectRequisition(r.id, 'senior_housemaster', 'Senior Housemaster');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${r.itemName} requisition rejected.')));
            }, child: Text('Reject', style: TextStyle(color: AppColors.danger))),
          ],
        )),
    ]);
  }
}

// ── Houses Overview (Senior Housemaster) ──

class _HousesPage extends StatelessWidget {
  const _HousesPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final totalCapacity = b.houses.fold(0, (s, h) => s + h.capacity);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Houses', value: '${b.houses.length}', icon: Icons.home, color: AppColors.primary),
        StatCard(label: 'Students', value: '${b.students.length}', icon: Icons.school, color: AppColors.info),
        StatCard(label: 'Rooms', value: '${b.rooms.length}', icon: Icons.bed, color: AppColors.success),
        StatCard(label: 'Capacity', value: '$totalCapacity', icon: Icons.event_seat, color: AppColors.warning),
      ]),
      const SizedBox(height: AppSpacing.lg),
      Text('All Houses', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      ...b.houses.map((h) {
        final hStudents = b.students.where((s) => s.house == h.name).length;
        final hRooms = b.rooms.where((r) => r.house == h.name).length;
        return _detailCard(
          title: '${h.name} House — ${h.type}',
          meta: 'Housemaster: ${h.housemaster} | Phone: ${h.phone}\nCapacity: ${h.occupied}/${h.capacity} | Since: ${h.since}\nStudents: $hStudents | Rooms: $hRooms',
          accentColor: AppColors.primary,
          children: [],
        );
      }),
      const SizedBox(height: AppSpacing.lg),
      Text('All Students', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      ...b.students.map((s) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.name, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold)),
            Text('${s.house} | Adm: ${s.admNo} | Class: ${s.className} | Room: ${s.room}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
          ])),
          TextButton(onPressed: () => b.deleteStudent(s.id), child: Text('Delete', style: TextStyle(color: AppColors.danger))),
        ]),
      )),
    ]);
  }
}

// ── Dialog helpers ──

void _showStudentDialog(BuildContext context) {
  final b = context.read<BoardingProvider>();
  final admNoCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final roomCtrl = TextEditingController();
  final bedCtrl = TextEditingController();
  String selectedHouse = b.houses.isNotEmpty ? b.houses.first.name : '';

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Add Student'),
    content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: admNoCtrl, decoration: const InputDecoration(labelText: 'Admission Number *', hintText: 'e.g. 2026/001')),
      TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Student Name *', hintText: 'Full name')),
      const SizedBox(height: AppSpacing.sm),
      Wrap(spacing: 6, children: b.houses.map((h) => ChoiceChip(label: Text(h.name), selected: selectedHouse == h.name, onSelected: (_) => setState(() => selectedHouse = h.name))).toList()),
      TextField(controller: classCtrl, decoration: const InputDecoration(labelText: 'Class', hintText: 'e.g. SHS2 Sci A')),
      TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Room', hintText: 'e.g. A-12')),
      TextField(controller: bedCtrl, decoration: const InputDecoration(labelText: 'Bed', hintText: 'e.g. 1')),
    ])),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (nameCtrl.text.trim().isEmpty || admNoCtrl.text.trim().isEmpty) return;
        b.addStudent(BoardingStudent(
          id: '', admNo: admNoCtrl.text.trim(), name: nameCtrl.text.trim(),
          className: classCtrl.text.trim(), house: selectedHouse, room: roomCtrl.text.trim(), bed: bedCtrl.text.trim(),
        ));
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}

void _showDisciplineDialog(BuildContext context) {
  final b = context.read<BoardingProvider>();
  final studentCtrl = TextEditingController();
  final incidentCtrl = TextEditingController();
  final actionCtrl = TextEditingController();
  String selectedHouse = b.houses.isNotEmpty ? b.houses.first.name : '';
  String selectedSeverity = 'Minor';

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Log Discipline Incident'),
    content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Wrap(spacing: 6, children: b.houses.map((h) => ChoiceChip(label: Text(h.name), selected: selectedHouse == h.name, onSelected: (_) => setState(() => selectedHouse = h.name))).toList()),
      TextField(controller: studentCtrl, decoration: const InputDecoration(labelText: 'Student Name *', hintText: 'Student name')),
      TextField(controller: incidentCtrl, decoration: const InputDecoration(labelText: 'Incident *', hintText: 'e.g. Bullying')),
      const SizedBox(height: AppSpacing.sm),
      Wrap(spacing: 6, children: _disciplineSeverities.map((sev) => ChoiceChip(label: Text(sev), selected: selectedSeverity == sev, onSelected: (_) => setState(() => selectedSeverity = sev))).toList()),
      TextField(controller: actionCtrl, decoration: const InputDecoration(labelText: 'Action Taken', hintText: 'e.g. Warning given')),
    ])),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (studentCtrl.text.trim().isEmpty || incidentCtrl.text.trim().isEmpty) return;
        b.addDiscipline(DisciplineLog(
          id: '', date: _todayISO(), house: selectedHouse, studentName: studentCtrl.text.trim(),
          incident: incidentCtrl.text.trim(), severity: selectedSeverity,
          actionTaken: actionCtrl.text.trim().isEmpty ? 'Pending' : actionCtrl.text.trim(),
          recordedBy: 'Senior Housemaster', escalated: false,
        ));
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}

void _showWelfareDialog(BuildContext context) {
  final b = context.read<BoardingProvider>();
  final studentCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String selectedHouse = b.houses.isNotEmpty ? b.houses.first.name : '';

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Add Welfare Note'),
    content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Wrap(spacing: 6, children: b.houses.map((h) => ChoiceChip(label: Text(h.name), selected: selectedHouse == h.name, onSelected: (_) => setState(() => selectedHouse = h.name))).toList()),
      TextField(controller: studentCtrl, decoration: const InputDecoration(labelText: 'Student Name *', hintText: 'Student name')),
      TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Note *', hintText: 'Welfare observation'), maxLines: 3),
    ])),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (studentCtrl.text.trim().isEmpty || noteCtrl.text.trim().isEmpty) return;
        b.addWelfare(WelfareNote(
          id: '', date: _todayISO(), house: selectedHouse, studentName: studentCtrl.text.trim(),
          note: noteCtrl.text.trim(), recordedBy: 'Senior Housemaster', resolved: false,
        ));
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}

void _showAssignDialog(BuildContext context, {String? houseId, String? housemasterName, String? phone}) {
  final b = context.read<BoardingProvider>();
  final nameCtrl = TextEditingController(text: housemasterName != null && housemasterName != 'Unassigned' ? housemasterName : '');
  final phoneCtrl = TextEditingController(text: phone ?? '');
  String selectedHouseId = houseId ?? (b.houses.isNotEmpty ? b.houses.first.id : '');

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Assign Housemaster'),
    content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Wrap(spacing: 6, children: b.houses.map((h) => ChoiceChip(label: Text(h.name), selected: selectedHouseId == h.id, onSelected: (_) => setState(() => selectedHouseId = h.id))).toList()),
      TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Housemaster Name *', hintText: 'e.g. Mr. Owusu')),
      TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone', hintText: 'e.g. 024-111-2222')),
      const SizedBox(height: AppSpacing.sm),
      Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)),
        child: Text('The housemaster will see this house\'s dashboard when they log in with the Housemaster/Housemistress role and their display name matches the name entered above.',
          style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
      ),
    ])),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (nameCtrl.text.trim().isEmpty) return;
        b.assignHousemaster(selectedHouseId, nameCtrl.text.trim(), phoneCtrl.text.trim());
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}
