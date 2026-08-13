import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/dynamic_dashboard_provider.dart';
import '../../core/widgets/widgets.dart';

// ══════════════════════════════════════════════
// ACADEMIC BOARD DASHBOARD
// ══════════════════════════════════════════════

const _kMeetingStatuses = ['Scheduled', 'Completed', 'Cancelled'];
const _kPolicyStatuses = ['Draft', 'Under Review', 'Approved', 'Active'];

Color _abStatusColor(String s) =>
    s == 'Active' || s == 'Completed' || s == 'Approved'
        ? AppColors.success
        : s == 'Scheduled' || s == 'Draft' || s == 'Under Review'
            ? AppColors.warning
            : s == 'Cancelled'
                ? AppColors.danger
                : AppColors.primary;

Color _abRatingColor(String r) =>
    r == 'Excellent'
        ? AppColors.success
        : r == 'Good'
            ? AppColors.primary
            : r == 'Average'
                ? AppColors.warning
                : AppColors.danger;

Widget _abBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
    child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.bold)),
  );
}

Widget _abPageTitle(String title, String subtitle) {
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

Widget _abSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
    child: Text(title, style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.w600, color: AppColors.text)),
  );
}

Widget _abCard({required Color borderLeftColor, required Widget child}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border(
        left: BorderSide(color: borderLeftColor, width: 4),
        top: BorderSide(color: AppColors.border),
        bottom: BorderSide(color: AppColors.border),
        right: BorderSide(color: AppColors.border),
      ),
      boxShadow: AppShadows.sm,
    ),
    child: child,
  );
}

Widget _abActionBtn(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Text(label, style: const TextStyle(color: AppColors.white, fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _abQuickBtn(String label, Color bg, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Text(label, style: const TextStyle(color: AppColors.white, fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _abDeleteBtn(VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text('✕', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.danger, fontWeight: FontWeight.bold)),
    ),
  );
}

Widget _abInputLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
    child: Text(label, style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
  );
}

Widget _abTextInput(TextEditingController controller, {String? hint, int maxLines = 1}) {
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

Widget _abChipSelector(String selected, List<String> options, ValueChanged<String> onSelect) {
  return Wrap(
    spacing: AppSpacing.xs,
    runSpacing: AppSpacing.xs,
    children: options.map((opt) {
      final isActive = selected == opt;
      return GestureDetector(
        onTap: () => onSelect(opt),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: isActive ? AppColors.primary : AppColors.border),
          ),
          child: Text(opt, style: TextStyle(
            fontSize: AppFontSize.xs,
            color: isActive ? AppColors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          )),
        ),
      );
    }).toList(),
  );
}

void _abSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
  ));
}

Future<bool?> _abConfirmDialog(BuildContext context, String title, String message) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold)),
      content: Text(message, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

class AcademicBoardDashboard extends StatelessWidget {
  final String pageKey;
  const AcademicBoardDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _ABOverviewPage();
      case 'planning': return const _ABPlanningPage();
      case 'curriculum': return const _ABCurriculumPage();
      case 'policy': return const _ABPolicyPage();
      case 'departments': return const _ABDepartmentsPage();
      case 'assessments': return const _ABAssessmentsPage();
      case 'calendar': return const _ABCalendarPage();
      case 'meetings': return const _ABMeetingsPage();
      case 'reports': return const _ABReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _ABOverviewPage extends StatelessWidget {
  const _ABOverviewPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    final upcoming = d.meetings.where((m) => m.status == 'Scheduled').toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Board Meetings', value: '${d.meetings.length}', icon: Icons.groups, color: AppColors.primary),
        StatCard(label: 'Active Policies', value: '${d.policies.where((p) => p.status == 'Active').length}', icon: Icons.policy, color: AppColors.success),
        StatCard(label: 'Departments', value: '${d.deptReports.length}', icon: Icons.account_balance, color: AppColors.info),
        StatCard(label: 'Draft Policies', value: '${d.policies.where((p) => p.status == 'Draft').length}', icon: Icons.edit_note, color: AppColors.warning),
      ]),
      _abSectionTitle('Upcoming Meetings'),
      ...upcoming.map((m) => _abCard(
        borderLeftColor: AppColors.primary,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.title, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
          const SizedBox(height: 4),
          Text('${m.date} | Attendees: ${m.attendees}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text('Agenda: ${m.agenda}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
        ]),
      )),
      _abSectionTitle('Quick Actions'),
      Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
        _abQuickBtn('+ Meeting', AppColors.primary, () => _showMeetingModal(context)),
        _abQuickBtn('+ Policy', AppColors.success, () => _showPolicyModal(context)),
      ]),
    ]);
  }
}

