import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/registry_provider.dart';
import '../../core/state/app_models.dart';
import '../../core/widgets/widgets.dart';

/// Generic dashboard used for roles that don't have a custom implementation yet.
/// Shows relevant stats and a placeholder for the selected page.
class GenericDashboard extends StatelessWidget {
  final String dashboardKey;
  final String dashboardLabel;
  final String pageKey;
  final String pageTitle;

  const GenericDashboard({
    super.key,
    required this.dashboardKey,
    required this.dashboardLabel,
    required this.pageKey,
    required this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show contextual stats based on dashboard type
        _buildStats(context),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: pageTitle,
          child: PlaceholderPage(pageTitle: pageTitle),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    switch (dashboardKey) {
      case 'Admin':
        final r = context.watch<RegistryProvider>();
        return StatCardGrid(cards: [
          StatCard(label: 'Admissions', value: '${r.admissions.length}', icon: Icons.assignment, color: AppColors.primaryLight),
          StatCard(label: 'Pending', value: '${r.pendingAdmissions}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Approved', value: '${r.admissions.where((a) => a.status == AdmissionStatus.approved).length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Staff', value: '${r.staff.length}', icon: Icons.people, color: AppColors.info),
        ]);
      case 'Domestic':
        return StatCardGrid(cards: [
          StatCard(label: 'Boarding Students', value: '—', icon: Icons.bed, color: AppColors.primaryLight),
          StatCard(label: 'Houses', value: '4', icon: Icons.home, color: AppColors.info),
          StatCard(label: 'Buses', value: '3', icon: Icons.directions_bus, color: AppColors.warning),
          StatCard(label: 'Cleaning Staff', value: '—', icon: Icons.cleaning_services, color: AppColors.purple),
        ]);
      case 'Stores':
        return StatCardGrid(cards: [
          StatCard(label: 'Inventory Items', value: '—', icon: Icons.inventory, color: AppColors.primaryLight),
          StatCard(label: 'Low Stock', value: '—', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Pending Requisitions', value: '—', icon: Icons.pending, color: AppColors.danger),
          StatCard(label: 'Suppliers', value: '—', icon: Icons.local_shipping, color: AppColors.info),
        ]);
      case 'Security':
        return StatCardGrid(cards: [
          StatCard(label: 'Gate Log Today', value: '—', icon: Icons.security, color: AppColors.primaryLight),
          StatCard(label: 'Pending Exeats', value: '—', icon: Icons.exit_to_app, color: AppColors.warning),
          StatCard(label: 'Incidents', value: '—', icon: Icons.report, color: AppColors.danger),
          StatCard(label: 'Guards', value: '—', icon: Icons.shield, color: AppColors.info),
        ]);
      case 'House':
      case 'SeniorHousemaster':
        return StatCardGrid(cards: [
          StatCard(label: 'Boarders', value: '—', icon: Icons.bed, color: AppColors.primaryLight),
          StatCard(label: 'Present', value: '—', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Absent', value: '—', icon: Icons.cancel, color: AppColors.danger),
          StatCard(label: 'On Exeat', value: '—', icon: Icons.exit_to_app, color: AppColors.warning),
        ]);
      case 'Catering':
        return StatCardGrid(cards: [
          StatCard(label: 'Meals Today', value: '—', icon: Icons.restaurant, color: AppColors.primaryLight),
          StatCard(label: 'Headcount', value: '—', icon: Icons.people, color: AppColors.info),
          StatCard(label: 'Kitchen Stock', value: '—', icon: Icons.inventory_2, color: AppColors.warning),
          StatCard(label: 'Hygiene Score', value: '—', icon: Icons.cleaning_services, color: AppColors.success),
        ]);
      case 'Health':
        return StatCardGrid(cards: [
          StatCard(label: 'Patients Today', value: '—', icon: Icons.local_hospital, color: AppColors.danger),
          StatCard(label: 'Referrals', value: '—', icon: Icons.forward, color: AppColors.warning),
          StatCard(label: 'Med Stock', value: '—', icon: Icons.medication, color: AppColors.info),
          StatCard(label: 'Records', value: '—', icon: Icons.folder, color: AppColors.primaryLight),
        ]);
      case 'Transport':
        return StatCardGrid(cards: [
          StatCard(label: 'Vehicles', value: '3', icon: Icons.directions_bus, color: AppColors.primaryLight),
          StatCard(label: 'Trips Today', value: '—', icon: Icons.route, color: AppColors.info),
          StatCard(label: 'Maintenance', value: '—', icon: Icons.build, color: AppColors.warning),
          StatCard(label: 'Drivers', value: '—', icon: Icons.person, color: AppColors.purple),
        ]);
      case 'Cleaning':
        return StatCardGrid(cards: [
          StatCard(label: 'Duty Roster', value: '—', icon: Icons.schedule, color: AppColors.primaryLight),
          StatCard(label: 'Tasks', value: '—', icon: Icons.task, color: AppColors.info),
          StatCard(label: 'Supplies', value: '—', icon: Icons.inventory, color: AppColors.warning),
          StatCard(label: 'Issues', value: '—', icon: Icons.report_problem, color: AppColors.danger),
        ]);
      case 'Teacher':
        return StatCardGrid(cards: [
          StatCard(label: 'My Classes', value: '—', icon: Icons.class_, color: AppColors.primaryLight),
          StatCard(label: 'Lesson Plans', value: '—', icon: Icons.menu_book, color: AppColors.info),
          StatCard(label: 'Assignments', value: '—', icon: Icons.assignment, color: AppColors.warning),
          StatCard(label: 'Students', value: '—', icon: Icons.people, color: AppColors.purple),
        ]);
      case 'Student':
        return StatCardGrid(cards: [
          StatCard(label: 'My Class', value: '—', icon: Icons.class_, color: AppColors.primaryLight),
          StatCard(label: 'Assignments', value: '—', icon: Icons.assignment, color: AppColors.warning),
          StatCard(label: 'Attendance', value: '—', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Fees Status', value: '—', icon: Icons.payments, color: AppColors.info),
        ]);
      case 'Parent':
        return StatCardGrid(cards: [
          StatCard(label: 'My Wards', value: '—', icon: Icons.family_restroom, color: AppColors.primaryLight),
          StatCard(label: 'Unread Reports', value: '—', icon: Icons.mail, color: AppColors.warning),
          StatCard(label: 'Upcoming Meetings', value: '—', icon: Icons.event, color: AppColors.info),
          StatCard(label: 'Payments Due', value: '—', icon: Icons.payments, color: AppColors.danger),
        ]);
      case 'SRC':
        return StatCardGrid(cards: [
          StatCard(label: 'Announcements', value: '—', icon: Icons.campaign, color: AppColors.primaryLight),
          StatCard(label: 'Events', value: '—', icon: Icons.event, color: AppColors.info),
          StatCard(label: 'Grievances', value: '—', icon: Icons.feedback, color: AppColors.warning),
          StatCard(label: 'Prefects', value: '—', icon: Icons.star, color: AppColors.accent),
        ]);
      case 'ElectoralCommission':
        return StatCardGrid(cards: [
          StatCard(label: 'Registered Voters', value: '—', icon: Icons.how_to_vote, color: AppColors.primaryLight),
          StatCard(label: 'Candidates', value: '—', icon: Icons.person, color: AppColors.info),
          StatCard(label: 'Votes Cast', value: '—', icon: Icons.check, color: AppColors.success),
          StatCard(label: 'Turnout', value: '—', icon: Icons.percent, color: AppColors.warning),
        ]);
      case 'PTA':
        return StatCardGrid(cards: [
          StatCard(label: 'Members', value: '—', icon: Icons.people, color: AppColors.primaryLight),
          StatCard(label: 'Dues Collected', value: '—', icon: Icons.payments, color: AppColors.success),
          StatCard(label: 'Meetings', value: '—', icon: Icons.event, color: AppColors.info),
          StatCard(label: 'Fundraising', value: '—', icon: Icons.volunteer_activism, color: AppColors.accent),
        ]);
      case 'SystemAdmin':
        return StatCardGrid(cards: [
          StatCard(label: 'Total Users', value: '—', icon: Icons.people, color: AppColors.primaryLight),
          StatCard(label: 'Active Sessions', value: '—', icon: Icons.computer, color: AppColors.success),
          StatCard(label: 'DB Size', value: '—', icon: Icons.storage, color: AppColors.info),
          StatCard(label: 'Backups', value: '—', icon: Icons.backup, color: AppColors.warning),
        ]);
      default:
        return StatCardGrid(cards: [
          StatCard(label: 'Records', value: '—', icon: Icons.dataset, color: AppColors.primaryLight),
          StatCard(label: 'Active', value: '—', icon: Icons.today, color: AppColors.success),
          StatCard(label: 'Pending', value: '—', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Alerts', value: '—', icon: Icons.notifications, color: AppColors.danger),
        ]);
    }
  }
}
