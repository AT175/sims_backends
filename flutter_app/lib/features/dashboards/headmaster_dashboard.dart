import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/app_models.dart';
import '../../core/state/registry_provider.dart';
import '../../core/state/bursary_provider.dart';
import '../../core/state/academic_provider.dart';
import '../../core/state/notification_provider.dart';
import '../../core/state/access_control_provider.dart';
import '../../core/state/system_admin_provider.dart';
import '../../core/state/kitchen_provider.dart';
import '../../core/state/headmaster_provider.dart';
import '../../core/state/misc_providers.dart';
import '../../core/navigation/dashboard_catalog.dart';
import '../../core/types/role_id.dart';
import '../../core/widgets/widgets.dart';

/// Headmaster dashboard — 11 pages.
class HeadmasterDashboard extends StatelessWidget {
  final String pageKey;

  const HeadmasterDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview':
        return _OverviewPage();
      case 'oversight':
        return _OversightPage();
      case 'staff':
        return _StaffPage();
      case 'approvals':
        return _ApprovalsPage();
      case 'reports':
        return _ReportsPage();
      case 'communication':
        return _CommunicationPage();
      case 'discipline':
        return _DisciplinePage();
      case 'users':
        return _UsersPage();
      case 'access':
        return _AccessPage();
      case 'menu':
        return _MenuPage();
      case 'sync':
        return _SyncPage();
      default:
        return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

// ── Helpers ──

Widget _pageTitle(String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      ],
    ),
  );
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
    child: Text(title, style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.w600, color: AppColors.text)),
  );
}

Widget _statusChip(String status) {
  final color = status == 'completed' || status == 'active' || status == 'Approved' || status == 'Healthy'
      ? AppColors.success
      : status == 'inProgress' || status == 'onLeave' || status == 'pending' || status == 'Suspended'
          ? AppColors.warning
          : status == 'Locked' || status == 'overdue'
              ? AppColors.danger
              : AppColors.textLight;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(status, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
  );
}

Widget _severityChip(String severity) {
  final color = severity == 'critical' || severity == 'Critical'
      ? AppColors.danger
      : severity == 'serious' || severity == 'Serious' || severity == 'Moderate'
          ? AppColors.warning
          : AppColors.info;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(severity, style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.white, fontWeight: FontWeight.w600)),
  );
}

Widget _priorityChip(String priority) {
  final color = priority == 'urgent' ? AppColors.danger : priority == 'important' ? AppColors.warning : AppColors.info;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(priority, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
  );
}

Widget _addButton(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Text(label, style: const TextStyle(color: AppColors.white, fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _actionButton(String label, Color bg, Color textColor, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: textColor, fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _miniButton(String label, {bool danger = false, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: danger ? AppColors.danger : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: danger ? AppColors.danger : AppColors.border),
      ),
      child: Text(label, style: TextStyle(fontSize: AppFontSize.xs, color: danger ? AppColors.white : AppColors.text, fontWeight: FontWeight.w500)),
    ),
  );
}

// ── Constants (mirrors RN HeadmasterDashboard.tsx) ──

const List<String> _kApprovalCategories = ['Budget Revision', 'Procurement', 'Discipline Escalation', 'Policy Change', 'Other'];
const List<BroadcastAudience> _kBroadcastAudiences = BroadcastAudience.values;
const List<BroadcastPriority> _kBroadcastPriorities = BroadcastPriority.values;
const List<DisciplineSeverity> _kDisciplineSeverities = DisciplineSeverity.values;
const List<String> _kHouses = ['Aggrey', 'Mensah', 'Sarbah', 'Danquah'];
const List<String> _kUserStatuses = ['Active', 'Suspended', 'Locked', 'Inactive'];

final List<(RoleId, String)> _kAllRoles = [
  (RoleId.headmaster, 'Headmaster'),
  (RoleId.asstHeadmasterAcademic, 'Asst. Headmaster (Academic)'),
  (RoleId.asstHeadmasterAdmin, 'Asst. Headmaster (Admin)'),
  (RoleId.asstHeadmasterDomestic, 'Asst. Headmaster (Domestic)'),
  (RoleId.teacher, 'Teacher'),
  (RoleId.subjectHod, 'Subject HOD'),
  (RoleId.seniorHousemaster, 'Senior Housemaster'),
  (RoleId.seniorHousemistress, 'Senior Housemistress'),
  (RoleId.housemaster, 'Housemaster'),
  (RoleId.housemistress, 'Housemistress'),
  (RoleId.bursary, 'Bursary'),
  (RoleId.accountant, 'Accountant'),
  (RoleId.stores, 'Stores'),
  (RoleId.registry, 'Registry'),
  (RoleId.security, 'Security'),
  (RoleId.catering, 'Catering'),
  (RoleId.health, 'Health Centre'),
  (RoleId.transport, 'Transport'),
  (RoleId.cleaning, 'Cleaning'),
  (RoleId.libraryIct, 'Library & ICT'),
  (RoleId.sportsClubs, 'Sports & Clubs'),
  (RoleId.counselling, 'Counselling'),
  (RoleId.plc, 'PLC'),
  (RoleId.staff, 'General Staff'),
  (RoleId.student, 'Student'),
  (RoleId.parent, 'Parent'),
  (RoleId.systemAdmin, 'System Admin'),
];

List<({String label, List<DashboardDef> dashboards})> get _kDashboardCategories => [
  (label: 'Leadership & Administration', dashboards: dashboardCatalog.where((d) => ['Headmaster', 'Academic', 'Admin', 'Domestic', 'GoverningBoard', 'SystemAdmin', 'AcademicBoard', 'InternalAuditor', 'HeadmasterSecretary'].contains(d.key)).toList()),
  (label: 'Finance', dashboards: dashboardCatalog.where((d) => ['Bursary', 'Accountant', 'Stores'].contains(d.key)).toList()),
  (label: 'Academic & Teaching', dashboards: dashboardCatalog.where((d) => ['Teacher', 'SubjectHOD', 'PLC', 'Student', 'ExamCommittee'].contains(d.key)).toList()),
  (label: 'Student Welfare & Services', dashboards: dashboardCatalog.where((d) => ['Health', 'Counselling', 'Catering', 'Cleaning', 'Transport', 'Security', 'LibraryICT', 'SportsClubs', 'Chaplain', 'DiningHall', 'SafeSpace'].contains(d.key)).toList()),
  (label: 'Boarding & Houses', dashboards: dashboardCatalog.where((d) => ['House', 'SeniorHousemaster'].contains(d.key)).toList()),
  (label: 'Records & Registry', dashboards: dashboardCatalog.where((d) => ['Registry'].contains(d.key)).toList()),
  (label: 'Community & Engagement', dashboards: dashboardCatalog.where((d) => ['Parent', 'PTA', 'SRC', 'ElectoralCommission', 'WelfareCommittee', 'Staff'].contains(d.key)).toList()),
];

// ── Modal helpers ──

Widget _chip(String label, bool selected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      margin: const EdgeInsets.only(right: AppSpacing.xs, bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: selected ? AppColors.primary : AppColors.border),
      ),
      child: Text(label, style: TextStyle(
        fontSize: AppFontSize.xs,
        color: selected ? AppColors.white : AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      )),
    ),
  );
}

Widget _chipWrap(List<Widget> chips) {
  return Wrap(children: chips);
}

Widget _inputLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
    child: Text(label, style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
  );
}