class _ABPlanningPage extends StatelessWidget {
  const _ABPlanningPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    final goodCount = d.deptReports.where((r) => r.performanceRating == 'Excellent' || r.performanceRating == 'Good').length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _abPageTitle('Academic Planning', 'Strategic academic planning and term preparation'),
      StatCardGrid(cards: [
        StatCard(label: 'Total Policies', value: '${d.policies.length}', icon: Icons.policy, color: AppColors.primary),
        StatCard(label: 'Total Meetings', value: '${d.meetings.length}', icon: Icons.groups, color: AppColors.info),
        StatCard(label: 'Departments', value: '${d.deptReports.length}', icon: Icons.account_balance, color: AppColors.success),
        StatCard(label: 'Avg Rating', value: d.deptReports.isNotEmpty ? '$goodCount/${d.deptReports.length}' : 'N/A', icon: Icons.star, color: AppColors.accent),
      ]),
    ]);
  }
}

class _ABCurriculumPage extends StatelessWidget {
  const _ABCurriculumPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _abPageTitle('Curriculum Oversight', 'Review and approve curriculum changes across departments'),
      ...d.deptReports.map((r) => _abCard(
        borderLeftColor: _abRatingColor(r.performanceRating),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(r.department, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
          const SizedBox(height: 4),
          Text('Head: ${r.head}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(r.summary, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
        ]),
      )),
    ]);
  }
}

class _ABPolicyPage extends StatefulWidget {
  const _ABPolicyPage();
  @override
  State<_ABPolicyPage> createState() => _ABPolicyPageState();
}

class _ABPolicyPageState extends State<_ABPolicyPage> {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _abPageTitle('Academic Policies', 'Manage academic policies and guidelines'),
      _abActionBtn('+ New Policy', () => _showPolicyModal(context)),
      const SizedBox(height: AppSpacing.md),
      ...d.policies.map((p) => _abCard(
        borderLeftColor: _abStatusColor(p.status),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(p.title, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text))),
              const SizedBox(width: AppSpacing.sm),
              _abBadge(p.status, _abStatusColor(p.status)),
            ]),
            const SizedBox(height: 4),
            Text('${p.category}${p.dateApproved != null ? ' | Approved: ${p.dateApproved}' : ''}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(p.description, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
          ])),
          _abDeleteBtn(() async {
            final confirmed = await _abConfirmDialog(context, 'Delete', 'Delete this policy?');
            if (confirmed == true) {
              d.deletePolicy(p.id);
              _abSnackBar(context, 'Policy deleted.');
            }
          }),
        ]),
      )),
    ]);
  }
}

class _ABDepartmentsPage extends StatefulWidget {
  const _ABDepartmentsPage();
  @override
  State<_ABDepartmentsPage> createState() => _ABDepartmentsPageState();
}

class _ABDepartmentsPageState extends State<_ABDepartmentsPage> {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _abPageTitle('Department Reports', 'Performance reports from academic departments'),
      ...d.deptReports.map((r) => _abCard(
        borderLeftColor: _abRatingColor(r.performanceRating),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(r.department, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text))),
              const SizedBox(width: AppSpacing.sm),
              _abBadge(r.performanceRating, _abRatingColor(r.performanceRating)),
            ]),
            const SizedBox(height: 4),
            Text('Head: ${r.head} | Date: ${r.reportDate}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(r.summary, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
          ])),
          _abDeleteBtn(() async {
            final confirmed = await _abConfirmDialog(context, 'Delete', 'Delete this report?');
            if (confirmed == true) {
              d.deleteDeptReport(r.id);
              _abSnackBar(context, 'Report deleted.');
            }
          }),
        ]),
      )),
    ]);
  }
}

class _ABAssessmentsPage extends StatelessWidget {
  const _ABAssessmentsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    final assessmentPolicies = d.policies.where((p) => p.category == 'Assessment').toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _abPageTitle('Assessment Review', 'Review assessment policies and results across departments'),
      ...assessmentPolicies.map((p) => _abCard(
        borderLeftColor: _abStatusColor(p.status),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.title, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
          const SizedBox(height: 4),
          Text(p.description, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
        ]),
      )),
    ]);
  }
}

class _ABCalendarPage extends StatelessWidget {
  const _ABCalendarPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _abPageTitle('Academic Calendar', 'Key academic dates and board meetings'),
      ...d.meetings.map((m) => _abCard(
        borderLeftColor: _abStatusColor(m.status),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.title, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
          const SizedBox(height: 4),
          Text('${m.date} | ${m.status}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
        ]),
      )),
    ]);
  }
}

class _ABMeetingsPage extends StatefulWidget {
  const _ABMeetingsPage();
  @override
  State<_ABMeetingsPage> createState() => _ABMeetingsPageState();
}

