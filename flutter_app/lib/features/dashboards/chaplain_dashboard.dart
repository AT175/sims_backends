import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/chaplain_provider.dart';
import '../../core/widgets/widgets.dart';

class ChaplainDashboard extends StatelessWidget {
  final String pageKey;
  const ChaplainDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'services': return const _ServicesPage();
      case 'prayerRequests': return const _PrayerRequestsPage();
      case 'counselling': return const _CounsellingPage();
      case 'events': return const _EventsPage();
      case 'fellowships': return const _FellowshipsPage();
      case 'outreach': return const _OutreachPage();
      case 'choir': return const _ChoirPage();
      case 'baptism': return const _BaptismPage();
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
    final c = context.watch<ChaplainProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Services', value: '${c.services.length}', icon: Icons.church, color: AppColors.primaryLight),
        StatCard(label: 'Prayer Requests', value: '${c.openPrayerRequests}', icon: Icons.pan_tool, color: AppColors.warning),
        StatCard(label: 'Fellowship Members', value: '${c.totalFellowshipMembers}', icon: Icons.groups, color: AppColors.info),
        StatCard(label: 'Choir Members', value: '${c.choir.length}', icon: Icons.music_note, color: AppColors.purple),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Upcoming Events', child: AppDataTable(
        columns: ['Title', 'Date', 'Venue', 'Expected', 'Status'],
        rows: c.events.where((e) => e.status == 'Planned').map((e) => [
          Text(e.title), Text(e.date), Text(e.venue),
          Text('${e.expectedAttendance}'), _chip(e.status, AppColors.warning),
        ]).toList(),
      )),
    ]);
  }
}

class _ServicesPage extends StatelessWidget {
  const _ServicesPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return SectionCard(title: 'Service Schedule', child: AppDataTable(
      columns: ['Type', 'Day', 'Time', 'Venue', 'Speaker', 'Topic', 'Attendance'],
      rows: c.services.map((s) => [
        Text(s.type), Text(s.day), Text(s.time), Text(s.venue),
        Text(s.speaker), Text(s.topic), Text('${s.attendance}'),
      ]).toList(),
    ));
  }
}

class _PrayerRequestsPage extends StatelessWidget {
  const _PrayerRequestsPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return SectionCard(title: 'Prayer Requests', child: AppDataTable(
      columns: ['Student', 'Class', 'Request', 'Date', 'Status', 'Visibility'],
      rows: c.prayerRequests.map((p) => [
        Text(p.studentName), Text(p.studentClass), Text(p.request),
        Text(p.dateSubmitted),
        _chip(p.status, p.status == 'Answered' ? AppColors.success : AppColors.warning),
        _chip(p.visibility, p.visibility == 'Confidential' ? AppColors.danger : AppColors.info),
      ]).toList(),
    ));
  }
}

class _CounsellingPage extends StatelessWidget {
  const _CounsellingPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return SectionCard(title: 'Spiritual Counselling', child: AppDataTable(
      columns: ['Student', 'Class', 'Type', 'Date', 'Summary', 'Status', 'Follow-up'],
      rows: c.counselling.map((cs) => [
        Text(cs.studentName), Text(cs.studentClass), Text(cs.type),
        Text(cs.date), Text(cs.summary),
        _chip(cs.status, cs.status == 'Resolved' ? AppColors.success : AppColors.warning),
        Text(cs.followUpDate ?? '—'),
      ]).toList(),
    ));
  }
}

class _EventsPage extends StatelessWidget {
  const _EventsPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return SectionCard(title: 'Religious Events', child: AppDataTable(
      columns: ['Title', 'Type', 'Date', 'Venue', 'Expected', 'Actual', 'Status'],
      rows: c.events.map((e) => [
        Text(e.title), Text(e.type), Text(e.date), Text(e.venue),
        Text('${e.expectedAttendance}'), Text(e.actualAttendance != null ? '${e.actualAttendance}' : '—'),
        _chip(e.status, e.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _FellowshipsPage extends StatelessWidget {
  const _FellowshipsPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return SectionCard(title: 'Fellowship Groups', child: AppDataTable(
      columns: ['Name', 'Leader', 'Day', 'Time', 'Venue', 'Members'],
      rows: c.fellowships.map((f) => [
        Text(f.name), Text(f.leader), Text(f.day), Text(f.time),
        Text(f.venue), Text('${f.members}'),
      ]).toList(),
    ));
  }
}

class _OutreachPage extends StatelessWidget {
  const _OutreachPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return SectionCard(title: 'Outreach & Charity', child: AppDataTable(
      columns: ['Title', 'Type', 'Date', 'Location', 'Beneficiaries', 'Budget', 'Status'],
      rows: c.outreach.map((o) => [
        Text(o.title), Text(o.type), Text(o.date), Text(o.location),
        Text('${o.beneficiaries}'), Text('GHS ${o.budget.toStringAsFixed(0)}'),
        _chip(o.status, o.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _ChoirPage extends StatelessWidget {
  const _ChoirPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return SectionCard(title: 'Choir & Music', child: AppDataTable(
      columns: ['Name', 'Voice Part', 'Role', 'Class', 'Attendance'],
      rows: c.choir.map((ch) => [
        Text(ch.name), Text(ch.voicePart), Text(ch.role),
        Text(ch.className), Text('${ch.attendance}%'),
      ]).toList(),
    ));
  }
}

class _BaptismPage extends StatelessWidget {
  const _BaptismPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return SectionCard(title: 'Baptism & Dedication', child: AppDataTable(
      columns: ['Name', 'Type', 'Date', 'Officiant', 'Class', 'Parent/Guardian', 'Certificate'],
      rows: c.baptisms.map((b) => [
        Text(b.name), Text(b.type), Text(b.date), Text(b.officiant),
        Text(b.className), Text(b.parentGuardian),
        _chip(b.certificateIssued ? 'Issued' : 'Pending', b.certificateIssued ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChaplainProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Services', value: '${c.services.length}', icon: Icons.church, color: AppColors.primaryLight),
        StatCard(label: 'Prayer Requests', value: '${c.prayerRequests.length}', icon: Icons.pan_tool, color: AppColors.warning),
        StatCard(label: 'Fellowships', value: '${c.fellowships.length}', icon: Icons.groups, color: AppColors.info),
        StatCard(label: 'Outreach Programs', value: '${c.outreach.length}', icon: Icons.volunteer_activism, color: AppColors.accent),
      ]),
    ]);
  }
}
