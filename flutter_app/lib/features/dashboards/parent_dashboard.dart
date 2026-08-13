import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/parent_provider.dart';
import '../../core/widgets/widgets.dart';

class ParentDashboard extends StatelessWidget {
  final String pageKey;
  const ParentDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'wards': return const _WardsPage();
      case 'academic': return const _AcademicPage();
      case 'attendance': return const _AttendancePage();
      case 'exeats': return const _ExeatsPage();
      case 'discipline': return const _DisciplinePage();
      case 'health': return _HealthPage();
      case 'announcements': return const _AnnouncementsPage();
      case 'meetings': return const _MeetingsPage();
      case 'payments': return const _PaymentsPage();
      case 'fundraising': return const _FundraisingPage();
      case 'feedback': return _FeedbackPage();
      case 'directory': return const _DirectoryPage();
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

class _WardsPage extends StatelessWidget {
  const _WardsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'My Children', value: '${p.wards.length}', icon: Icons.family_restroom, color: AppColors.primaryLight),
        StatCard(label: 'Fees Cleared', value: '${p.wards.where((w) => w.feesStatus == 'Cleared').length}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Fees Pending', value: '${p.wards.where((w) => w.feesStatus != 'Cleared').length}', icon: Icons.pending, color: AppColors.warning),
        StatCard(label: 'Health Alerts', value: '${p.wards.where((w) => w.healthAlert != null).length}', icon: Icons.health_and_safety, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'My Children', child: AppDataTable(
        columns: ['Name', 'Adm No', 'Class', 'House', 'Attendance', 'Avg Score', 'Last Grade', 'Fees', 'Health'],
        rows: p.wards.map((w) => [
          Text(w.name), Text(w.admNo), Text(w.className), Text(w.house),
          Text(w.attendancePct), Text(w.avgScore),
          _chip(w.lastGrade, w.lastGrade == 'A1' ? AppColors.success : AppColors.info),
          _chip(w.feesStatus, w.feesStatus == 'Cleared' ? AppColors.success : AppColors.warning),
          Text(w.healthAlert ?? '—'),
        ]).toList(),
      )),
    ]);
  }
}

class _AcademicPage extends StatelessWidget {
  const _AcademicPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Academic Reports', child: AppDataTable(
      columns: ['Term', 'Subject', 'Score', 'Max', 'Grade', 'Class Avg', 'Remarks'],
      rows: p.academicReports.map((r) => [
        Text(r.term), Text(r.subject), Text(r.score), Text(r.maxScore),
        _chip(r.grade, r.grade == 'A1' ? AppColors.success : r.grade == 'B2' ? AppColors.info : AppColors.warning),
        Text(r.classAvg), Text(r.remarks),
      ]).toList(),
    ));
  }
}

class _AttendancePage extends StatelessWidget {
  const _AttendancePage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Attendance', child: AppDataTable(
      columns: ['Term', 'Total Days', 'Present', 'Absent', 'Late', 'Percentage'],
      rows: p.attendance.map((a) => [
        Text(a.term), Text(a.totalDays), Text(a.present), Text(a.absent), Text(a.late),
        _chip(a.percentage, AppColors.success),
      ]).toList(),
    ));
  }
}

class _ExeatsPage extends StatelessWidget {
  const _ExeatsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Exeats', child: AppDataTable(
      columns: ['Exeat No', 'Student', 'Reason', 'Departure', 'Return', 'Status'],
      rows: p.exeats.map((e) => [
        Text(e.exeatNo), Text(e.studentName), Text(e.reason),
        Text(e.departureDate), Text(e.returnDate),
        _chip(e.status, e.status == 'Approved' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _DisciplinePage extends StatelessWidget {
  const _DisciplinePage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Discipline & Welfare', child: AppDataTable(
      columns: ['Date', 'Student', 'Incident', 'Severity', 'Action'],
      rows: p.discipline.map((d) => [
        Text(d.date), Text(d.studentName), Text(d.incident),
        _chip(d.severity, d.severity == 'Minor' ? AppColors.info : AppColors.warning),
        Text(d.action),
      ]).toList(),
    ));
  }
}

class _HealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'Health Records', child: Center(
      child: Text('Health records available in the Sick Bay.', style: TextStyle(color: AppColors.textSecondary)),
    ));
  }
}

class _AnnouncementsPage extends StatelessWidget {
  const _AnnouncementsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Announcements', child: AppDataTable(
      columns: ['Title', 'Date', 'Author', 'Body'],
      rows: p.announcements.map((a) => [
        Text(a.title), Text(a.date), Text(a.author), Text(a.body),
      ]).toList(),
    ));
  }
}

class _MeetingsPage extends StatelessWidget {
  const _MeetingsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Meetings & RSVP', child: AppDataTable(
      columns: ['Date', 'Time', 'Topic', 'Location', 'RSVP'],
      rows: p.meetings.map((m) => [
        Text(m.date), Text(m.time), Text(m.topic), Text(m.location),
        _chip(m.rsvp, AppColors.warning),
      ]).toList(),
    ));
  }
}

class _PaymentsPage extends StatelessWidget {
  const _PaymentsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Payments', child: AppDataTable(
      columns: ['Date', 'Description', 'Amount', 'Method', 'Term', 'Status'],
      rows: p.payments.map((pmt) => [
        Text(pmt.date), Text(pmt.description), Text('GHS ${pmt.amount}'),
        Text(pmt.method), Text(pmt.term),
        _chip(pmt.status, pmt.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _FundraisingPage extends StatelessWidget {
  const _FundraisingPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Fundraising', child: AppDataTable(
      columns: ['Project', 'Target', 'Raised', 'My Contribution'],
      rows: p.fundraising.map((f) => [
        Text(f.project), Text('GHS ${f.targetAmount}'), Text('GHS ${f.raisedAmount}'),
        Text('GHS ${f.myContribution}'),
      ]).toList(),
    ));
  }
}

class _FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'Feedback', child: Center(
      child: Text('Submit feedback through the PTA dashboard.', style: TextStyle(color: AppColors.textSecondary)),
    ));
  }
}

class _DirectoryPage extends StatelessWidget {
  const _DirectoryPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ParentProvider>();
    return SectionCard(title: 'Parent Directory', child: AppDataTable(
      columns: ['Name', 'Phone', 'Ward', 'Ward Class'],
      rows: p.directory.map((d) => [
        Text(d.name), Text(d.phone), Text(d.wardName), Text(d.wardClass),
      ]).toList(),
    ));
  }
}