class _ABMeetingsPageState extends State<_ABMeetingsPage> {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _abPageTitle('Board Meetings', 'Schedule and manage academic board meetings'),
      _abActionBtn('+ Schedule Meeting', () => _showMeetingModal(context)),
      const SizedBox(height: AppSpacing.md),
      ...d.meetings.map((m) => _abCard(
        borderLeftColor: _abStatusColor(m.status),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(m.title, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text))),
              const SizedBox(width: AppSpacing.sm),
              _abBadge(m.status, _abStatusColor(m.status)),
            ]),
            const SizedBox(height: 4),
            Text('${m.date} | Attendees: ${m.attendees}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(m.agenda, style: const TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
            if (m.minutes.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Minutes: ${m.minutes}', style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
            ],
          ])),
          _abDeleteBtn(() async {
            final confirmed = await _abConfirmDialog(context, 'Delete', 'Delete this meeting?');
            if (confirmed == true) {
              d.deleteMeeting(m.id);
              _abSnackBar(context, 'Meeting deleted.');
            }
          }),
        ]),
      )),
    ]);
  }
}

class _ABReportsPage extends StatelessWidget {
  const _ABReportsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _abPageTitle('Reports & Analytics', 'Academic board summary and department performance'),
      StatCardGrid(cards: [
        StatCard(label: 'Meetings', value: '${d.meetings.length}', icon: Icons.groups, color: AppColors.primary),
        StatCard(label: 'Policies', value: '${d.policies.length}', icon: Icons.policy, color: AppColors.success),
        StatCard(label: 'Departments', value: '${d.deptReports.length}', icon: Icons.account_balance, color: AppColors.info),
        StatCard(label: 'Active Policies', value: '${d.policies.where((p) => p.status == 'Active').length}', icon: Icons.check_circle, color: AppColors.accent),
      ]),
      _abSectionTitle('Department Performance'),
      ...d.deptReports.map((r) => _abCard(
        borderLeftColor: _abRatingColor(r.performanceRating),
        child: Row(children: [
          Expanded(child: Text(r.department, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text))),
          _abBadge(r.performanceRating, _abRatingColor(r.performanceRating)),
        ]),
      )),
    ]);
  }
}

// ── Academic Board Modals ──

void _showMeetingModal(BuildContext context) {
  final titleCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final attendeesCtrl = TextEditingController();
  final agendaCtrl = TextEditingController();
  final minutesCtrl = TextEditingController();
  String status = 'Scheduled';

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
      return AlertDialog(
        title: const Text('Schedule Meeting', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _abInputLabel('Title'), _abTextInput(titleCtrl, hint: 'Meeting title'),
          _abInputLabel('Date (YYYY-MM-DD)'), _abTextInput(dateCtrl, hint: '2026-09-01'),
          _abInputLabel('Attendees'), _abTextInput(attendeesCtrl, hint: '12'),
          _abInputLabel('Agenda'), _abTextInput(agendaCtrl, hint: 'Meeting agenda', maxLines: 3),
          _abInputLabel('Status'), _abChipSelector(status, _kMeetingStatuses, (v) => setState(() => status = v)),
          _abInputLabel('Minutes'), _abTextInput(minutesCtrl, hint: 'Meeting minutes (optional)', maxLines: 3),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (titleCtrl.text.trim().isEmpty || dateCtrl.text.trim().isEmpty) {
              _abSnackBar(context, 'Title and date are required.');
              return;
            }
            context.read<DynamicDashboardProvider>().addMeeting(
              title: titleCtrl.text.trim(),
              date: dateCtrl.text.trim(),
              attendees: attendeesCtrl.text.trim().isEmpty ? '0' : attendeesCtrl.text.trim(),
              agenda: agendaCtrl.text.trim(),
              status: status,
              minutes: minutesCtrl.text.trim(),
            );
            _abSnackBar(context, 'Meeting scheduled.');
            Navigator.pop(ctx);
          }, child: const Text('Save')),
        ],
      );
    }),
  );
}

void _showPolicyModal(BuildContext context) {
  final titleCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final dateApprovedCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  String status = 'Draft';

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
      return AlertDialog(
        title: const Text('New Policy', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _abInputLabel('Title'), _abTextInput(titleCtrl, hint: 'Policy title'),
          _abInputLabel('Category'), _abTextInput(categoryCtrl, hint: 'e.g. Assessment, Academic, Support'),
          _abInputLabel('Status'), _abChipSelector(status, _kPolicyStatuses, (v) => setState(() => status = v)),
          _abInputLabel('Date Approved (YYYY-MM-DD)'), _abTextInput(dateApprovedCtrl, hint: 'Leave empty if not yet approved'),
          _abInputLabel('Description'), _abTextInput(descCtrl, hint: 'Policy description', maxLines: 3),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (titleCtrl.text.trim().isEmpty) {
              _abSnackBar(context, 'Title is required.');
              return;
            }
            context.read<DynamicDashboardProvider>().addPolicy(
              title: titleCtrl.text.trim(),
              category: categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim(),
              status: status,
              dateApproved: dateApprovedCtrl.text.trim().isEmpty ? null : dateApprovedCtrl.text.trim(),
              description: descCtrl.text.trim(),
            );
            _abSnackBar(context, 'Policy created.');
            Navigator.pop(ctx);
          }, child: const Text('Save')),
        ],
      );
    }),
  );
}

