import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/misc_providers.dart';
import '../../core/widgets/widgets.dart';

class StaffDashboard extends StatelessWidget {
  final String pageKey;
  const StaffDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _StaffOverviewPage();
      case 'notice': return const _StaffNoticePage();
      case 'minutes': return const _StaffMinutesPage();
      case 'resources': return const _StaffResourcesPage();
      case 'leave': return const _StaffLeavePage();
      case 'directory': return const _StaffDirectoryPage();
      case 'reports': return const _StaffReportsPage();
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

class _StaffOverviewPage extends StatelessWidget {
  const _StaffOverviewPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StaffProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Notices', value: '${s.notices.length}', icon: Icons.campaign, color: AppColors.primaryLight),
        StatCard(label: 'Pending Leave', value: '${s.pendingLeave}', icon: Icons.pending_actions, color: AppColors.warning),
        StatCard(label: 'Resources', value: '${s.resources.length}', icon: Icons.folder, color: AppColors.info),
        StatCard(label: 'Staff', value: '${s.directory.length}', icon: Icons.people, color: AppColors.purple),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Recent Notices', child: AppDataTable(
        columns: ['Title', 'Date', 'Author', 'Priority'],
        rows: s.notices.take(5).map((n) => [
          Text(n.title), Text(n.date), Text(n.author),
          _chip(n.priority, n.priority == 'Urgent' ? AppColors.danger : n.priority == 'Important' ? AppColors.warning : AppColors.info),
        ]).toList(),
      )),
    ]);
  }
}

class _StaffNoticePage extends StatelessWidget {
  const _StaffNoticePage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StaffProvider>();
    return SectionCard(title: 'Staff Notice Board', child: AppDataTable(
      columns: ['Title', 'Date', 'Author', 'Priority', 'Body'],
      rows: s.notices.map((n) => [
        Text(n.title), Text(n.date), Text(n.author),
        _chip(n.priority, n.priority == 'Urgent' ? AppColors.danger : n.priority == 'Important' ? AppColors.warning : AppColors.info),
        Text(n.body),
      ]).toList(),
    ));
  }
}

class _StaffMinutesPage extends StatelessWidget {
  const _StaffMinutesPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StaffProvider>();
    return SectionCard(title: 'Meeting Minutes', child: AppDataTable(
      columns: ['Title', 'Date', 'Attendees', 'Facilitator', 'Summary'],
      rows: s.minutes.map((m) => [
        Text(m.title), Text(m.date), Text(m.attendees), Text(m.facilitator), Text(m.summary),
      ]).toList(),
    ));
  }
}

class _StaffResourcesPage extends StatelessWidget {
  const _StaffResourcesPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StaffProvider>();
    return SectionCard(title: 'Resource Library', child: AppDataTable(
      columns: ['Title', 'Type', 'Uploaded By', 'Date', 'File Size'],
      rows: s.resources.map((r) => [
        Text(r.title), Text(r.type), Text(r.uploadedBy), Text(r.date), Text(r.fileSize),
      ]).toList(),
    ));
  }
}

class _StaffLeavePage extends StatelessWidget {
  const _StaffLeavePage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StaffProvider>();
    return SectionCard(title: 'Leave Requests', child: AppDataTable(
      columns: ['ID', 'Staff', 'Type', 'Start', 'End', 'Days', 'Reason', 'Status'],
      rows: s.leaveRequests.map((l) => [
        Text(l.id), Text(l.staffName), Text(l.type), Text(l.startDate), Text(l.endDate),
        Text(l.days), Text(l.reason),
        _chip(l.status, l.status == 'Approved' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _StaffDirectoryPage extends StatelessWidget {
  const _StaffDirectoryPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StaffProvider>();
    return SectionCard(title: 'Staff Directory', child: AppDataTable(
      columns: ['Name', 'Position', 'Department', 'Phone', 'Email'],
      rows: s.directory.map((d) => [
        Text(d.name), Text(d.position), Text(d.department), Text(d.phone), Text(d.email),
      ]).toList(),
    ));
  }
}

class _StaffReportsPage extends StatelessWidget {
  const _StaffReportsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StaffProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Notices', value: '${s.notices.length}', icon: Icons.campaign, color: AppColors.primaryLight),
        StatCard(label: 'Minutes', value: '${s.minutes.length}', icon: Icons.receipt, color: AppColors.info),
        StatCard(label: 'Resources', value: '${s.resources.length}', icon: Icons.folder, color: AppColors.purple),
        StatCard(label: 'Leave Requests', value: '${s.leaveRequests.length}', icon: Icons.event_busy, color: AppColors.warning),
      ]),
    ]);
  }
}