Widget _textInput(TextEditingController controller, {String? hint, int maxLines = 1}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textLight, fontSize: AppFontSize.sm),
      filled: true,
      fillColor: AppColors.surfaceAlt,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
    ),
    style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text),
  );
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
  ));
}

Future<void> _showFormDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required String actionLabel,
  required VoidCallback onAction,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(child: content),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () { onAction(); Navigator.pop(ctx); }, child: Text(actionLabel)),
      ],
    ),
  );
}

Future<bool?> _showConfirmDialog(BuildContext context, String title, String message, {String confirmLabel = 'Confirm', bool danger = false}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold)),
      content: Text(message, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: AppColors.danger) : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

// ── Executive Overview ──

class _OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registry = context.watch<RegistryProvider>();
    final bursary = context.watch<BursaryProvider>();
    final sysAdmin = context.watch<SystemAdminProvider>();
    final notif = context.watch<NotificationProvider>();
    final hm = context.watch<HeadmasterProvider>();
    final staff = context.watch<StaffProvider>();

    final totalCollected = bursary.totalCollected;
    final totalOutstanding = bursary.totalOutstanding;
    final feeRate = totalCollected + totalOutstanding > 0
        ? ((totalCollected / (totalCollected + totalOutstanding)) * 100).round()
        : 0;
    final openDiscipline = hm.disciplineCases.where((d) => d.status != DisciplineStatus.resolved).length;
    final pendingAdmissions = registry.pendingAdmissions;
    final pendingHmApprovals = hm.getPendingApprovals();
    final pendingLeave = staff.pendingLeave;
    final totalPending = pendingHmApprovals.length + pendingLeave;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('Executive Overview', 'Live snapshot of the entire school'),
        StatCardGrid(cards: [
          StatCard(label: 'Total Enrollment', value: '${registry.activeStudentCount}', icon: Icons.school, color: AppColors.primary),
          StatCard(label: 'Staff Count', value: '${registry.staff.length}', icon: Icons.badge, color: AppColors.primaryLight),
          StatCard(label: 'Fee Collection', value: '$feeRate%', icon: Icons.trending_up, color: AppColors.accent),
          StatCard(label: 'Pending Approvals', value: '$totalPending', icon: Icons.inbox, color: AppColors.warning),
          StatCard(label: 'Open Discipline Cases', value: '$openDiscipline', icon: Icons.gavel, color: AppColors.danger),
          StatCard(label: 'Pending Admissions', value: '$pendingAdmissions', icon: Icons.pending_actions, color: AppColors.info),
        ]),
        _sectionTitle('Awaiting Your Approval'),
        if (totalPending == 0)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: const Text('No pending approvals. All caught up.', style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
          )
        else ...[
          ...staff.leaveRequests.where((l) => l.status == 'Pending').take(3).map((l) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Text('Leave Request — ${l.staffName} (${l.type})', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
            ),
          )),
          ...pendingHmApprovals.take(3).map((a) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Text('${a.category} — ${a.requester}', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
            ),
          )),
        ],
        _sectionTitle('Key Metrics'),
        SectionCard(
          title: 'Financial Summary',
          child: Column(children: [
            _metricRow('Fees Collected', 'GH₵${totalCollected.toStringAsFixed(0)}'),
            _metricRow('Outstanding Fees', 'GH₵${totalOutstanding.toStringAsFixed(0)}'),
            _metricRow('Budget Allocated', 'GH₵${bursary.totalBudgetAllocated.toStringAsFixed(0)}'),
            _metricRow('Budget Spent', 'GH₵${bursary.totalBudgetSpent.toStringAsFixed(0)}'),
            _metricRow('Overdue Invoices', '${bursary.overdueInvoiceCount}'),
          ]),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'System & Notifications',
          child: Column(children: [
            _metricRow('System Users', '${sysAdmin.users.length}'),
            _metricRow('DB Status', sysAdmin.dbHealth.status),
            _metricRow('Unread Notifications', '${notif.unreadCount}'),
          ]),
        ),
        _sectionTitle('Recent Notifications'),
        SectionCard(
          title: 'Latest Alerts',
          child: Column(
            children: notif.notifications.take(5).map((n) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                n.type == 'warning' ? Icons.warning_amber : Icons.info_outline,
                color: n.type == 'warning' ? AppColors.warning : AppColors.info,
                size: 20,
              ),
              title: Text(n.title, style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
              subtitle: Text(n.message, style: const TextStyle(fontSize: AppFontSize.xs)),
              trailing: n.read ? null : Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
        ],
      ),
    );
  }
}

// ── School-Wide Oversight ──

class _OversightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registry = context.watch<RegistryProvider>();
    final bursary = context.watch<BursaryProvider>();
    final hm = context.watch<HeadmasterProvider>();
    final sysAdmin = context.watch<SystemAdminProvider>();
    final academic = context.watch<AcademicProvider>();
    final staff = context.watch<StaffProvider>();

    final totalCollected = bursary.totalCollected;
    final totalOutstanding = bursary.totalOutstanding;
    final feeRate = totalCollected + totalOutstanding > 0
        ? ((totalCollected / (totalCollected + totalOutstanding)) * 100).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('School-Wide Oversight', 'Cross-department control center — monitor every unit of the school'),
        _sectionTitle('Academics & Admissions (Registry)'),
        StatCardGrid(cards: [
          StatCard(label: 'Total Students', value: '${registry.students.length}', icon: Icons.school, color: AppColors.primary),
          StatCard(label: 'Admissions Pending', value: '${registry.pendingAdmissions}', icon: Icons.pending_actions, color: AppColors.warning),
          StatCard(label: 'Admissions Approved', value: '${registry.admissions.where((a) => a.status == AdmissionStatus.approved).length}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        _sectionTitle('Human Resources (Staff)'),
        StatCardGrid(cards: [
          StatCard(label: 'Total Staff', value: '${staff.directory.length}', icon: Icons.badge, color: AppColors.primary),
          StatCard(label: 'On Leave', value: '${staff.directory.where((d) => d.status == 'On Leave').length}', icon: Icons.beach_access, color: AppColors.info),
          StatCard(label: 'Pending Leave', value: '${staff.pendingLeave}', icon: Icons.inbox, color: AppColors.warning),
        ]),
        _sectionTitle('Finance (Bursary)'),
        StatCardGrid(cards: [
          StatCard(label: 'Total Collected', value: 'GH₵${totalCollected.toStringAsFixed(0)}', icon: Icons.payments, color: AppColors.success),
          StatCard(label: 'Outstanding', value: 'GH₵${totalOutstanding.toStringAsFixed(0)}', icon: Icons.money_off, color: AppColors.danger),
          StatCard(label: 'Collection Rate', value: '$feeRate%', icon: Icons.trending_up, color: AppColors.accent),
        ]),
        _sectionTitle('System & IT Health'),
        StatCardGrid(cards: [
          StatCard(label: 'DB Status', value: sysAdmin.dbHealth.status, icon: Icons.storage, color: sysAdmin.dbHealth.status == 'Healthy' ? AppColors.success : AppColors.warning),
          StatCard(label: 'System Users', value: '${sysAdmin.users.length}', icon: Icons.people, color: AppColors.info),
          StatCard(label: 'Pending Syncs', value: '${sysAdmin.dbHealth.pendingChanges}', icon: Icons.sync, color: sysAdmin.dbHealth.pendingChanges > 0 ? AppColors.warning : AppColors.success),
        ]),
        _sectionTitle('Discipline & Welfare'),
        StatCardGrid(cards: [
          StatCard(label: 'Open Cases', value: '${hm.disciplineCases.where((d) => d.status == DisciplineStatus.open).length}', icon: Icons.gavel, color: AppColors.warning),
          StatCard(label: 'Escalated', value: '${hm.disciplineCases.where((d) => d.status == DisciplineStatus.escalated).length}', icon: Icons.priority_high, color: AppColors.danger),
          StatCard(label: 'Resolved', value: '${hm.disciplineCases.where((d) => d.status == DisciplineStatus.resolved).length}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        _sectionTitle('Enrollment by Programme'),
        SectionCard(
          title: 'Student Distribution',
          child: Column(children: [
            _enrollmentRow('Science', registry.students.where((s) => s.programme == Programme.science && s.status == StudentStatus.active).length, registry.activeStudentCount),
            _enrollmentRow('Arts', registry.students.where((s) => s.programme == Programme.arts && s.status == StudentStatus.active).length, registry.activeStudentCount),
            _enrollmentRow('Business', registry.students.where((s) => s.programme == Programme.business && s.status == StudentStatus.active).length, registry.activeStudentCount),
          ]),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Curriculum Coverage',
          child: AppDataTable(
            columns: ['Subject', 'Class', 'Coverage', 'Status'],
            rows: academic.curriculum.map((c) => [
              Text(c.subject),
              Text(c.classForm),
              Text('${c.coveragePct.toStringAsFixed(1)}%'),
              _statusChip(c.status.name),
            ]).toList(),
          ),
        ),
      ],
    );
  }

  Widget _enrollmentRow(String programme, int count, int total) {
    final pct = total > 0 ? (count / total * 100).round() : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(programme, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
              Text('$count ($pct%)', style: const TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: total > 0 ? count / total : 0, minHeight: 6, backgroundColor: AppColors.surfaceAlt, color: AppColors.primaryLight),
        ],
      ),
    );
  }
}

