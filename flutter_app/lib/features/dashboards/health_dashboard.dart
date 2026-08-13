import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/health_provider.dart';
import '../../core/widgets/widgets.dart';

class HealthDashboard extends StatelessWidget {
  final String pageKey;
  const HealthDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'patients': return const _PatientsPage();
      case 'inventory': return const _InventoryPage();
      case 'referrals': return const _ReferralsPage();
      case 'records': return const _RecordsPage();
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

class _PatientsPage extends StatelessWidget {
  const _PatientsPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HealthProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Today\'s Visits', value: '${h.todayVisits}', icon: Icons.local_hospital, color: AppColors.danger),
        StatCard(label: 'Total Visits', value: '${h.visits.length}', icon: Icons.receipt, color: AppColors.primaryLight),
        StatCard(label: 'Referrals', value: '${h.pendingReferrals}', icon: Icons.forward, color: AppColors.warning),
        StatCard(label: 'Low Stock', value: '${h.lowStockMeds}', icon: Icons.medication, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Patient Log', child: AppDataTable(
        columns: ['Date', 'Time', 'Student', 'Class', 'Complaint', 'Diagnosis', 'Treatment', 'Attendant', 'Status'],
        rows: h.visits.map((v) => [
          Text(v.date), Text(v.time), Text(v.studentName), Text(v.className),
          Text(v.complaint), Text(v.diagnosis), Text(v.treatment), Text(v.attendant),
          _chip(v.status, v.status == 'Treated' ? AppColors.success : AppColors.warning),
        ]).toList(),
      )),
    ]);
  }
}

class _InventoryPage extends StatelessWidget {
  const _InventoryPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HealthProvider>();
    return SectionCard(title: 'Medical Inventory', child: AppDataTable(
      columns: ['Item', 'Category', 'Qty', 'Unit', 'Reorder Level', 'Unit Price', 'Expiry', 'Status'],
      rows: h.meds.map((m) => [
        Text(m.name), Text(m.category), Text('${m.quantity}'), Text(m.unit),
        Text('${m.reorderLevel}'), Text('GHS ${m.unitPrice}'), Text(m.expiryDate),
        _chip(m.quantity <= m.reorderLevel ? 'Low Stock' : 'In Stock', m.quantity <= m.reorderLevel ? AppColors.warning : AppColors.success),
      ]).toList(),
    ));
  }
}

class _ReferralsPage extends StatelessWidget {
  const _ReferralsPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HealthProvider>();
    return SectionCard(title: 'Referral Tracker', child: AppDataTable(
      columns: ['Date', 'Student', 'Class', 'Destination', 'Reason', 'Referred By', 'Status', 'Feedback'],
      rows: h.referrals.map((r) => [
        Text(r.date), Text(r.studentName), Text(r.className), Text(r.destination),
        Text(r.reason), Text(r.referredBy),
        _chip(r.status, r.status == 'Completed' ? AppColors.success : AppColors.warning),
        Text(r.feedback ?? '—'),
      ]).toList(),
    ));
  }
}

class _RecordsPage extends StatelessWidget {
  const _RecordsPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HealthProvider>();
    return SectionCard(title: 'Health Records', child: AppDataTable(
      columns: ['Student', 'Class', 'Blood Group', 'Allergies', 'Chronic Conditions', 'Vaccinations', 'Last Checkup', 'Notes'],
      rows: h.records.map((r) => [
        Text(r.studentName), Text(r.className), Text(r.bloodGroup),
        Text(r.allergies), Text(r.chronicConditions), Text(r.vaccinations),
        Text(r.lastCheckup), Text(r.notes),
      ]).toList(),
    ));
  }
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final h = context.watch<HealthProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Visits', value: '${h.visits.length}', icon: Icons.receipt, color: AppColors.primaryLight),
        StatCard(label: 'Referrals', value: '${h.referrals.length}', icon: Icons.forward, color: AppColors.warning),
        StatCard(label: 'Med Items', value: '${h.meds.length}', icon: Icons.medication, color: AppColors.info),
        StatCard(label: 'Health Records', value: '${h.records.length}', icon: Icons.folder, color: AppColors.purple),
      ]),
    ]);
  }
}