// ── Subject HOD Dashboard ──

class SubjectHodDashboard extends StatelessWidget {
  final String pageKey;
  const SubjectHodDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _HodOverviewPage();
      case 'syllabus': return const _HodSyllabusPage();
      case 'lesson': return const _HodLessonPage();
      case 'exam': return const _HodExamPage();
      case 'results': return const _HodResultsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _HodOverviewPage extends StatelessWidget {
  const _HodOverviewPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HodProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Department', value: h.department, icon: Icons.account_balance, color: AppColors.primaryLight),
        StatCard(label: 'Syllabus Topics', value: '${h.syllabus.length}', icon: Icons.menu_book, color: AppColors.info),
        StatCard(label: 'Pending Plans', value: '${h.lessonPlans.where((p) => p.status == 'Pending').length}', icon: Icons.pending, color: AppColors.warning),
        StatCard(label: 'Exams', value: '${h.exams.length}', icon: Icons.school, color: AppColors.purple),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Syllabus Progress', child: AppDataTable(
        columns: ['Week', 'Topic', 'Status'],
        rows: h.syllabus.take(5).map((s) => [
          Text('W${s.week}'), Text(s.topic),
          _chip(s.status, s.status == 'Completed' ? AppColors.success : s.status == 'In Progress' ? AppColors.warning : AppColors.info),
        ]).toList(),
      )),
    ]);
  }
}

class _HodSyllabusPage extends StatelessWidget {
  const _HodSyllabusPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HodProvider>();
    return SectionCard(title: 'Syllabus Tracker', child: AppDataTable(
      columns: ['Subject', 'Class', 'Week', 'Topic', 'Sub-Topics', 'Status'],
      rows: h.syllabus.map((s) => [
        Text(s.subject), Text(s.classForm), Text('W${s.week}'), Text(s.topic), Text(s.subTopics),
        _chip(s.status, s.status == 'Completed' ? AppColors.success : s.status == 'In Progress' ? AppColors.warning : AppColors.info),
      ]).toList(),
    ));
  }
}

class _HodLessonPage extends StatelessWidget {
  const _HodLessonPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HodProvider>();
    return SectionCard(title: 'Lesson Plan Review', child: AppDataTable(
      columns: ['Date', 'Teacher', 'Subject', 'Class', 'Topic', 'Status', 'Notes'],
      rows: h.lessonPlans.map((l) => [
        Text(l.date), Text(l.teacher), Text(l.subject), Text(l.classForm), Text(l.topic),
        _chip(l.status, l.status == 'Approved' ? AppColors.success : AppColors.warning),
        Text(l.notes.isEmpty ? '—' : l.notes),
      ]).toList(),
    ));
  }
}