// ══════════════════════════════════════════════
// DINING HALL DASHBOARD
// ══════════════════════════════════════════════

Widget _chip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
  );
}

class DiningHallDashboard extends StatelessWidget {
  final String pageKey;
  const DiningHallDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _DHOverviewPage();
      case 'seating': return const _DHSeatingPage();
      case 'menu': return const _DHMenuPage();
      case 'attendance': return const _DHAttendancePage();
      case 'supplies': return const _DHSuppliesPage();
      case 'hygiene': return const _DHHygienePage();
      case 'feedback': return const _DHFeedbackPage();
      case 'reports': return const _DHReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _DHOverviewPage extends StatelessWidget {
  const _DHOverviewPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Meal Records', value: '${d.mealAttendance.length}', icon: Icons.restaurant, color: AppColors.primaryLight),
        StatCard(label: 'Hygiene Inspections', value: '${d.hygieneInspections.length}', icon: Icons.cleaning_services, color: AppColors.success),
        StatCard(label: 'Feedback', value: '${d.studentFeedback.length}', icon: Icons.feedback, color: AppColors.info),
        StatCard(label: 'Low Stock Supplies', value: '${d.supplies.where((s) => s.status != 'In Stock').length}', icon: Icons.warning, color: AppColors.warning),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Recent Meal Attendance', child: AppDataTable(
        columns: ['Date', 'Meal', 'Expected', 'Present', 'Absentees'],
        rows: d.mealAttendance.take(5).map((a) => [
          Text(a.date), Text(a.meal), Text('${a.expected}'), Text('${a.present}'), Text(a.absentees),
        ]).toList(),
      )),
    ]);
  }
}

class _DHSeatingPage extends StatelessWidget {
  const _DHSeatingPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Seating Plan', child: AppDataTable(
      columns: ['Table', 'House', 'Form', 'Capacity', 'Students'],
      rows: d.seatingPlans.map((s) => [
        Text(s.table), Text(s.house), Text(s.form),
        Text('${s.capacity}'), Text(s.students),
      ]).toList(),
    ));
  }
}

class _DHMenuPage extends StatelessWidget {
  const _DHMenuPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Menu Oversight', child: AppDataTable(
      columns: ['Date', 'Meal', 'Main Dish', 'Side', 'Drink', 'Status'],
      rows: d.menuItems.map((m) => [
        Text(m.date), Text(m.meal), Text(m.mainDish), Text(m.side), Text(m.drink),
        _chip(m.status, m.status == 'Approved' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _DHAttendancePage extends StatelessWidget {
  const _DHAttendancePage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Meal Attendance', child: AppDataTable(
      columns: ['Date', 'Meal', 'Expected', 'Present', 'Absentees'],
      rows: d.mealAttendance.map((a) => [
        Text(a.date), Text(a.meal), Text('${a.expected}'), Text('${a.present}'), Text(a.absentees),
      ]).toList(),
    ));
  }
}

class _DHSuppliesPage extends StatelessWidget {
  const _DHSuppliesPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Supplies & Stock', child: AppDataTable(
      columns: ['Item', 'Category', 'Qty', 'Unit', 'Min Stock', 'Status'],
      rows: d.supplies.map((s) => [
        Text(s.item), Text(s.category), Text('${s.quantity}'), Text(s.unit),
        Text('${s.minStock}'),
        _chip(s.status, s.status == 'In Stock' ? AppColors.success : AppColors.danger),
      ]).toList(),
    ));
  }
}

class _DHHygienePage extends StatelessWidget {
  const _DHHygienePage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Hygiene Inspection', child: AppDataTable(
      columns: ['Date', 'Area', 'Rating', 'Inspector', 'Notes'],
      rows: d.hygieneInspections.map((i) => [
        Text(i.date), Text(i.area),
        _chip(i.rating, i.rating == 'Excellent' ? AppColors.success : i.rating == 'Good' ? AppColors.info : AppColors.warning),
        Text(i.inspector), Text(i.notes),
      ]).toList(),
    ));
  }
}

class _DHFeedbackPage extends StatelessWidget {
  const _DHFeedbackPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Student Feedback', child: AppDataTable(
      columns: ['Date', 'Student', 'Meal', 'Rating', 'Comment'],
      rows: d.studentFeedback.map((f) => [
        Text(f.date), Text(f.studentName), Text(f.meal),
        Text('${f.rating}/5'), Text(f.comment),
      ]).toList(),
    ));
  }
}

class _DHReportsPage extends StatelessWidget {
  const _DHReportsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Avg Attendance', value: '${d.mealAttendance.isEmpty ? 0 : (d.mealAttendance.fold(0, (s, a) => s + a.present) / d.mealAttendance.length).round()}', icon: Icons.people, color: AppColors.primaryLight),
        StatCard(label: 'Inspections', value: '${d.hygieneInspections.length}', icon: Icons.cleaning_services, color: AppColors.success),
        StatCard(label: 'Feedback Items', value: '${d.studentFeedback.length}', icon: Icons.feedback, color: AppColors.info),
        StatCard(label: 'Supply Items', value: '${d.supplies.length}', icon: Icons.inventory, color: AppColors.warning),
      ]),
    ]);
  }
}

