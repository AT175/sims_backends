import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/src_electoral_provider.dart';
import '../../core/widgets/widgets.dart';

class SrcDashboard extends StatelessWidget {
  final String pageKey;
  const SrcDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'announcements': return const _AnnouncementsPage();
      case 'events': return const _EventsPage();
      case 'grievances': return const _GrievancesPage();
      case 'prefects': return const _PrefectsPage();
      case 'budget': return const _BudgetPage();
      case 'initiatives': return const _InitiativesPage();
      case 'feedback': return const _FeedbackPage();
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
    final s = context.watch<SrcProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Announcements', value: '${s.announcements.length}', icon: Icons.campaign, color: AppColors.primaryLight),
        StatCard(label: 'Events', value: '${s.events.length}', icon: Icons.event, color: AppColors.info),
        StatCard(label: 'Open Grievances', value: '${s.grievances.where((g) => g.status != 'Resolved').length}', icon: Icons.report, color: AppColors.warning),
        StatCard(label: 'Prefects', value: '${s.prefects.length}', icon: Icons.badge, color: AppColors.purple),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Active Initiatives', child: AppDataTable(
        columns: ['Title', 'Date', 'Description', 'Status'],
        rows: s.initiatives.where((i) => i.status == 'Active').map((i) => [
          Text(i.title), Text(i.date), Text(i.description),
          _chip(i.status, AppColors.success),
        ]).toList(),
      )),
    ]);
  }
}

class _AnnouncementsPage extends StatelessWidget {
  const _AnnouncementsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SrcProvider>();
    return SectionCard(title: 'Announcements', child: AppDataTable(
      columns: ['Title', 'Date', 'Author', 'Body'],
      rows: s.announcements.map((a) => [
        Text(a.title), Text(a.date), Text(a.author), Text(a.body),
      ]).toList(),
    ));
  }
}

class _EventsPage extends StatelessWidget {
  const _EventsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SrcProvider>();
    return SectionCard(title: 'Event Planner', child: AppDataTable(
      columns: ['Title', 'Date', 'Venue', 'Organizer', 'Budget', 'Status'],
      rows: s.events.map((e) => [
        Text(e.title), Text(e.date), Text(e.venue), Text(e.organizer), Text(e.budget),
        _chip(e.status, e.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _GrievancesPage extends StatelessWidget {
  const _GrievancesPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SrcProvider>();
    return SectionCard(title: 'Grievance Log', child: AppDataTable(
      columns: ['ID', 'Date', 'Class', 'Category', 'Complaint', 'Status', 'Response'],
      rows: s.grievances.map((g) => [
        Text(g.id), Text(g.date), Text(g.className), Text(g.category),
        Text(g.complaint),
        _chip(g.status, g.status == 'Resolved' ? AppColors.success : AppColors.warning),
        Text(g.response.isEmpty ? '—' : g.response),
      ]).toList(),
    ));
  }
}

class _PrefectsPage extends StatelessWidget {
  const _PrefectsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SrcProvider>();
    return SectionCard(title: 'Prefect Roster', child: AppDataTable(
      columns: ['Name', 'Position', 'Class', 'House'],
      rows: s.prefects.map((p) => [
        Text(p.name), Text(p.position), Text(p.className), Text(p.house),
      ]).toList(),
    ));
  }
}

class _BudgetPage extends StatelessWidget {
  const _BudgetPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SrcProvider>();
    return SectionCard(title: 'Budget Tracker', child: AppDataTable(
      columns: ['Category', 'Allocated', 'Spent', 'Remaining'],
      rows: s.budget.map((b) => [
        Text(b.category), Text('GHS ${b.allocated}'), Text('GHS ${b.spent}'), Text('GHS ${b.remaining}'),
      ]).toList(),
    ));
  }
}

class _InitiativesPage extends StatelessWidget {
  const _InitiativesPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SrcProvider>();
    return SectionCard(title: 'Initiatives', child: AppDataTable(
      columns: ['Title', 'Date', 'Description', 'Status'],
      rows: s.initiatives.map((i) => [
        Text(i.title), Text(i.date), Text(i.description),
        _chip(i.status, i.status == 'Active' ? AppColors.success : AppColors.info),
      ]).toList(),
    ));
  }
}

class _FeedbackPage extends StatelessWidget {
  const _FeedbackPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SrcProvider>();
    return SectionCard(title: 'Student Feedback', child: AppDataTable(
      columns: ['ID', 'Date', 'Subject', 'Body', 'Rating'],
      rows: s.feedback.map((f) => [
        Text(f.id), Text(f.date), Text(f.subject), Text(f.body),
        _chip(f.rating, AppColors.accent),
      ]).toList(),
    ));
  }
}

// ── Electoral Commission Dashboard ──

class ElectoralDashboard extends StatelessWidget {
  final String pageKey;
  const ElectoralDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'calendar': return const _ElectionCalendarPage();
      case 'candidates': return const _CandidatesPage();
      case 'voters': return const _VotersPage();
      case 'ballot': return const _BallotPage();
      case 'voting': return _VotingPage();
      case 'reports': return const _ElectionReportsPage();
      case 'settings': return _ElectionSettingsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _ElectionCalendarPage extends StatelessWidget {
  const _ElectionCalendarPage();
  @override
  Widget build(BuildContext context) {
    final e = context.watch<ElectoralProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Elections', value: '${e.calendar.length}', icon: Icons.how_to_vote, color: AppColors.primaryLight),
        StatCard(label: 'Candidates', value: '${e.candidates.length}', icon: Icons.people, color: AppColors.info),
        StatCard(label: 'Pending Approval', value: '${e.pendingCandidates}', icon: Icons.pending, color: AppColors.warning),
        StatCard(label: 'Registered Voters', value: '${e.registeredVoters}', icon: Icons.how_to_reg, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Election Calendar', child: AppDataTable(
        columns: ['Title', 'Date', 'Status', 'Description'],
        rows: e.calendar.map((c) => [
          Text(c.title), Text(c.date),
          _chip(c.status, c.status == 'Scheduled' ? AppColors.warning : AppColors.info),
          Text(c.description),
        ]).toList(),
      )),
    ]);
  }
}