class _HodExamPage extends StatelessWidget {
  const _HodExamPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HodProvider>();
    return SectionCard(title: 'Internal Exam Setting', child: AppDataTable(
      columns: ['Exam', 'Subject', 'Class', 'Date', 'Duration', 'Max Score', 'Status'],
      rows: h.exams.map((e) => [
        Text(e.examName), Text(e.subject), Text(e.classForm), Text(e.date),
        Text(e.duration), Text(e.maxScore),
        _chip(e.status, e.status.contains('Approved') ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _HodResultsPage extends StatelessWidget {
  const _HodResultsPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HodProvider>();
    return SectionCard(title: 'Result Entry', child: AppDataTable(
      columns: ['Exam', 'Subject', 'Class', 'Students', 'Average', 'Highest', 'Lowest', 'Pass Rate'],
      rows: h.results.map((r) => [
        Text(r.examName), Text(r.subject), Text(r.classForm), Text(r.students),
        Text(r.average), Text(r.highest), Text(r.lowest),
        _chip(r.passRate, AppColors.success),
      ]).toList(),
    ));
  }
}

// ── Governing Board Dashboard ──

class GoverningBoardDashboard extends StatelessWidget {
  final String pageKey;
  const GoverningBoardDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _BoardOverviewPage();
      case 'policy': return const _BoardPolicyPage();
      case 'budget': return const _BoardBudgetPage();
      case 'minutes': return const _BoardMinutesPage();
      case 'reports': return const _BoardReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _BoardOverviewPage extends StatelessWidget {
  const _BoardOverviewPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<GoverningBoardProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Policies', value: '${b.policies.length}', icon: Icons.policy, color: AppColors.primaryLight),
        StatCard(label: 'Budgets', value: '${b.budgets.length}', icon: Icons.account_balance, color: AppColors.info),
        StatCard(label: 'Meetings', value: '${b.minutes.length}', icon: Icons.groups, color: AppColors.purple),
        StatCard(label: 'Reports', value: '${b.reports.length}', icon: Icons.assessment, color: AppColors.accent),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Recent Reports', child: AppDataTable(
        columns: ['Title', 'Date', 'Author', 'Category'],
        rows: b.reports.take(5).map((r) => [
          Text(r.title), Text(r.date), Text(r.author), Text(r.category),
        ]).toList(),
      )),
    ]);
  }
}

class _BoardPolicyPage extends StatelessWidget {
  const _BoardPolicyPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<GoverningBoardProvider>();
    return SectionCard(title: 'Policy Documents', child: AppDataTable(
      columns: ['Title', 'Category', 'Date Approved', 'Status', 'Description'],
      rows: b.policies.map((p) => [
        Text(p.title), Text(p.category), Text(p.dateApproved),
        _chip(p.status, p.status == 'Active' ? AppColors.success : AppColors.warning),
        Text(p.description),
      ]).toList(),
    ));
  }
}