// ══════════════════════════════════════════════
// EXAM COMMITTEE DASHBOARD
// ══════════════════════════════════════════════

class ExamCommitteeDashboard extends StatelessWidget {
  final String pageKey;
  const ExamCommitteeDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _ECOverviewPage();
      case 'schedule': return const _ECSchedulePage();
      case 'papers': return const _ECPapersPage();
      case 'invigilation': return const _ECInvigilationPage();
      case 'grading': return _ECGradingPage();
      case 'results': return const _ECResultsPage();
      case 'malpractice': return const _ECMalpracticePage();
      case 'reports': return const _ECReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _ECOverviewPage extends StatelessWidget {
  const _ECOverviewPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Scheduled Exams', value: '${d.scheduledExams}', icon: Icons.event, color: AppColors.primaryLight),
        StatCard(label: 'Question Papers', value: '${d.questionPapers.length}', icon: Icons.description, color: AppColors.info),
        StatCard(label: 'Invigilators', value: '${d.invigilation.length}', icon: Icons.supervisor_account, color: AppColors.purple),
        StatCard(label: 'Malpractice', value: '${d.malpractice.length}', icon: Icons.warning, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Exam Schedule', child: AppDataTable(
        columns: ['Exam', 'Subject', 'Date', 'Time', 'Duration', 'Venue', 'Status'],
        rows: d.exams.take(5).map((e) => [
          Text(e.examName), Text(e.subject), Text(e.date), Text(e.time),
          Text(e.duration), Text(e.venue),
          _chip(e.status, e.status == 'Completed' ? AppColors.success : AppColors.warning),
        ]).toList(),
      )),
    ]);
  }
}

class _ECSchedulePage extends StatelessWidget {
  const _ECSchedulePage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Exam Schedule', child: AppDataTable(
      columns: ['Exam', 'Subject', 'Date', 'Time', 'Duration', 'Venue', 'Status'],
      rows: d.exams.map((e) => [
        Text(e.examName), Text(e.subject), Text(e.date), Text(e.time),
        Text(e.duration), Text(e.venue),
        _chip(e.status, e.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _ECPapersPage extends StatelessWidget {
  const _ECPapersPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Question Papers', child: AppDataTable(
      columns: ['Subject', 'Examiner', 'Status', 'Date Submitted', 'Notes'],
      rows: d.questionPapers.map((p) => [
        Text(p.subject), Text(p.examiner),
        _chip(p.status, p.status == 'Approved' ? AppColors.success : p.status == 'Reviewed' ? AppColors.info : AppColors.warning),
        Text(p.dateSubmitted), Text(p.notes),
      ]).toList(),
    ));
  }
}

class _ECInvigilationPage extends StatelessWidget {
  const _ECInvigilationPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Invigilation Duty', child: AppDataTable(
      columns: ['Exam', 'Date', 'Time', 'Venue', 'Invigilator'],
      rows: d.invigilation.map((i) => [
        Text(i.examName), Text(i.date), Text(i.time), Text(i.venue), Text(i.invigilator),
      ]).toList(),
    ));
  }
}

class _ECGradingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Grading & Moderation', child: AppDataTable(
      columns: ['Exam', 'Subject', 'Completed', 'Passed', 'Failed', 'Average', 'Remarks'],
      rows: d.examResults.map((r) => [
        Text(r.examName), Text(r.subject), Text('${r.completed}'),
        Text('${r.passed}'), Text('${r.failed}'), Text('${r.averageScore}%'), Text(r.remarks),
      ]).toList(),
    ));
  }
}

class _ECResultsPage extends StatelessWidget {
  const _ECResultsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Results Processing', child: AppDataTable(
      columns: ['Exam', 'Subject', 'Completed', 'Passed', 'Failed', 'Average', 'Remarks'],
      rows: d.examResults.map((r) => [
        Text(r.examName), Text(r.subject), Text('${r.completed}'),
        Text('${r.passed}'), Text('${r.failed}'), Text('${r.averageScore}%'), Text(r.remarks),
      ]).toList(),
    ));
  }
}

class _ECMalpracticePage extends StatelessWidget {
  const _ECMalpracticePage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Malpractice Log', child: AppDataTable(
      columns: ['Student', 'Class', 'Exam', 'Type', 'Date', 'Description', 'Action'],
      rows: d.malpractice.map((m) => [
        Text(m.studentName), Text(m.studentClass), Text(m.exam),
        Text(m.type), Text(m.date), Text(m.description), Text(m.action),
      ]).toList(),
    ));
  }
}

