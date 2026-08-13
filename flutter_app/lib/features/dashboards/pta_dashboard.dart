import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/pta_provider.dart';
import '../../core/widgets/widgets.dart';

class PtaDashboard extends StatelessWidget {
  final String pageKey;
  const PtaDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'wards': return const _WardsPage();
      case 'announcements': return const _AnnouncementsPage();
      case 'fundraising': return const _FundraisingPage();
      case 'meetings': return const _MeetingsPage();
      case 'directory': return const _DirectoryPage();
      case 'dues': return const _DuesPage();
      case 'finance': return const _FinancePage();
      case 'feedback': return const _FeedbackPage();
      case 'access': return const _AccessPage();
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
    final p = context.watch<PtaProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'My Wards', value: '${p.wards.length}', icon: Icons.family_restroom, color: AppColors.primaryLight),
        StatCard(label: 'Fundraising Target', value: 'GHS ${p.totalTarget.toStringAsFixed(0)}', icon: Icons.volunteer_activism, color: AppColors.accent),
        StatCard(label: 'Raised', value: 'GHS ${p.totalRaised.toStringAsFixed(0)}', icon: Icons.savings, color: AppColors.success),
        StatCard(label: 'Upcoming Meetings', value: '${p.meetings.length}', icon: Icons.event, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'My Ward(s)', child: AppDataTable(
        columns: ['Name', 'Class', 'House', 'Attendance', 'Avg Score', 'Fees'],
        rows: p.wards.map((w) => [
          Text(w.name), Text(w.className), Text(w.house),
          Text(w.attendance), Text(w.avgScore),
          _chip(w.feesStatus, w.feesStatus == 'Cleared' ? AppColors.success : AppColors.warning),
        ]).toList(),
      )),
    ]);
  }
}

class _AnnouncementsPage extends StatelessWidget {
  const _AnnouncementsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PtaProvider>();
    return SectionCard(title: 'Announcements', child: AppDataTable(
      columns: ['Title', 'Date', 'Author'],
      rows: p.announcements.map((a) => [
        Text(a.title), Text(a.date), Text(a.author),
      ]).toList(),
    ));
  }
}

class _FundraisingPage extends StatelessWidget {
  const _FundraisingPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PtaProvider>();
    return SectionCard(title: 'Fundraising Projects', child: AppDataTable(
      columns: ['Project', 'Target', 'Raised', 'Progress'],
      rows: p.fundraising.map((f) => [
        Text(f.project),
        Text('GHS ${f.targetAmount.toStringAsFixed(0)}'),
        Text('GHS ${f.raisedAmount.toStringAsFixed(0)}'),
        Text('${(f.raisedAmount / f.targetAmount * 100).toStringAsFixed(0)}%'),
      ]).toList(),
    ));
  }
}

class _MeetingsPage extends StatelessWidget {
  const _MeetingsPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PtaProvider>();
    return SectionCard(title: 'Meetings & RSVP', child: AppDataTable(
      columns: ['Date', 'Time', 'Topic', 'Location', 'RSVP'],
      rows: p.meetings.map((m) => [
        Text(m.date), Text(m.time), Text(m.topic), Text(m.location),
        _chip(m.rsvp, AppColors.warning),
      ]).toList(),
    ));
  }
}

class _DirectoryPage extends StatelessWidget {
  const _DirectoryPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PtaProvider>();
    return SectionCard(title: 'Parent Directory', child: AppDataTable(
      columns: ['Name', 'Phone', 'PTA Role', 'Ward(s)'],
      rows: p.directory.map((d) => [
        Text(d.name), Text(d.phone), Text(d.ptaRole), Text(d.wardNames),
      ]).toList(),
    ));
  }
}

class _DuesPage extends StatelessWidget {
  const _DuesPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PtaProvider>();
    return SectionCard(title: 'PTA Dues', child: AppDataTable(
      columns: ['Term', 'Amount', 'Paid', 'Status', 'Due Date', 'Paid Date', 'Method'],
      rows: p.dues.map((d) => [
        Text(d.term), Text('GHS ${d.amount.toStringAsFixed(0)}'),
        Text('GHS ${d.amountPaid.toStringAsFixed(0)}'),
        _chip(d.status, d.status == 'Paid' ? AppColors.success : AppColors.warning),
        Text(d.dueDate), Text(d.paidDate ?? '—'), Text(d.method ?? '—'),
      ]).toList(),
    ));
  }
}

class _FinancePage extends StatelessWidget {
  const _FinancePage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PtaProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Income', value: 'GHS ${p.totalIncome.toStringAsFixed(0)}', icon: Icons.trending_up, color: AppColors.success),
        StatCard(label: 'Total Expense', value: 'GHS ${p.totalExpense.toStringAsFixed(0)}', icon: Icons.trending_down, color: AppColors.danger),
        StatCard(label: 'Balance', value: 'GHS ${(p.totalIncome - p.totalExpense).toStringAsFixed(0)}', icon: Icons.account_balance, color: AppColors.primaryLight),
        StatCard(label: 'Budgets', value: '${p.budgets.length}', icon: Icons.account_balance_wallet, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Transactions', child: AppDataTable(
        columns: ['Date', 'Type', 'Category', 'Description', 'Amount', 'Method'],
        rows: p.transactions.map((t) => [
          Text(t.date), Text(t.type), Text(t.category), Text(t.description),
          Text('GHS ${t.amount.toStringAsFixed(0)}'), Text(t.method),
        ]).toList(),
      )),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Budgets', child: AppDataTable(
        columns: ['Name', 'Term', 'Allocated', 'Spent', 'Remaining'],
        rows: p.budgets.map((b) => [
          Text(b.name), Text(b.term),
          Text('GHS ${b.allocated.toStringAsFixed(0)}'),
          Text('GHS ${b.spent.toStringAsFixed(0)}'),
          Text('GHS ${(b.allocated - b.spent).toStringAsFixed(0)}'),
        ]).toList(),
      )),
    ]);
  }
}

class _FeedbackPage extends StatelessWidget {
  const _FeedbackPage();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<PtaProvider>();
    return SectionCard(title: 'Feedback', child: AppDataTable(
      columns: ['Date', 'Subject', 'Body', 'Status', 'Response'],
      rows: p.feedback.map((f) => [
        Text(f.date), Text(f.subject), Text(f.body),
        _chip(f.status, f.status == 'Acknowledged' ? AppColors.success : AppColors.warning),
        Text(f.response ?? '—'),
      ]).toList(),
    ));
  }
}

class _AccessPage extends StatelessWidget {
  const _AccessPage();
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'Access Control', child: Center(
      child: Text('Access managed by System Administrator', style: TextStyle(color: AppColors.textSecondary)),
    ));
  }
}