// ── Staff Directory & Appraisal ──

class _StaffPage extends StatefulWidget {
  @override
  State<_StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<_StaffPage> {
  final _nameCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();
  final _departmentCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose(); _positionCtrl.dispose(); _departmentCtrl.dispose();
    _phoneCtrl.dispose(); _emailCtrl.dispose();
    super.dispose();
  }

  void _showAddStaffModal() {
    _nameCtrl.clear(); _positionCtrl.clear(); _departmentCtrl.clear();
    _phoneCtrl.clear(); _emailCtrl.clear();
    _showFormDialog(
      context: context,
      title: 'Add Staff Member',
      actionLabel: 'Add Staff',
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _inputLabel('Name'), _textInput(_nameCtrl, hint: 'Full name'),
        _inputLabel('Position'), _textInput(_positionCtrl, hint: 'e.g. Senior Teacher'),
        _inputLabel('Department'), _textInput(_departmentCtrl, hint: 'e.g. Mathematics'),
        _inputLabel('Phone'), _textInput(_phoneCtrl, hint: 'Phone number'),
        _inputLabel('Email'), _textInput(_emailCtrl, hint: 'Email address'),
      ]),
      onAction: () {
        if (_nameCtrl.text.trim().isEmpty || _positionCtrl.text.trim().isEmpty) {
          _showSnackBar(context, 'Name and position are required.');
          return;
        }
        final staff = context.read<StaffProvider>();
        staff.directory.insert(0, StaffDirectoryEntry(
          name: _nameCtrl.text.trim(),
          position: _positionCtrl.text.trim(),
          department: _departmentCtrl.text.trim().isEmpty ? 'General' : _departmentCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
        ));
        _showSnackBar(context, 'Staff member added to directory.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final staff = context.watch<StaffProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pageTitle('Staff Directory & Appraisal', 'Full staff roster across all departments'),
            _addButton('+ Add Staff', _showAddStaffModal),
          ],
        ),
        StatCardGrid(cards: [
          StatCard(label: 'Total Staff', value: '${staff.directory.length}', icon: Icons.badge, color: AppColors.primary),
          StatCard(label: 'Active', value: '${staff.directory.where((d) => d.status == 'Active').length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Pending Leave', value: '${staff.pendingLeave}', icon: Icons.beach_access, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Staff Directory',
          child: AppDataTable(
            columns: ['Name', 'Position', 'Department', 'Status'],
            rows: staff.directory.map((s) => [
              Text(s.name),
              Text(s.position),
              Text(s.department),
              _statusChip(s.status),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Approvals Inbox ──

class _ApprovalsPage extends StatefulWidget {
  @override
  State<_ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<_ApprovalsPage> {
  String _approvalCategory = 'Other';
  final _requesterCtrl = TextEditingController();
  final _departmentCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();

  @override
  void dispose() {
    _requesterCtrl.dispose(); _departmentCtrl.dispose(); _detailsCtrl.dispose();
    super.dispose();
  }

  void _showAddApprovalModal() {
    _approvalCategory = 'Other';
    _requesterCtrl.clear(); _departmentCtrl.clear(); _detailsCtrl.clear();
    _showFormDialog(
      context: context,
      title: 'Log Approval Request',
      actionLabel: 'Log Request',
      content: StatefulBuilder(builder: (ctx, setState) => Column(mainAxisSize: MainAxisSize.min, children: [
        _inputLabel('Category'),
        _chipWrap(_kApprovalCategories.map((c) => _chip(c, _approvalCategory == c, () => setState(() => _approvalCategory = c))).toList()),
        _inputLabel('Requester'), _textInput(_requesterCtrl, hint: 'e.g. Bursary'),
        _inputLabel('Department'), _textInput(_departmentCtrl, hint: 'e.g. Bursary'),
        _inputLabel('Details'), _textInput(_detailsCtrl, hint: 'Describe the request', maxLines: 3),
      ])),
      onAction: () {
        if (_requesterCtrl.text.trim().isEmpty || _detailsCtrl.text.trim().isEmpty) {
          _showSnackBar(context, 'Requester and details are required.');
          return;
        }
        final hm = context.read<HeadmasterProvider>();
        hm.addApproval(
          category: _approvalCategory,
          requester: _requesterCtrl.text.trim(),
          department: _departmentCtrl.text.trim().isEmpty ? 'General' : _departmentCtrl.text.trim(),
          details: _detailsCtrl.text.trim(),
        );
        _showSnackBar(context, 'Approval request logged.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    final staff = context.watch<StaffProvider>();
    final hm = context.watch<HeadmasterProvider>();
    final pendingHm = hm.getPendingApprovals();
    final pendingLeave = staff.leaveRequests.where((l) => l.status == 'Pending').toList();
    final totalPending = pendingHm.length + pendingLeave.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pageTitle('Approvals Inbox', 'Pending requests from all departments'),
            _addButton('+ Log Approval', _showAddApprovalModal),
          ],
        ),
        StatCardGrid(cards: [
          StatCard(label: 'Total Pending', value: '$totalPending', icon: Icons.inbox, color: AppColors.warning),
          StatCard(label: 'HM Approvals', value: '${pendingHm.length}', icon: Icons.approval, color: AppColors.primary),
          StatCard(label: 'Leave Requests', value: '${pendingLeave.length}', icon: Icons.beach_access, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Pending Leave Requests'),
        if (pendingLeave.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: const Text('No pending leave requests.', style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
          )
        else
          ...pendingLeave.map((l) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Leave Request (${l.type})', style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                      Text(l.dateSubmitted, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textLight)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('${l.staffName} — ${l.staffRole}', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text(l.reason, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('${l.startDate} to ${l.endDate} (${l.days} days)', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _actionButton('Approve', AppColors.success, AppColors.white, () {
                        context.read<StaffProvider>().reviewLeave(l.id, 'Approved', 'Headmaster', '');
                        _showSnackBar(context, 'Leave request for ${l.staffName} approved.');
                      }),
                      const SizedBox(width: AppSpacing.sm),
                      _actionButton('Reject', AppColors.surface, AppColors.danger, () {
                        context.read<StaffProvider>().reviewLeave(l.id, 'Rejected', 'Headmaster', '');
                        _showSnackBar(context, 'Leave request for ${l.staffName} rejected.');
                      }),
                    ],
                  ),
                ],
              ),
            ),
          )),
        _sectionTitle('Headmaster Approvals'),
        if (pendingHm.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: const Text('No pending approvals. All caught up.', style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
          )
        else
          ...pendingHm.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(a.category, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                      Text(a.date, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textLight)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('${a.requester} — ${a.department}', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(a.details, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _actionButton('Approve', AppColors.success, AppColors.white, () {
                        context.read<HeadmasterProvider>().reviewApproval(a.id, HmApprovalStatus.approved, 'Headmaster');
                        _showSnackBar(context, '${a.category} request approved.');
                      }),
                      const SizedBox(width: AppSpacing.sm),
                      _actionButton('Reject', AppColors.surface, AppColors.danger, () {
                        context.read<HeadmasterProvider>().reviewApproval(a.id, HmApprovalStatus.rejected, 'Headmaster');
                        _showSnackBar(context, '${a.category} request rejected.');
                      }),
                    ],
                  ),
                ],
              ),
            ),
          )),
        _sectionTitle('HOD Approvals'),
        ...academic.hodApprovals.where((a) => a.status == HodApprovalStatus.pending).map((a) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(a.type, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                    Text(a.date, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('${a.from} — ${a.department}', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.xs),
                Text(a.detail, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _actionButton('Approve', AppColors.success, AppColors.white, () {
                      context.read<AcademicProvider>().reviewHodApproval(a.id, HodApprovalStatus.approved);
                      _showSnackBar(context, '${a.type} approved.');
                    }),
                    const SizedBox(width: AppSpacing.sm),
                    _actionButton('Reject', AppColors.surface, AppColors.danger, () {
                      context.read<AcademicProvider>().reviewHodApproval(a.id, HodApprovalStatus.rejected);
                      _showSnackBar(context, '${a.type} rejected.');
                    }),
                  ],
                ),
              ],
            ),
          ),
        )).toList(),
      ],
    );
  }
}