class _ECReportsPage extends StatelessWidget {
  const _ECReportsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Exams', value: '${d.exams.length}', icon: Icons.event, color: AppColors.primaryLight),
        StatCard(label: 'Question Papers', value: '${d.questionPapers.length}', icon: Icons.description, color: AppColors.info),
        StatCard(label: 'Invigilation Duties', value: '${d.invigilation.length}', icon: Icons.supervisor_account, color: AppColors.purple),
        StatCard(label: 'Malpractice Cases', value: '${d.malpractice.length}', icon: Icons.warning, color: AppColors.danger),
      ]),
    ]);
  }
}

// ══════════════════════════════════════════════
// SAFE SPACE DASHBOARD
// ══════════════════════════════════════════════

class SafeSpaceDashboard extends StatelessWidget {
  final String pageKey;
  const SafeSpaceDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _SSOverviewPage();
      case 'incidents': return const _SSIncidentsPage();
      case 'inspections': return const _SSInspectionsPage();
      case 'relationships': return const _SSRelationshipsPage();
      case 'environment': return _SSEnvironmentPage();
      case 'training': return const _SSTrainingPage();
      case 'reports': return const _SSReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _SSOverviewPage extends StatelessWidget {
  const _SSOverviewPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Open Incidents', value: '${d.openIncidents}', icon: Icons.report, color: AppColors.danger),
        StatCard(label: 'Inspections', value: '${d.safetyInspections.length}', icon: Icons.fact_check, color: AppColors.info),
        StatCard(label: 'Relationship Cases', value: '${d.relationshipCases.length}', icon: Icons.handshake, color: AppColors.purple),
        StatCard(label: 'Training Records', value: '${d.trainingRecords.length}', icon: Icons.school, color: AppColors.accent),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Recent Safety Incidents', child: AppDataTable(
        columns: ['Date', 'Location', 'Severity', 'Description', 'Status'],
        rows: d.incidents.take(5).map((i) => [
          Text(i.date), Text(i.location),
          _chip(i.severity, i.severity == 'High' ? AppColors.danger : AppColors.warning),
          Text(i.description),
          _chip(i.status, i.status == 'Resolved' ? AppColors.success : AppColors.warning),
        ]).toList(),
      )),
    ]);
  }
}

class _SSIncidentsPage extends StatelessWidget {
  const _SSIncidentsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Safety Incidents', child: AppDataTable(
      columns: ['Date', 'Location', 'Severity', 'Description', 'Reported By', 'Status', 'Action'],
      rows: d.incidents.map((i) => [
        Text(i.date), Text(i.location),
        _chip(i.severity, i.severity == 'High' ? AppColors.danger : AppColors.warning),
        Text(i.description), Text(i.reportedBy),
        _chip(i.status, i.status == 'Resolved' ? AppColors.success : AppColors.warning),
        Text(i.action),
      ]).toList(),
    ));
  }
}

class _SSInspectionsPage extends StatelessWidget {
  const _SSInspectionsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Safety Inspections', child: AppDataTable(
      columns: ['Date', 'Area', 'Finding', 'Risk Level', 'Recommendation', 'Resolved'],
      rows: d.safetyInspections.map((i) => [
        Text(i.date), Text(i.area), Text(i.finding),
        _chip(i.riskLevel, i.riskLevel == 'Safe' ? AppColors.success : i.riskLevel == 'Major Risk' ? AppColors.danger : AppColors.warning),
        Text(i.recommendation),
        _chip(i.resolved ? 'Yes' : 'No', i.resolved ? AppColors.success : AppColors.danger),
      ]).toList(),
    ));
  }
}

class _SSRelationshipsPage extends StatelessWidget {
  const _SSRelationshipsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Relationship Management', child: AppDataTable(
      columns: ['Date', 'Parties', 'Issue', 'Mediator', 'Status', 'Notes'],
      rows: d.relationshipCases.map((r) => [
        Text(r.date), Text(r.parties), Text(r.issue),
        Text(r.mediator),
        _chip(r.status, r.status == 'Mediated' ? AppColors.success : AppColors.warning),
        Text(r.notes),
      ]).toList(),
    ));
  }
}

class _SSEnvironmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Environment Audit', child: AppDataTable(
      columns: ['Date', 'Area', 'Finding', 'Risk Level', 'Recommendation', 'Resolved'],
      rows: d.safetyInspections.map((i) => [
        Text(i.date), Text(i.area), Text(i.finding),
        _chip(i.riskLevel, i.riskLevel == 'Safe' ? AppColors.success : AppColors.danger),
        Text(i.recommendation),
        _chip(i.resolved ? 'Yes' : 'No', i.resolved ? AppColors.success : AppColors.danger),
      ]).toList(),
    ));
  }
}

class _SSTrainingPage extends StatelessWidget {
  const _SSTrainingPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Safety Training', child: AppDataTable(
      columns: ['Title', 'Date', 'Trainer', 'Type', 'Participants'],
      rows: d.trainingRecords.map((t) => [
        Text(t.title), Text(t.date), Text(t.trainer), Text(t.type),
        Text('${t.participants}'),
      ]).toList(),
    ));
  }
}

