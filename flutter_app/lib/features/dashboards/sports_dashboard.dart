import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/sports_provider.dart';
import '../../core/widgets/widgets.dart';

class SportsDashboard extends StatelessWidget {
  final String pageKey;
  const SportsDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'clubs': return const _ClubsPage();
      case 'fixtures': return const _FixturesPage();
      case 'participation': return const _ParticipationPage();
      case 'equipment': return const _EquipmentPage();
      case 'achievements': return const _AchievementsPage();
      case 'access': return const _AccessPage();
      case 'requisitions': return const _RequisitionsPage();
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

class _ClubsPage extends StatelessWidget {
  const _ClubsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SportsProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Clubs', value: '${s.clubs.length}', icon: Icons.groups, color: AppColors.primaryLight),
        StatCard(label: 'Total Members', value: '${s.totalClubMembers}', icon: Icons.people, color: AppColors.info),
        StatCard(label: 'Upcoming Fixtures', value: '${s.upcomingFixtures}', icon: Icons.event, color: AppColors.warning),
        StatCard(label: 'Achievements', value: '${s.achievements.length}', icon: Icons.emoji_events, color: AppColors.accent),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Clubs & Societies', child: AppDataTable(
        columns: ['Name', 'Category', 'Patron', 'Members', 'Meeting Day'],
        rows: s.clubs.map((c) => [
          Text(c.name), Text(c.category), Text(c.patron),
          Text('${c.memberCount}'), Text(c.meetingDay),
        ]).toList(),
      )),
    ]);
  }
}

class _FixturesPage extends StatelessWidget {
  const _FixturesPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SportsProvider>();
    return SectionCard(title: 'Sports Fixtures', child: AppDataTable(
      columns: ['Date', 'Sport', 'Match', 'Venue', 'Score', 'Result', 'Status'],
      rows: s.fixtures.map((f) => [
        Text(f.date), Text(f.sport), Text(f.match), Text(f.venue),
        Text(f.scoreHome != null ? '${f.scoreHome} - ${f.scoreAway}' : '—'),
        Text(f.result ?? '—'),
        _chip(f.status, f.status == 'Completed' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _ParticipationPage extends StatelessWidget {
  const _ParticipationPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SportsProvider>();
    return SectionCard(title: 'Participation Records', child: AppDataTable(
      columns: ['Date', 'Activity', 'Participants'],
      rows: s.participation.map((p) => [
        Text(p.date), Text(p.activity), Text('${p.participantCount}'),
      ]).toList(),
    ));
  }
}

class _EquipmentPage extends StatelessWidget {
  const _EquipmentPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SportsProvider>();
    return SectionCard(title: 'Equipment & Kits', child: AppDataTable(
      columns: ['Item', 'Qty', 'Condition', 'Location'],
      rows: s.equipment.map((e) => [
        Text(e.item), Text('${e.quantity}'),
        _chip(e.condition, e.condition == 'Good' ? AppColors.success : e.condition == 'Fair' ? AppColors.warning : AppColors.danger),
        Text(e.location),
      ]).toList(),
    ));
  }
}

class _AchievementsPage extends StatelessWidget {
  const _AchievementsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SportsProvider>();
    return SectionCard(title: 'Achievements', child: AppDataTable(
      columns: ['Date', 'Achievement', 'Level', 'Recipients'],
      rows: s.achievements.map((a) => [
        Text(a.date), Text(a.achievement),
        _chip(a.level, a.level == 'Regional' ? AppColors.success : AppColors.info),
        Text(a.recipients ?? '—'),
      ]).toList(),
    ));
  }
}

class _AccessPage extends StatelessWidget {
  const _AccessPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SportsProvider>();
    return SectionCard(title: 'Access Control', child: AppDataTable(
      columns: ['Person', 'Role', 'Resource', 'Access Level', 'Granted Date', 'Granted By'],
      rows: s.accessRecords.map((a) => [
        Text(a.personName), Text(a.role), Text(a.resource),
        _chip(a.accessLevel, a.accessLevel == 'Full' ? AppColors.success : AppColors.info),
        Text(a.grantedDate), Text(a.grantedBy),
      ]).toList(),
    ));
  }
}

class _RequisitionsPage extends StatelessWidget {
  const _RequisitionsPage();
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'Sports Requisitions', child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.inventory_2, size: 48, color: AppColors.textLight),
        const SizedBox(height: AppSpacing.sm),
        Text('No pending requisitions', style: TextStyle(color: AppColors.textSecondary)),
      ]),
    ));
  }
}