// ── Reports & Analytics ──

class _ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bursary = context.watch<BursaryProvider>();

    final reports = [
      'Academic Performance Report',
      'Financial Summary',
      'Attendance Report',
      'Welfare Report',
      'Boarding Operations Report',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('Reports & Analytics', 'Generate termly/annual reports'),
        StatCardGrid(cards: [
          StatCard(label: 'Total Collected', value: 'GH₵${bursary.totalCollected.toStringAsFixed(0)}', icon: Icons.trending_up, color: AppColors.success),
          StatCard(label: 'Total Expenditure', value: 'GH₵${bursary.totalExpenditure.toStringAsFixed(0)}', icon: Icons.trending_down, color: AppColors.danger),
          StatCard(label: 'Net', value: 'GH₵${(bursary.totalCollected - bursary.totalExpenditure).toStringAsFixed(0)}', icon: Icons.account_balance, color: AppColors.primaryLight),
          StatCard(label: 'Budget Remaining', value: 'GH₵${bursary.totalBudgetRemaining.toStringAsFixed(0)}', icon: Icons.savings, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Available Reports'),
        ...reports.map((report) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(report, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w500, color: AppColors.text)),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Text('Generate (PDF)', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.picture_as_pdf, size: 18, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Budget by Department',
          child: AppDataTable(
            columns: ['Department', 'Allocated', 'Spent', 'Remaining'],
            rows: bursary.budgetItems.map((b) => [
              Text(b.department),
              Text('GH₵${b.allocated.toStringAsFixed(0)}'),
              Text('GH₵${b.spent.toStringAsFixed(0)}'),
              Text('GH₵${b.remaining.toStringAsFixed(0)}'),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Communication ──

class _CommunicationPage extends StatefulWidget {
  @override
  State<_CommunicationPage> createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<_CommunicationPage> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  BroadcastAudience _audience = BroadcastAudience.everyone;
  BroadcastPriority _priority = BroadcastPriority.normal;

  @override
  void dispose() {
    _titleCtrl.dispose(); _bodyCtrl.dispose();
    super.dispose();
  }

  void _showBroadcastModal() {
    _titleCtrl.clear(); _bodyCtrl.clear();
    _audience = BroadcastAudience.everyone;
    _priority = BroadcastPriority.normal;
    _showFormDialog(
      context: context,
      title: 'Compose New Broadcast',
      actionLabel: 'Send Broadcast',
      content: StatefulBuilder(builder: (ctx, setState) => Column(mainAxisSize: MainAxisSize.min, children: [
        _inputLabel('Title'), _textInput(_titleCtrl, hint: 'Broadcast title'),
        _inputLabel('Message'), _textInput(_bodyCtrl, hint: 'Message body', maxLines: 3),
        _inputLabel('Audience'),
        _chipWrap(_kBroadcastAudiences.map((a) => _chip(a.label, _audience == a, () => setState(() => _audience = a))).toList()),
        _inputLabel('Priority'),
        _chipWrap(_kBroadcastPriorities.map((p) => _chip(p.label, _priority == p, () => setState(() => _priority = p))).toList()),
      ])),
      onAction: () {
        if (_titleCtrl.text.trim().isEmpty || _bodyCtrl.text.trim().isEmpty) {
          _showSnackBar(context, 'Title and message body are required.');
          return;
        }
        context.read<HeadmasterProvider>().addBroadcast(
          title: _titleCtrl.text.trim(),
          body: _bodyCtrl.text.trim(),
          audience: _audience,
          priority: _priority,
          postedBy: 'Headmaster',
        );
        _showSnackBar(context, 'Broadcast sent successfully.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hm = context.watch<HeadmasterProvider>();
    final registry = context.read<RegistryProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pageTitle('Communication', 'Broadcast messages to staff, students, or parents'),
            _addButton('+ Compose Broadcast', _showBroadcastModal),
          ],
        ),
        _sectionTitle('Active Broadcasts'),
        ...hm.broadcasts.map((msg) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(msg.title, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text))),
                    _priorityChip(msg.priority.label),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(msg.body, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.xs),
                Text('Sent to: ${msg.audience.label} | ${msg.date} | ${msg.postedBy}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              ],
            ),
          ),
        )),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Correspondence Log'),
        SectionCard(
          title: 'All Correspondence',
          child: AppDataTable(
            columns: ['Date', 'Direction', 'Subject', 'Priority'],
            rows: registry.correspondence.map((c) => [
              Text(c.date),
              Text(c.direction.name),
              Text(c.subject),
              _priorityChip(c.priority.name),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Discipline Case Log ──

class _DisciplinePage extends StatefulWidget {
  @override
  State<_DisciplinePage> createState() => _DisciplinePageState();
}

class _DisciplinePageState extends State<_DisciplinePage> {
  final _studentCtrl = TextEditingController();
  final _incidentCtrl = TextEditingController();
  String _house = _kHouses[0];
  DisciplineSeverity _severity = DisciplineSeverity.minor;
  final _resolutionCtrl = TextEditingController();

  @override
  void dispose() {
    _studentCtrl.dispose(); _incidentCtrl.dispose(); _resolutionCtrl.dispose();
    super.dispose();
  }

  void _showAddDisciplineModal() {
    _studentCtrl.clear(); _incidentCtrl.clear();
    _house = _kHouses[0];
    _severity = DisciplineSeverity.minor;
    _showFormDialog(
      context: context,
      title: 'Log Discipline Case',
      actionLabel: 'Log Case',
      content: StatefulBuilder(builder: (ctx, setState) => Column(mainAxisSize: MainAxisSize.min, children: [
        _inputLabel('Student Name'), _textInput(_studentCtrl, hint: 'Student full name'),
        _inputLabel('House'),
        _chipWrap(_kHouses.map((h) => _chip(h, _house == h, () => setState(() => _house = h))).toList()),
        _inputLabel('Incident'), _textInput(_incidentCtrl, hint: 'Describe the incident', maxLines: 3),
        _inputLabel('Severity'),
        _chipWrap(_kDisciplineSeverities.map((s) => _chip(s.label, _severity == s, () => setState(() => _severity = s))).toList()),
      ])),
      onAction: () {
        if (_studentCtrl.text.trim().isEmpty || _incidentCtrl.text.trim().isEmpty) {
          _showSnackBar(context, 'Student name and incident are required.');
          return;
        }
        context.read<HeadmasterProvider>().addDisciplineCase(
          student: _studentCtrl.text.trim(),
          house: _house,
          incident: _incidentCtrl.text.trim(),
          severity: _severity,
          reportedBy: 'Headmaster',
        );
        _showSnackBar(context, 'Discipline case logged.');
      },
    );
  }

  void _showResolveModal(String caseId) {
    _resolutionCtrl.clear();
    _showFormDialog(
      context: context,
      title: 'Resolve Discipline Case',
      actionLabel: 'Mark Resolved',
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _inputLabel('Resolution Notes'),
        _textInput(_resolutionCtrl, hint: 'Describe how this case was resolved', maxLines: 3),
      ]),
      onAction: () {
        context.read<HeadmasterProvider>().resolveDisciplineCase(caseId, _resolutionCtrl.text.trim());
        _showSnackBar(context, 'Discipline case resolved.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hm = context.watch<HeadmasterProvider>();
    final cases = hm.disciplineCases;
    final escalated = cases.where((d) => d.status == DisciplineStatus.escalated).toList();
    final open = cases.where((d) => d.status == DisciplineStatus.open).toList();
    final resolved = cases.where((d) => d.status == DisciplineStatus.resolved).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pageTitle('Discipline Case Log', 'Serious matters escalated from Counselling & Boarding'),
            _addButton('+ Log Case', _showAddDisciplineModal),
          ],
        ),
        StatCardGrid(cards: [
          StatCard(label: 'Total Cases', value: '${cases.length}', icon: Icons.gavel, color: AppColors.primaryLight),
          StatCard(label: 'Open', value: '${open.length}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Escalated', value: '${escalated.length}', icon: Icons.priority_high, color: AppColors.danger),
          StatCard(label: 'Resolved', value: '${resolved.length}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('All Cases'),
        ...cases.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.student, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                    _severityChip(item.severity.label),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Incident: ${item.incident}', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
                const SizedBox(height: 4),
                Text('House: ${item.house}  |  Date: ${item.date}  |  Status: ${item.status.label}', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Reported by: ${item.reportedBy}', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                if (item.resolutionNotes != null && item.resolutionNotes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Resolution: ${item.resolutionNotes}', style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.success)),
                ],
                if (item.status != DisciplineStatus.resolved) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      if (item.status != DisciplineStatus.escalated) ...[
                        _actionButton('Escalate', AppColors.surface, AppColors.danger, () {
                          context.read<HeadmasterProvider>().escalateDisciplineCase(item.id);
                          _showSnackBar(context, 'Case escalated.');
                        }),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      _actionButton('Resolve', AppColors.success, AppColors.white, () => _showResolveModal(item.id)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        )),
      ],
    );
  }
}

// ── User Management ──

class _UsersPage extends StatefulWidget {
  @override
  State<_UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<_UsersPage> {
  final _usernameCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String _userStatus = 'Active';
  List<String> _selectedRoles = [];
  SystemUser? _editingUser;
  List<String> _roleDraft = [];

  @override
  void dispose() {
    _usernameCtrl.dispose(); _displayNameCtrl.dispose(); _emailCtrl.dispose();
    super.dispose();
  }

  void _showAddUserModal() {
    _usernameCtrl.clear(); _displayNameCtrl.clear(); _emailCtrl.clear();
    _userStatus = 'Active';
    _selectedRoles = [];
    _showFormDialog(
      context: context,
      title: 'Create New User Account',
      actionLabel: 'Create User',
      content: StatefulBuilder(builder: (ctx, setState) => Column(mainAxisSize: MainAxisSize.min, children: [
        _inputLabel('Username'), _textInput(_usernameCtrl, hint: 'e.g. jmensah'),
        _inputLabel('Display Name'), _textInput(_displayNameCtrl, hint: 'e.g. John Mensah'),
        _inputLabel('Email'), _textInput(_emailCtrl, hint: 'e.g. jmensah@sims.edu'),
        _inputLabel('Status'),
        _chipWrap(_kUserStatuses.map((s) => _chip(s, _userStatus == s, () => setState(() => _userStatus = s))).toList()),
        _inputLabel('Roles (select one or more)'),
        _chipWrap(_kAllRoles.map((r) => _chip(r.$2, _selectedRoles.contains(r.$1.value), () {
          setState(() {
            if (_selectedRoles.contains(r.$1.value)) {
              _selectedRoles.remove(r.$1.value);
            } else {
              _selectedRoles.add(r.$1.value);
            }
          });
        })).toList()),
      ])),
      onAction: () {
        if (_usernameCtrl.text.trim().isEmpty || _displayNameCtrl.text.trim().isEmpty) {
          _showSnackBar(context, 'Username and display name are required.');
          return;
        }
        if (_selectedRoles.isEmpty) {
          _showSnackBar(context, 'At least one role must be assigned.');
          return;
        }
        context.read<SystemAdminProvider>().addUser(
          username: _usernameCtrl.text.trim(),
          displayName: _displayNameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          roles: _selectedRoles,
          status: _userStatus,
        );
        _showSnackBar(context, 'User account created.');
      },
    );
  }

  void _showEditRolesModal(SystemUser user) {
    _editingUser = user;
    _roleDraft = List.from(user.roles);
    _showFormDialog(
      context: context,
      title: 'Edit Roles — ${user.displayName}',
      actionLabel: 'Save Roles',
      content: StatefulBuilder(builder: (ctx, setState) => Column(mainAxisSize: MainAxisSize.min, children: [
        _inputLabel('Assigned Roles'),
        _chipWrap(_kAllRoles.map((r) => _chip(r.$2, _roleDraft.contains(r.$1.value), () {
          setState(() {
            if (_roleDraft.contains(r.$1.value)) {
              _roleDraft.remove(r.$1.value);
            } else {
              _roleDraft.add(r.$1.value);
            }
          });
        })).toList()),
      ])),
      onAction: () {
        if (_editingUser != null) {
          context.read<SystemAdminProvider>().updateUserRoles(_editingUser!.id, _roleDraft);
          _showSnackBar(context, 'Roles updated for ${_editingUser!.displayName}.');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sysAdmin = context.watch<SystemAdminProvider>();
    final users = sysAdmin.users;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pageTitle('User Management', 'Create and manage all system user accounts'),
            _addButton('+ Add User', _showAddUserModal),
          ],
        ),
        StatCardGrid(cards: [
          StatCard(label: 'Total Users', value: '${users.length}', icon: Icons.people, color: AppColors.primaryLight),
          StatCard(label: 'Active', value: '${users.where((u) => u.status == 'Active').length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Suspended', value: '${users.where((u) => u.status == 'Suspended').length}', icon: Icons.block, color: AppColors.warning),
          StatCard(label: 'Locked', value: '${users.where((u) => u.status == 'Locked').length}', icon: Icons.lock, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'User Accounts',
          child: AppDataTable(
            columns: ['Name', 'Username', 'Roles', 'Status', 'Last Login'],
            rows: users.map((u) => [
              Text(u.displayName),
              Text(u.username),
              Text(u.roles.map((r) => _kAllRoles.firstWhere((ar) => ar.$1.value == r, orElse: (() => (RoleId.voter, r))).$2).join(', ')),
              _statusChip(u.status),
              Text(u.lastLogin ?? 'Never'),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('User Actions'),
        ...users.map((u) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.displayName, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                      Text('${u.username} — ${u.status}${u.failedAttempts > 0 ? ' (${u.failedAttempts} failed attempts)' : ''}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 4,
                  children: [
                    _miniButton('Roles', onTap: () => _showEditRolesModal(u)),
                    if (u.status == 'Locked')
                      _miniButton('Unlock', onTap: () {
                        context.read<SystemAdminProvider>().unlockUser(u.id);
                        _showSnackBar(context, '${u.displayName} has been unlocked.');
                      }),
                    if (u.status == 'Suspended')
                      _miniButton('Activate', onTap: () {
                        context.read<SystemAdminProvider>().updateUserStatus(u.id, 'Active');
                        _showSnackBar(context, '${u.displayName} reactivated.');
                      })
                    else if (u.status == 'Active')
                      _miniButton('Suspend', danger: true, onTap: () {
                        context.read<SystemAdminProvider>().updateUserStatus(u.id, 'Suspended');
                        _showSnackBar(context, '${u.displayName} suspended.');
                      }),
                    _miniButton('Reset PW', onTap: () {
                        context.read<SystemAdminProvider>().resetUserPassword(u.id);
                        _showSnackBar(context, 'Password reset link sent to ${u.displayName}.');
                      }),
                    _miniButton('Delete', danger: true, onTap: () async {
                      final confirmed = await _showConfirmDialog(
                        context, 'Delete User',
                        'Permanently delete ${u.displayName}?',
                        confirmLabel: 'Delete', danger: true,
                      );
                      if (confirmed == true) {
                        context.read<SystemAdminProvider>().deleteUser(u.id);
                        _showSnackBar(context, '${u.displayName} removed.');
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

// ── Access Control ──

class _AccessPage extends StatefulWidget {
  @override
  State<_AccessPage> createState() => _AccessPageState();
}

class _AccessPageState extends State<_AccessPage> {
  final _searchCtrl = TextEditingController();
  String _accessSearch = '';
  String _accessFilter = 'all'; // 'all' | 'full' | 'page'
  String? _selectedAccessUser;

  // Access form state
  String _formUserId = '';
  String _formDashboardKey = '';
  List<String> _formAllowedPages = [];
  bool _formFullAccess = false;
  String? _editingGrantId;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openNewAccessModal() {
    _editingGrantId = null;
    _formUserId = '';
    _formDashboardKey = '';
    _formAllowedPages = [];
    _formFullAccess = false;
    _accessSearch = '';
    _showAccessModal();
  }

  void _openEditAccessModal(String grantId) {
    final access = context.read<AccessControlProvider>();
    final grant = access.grants.firstWhere((g) => g.id == grantId);
    _editingGrantId = grantId;
    _formUserId = grant.userId;
    _formDashboardKey = grant.dashboardKey;
    _formAllowedPages = grant.allowedPages == 'all' ? [] : List<String>.from(grant.allowedPages as List);
    _formFullAccess = grant.allowedPages == 'all';
    _showAccessModal();
  }

  void _showAccessModal() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
        final sysAdmin = context.read<SystemAdminProvider>();
        final accessSearch = _accessSearch;
        return AlertDialog(
          title: Text(_editingGrantId != null ? 'Edit Access Assignment' : 'Assign Dashboard Access', style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: Select User
                  _inputLabel('Step 1 — Select User'),
                  if (_formUserId.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(sysAdmin.users.firstWhere((u) => u.id == _formUserId, orElse: () => sysAdmin.users.first).displayName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
                                Text('@${sysAdmin.users.firstWhere((u) => u.id == _formUserId, orElse: () => sysAdmin.users.first).username}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          if (_editingGrantId == null)
                            GestureDetector(onTap: () => setState(() => _formUserId = ''), child: const Text('Change', style: TextStyle(color: AppColors.primary, fontSize: AppFontSize.sm))),
                        ],
                      ),
                    ),
                  ] else ...[
                    TextField(
                      decoration: const InputDecoration(hintText: 'Search users...', prefixIcon: Icon(Icons.search, size: 18)),
                      onChanged: (v) => setState(() => _accessSearch = v),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...sysAdmin.users.where((u) {
                      if (accessSearch.trim().isEmpty) return true;
                      final q = accessSearch.toLowerCase();
                      return u.displayName.toLowerCase().contains(q) || u.username.toLowerCase().contains(q);
                    }).map((u) => ListTile(
                      dense: true,
                      leading: CircleAvatar(child: Text(u.displayName.isNotEmpty ? u.displayName[0].toUpperCase() : '?')),
                      title: Text(u.displayName, style: const TextStyle(fontSize: AppFontSize.sm)),
                      subtitle: Text('@${u.username}', style: const TextStyle(fontSize: AppFontSize.xs)),
                      trailing: Text(u.status, style: TextStyle(fontSize: AppFontSize.xs, color: u.status == 'Active' ? AppColors.success : AppColors.danger)),
                      onTap: () => setState(() { _formUserId = u.id; _accessSearch = ''; }),
                    )),
                  ],
                  // Step 2: Select Dashboard
                  if (_formUserId.isNotEmpty) ...[
                    _inputLabel('Step 2 — Select Dashboard'),
                    if (_formDashboardKey.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dashboardMap[_formDashboardKey]?.label ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
                                  Text('${dashboardMap[_formDashboardKey]?.pages.length ?? 0} pages available', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            if (_editingGrantId == null)
                              GestureDetector(onTap: () => setState(() { _formDashboardKey = ''; _formAllowedPages = []; }), child: const Text('Change', style: TextStyle(color: AppColors.primary, fontSize: AppFontSize.sm))),
                          ],
                        ),
                      ),
                    ] else ...[
                      ..._kDashboardCategories.map((cat) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cat.label, style: const TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Wrap(children: cat.dashboards.map((d) => _chip(d.label, _formDashboardKey == d.key, () => setState(() { _formDashboardKey = d.key; _formAllowedPages = []; }))).toList()),
                          ],
                        ),
                      )),
                    ],
                  ],
                  // Step 3: Access Scope
                  if (_formDashboardKey.isNotEmpty) ...[
                    _inputLabel('Step 3 — Access Scope'),
                    Row(
                      children: [
                        Expanded(child: GestureDetector(
                          onTap: () => setState(() { _formFullAccess = true; _formAllowedPages = []; }),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            margin: const EdgeInsets.only(right: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: _formFullAccess ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: _formFullAccess ? AppColors.primary : AppColors.border),
                            ),
                            child: Column(children: [
                              const Icon(Icons.dashboard, size: 24, color: AppColors.primary),
                              const SizedBox(height: 4),
                              Text('Full Dashboard', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: _formFullAccess ? AppColors.primary : AppColors.text)),
                              Text('All ${dashboardMap[_formDashboardKey]?.pages.length ?? 0} pages', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                            ]),
                          ),
                        )),
                        Expanded(child: GestureDetector(
                          onTap: () => setState(() => _formFullAccess = false),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: !_formFullAccess ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: !_formFullAccess ? AppColors.primary : AppColors.border),
                            ),
                            child: Column(children: [
                              const Icon(Icons.pages, size: 24, color: AppColors.primary),
                              const SizedBox(height: 4),
                              Text('Specific Pages', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: !_formFullAccess ? AppColors.primary : AppColors.text)),
                              const Text('Choose pages', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                            ]),
                          ),
                        )),
                      ],
                    ),
                    if (!_formFullAccess) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Select Pages', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
                          Row(children: [
                            GestureDetector(onTap: () => setState(() => _formAllowedPages = dashboardMap[_formDashboardKey]?.pages.map((p) => p.key).toList() ?? []), child: const Text('Select All', style: TextStyle(color: AppColors.primary, fontSize: AppFontSize.xs))),
                            const Text('  ·  '),
                            GestureDetector(onTap: () => setState(() => _formAllowedPages = []), child: const Text('Clear', style: TextStyle(color: AppColors.danger, fontSize: AppFontSize.xs))),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ...?dashboardMap[_formDashboardKey]?.pages.map((p) {
                        final isSelected = _formAllowedPages.contains(p.key);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (isSelected) { _formAllowedPages.remove(p.key); } else { _formAllowedPages.add(p.key); }
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                            margin: const EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Row(children: [
                              Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank, size: 18, color: isSelected ? AppColors.primary : AppColors.textLight),
                              const SizedBox(width: AppSpacing.sm),
                              Text(p.label, style: TextStyle(fontSize: AppFontSize.sm, color: isSelected ? AppColors.primary : AppColors.text)),
                            ]),
                          ),
                        );
                      }),
                    ],
                  ],
                  // Summary
                  if (_formUserId.isNotEmpty && _formDashboardKey.isNotEmpty && (_formFullAccess || _formAllowedPages.isNotEmpty) && dashboardMap.containsKey(_formDashboardKey)) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.md)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Assignment Summary', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('User: ${sysAdmin.users.firstWhere((u) => u.id == _formUserId, orElse: () => sysAdmin.users.first).displayName}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                          Text('Dashboard: ${dashboardMap[_formDashboardKey]?.label}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                          Text('Access: ${_formFullAccess ? 'Full Dashboard (${dashboardMap[_formDashboardKey]?.pages.length} pages)' : '${_formAllowedPages.length} page(s)'}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () { Navigator.pop(ctx); _editingGrantId = null; }, child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (_formUserId.isEmpty || _formDashboardKey.isEmpty) {
                  _showSnackBar(context, 'Select a user and a dashboard.');
                  return;
                }
                if (!_formFullAccess && _formAllowedPages.isEmpty) {
                  _showSnackBar(context, 'Select at least one page or grant full access.');
                  return;
                }
                final sysAdminProv = context.read<SystemAdminProvider>();
                final targetUser = sysAdminProv.users.firstWhere((u) => u.id == _formUserId, orElse: () => sysAdminProv.users.first);
                final dashDef = dashboardMap[_formDashboardKey]!;
                final roleToAdd = dashDef.role.value;
                final updatedRoles = targetUser.roles.contains(roleToAdd) ? targetUser.roles : [...targetUser.roles, roleToAdd];
                if (updatedRoles.length != targetUser.roles.length) {
                  sysAdminProv.updateUserRoles(targetUser.id, updatedRoles);
                }
                context.read<AccessControlProvider>().assignAccess(
                  userId: targetUser.id,
                  username: targetUser.username,
                  displayName: targetUser.displayName,
                  dashboardKey: _formDashboardKey,
                  dashboardLabel: dashDef.label,
                  allowedPages: _formFullAccess ? 'all' : _formAllowedPages,
                  grantedBy: 'Headmaster',
                );
                Navigator.pop(ctx);
                _editingGrantId = null;
                _showSnackBar(context, 'Access assigned to ${targetUser.displayName}.');
              },
              child: Text(_editingGrantId != null ? 'Update Access' : 'Assign Access'),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessControlProvider>();
    final sysAdmin = context.watch<SystemAdminProvider>();
    final grants = access.grants;
    final fullAccess = grants.where((g) => g.allowedPages == 'all').length;
    final pageLevel = grants.length - fullAccess;

    // Filter grants
    final filteredGrants = grants.where((g) {
      if (_accessFilter == 'full' && g.allowedPages != 'all') return false;
      if (_accessFilter == 'page' && g.allowedPages == 'all') return false;
      if (_selectedAccessUser != null && g.userId != _selectedAccessUser) return false;
      if (_accessSearch.trim().isNotEmpty) {
        final q = _accessSearch.toLowerCase();
        return g.displayName.toLowerCase().contains(q) || g.dashboardLabel.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    // Group by user
    final grantsByUser = <String, List<PageAccessGrant>>{};
    for (final g in filteredGrants) {
      grantsByUser.putIfAbsent(g.userId, () => []).add(g);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pageTitle('Access Control', 'Assign dashboards or specific pages to any user'),
            _addButton('+ Assign Access', _openNewAccessModal),
          ],
        ),
        StatCardGrid(cards: [
          StatCard(label: 'Total Grants', value: '${grants.length}', icon: Icons.security, color: AppColors.primaryLight),
          StatCard(label: 'Full Dashboard', value: '$fullAccess', icon: Icons.dashboard, color: AppColors.success),
          StatCard(label: 'Page-Level', value: '$pageLevel', icon: Icons.pages, color: AppColors.info),
          StatCard(label: 'Users with Grants', value: '${grants.map((g) => g.userId).toSet().length}', icon: Icons.person, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        // Search bar
        TextField(
          controller: _searchCtrl,
          decoration: const InputDecoration(hintText: 'Search by user or dashboard...', prefixIcon: Icon(Icons.search, size: 18)),
          onChanged: (v) => setState(() => _accessSearch = v),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Filter tabs
        Row(
          children: [
            _filterTab('All', 'all', grants.length, () => setState(() => _accessFilter = 'all')),
            const SizedBox(width: AppSpacing.xs),
            _filterTab('Full Dashboard', 'full', fullAccess, () => setState(() => _accessFilter = 'full')),
            const SizedBox(width: AppSpacing.xs),
            _filterTab('Page-Level', 'page', pageLevel, () => setState(() => _accessFilter = 'page')),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (grants.isEmpty) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(
              children: [
                const Text('No Access Assignments Yet', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                const SizedBox(height: AppSpacing.sm),
                Text('Click "+ Assign Access" to grant a user access to a full dashboard or specific pages.', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ] else ...[
          // Grants grouped by user
          ...grantsByUser.entries.map((entry) {
            final userGrants = entry.value;
            final targetUser = sysAdmin.users.firstWhere((u) => u.id == entry.key, orElse: () => sysAdmin.users.first);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(child: Text(userGrants.first.displayName.isNotEmpty ? userGrants.first.displayName[0].toUpperCase() : '?')),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userGrants.first.displayName, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                              Text('@${userGrants.first.username} · ${targetUser.roles.map((r) => _kAllRoles.firstWhere((ar) => ar.$1.value == r, orElse: (() => (RoleId.voter, r))).$2).join(', ')}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
                          child: Text('${userGrants.length} grant(s)', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...userGrants.map((grant) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(grant.dashboardLabel, style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
                                      const SizedBox(width: AppSpacing.xs),
                                      if (grant.allowedPages == 'all')
                                        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(AppRadius.sm)), child: const Text('FULL ACCESS', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)))
                                      else
                                        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)), child: Text('${(grant.allowedPages as List).length} PAGE(S)', style: const TextStyle(fontSize: 10, color: AppColors.info, fontWeight: FontWeight.w600))),
                                    ],
                                  ),
                                  if (grant.allowedPages != 'all') ...[
                                    const SizedBox(height: 4),
                                    Wrap(spacing: 4, runSpacing: 2, children: (grant.allowedPages as List).map((pk) {
                                      final pages = dashboardMap[grant.dashboardKey]?.pages ?? [];
                                      final pageDef = pages.firstWhere((p) => p.key == pk, orElse: () => DashboardPage(key: pk, label: pk));
                                      return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.sm)), child: Text(pageDef.label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)));
                                    }).toList()),
                                  ],
                                  const SizedBox(height: 4),
                                  Text('Granted by ${grant.grantedBy} on ${grant.grantedAt.substring(0, 10)}', style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                _miniButton('Edit', onTap: () => _openEditAccessModal(grant.id)),
                                _miniButton('Revoke', danger: true, onTap: () async {
                                  final confirmed = await _showConfirmDialog(
                                    context, 'Revoke Access',
                                    'Remove ${grant.displayName}\'s access to ${grant.dashboardLabel}?',
                                    confirmLabel: 'Revoke', danger: true,
                                  );
                                  if (confirmed == true) {
                                    context.read<AccessControlProvider>().revokeAccess(grant.id);
                                    _showSnackBar(context, 'Access has been removed.');
                                  }
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            );
          }),
        ],
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Recent Activity',
          child: access.activities.isEmpty
              ? const Text('No recent activity.', style: TextStyle(color: AppColors.textSecondary))
              : AppDataTable(
                  columns: ['User', 'Dashboard', 'Page', 'Action', 'Timestamp'],
                  rows: access.activities.map((a) => [
                    Text(a.displayName),
                    Text(a.dashboardLabel),
                    Text(a.pageLabel),
                    Text(a.action),
                    Text(a.timestamp.substring(0, 16)),
                  ]).toList(),
                ),
        ),
      ],
    );
  }

  Widget _filterTab(String label, String key, int count, VoidCallback onTap) {
    final active = _accessFilter == key;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
        ),
        child: Text('$label ($count)', style: TextStyle(
          fontSize: AppFontSize.xs,
          color: active ? AppColors.white : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        )),
      ),
    );
  }
}

// ── Today's Menu ──

class _MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final kitchen = context.watch<KitchenProvider>();
    final today = kitchen.menu.isNotEmpty ? kitchen.menu.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle("Today's Menu", 'Kitchen meals for the day'),
        SectionCard(
          title: today != null ? today.day : 'Today',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _mealRow('Breakfast', today?.breakfast ?? 'Porridge, Bread, Tea'),
              _mealRow('Lunch', today?.lunch ?? 'Jollof Rice, Chicken, Salad'),
              _mealRow('Supper', today?.dinner ?? 'Banku, Tilapia, Pepper Sauce'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Weekly Menu'),
        SectionCard(
          title: 'Full Week',
          child: AppDataTable(
            columns: ['Day', 'Breakfast', 'Lunch', 'Dinner'],
            rows: kitchen.menu.map((m) => [
              Text(m.day),
              Text(m.breakfast),
              Text(m.lunch),
              Text(m.dinner),
            ]).toList(),
          ),
        ),
      ],
    );
  }

  Widget _mealRow(String meal, String food) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(meal, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
          Text(food, style: const TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm)),
        ],
      ),
    );
  }
}

// ── Sync & Data Health ──

class _SyncPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sysAdmin = context.watch<SystemAdminProvider>();
    final db = sysAdmin.dbHealth;

    final devices = [
      {'device': 'Office Desktop', 'role': 'Bursary', 'lastSync': '2 min ago', 'pending': '0'},
      {'device': 'Registry PC', 'role': 'Registry', 'lastSync': '5 min ago', 'pending': '0'},
      {'device': 'Security Tablet', 'role': 'Security', 'lastSync': '1 hr ago', 'pending': '3'},
      {'device': 'Aggrey House Phone', 'role': 'Housemaster', 'lastSync': '3 hr ago', 'pending': '12'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('Sync & Data Health', 'Database and device sync status across the school'),
        StatCardGrid(cards: [
          StatCard(label: 'DB Status', value: db.status, icon: Icons.storage, color: db.status == 'Healthy' ? AppColors.success : AppColors.warning),
          StatCard(label: 'Last Sync', value: db.lastSync.split(' ').last, icon: Icons.schedule, color: AppColors.info),
          StatCard(label: 'Pending Changes', value: '${db.pendingChanges}', icon: Icons.sync_problem, color: db.pendingChanges > 0 ? AppColors.warning : AppColors.success),
          StatCard(label: 'Failed Syncs', value: '${db.failedSyncs}', icon: Icons.warning, color: db.failedSyncs > 0 ? AppColors.danger : AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Device Sync Log'),
        SectionCard(
          title: 'Connected Devices',
          child: AppDataTable(
            columns: ['Device', 'Role', 'Last Synced', 'Pending'],
            rows: devices.map((d) => [
              Text(d['device']!),
              Text(d['role']!),
              Text(d['lastSync']!),
              Text(d['pending']!),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Sync History'),
        SectionCard(
          title: 'Recent Sync Events',
          child: Column(
            children: [
              _logRow('2026-07-15 14:30', 'Pull completed — 0 records', AppColors.success),
              _logRow('2026-07-15 14:25', 'Push completed — 0 records', AppColors.success),
              _logRow('2026-07-15 14:00', 'Pull completed — 3 records', AppColors.success),
              _logRow('2026-07-15 13:30', 'Push completed — 1 record', AppColors.success),
              _logRow('2026-07-12 14:15', 'Sync failed for device_003 — timeout', AppColors.danger),
            ],
          ),
        ),
      ],
    );
  }

  Widget _logRow(String time, String message, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(time, style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message, style: const TextStyle(fontSize: AppFontSize.sm))),
        ],
      ),
    );
  }
}