class _SSReportsPage extends StatelessWidget {
  const _SSReportsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Incidents', value: '${d.incidents.length}', icon: Icons.report, color: AppColors.danger),
        StatCard(label: 'Open', value: '${d.openIncidents}', icon: Icons.pending, color: AppColors.warning),
        StatCard(label: 'Inspections', value: '${d.safetyInspections.length}', icon: Icons.fact_check, color: AppColors.info),
        StatCard(label: 'Training', value: '${d.trainingRecords.length}', icon: Icons.school, color: AppColors.accent),
      ]),
    ]);
  }
}

// ══════════════════════════════════════════════
// INTERNAL AUDITOR DASHBOARD
// ══════════════════════════════════════════════

class InternalAuditorDashboard extends StatelessWidget {
  final String pageKey;
  const InternalAuditorDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _IAOverviewPage();
      case 'audits': return const _IAAuditsPage();
      case 'findings': return const _IAFindingsPage();
      case 'compliance': return _IACompliancePage();
      case 'financial': return _IAFinancialPage();
      case 'reports': return const _IAReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _IAOverviewPage extends StatelessWidget {
  const _IAOverviewPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Audits', value: '${d.audits.length}', icon: Icons.fact_check, color: AppColors.primaryLight),
        StatCard(label: 'Open Findings', value: '${d.openFindings}', icon: Icons.warning, color: AppColors.danger),
        StatCard(label: 'In Progress', value: '${d.audits.where((a) => a.status == 'In Progress').length}', icon: Icons.pending, color: AppColors.warning),
        StatCard(label: 'Completed', value: '${d.audits.where((a) => a.status == 'Completed').length}', icon: Icons.check_circle, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Audit Schedule', child: AppDataTable(
        columns: ['Title', 'Type', 'Start', 'End', 'Auditor', 'Status'],
        rows: d.audits.map((a) => [
          Text(a.title), Text(a.type), Text(a.startDate), Text(a.endDate),
          Text(a.auditor),
          _chip(a.status, a.status == 'Completed' ? AppColors.success : a.status == 'In Progress' ? AppColors.warning : AppColors.info),
        ]).toList(),
      )),
    ]);
  }
}

class _IAAuditsPage extends StatelessWidget {
  const _IAAuditsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Audit Schedule', child: AppDataTable(
      columns: ['Title', 'Type', 'Start Date', 'End Date', 'Auditor', 'Status'],
      rows: d.audits.map((a) => [
        Text(a.title), Text(a.type), Text(a.startDate), Text(a.endDate),
        Text(a.auditor),
        _chip(a.status, a.status == 'Completed' ? AppColors.success : a.status == 'In Progress' ? AppColors.warning : AppColors.info),
      ]).toList(),
    ));
  }
}

class _IAFindingsPage extends StatelessWidget {
  const _IAFindingsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Audit Findings', child: AppDataTable(
      columns: ['Audit', 'Severity', 'Finding', 'Recommendation', 'Status', 'Date'],
      rows: d.auditFindings.map((f) => [
        Text(f.auditTitle),
        _chip(f.severity, f.severity == 'High' ? AppColors.danger : f.severity == 'Medium' ? AppColors.warning : AppColors.info),
        Text(f.finding), Text(f.recommendation),
        _chip(f.status, f.status == 'Closed' ? AppColors.success : f.status == 'Addressed' ? AppColors.info : AppColors.warning),
        Text(f.date),
      ]).toList(),
    ));
  }
}