class _BoardBudgetPage extends StatelessWidget {
  const _BoardBudgetPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<GoverningBoardProvider>();
    return SectionCard(title: 'Budget Approvals', child: AppDataTable(
      columns: ['Department', 'Allocated', 'Approved', 'Spent', 'Remaining', 'Fiscal Year', 'Status'],
      rows: b.budgets.map((b2) => [
        Text(b2.department), Text('GHS ${b2.allocated}'), Text('GHS ${b2.approved}'),
        Text('GHS ${b2.spent}'), Text('GHS ${b2.remaining}'), Text(b2.fiscalYear),
        _chip(b2.status, b2.status == 'Active' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _BoardMinutesPage extends StatelessWidget {
  const _BoardMinutesPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<GoverningBoardProvider>();
    return SectionCard(title: 'Meeting Minutes', child: AppDataTable(
      columns: ['Title', 'Date', 'Attendees', 'Chair', 'Summary'],
      rows: b.minutes.map((m) => [
        Text(m.title), Text(m.date), Text(m.attendees), Text(m.chair), Text(m.summary),
      ]).toList(),
    ));
  }
}

class _BoardReportsPage extends StatelessWidget {
  const _BoardReportsPage();
  @override
  Widget build(BuildContext context) {
    final b = context.watch<GoverningBoardProvider>();
    return SectionCard(title: 'Reports', child: AppDataTable(
      columns: ['Title', 'Date', 'Author', 'Category', 'Summary'],
      rows: b.reports.map((r) => [
        Text(r.title), Text(r.date), Text(r.author), Text(r.category), Text(r.summary),
      ]).toList(),
    ));
  }
}

// ── Welfare Committee Dashboard ──

class WelfareDashboard extends StatelessWidget {
  final String pageKey;
  const WelfareDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'ledger': return const _WelfareLedgerPage();
      case 'support': return const _WelfareSupportPage();
      case 'disbursement': return const _WelfareDisbursementPage();
      case 'membership': return const _WelfareMembershipPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _WelfareLedgerPage extends StatelessWidget {
  const _WelfareLedgerPage();
  @override
  Widget build(BuildContext context) {
    final w = context.watch<WelfareProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Balance', value: 'GHS ${w.totalBalance.toStringAsFixed(0)}', icon: Icons.account_balance, color: AppColors.primaryLight),
        StatCard(label: 'Transactions', value: '${w.ledger.length}', icon: Icons.receipt, color: AppColors.info),
        StatCard(label: 'Pending Requests', value: '${w.pendingRequests}', icon: Icons.pending, color: AppColors.warning),
        StatCard(label: 'Members', value: '${w.members.length}', icon: Icons.people, color: AppColors.purple),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Welfare Fund Ledger', child: AppDataTable(
        columns: ['Date', 'Type', 'Description', 'Amount', 'Balance', 'Recorded By'],
        rows: w.ledger.map((t) => [
          Text(t.date),
          _chip(t.type, t.type == 'Income' ? AppColors.success : AppColors.danger),
          Text(t.description), Text('GHS ${t.amount}'), Text('GHS ${t.balance}'), Text(t.recordedBy),
        ]).toList(),
      )),
    ]);
  }
}

class _WelfareSupportPage extends StatelessWidget {
  const _WelfareSupportPage();
  @override
  Widget build(BuildContext context) {
    final w = context.watch<WelfareProvider>();
    return SectionCard(title: 'Support Requests', child: AppDataTable(
      columns: ['ID', 'Date', 'Beneficiary', 'Amount', 'Reason', 'Category', 'Status', 'Approved By'],
      rows: w.supportRequests.map((s) => [
        Text(s.id), Text(s.date), Text(s.beneficiary), Text('GHS ${s.amount}'),
        Text(s.reason), Text(s.category),
        _chip(s.status, s.status == 'Approved' ? AppColors.success : AppColors.warning),
        Text(s.approvedBy.isEmpty ? '—' : s.approvedBy),
      ]).toList(),
    ));
  }
}

class _WelfareDisbursementPage extends StatelessWidget {
  const _WelfareDisbursementPage();
  @override
  Widget build(BuildContext context) {
    final w = context.watch<WelfareProvider>();
    return SectionCard(title: 'Disbursement Approvals', child: AppDataTable(
      columns: ['ID', 'Date', 'Beneficiary', 'Amount', 'Purpose', 'Approved By', 'Disbursed Date', 'Status'],
      rows: w.disbursements.map((d) => [
        Text(d.id), Text(d.date), Text(d.beneficiary), Text('GHS ${d.amount}'),
        Text(d.purpose), Text(d.approvedBy), Text(d.disbursedDate),
        _chip(d.status, d.status == 'Disbursed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _WelfareMembershipPage extends StatelessWidget {
  const _WelfareMembershipPage();
  @override
  Widget build(BuildContext context) {
    final w = context.watch<WelfareProvider>();
    return SectionCard(title: 'Membership Register', child: AppDataTable(
      columns: ['Name', 'Role', 'Contribution', 'Join Date', 'Status'],
      rows: w.members.map((m) => [
        Text(m.name), Text(m.role), Text('GHS ${m.contribution}'),
        Text(m.joinDate), _chip(m.status, AppColors.success),
      ]).toList(),
    ));
  }
}
