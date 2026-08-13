import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/system_admin_provider.dart';
import '../../core/widgets/widgets.dart';

class SystemAdminDashboard extends StatelessWidget {
  final String pageKey;
  const SystemAdminDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'users': return const _UsersPage();
      case 'tenant': return const _TenantPage();
      case 'modules': return const _ModulesPage();
      case 'database': return const _DatabasePage();
      case 'backups': return const _BackupsPage();
      case 'logs': return const _LogsPage();
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
    final s = context.watch<SystemAdminProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Users', value: '${s.users.length}', icon: Icons.people, color: AppColors.primaryLight),
        StatCard(label: 'Active Users', value: '${s.activeUsers}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Modules', value: '${s.enabledModules}/${s.modules.length}', icon: Icons.extension, color: AppColors.info),
        StatCard(label: 'DB Status', value: s.dbHealth.status, icon: Icons.storage, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Recent System Logs', child: AppDataTable(
        columns: ['Timestamp', 'Level', 'Source', 'Message'],
        rows: s.logs.take(8).map((l) => [
          Text(l.timestamp),
          _chip(l.level, l.level == 'ERROR' ? AppColors.danger : l.level == 'WARN' ? AppColors.warning : AppColors.info),
          Text(l.source), Text(l.message),
        ]).toList(),
      )),
    ]);
  }
}

class _UsersPage extends StatelessWidget {
  const _UsersPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SystemAdminProvider>();
    return SectionCard(title: 'User Management', child: AppDataTable(
      columns: ['Username', 'Display Name', 'Email', 'Roles', 'Status', 'Last Login'],
      rows: s.users.map((u) => [
        Text(u.username), Text(u.displayName), Text(u.email),
        Text(u.roles.join(', ')),
        _chip(u.status, u.status == 'Active' ? AppColors.success : AppColors.danger),
        Text(u.lastLogin ?? '—'),
      ]).toList(),
    ));
  }
}

class _TenantPage extends StatelessWidget {
  const _TenantPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SystemAdminProvider>();
    final t = s.tenant;
    return SectionCard(title: 'School Configuration', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _infoRow('School Name', t.schoolName),
      _infoRow('School Code', t.schoolCode),
      _infoRow('Region', t.region),
      _infoRow('District', t.district),
      _infoRow('Address', t.address),
      _infoRow('Phone', t.phone),
      _infoRow('Email', t.email),
      _infoRow('Academic Year', t.academicYear),
      _infoRow('Current Term', t.term),
      _infoRow('Max Students', '${t.maxStudents}'),
      _infoRow('Max Staff', '${t.maxStaff}'),
      _infoRow('Subscription', '${t.subscriptionPlan} (expires ${t.subscriptionExpiry})'),
      _infoRow('Enabled Modules', '${t.enabledModules.length} modules'),
    ]));
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 160, child: Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm))),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _ModulesPage extends StatelessWidget {
  const _ModulesPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SystemAdminProvider>();
    return SectionCard(title: 'Modules', child: AppDataTable(
      columns: ['Module', 'Version', 'Enabled', 'Last Updated', 'Health'],
      rows: s.modules.map((m) => [
        Text(m.name), Text(m.version),
        _chip(m.enabled ? 'Enabled' : 'Disabled', m.enabled ? AppColors.success : AppColors.textLight),
        Text(m.lastUpdated),
        _chip(m.health, m.health == 'Healthy' ? AppColors.success : m.health == 'Degraded' ? AppColors.warning : AppColors.danger),
      ]).toList(),
    ));
  }
}

class _DatabasePage extends StatelessWidget {
  const _DatabasePage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SystemAdminProvider>();
    final d = s.dbHealth;
    return SectionCard(title: 'Database & Sync', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _infoRow('Status', d.status),
      _infoRow('Connection Latency', d.connectionLatency),
      _infoRow('Active Connections', '${d.activeConnections}'),
      _infoRow('Total Records', '${d.totalRecords}'),
      _infoRow('Last Sync', d.lastSync),
      _infoRow('Pending Changes', '${d.pendingChanges}'),
      _infoRow('Failed Syncs', '${d.failedSyncs}'),
      _infoRow('Storage Used', d.storageUsed),
    ]));
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 180, child: Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm))),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _BackupsPage extends StatelessWidget {
  const _BackupsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SystemAdminProvider>();
    return SectionCard(title: 'Backups', child: AppDataTable(
      columns: ['Timestamp', 'Type', 'Size', 'Status', 'Performed By'],
      rows: s.backups.map((b) => [
        Text(b.timestamp), Text(b.type), Text(b.size),
        _chip(b.status, b.status == 'Success' ? AppColors.success : AppColors.danger),
        Text(b.performedBy),
      ]).toList(),
    ));
  }
}

class _LogsPage extends StatelessWidget {
  const _LogsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SystemAdminProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Logs', value: '${s.logs.length}', icon: Icons.receipt_long, color: AppColors.primaryLight),
        StatCard(label: 'Errors', value: '${s.errorLogs}', icon: Icons.error, color: AppColors.danger),
        StatCard(label: 'Warnings', value: '${s.warnLogs}', icon: Icons.warning, color: AppColors.warning),
        StatCard(label: 'Info', value: '${s.logs.where((l) => l.level == 'INFO').length}', icon: Icons.info, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'System Logs', child: AppDataTable(
        columns: ['Timestamp', 'Level', 'Source', 'Message', 'User'],
        rows: s.logs.map((l) => [
          Text(l.timestamp),
          _chip(l.level, l.level == 'ERROR' ? AppColors.danger : l.level == 'WARN' ? AppColors.warning : AppColors.info),
          Text(l.source), Text(l.message), Text(l.user ?? '—'),
        ]).toList(),
      )),
    ]);
  }
}