class _IACompliancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    final complianceAudits = d.audits.where((a) => a.type == 'Compliance').toList();
    return SectionCard(title: 'Compliance Review', child: AppDataTable(
      columns: ['Title', 'Start Date', 'End Date', 'Auditor', 'Status'],
      rows: complianceAudits.map((a) => [
        Text(a.title), Text(a.startDate), Text(a.endDate), Text(a.auditor),
        _chip(a.status, a.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _IAFinancialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    final financialAudits = d.audits.where((a) => a.type == 'Financial').toList();
    return SectionCard(title: 'Financial Audit', child: AppDataTable(
      columns: ['Title', 'Start Date', 'End Date', 'Auditor', 'Status'],
      rows: financialAudits.map((a) => [
        Text(a.title), Text(a.startDate), Text(a.endDate), Text(a.auditor),
        _chip(a.status, a.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _IAReportsPage extends StatelessWidget {
  const _IAReportsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Audits', value: '${d.audits.length}', icon: Icons.fact_check, color: AppColors.primaryLight),
        StatCard(label: 'Findings', value: '${d.auditFindings.length}', icon: Icons.warning, color: AppColors.warning),
        StatCard(label: 'Open', value: '${d.openFindings}', icon: Icons.error, color: AppColors.danger),
        StatCard(label: 'Closed', value: '${d.auditFindings.where((f) => f.status == 'Closed').length}', icon: Icons.check_circle, color: AppColors.success),
      ]),
    ]);
  }
}

// ══════════════════════════════════════════════
// HEADMASTER SECRETARY DASHBOARD
// ══════════════════════════════════════════════

class HeadmasterSecretaryDashboard extends StatelessWidget {
  final String pageKey;
  const HeadmasterSecretaryDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _HSOverviewPage();
      case 'appointments': return const _HSAppointmentsPage();
      case 'correspondence': return const _HSCorrespondencePage();
      case 'filing': return _HSFilingPage();
      case 'visitors': return const _HSVisitorsPage();
      case 'tasks': return const _HSTasksPage();
      case 'reports': return const _HSReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _HSOverviewPage extends StatelessWidget {
  const _HSOverviewPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Appointments', value: '${d.appointments.length}', icon: Icons.event, color: AppColors.primaryLight),
        StatCard(label: 'Pending Appts', value: '${d.pendingAppointments}', icon: Icons.pending, color: AppColors.warning),
        StatCard(label: 'Correspondence', value: '${d.correspondence.length}', icon: Icons.mail, color: AppColors.info),
        StatCard(label: 'Pending Tasks', value: '${d.pendingTasks}', icon: Icons.task, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Upcoming Appointments', child: AppDataTable(
        columns: ['Date', 'Time', 'Visitor', 'Purpose', 'Status'],
        rows: d.appointments.where((a) => a.status != 'Completed').map((a) => [
          Text(a.date), Text(a.time), Text(a.visitorName), Text(a.purpose),
          _chip(a.status, a.status == 'Confirmed' ? AppColors.success : AppColors.warning),
        ]).toList(),
      )),
    ]);
  }
}

class _HSAppointmentsPage extends StatelessWidget {
  const _HSAppointmentsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Appointments', child: AppDataTable(
      columns: ['Date', 'Time', 'Visitor', 'Purpose', 'Status', 'Notes'],
      rows: d.appointments.map((a) => [
        Text(a.date), Text(a.time), Text(a.visitorName), Text(a.purpose),
        _chip(a.status, a.status == 'Completed' ? AppColors.success : a.status == 'Confirmed' ? AppColors.info : AppColors.warning),
        Text(a.notes),
      ]).toList(),
    ));
  }
}

class _HSCorrespondencePage extends StatelessWidget {
  const _HSCorrespondencePage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Correspondence', child: AppDataTable(
      columns: ['Date', 'Type', 'From', 'To', 'Subject', 'Status'],
      rows: d.correspondence.map((c) => [
        Text(c.date), Text(c.type), Text(c.from), Text(c.to),
        Text(c.subject),
        _chip(c.status, c.status == 'Filed' ? AppColors.success : c.status == 'Forwarded' ? AppColors.info : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _HSFilingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Filing & Records', child: AppDataTable(
      columns: ['Date', 'Type', 'Subject', 'Status'],
      rows: d.correspondence.map((c) => [
        Text(c.date), Text(c.type), Text(c.subject),
        _chip(c.status, c.status == 'Filed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _HSVisitorsPage extends StatelessWidget {
  const _HSVisitorsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Visitor Log', child: AppDataTable(
      columns: ['Date', 'Time In', 'Time Out', 'Visitor', 'Purpose', 'Contact'],
      rows: d.visitors.map((v) => [
        Text(v.date), Text(v.timeIn), Text(v.timeOut),
        Text(v.visitorName), Text(v.purpose), Text(v.contact),
      ]).toList(),
    ));
  }
}

class _HSTasksPage extends StatelessWidget {
  const _HSTasksPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return SectionCard(title: 'Task Tracker', child: AppDataTable(
      columns: ['Title', 'Priority', 'Due Date', 'Assigned By', 'Status', 'Notes'],
      rows: d.secretaryTasks.map((t) => [
        Text(t.title),
        _chip(t.priority, t.priority == 'High' ? AppColors.danger : t.priority == 'Medium' ? AppColors.warning : AppColors.info),
        Text(t.dueDate), Text(t.assignedBy),
        _chip(t.status, t.status == 'Completed' ? AppColors.success : t.status == 'In Progress' ? AppColors.info : AppColors.warning),
        Text(t.notes),
      ]).toList(),
    ));
  }
}

class _HSReportsPage extends StatelessWidget {
  const _HSReportsPage();
  @override
  Widget build(BuildContext context) {
    final d = context.watch<DynamicDashboardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Appointments', value: '${d.appointments.length}', icon: Icons.event, color: AppColors.primaryLight),
        StatCard(label: 'Correspondence', value: '${d.correspondence.length}', icon: Icons.mail, color: AppColors.info),
        StatCard(label: 'Visitors', value: '${d.visitors.length}', icon: Icons.person, color: AppColors.purple),
        StatCard(label: 'Tasks', value: '${d.secretaryTasks.length}', icon: Icons.task, color: AppColors.accent),
      ]),
    ]);
  }
}
