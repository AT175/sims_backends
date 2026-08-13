import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/plc_provider.dart';
import '../../core/widgets/widgets.dart';

class PLCDashboard extends StatelessWidget {
  final String pageKey;
  const PLCDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'meetings': return const _MeetingsPage();
      case 'duty': return const _DutyPage();
      case 'observations': return const _ObservationsPage();
      case 'lesson': return const _LessonPage();
      case 'performance': return const _PerformancePage();
      case 'resources': return const _ResourcesPage();
      case 'action': return const _ActionPage();
      case 'requisitions': return const _RequisitionsPage();
      case 'reports': return const _ReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

Widget _chip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
  );
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PLCProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Meetings', value: '${p.meetings.length}', icon: Icons.groups, color: AppColors.primaryLight),
        StatCard(label: 'Scheduled', value: '${p.scheduledMeetings}', icon: Icons.event, color: AppColors.warning),
        StatCard(label: 'Observations', value: '${p.observations.length}', icon: Icons.visibility, color: AppColors.info),
        StatCard(label: 'Pending Actions', value: '${p.pendingActions}', icon: Icons.pending_actions, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Upcoming Meetings', child: AppDataTable(
        columns: ['Date', 'Topic', 'Facilitator', 'Location', 'Status'],
        rows: p.meetings.where((m) => m.status == 'Scheduled').map((m) => [
          Text(m.date), Text(m.topic), Text(m.facilitator), Text(m.location),
          _chip(m.status, AppColors.warning),
        ]).toList(),
      )),
    ]);
  }
}

class _MeetingsPage extends StatelessWidget {
  const _MeetingsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PLCProvider>();
    return SectionCard(title: 'Meetings & Attendance', child: AppDataTable(
      columns: ['Date', 'Topic', 'Facilitator', 'Location', 'Attendees', 'Status'],
      rows: p.meetings.map((m) => [
        Text(m.date), Text(m.topic), Text(m.facilitator), Text(m.location),
        Text('${m.attendees}'),
        _chip(m.status, m.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _DutyPage extends StatelessWidget {
  const _DutyPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PLCProvider>();
    return SectionCard(title: 'Coordinator Duty Roster', child: AppDataTable(
      columns: ['Day', 'Coordinator', 'Duty', 'Time'],
      rows: p.dutyRoster.map((d) => [
        Text(d.day), Text(d.coordinator), Text(d.duty), Text(d.time),
      ]).toList(),
    ));
  }
}

class _ObservationsPage extends StatelessWidget {
  const _ObservationsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PLCProvider>();
    return SectionCard(title: 'Critical Friend Observations', child: AppDataTable(
      columns: ['Date', 'Observer', 'Teacher', 'Subject', 'Class', 'Focus Area', 'Rating'],
      rows: p.observations.map((o) => [
        Text(o.date), Text(o.observer), Text(o.teacher), Text(o.subject),
        Text(o.classForm), Text(o.focusArea),
        _chip(o.rating, o.rating == 'Excellent' ? AppColors.success : AppColors.info),
      ]).toList(),
    ));
  }
}

class _LessonPage extends StatelessWidget {
  const _LessonPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PLCProvider>();
    return SectionCard(title: 'Lesson Study Log', child: AppDataTable(
      columns: ['Date', 'Subject', 'Class', 'Topic', 'Lead Teacher', 'Status'],
      rows: p.lessonStudies.map((l) => [
        Text(l.date), Text(l.subject), Text(l.classForm), Text(l.topic),
        Text(l.leadTeacher),
        _chip(l.status, l.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _PerformancePage extends StatelessWidget {
  const _PerformancePage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PLCProvider>();
    return SectionCard(title: 'Performance Reviews', child: AppDataTable(
      columns: ['Teacher', 'Period', 'Rating', 'Strengths', 'Areas for Growth', 'Reviewer', 'Date'],
      rows: p.performanceReviews.map((r) => [
        Text(r.teacher), Text(r.period),
        _chip(r.rating, r.rating == 'Excellent' ? AppColors.success : AppColors.info),
        Text(r.strengths), Text(r.areasForGrowth), Text(r.reviewer), Text(r.date),
      ]).toList(),
    ));
  }
}

class _ResourcesPage extends StatelessWidget {
  const _ResourcesPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PLCProvider>();
    return SectionCard(title: 'Resource Sharing', child: AppDataTable(
      columns: ['Title', 'Type', 'Uploaded By', 'Date'],
      rows: p.resources.map((r) => [
        Text(r.title), Text(r.type), Text(r.uploadedBy), Text(r.date),
      ]).toList(),
    ));
  }
}

class _ActionPage extends StatelessWidget {
  const _ActionPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PLCProvider>();
    return SectionCard(title: 'Action Plan Tracker', child: AppDataTable(
      columns: ['Action', 'Owner', 'Due Date', 'Priority', 'Status'],
      rows: p.actionItems.map((a) => [
        Text(a.action), Text(a.owner), Text(a.dueDate),
        _chip(a.priority, a.priority == 'High' ? AppColors.danger : a.priority == 'Medium' ? AppColors.warning : AppColors.info),
        _chip(a.status, a.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _RequisitionsPage extends StatelessWidget {
  const _RequisitionsPage();
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'PLC Requisitions', child: Center(
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
    final p = context.watch<PLCProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Meetings', value: '${p.meetings.length}', icon: Icons.groups, color: AppColors.primaryLight),
        StatCard(label: 'Observations', value: '${p.observations.length}', icon: Icons.visibility, color: AppColors.info),
        StatCard(label: 'Lesson Studies', value: '${p.lessonStudies.length}', icon: Icons.menu_book, color: AppColors.purple),
        StatCard(label: 'Resources', value: '${p.resources.length}', icon: Icons.folder, color: AppColors.accent),
      ]),
    ]);
  }
}