class _CandidatesPage extends StatelessWidget {
  const _CandidatesPage();
  @override
  Widget build(BuildContext context) {
    final e = context.watch<ElectoralProvider>();
    return SectionCard(title: 'Candidate Registration', child: AppDataTable(
      columns: ['Name', 'Position', 'Class', 'Manifesto', 'Approved'],
      rows: e.candidates.map((c) => [
        Text(c.name), Text(c.position), Text(c.className), Text(c.manifesto),
        _chip(c.approved ? 'Yes' : 'Pending', c.approved ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _VotersPage extends StatelessWidget {
  const _VotersPage();
  @override
  Widget build(BuildContext context) {
    final e = context.watch<ElectoralProvider>();
    return SectionCard(title: 'Voter Roll', child: AppDataTable(
      columns: ['Name', 'Class', 'Voter ID', 'Status'],
      rows: e.voters.map((v) => [
        Text(v.name), Text(v.className), Text(v.voterId),
        _chip(v.status, AppColors.success),
      ]).toList(),
    ));
  }
}

class _BallotPage extends StatelessWidget {
  const _BallotPage();
  @override
  Widget build(BuildContext context) {
    final e = context.watch<ElectoralProvider>();
    return SectionCard(title: 'Ballot Management', child: AppDataTable(
      columns: ['Position', 'Candidates', 'Total Votes', 'Status'],
      rows: e.ballots.map((b) => [
        Text(b.position), Text(b.candidates), Text(b.totalVotes),
        _chip(b.status, b.status == 'Open' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _VotingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final e = context.watch<ElectoralProvider>();
    return SectionCard(title: 'Voting & Live Results', child: AppDataTable(
      columns: ['Position', 'Candidates', 'Total Votes', 'Status'],
      rows: e.ballots.map((b) => [
        Text(b.position), Text(b.candidates), Text(b.totalVotes),
        _chip(b.status, b.status == 'Open' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _ElectionReportsPage extends StatelessWidget {
  const _ElectionReportsPage();
  @override
  Widget build(BuildContext context) {
    final e = context.watch<ElectoralProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Elections', value: '${e.calendar.length}', icon: Icons.how_to_vote, color: AppColors.primaryLight),
        StatCard(label: 'Candidates', value: '${e.candidates.length}', icon: Icons.people, color: AppColors.info),
        StatCard(label: 'Voters', value: '${e.registeredVoters}', icon: Icons.how_to_reg, color: AppColors.success),
        StatCard(label: 'Ballot Positions', value: '${e.ballots.length}', icon: Icons.ballot, color: AppColors.purple),
      ]),
    ]);
  }
}

class _ElectionSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'Settings', child: Center(
      child: Text('Election configuration settings.', style: TextStyle(color: AppColors.textSecondary)),
    ));
  }
}
