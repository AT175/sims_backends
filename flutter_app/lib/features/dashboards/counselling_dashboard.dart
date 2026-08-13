import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/counselling_provider.dart';
import '../../core/widgets/widgets.dart';

class CounsellingDashboard extends StatelessWidget {
  final String pageKey;
  const CounsellingDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'cases': return const _CasesPage();
      case 'caseDetail': return const _CaseDetailPage();
      case 'appointments': return const _AppointmentsPage();
      case 'referrals': return const _ReferralsPage();
      case 'career': return const _CareerPage();
      case 'counsellors': return const _CounsellorsPage();
      case 'reports': return const _ReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

// ── Helpers ──

Color _statusColor(CaseStatus s) => switch (s) {
  CaseStatus.active => AppColors.warning,
  CaseStatus.monitor => AppColors.info,
  CaseStatus.closed => AppColors.success,
  CaseStatus.referred => AppColors.purple,
};

Color _priorityColor(CasePriority p) => switch (p) {
  CasePriority.high => AppColors.danger,
  CasePriority.medium => AppColors.warning,
  CasePriority.low => AppColors.info,
};

Color _typeColor(CounsellorType t) => t == CounsellorType.academic ? AppColors.info : AppColors.purple;

Color _apptStatusColor(AppointmentStatus s) => switch (s) {
  AppointmentStatus.scheduled => AppColors.warning,
  AppointmentStatus.completed => AppColors.success,
  AppointmentStatus.cancelled => AppColors.danger,
  AppointmentStatus.noShow => AppColors.danger,
};

Color _referralStatusColor(ReferralStatus s) => switch (s) {
  ReferralStatus.pending => AppColors.warning,
  ReferralStatus.ongoing => AppColors.info,
  ReferralStatus.completed => AppColors.success,
};

String _statusLabel(CaseStatus s) => switch (s) {
  CaseStatus.active => 'Active',
  CaseStatus.monitor => 'Monitor',
  CaseStatus.closed => 'Closed',
  CaseStatus.referred => 'Referred',
};

String _priorityLabel(CasePriority p) => switch (p) {
  CasePriority.high => 'High',
  CasePriority.medium => 'Medium',
  CasePriority.low => 'Low',
};

String _typeLabel(CounsellorType t) => t == CounsellorType.academic ? 'Academic' : 'Psychosocial';

String _apptStatusLabel(AppointmentStatus s) => switch (s) {
  AppointmentStatus.scheduled => 'Scheduled',
  AppointmentStatus.completed => 'Completed',
  AppointmentStatus.cancelled => 'Cancelled',
  AppointmentStatus.noShow => 'No Show',
};

String _referralStatusLabel(ReferralStatus s) => switch (s) {
  ReferralStatus.pending => 'Pending',
  ReferralStatus.ongoing => 'Ongoing',
  ReferralStatus.completed => 'Completed',
};

Widget _chip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
  );
}

Widget _actionBtn(String label, VoidCallback onPressed, {Color? color}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _filterChip(String label, bool active, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceAlt,
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: TextStyle(fontSize: AppFontSize.xs, color: active ? Colors.white : AppColors.textSecondary, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
    ),
  );
}

Widget _selectChip(String label, bool active, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceAlt,
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: TextStyle(fontSize: AppFontSize.xs, color: active ? Colors.white : AppColors.textSecondary, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
    ),
  );
}

Widget _inputField(String label, TextEditingController ctrl, {String? hint, int maxLines = 1}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
    ),
    const SizedBox(height: AppSpacing.sm),
  ]);
}

Widget _progressBar(String label, int count, int total, Color color) {
  final pct = total > 0 ? (count / total * 100).round() : 0;
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Row(children: [
      SizedBox(width: 120, child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
      const SizedBox(width: AppSpacing.sm),
      Expanded(child: Container(height: 8, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(4)), child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: pct / 100,
        child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
      ))),
      const SizedBox(width: AppSpacing.sm),
      SizedBox(width: 30, child: Text('$count', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold, color: AppColors.text), textAlign: TextAlign.right)),
    ]),
  );
}

void _confirmDelete(BuildContext context, String message, VoidCallback onConfirm) {
  showDialog(context: context, builder: (ctx) => AlertDialog(
    title: const Text('Confirm Delete'),
    content: Text(message),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      TextButton(onPressed: () { Navigator.pop(ctx); onConfirm(); }, style: TextButton.styleFrom(foregroundColor: AppColors.danger), child: const Text('Delete')),
    ],
  ));
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounsellingProvider>();
    final activeCases = c.getActiveCases();
    final followUps = c.getFollowUpsDue();
    final todayAppts = c.getTodayAppointments();
    final academicCases = c.getCasesByType(CounsellorType.academic);
    final psychoCases = c.getCasesByType(CounsellorType.psychosocial);

    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Active Cases', value: '${activeCases.length}', icon: Icons.warning_amber, color: AppColors.warning),
        StatCard(label: "Today's Appts", value: '${todayAppts.length}', icon: Icons.event, color: AppColors.primary),
        StatCard(label: 'Follow-ups Due', value: '${followUps.length}', icon: Icons.schedule, color: followUps.isNotEmpty ? AppColors.danger : AppColors.success),
        StatCard(label: 'Pending Referrals', value: '${c.referrals.where((r) => r.status != ReferralStatus.completed).length}', icon: Icons.outbound, color: AppColors.info),
        StatCard(label: 'Academic Cases', value: '${academicCases.length}', icon: Icons.school, color: AppColors.info),
        StatCard(label: 'Psychosocial', value: '${psychoCases.length}', icon: Icons.psychology, color: AppColors.purple),
        StatCard(label: 'Total Cases', value: '${c.cases.length}', icon: Icons.folder, color: AppColors.accent),
        StatCard(label: 'Resources', value: '${c.resources.length}', icon: Icons.menu_book, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),

      if (followUps.isNotEmpty) ...[
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.dangerBg, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: AppColors.danger, width: 4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${followUps.length} Follow-up(s) Due', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.danger)),
            const SizedBox(height: AppSpacing.xs),
            ...followUps.map((cs) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('${cs.caseId} — ${cs.studentName} (${cs.category}) | Due: ${cs.followUpDate}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger)),
            )),
          ]),
        ),
        const SizedBox(height: AppSpacing.md),
      ],

      if (todayAppts.isNotEmpty) ...[
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: AppColors.primary, width: 4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Today's Appointments (${todayAppts.length})", style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: AppSpacing.xs),
            ...todayAppts.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('${a.time} — ${a.studentName} (${_typeLabel(a.type)}) with ${a.counsellor}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            )),
          ]),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],

      Text('Counsellor Workload', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      ...c.counsellors.map((cou) {
        final couCases = c.getCasesByCounsellor(cou.name);
        final couActive = couCases.where((cs) => cs.status == CaseStatus.active || cs.status == CaseStatus.monitor).length;
        final couAppts = c.appointments.where((a) => a.counsellor == cou.name && a.status == AppointmentStatus.scheduled).length;
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _typeColor(cou.type), width: 4)), boxShadow: AppShadows.sm),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(cou.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
              Text(cou.title, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('${cou.room} | ${cou.phone}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              const SizedBox(height: AppSpacing.xs),
              Wrap(spacing: AppSpacing.sm, children: [
                Text('Active: $couActive', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Total: ${couCases.length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Appts: $couAppts', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ]),
            ])),
            _chip(_typeLabel(cou.type), _typeColor(cou.type)),
          ]),
        );
      }),

      const SizedBox(height: AppSpacing.lg),
      Text('Quick Actions', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
        ElevatedButton(onPressed: () => _showCaseModal(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), child: const Text('+ New Case')),
        ElevatedButton(onPressed: () => _showApptModal(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white), child: const Text('+ Book Appt')),
        ElevatedButton(onPressed: () => _showReferralModal(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white), child: const Text('+ Refer Student')),
        ElevatedButton(onPressed: () => _showResourceModal(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white), child: const Text('+ Add Resource')),
      ]),
    ]));
  }
}

class _CasesPage extends StatefulWidget {
  const _CasesPage();
  @override
  State<_CasesPage> createState() => _CasesPageState();
}

class _CasesPageState extends State<_CasesPage> {
  String _filter = 'All';
  String? _selectedCaseId;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounsellingProvider>();
    final filtered = _filter == 'All' ? c.cases : c.cases.where((cs) => _typeLabel(cs.type) == _filter).toList();
    final academicCount = c.getCasesByType(CounsellorType.academic).length;
    final psychoCount = c.getCasesByType(CounsellorType.psychosocial).length;

    if (_selectedCaseId != null) {
      final selectedCase = c.getCaseById(_selectedCaseId!);
      if (selectedCase != null) return _buildCaseDetail(context, c, selectedCase);
      _selectedCaseId = null;
    }

    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Cases', value: '${c.cases.length}', icon: Icons.folder, color: AppColors.primary),
        StatCard(label: 'Active', value: '${c.cases.where((cs) => cs.status == CaseStatus.active).length}', icon: Icons.warning_amber, color: AppColors.warning),
        StatCard(label: 'Monitor', value: '${c.cases.where((cs) => cs.status == CaseStatus.monitor).length}', icon: Icons.visibility, color: AppColors.info),
        StatCard(label: 'Closed', value: '${c.cases.where((cs) => cs.status == CaseStatus.closed).length}', icon: Icons.check_circle, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Case Log', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Confidential — access restricted to counselling staff', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),

      _actionBtn('+ Open New Case', () => _showCaseModal(context)),
      const SizedBox(height: AppSpacing.md),

      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [
        _filterChip('All (${c.cases.length})', _filter == 'All', () => setState(() => _filter = 'All')),
        _filterChip('Academic ($academicCount)', _filter == 'Academic', () => setState(() => _filter = 'Academic')),
        _filterChip('Psychosocial ($psychoCount)', _filter == 'Psychosocial', () => setState(() => _filter = 'Psychosocial')),
      ]),
      const SizedBox(height: AppSpacing.md),

      if (filtered.isEmpty)
        Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: Text('No cases found.', style: TextStyle(color: AppColors.textLight))))
      else
        ...filtered.map((cs) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              onTap: () => setState(() => _selectedCaseId = cs.id),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.sm),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(cs.caseId, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      if (cs.confidential) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Text('🔒 Confidential', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.danger, fontWeight: FontWeight.w600)),
                      ],
                    ]),
                    const SizedBox(height: AppSpacing.xs),
                    Text('${cs.studentName} — ${cs.studentClass}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                    Text('${cs.category} | Opened: ${cs.openedDate} | ${cs.assignedCounsellor}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                    if (cs.description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(cs.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                    ],
                    if (cs.followUpDate.isNotEmpty && (cs.status == CaseStatus.active || cs.status == CaseStatus.monitor)) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text('Follow-up: ${cs.followUpDate}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.warning, fontWeight: FontWeight.w600)),
                    ],
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    _chip(_typeLabel(cs.type), _typeColor(cs.type)),
                    const SizedBox(height: 4),
                    _chip(_priorityLabel(cs.priority), _priorityColor(cs.priority)),
                    const SizedBox(height: 4),
                    _chip(_statusLabel(cs.status), _statusColor(cs.status)),
                  ]),
                ]),
              ),
            ),
          ),
        )),
    ]));
  }

  Widget _buildCaseDetail(BuildContext context, CounsellingProvider c, CounsellingCase selectedCase) {
    final caseSessions = c.getSessionsByCase(selectedCase.id);
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(onTap: () => setState(() => _selectedCaseId = null), child: Text('← Back to Case Log', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
      const SizedBox(height: AppSpacing.md),

      Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border(left: BorderSide(color: _typeColor(selectedCase.type), width: 4)), boxShadow: AppShadows.sm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(selectedCase.caseId, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
                if (selectedCase.confidential) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text('🔒 Confidential', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.danger, fontWeight: FontWeight.w600)),
                ],
              ]),
              Text('${selectedCase.studentName} — ${selectedCase.studentClass}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('Category: ${selectedCase.category} | Type: ${_typeLabel(selectedCase.type)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Counsellor: ${selectedCase.assignedCounsellor} | Opened: ${selectedCase.openedDate}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              _chip(_priorityLabel(selectedCase.priority), _priorityColor(selectedCase.priority)),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  final idx = CaseStatus.values.indexOf(selectedCase.status);
                  c.updateCaseStatus(selectedCase.id, CaseStatus.values[(idx + 1) % CaseStatus.values.length]);
                },
                child: _chip(_statusLabel(selectedCase.status), _statusColor(selectedCase.status)),
              ),
            ]),
          ]),
          if (selectedCase.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(selectedCase.description, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
          ],
          if (selectedCase.notes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('Notes: ${selectedCase.notes}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
          ],
          if (selectedCase.followUpDate.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text('Next follow-up: ${selectedCase.followUpDate}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.warning, fontWeight: FontWeight.w600)),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(children: [
            GestureDetector(onTap: () => _showSessionModal(context, selectedCase), child: Text('+ Log Session', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.primary))),
            const SizedBox(width: AppSpacing.md),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete this case and all its sessions?', () { c.deleteCase(selectedCase.id); setState(() => _selectedCaseId = null); }), child: Text('Delete Case', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
          ]),
        ]),
      ),

      const SizedBox(height: AppSpacing.lg),
      Text('Session History (${caseSessions.length})', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),

      if (caseSessions.isEmpty)
        Text('No sessions logged yet.', style: TextStyle(color: AppColors.textLight))
      else
        ...caseSessions.map((s) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: AppColors.info, width: 3)), boxShadow: AppShadows.sm),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${s.date} — ${s.summary}', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('Counsellor: ${s.counsellor} | Type: ${_typeLabel(s.type)}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
              if (s.notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(s.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ],
              if (s.nextAction.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text('Next: ${s.nextAction}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
              if (s.nextSessionDate.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text('Next session: ${s.nextSessionDate}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.info)),
              ],
            ])),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete this session log?', () => c.deleteSession(s.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
          ]),
        )),
    ]));
  }
}

class _CaseDetailPage extends StatelessWidget {
  const _CaseDetailPage();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Select a case from Case Log to view details.', style: TextStyle(color: AppColors.textSecondary)));
  }
}

class _AppointmentsPage extends StatefulWidget {
  const _AppointmentsPage();
  @override
  State<_AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<_AppointmentsPage> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounsellingProvider>();
    final filtered = _filter == 'All' ? c.appointments : c.appointments.where((a) => _typeLabel(a.type) == _filter).toList();
    final todayAppts = c.getTodayAppointments();

    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total', value: '${c.appointments.length}', icon: Icons.event, color: AppColors.primary),
        StatCard(label: 'Scheduled', value: '${c.appointments.where((a) => a.status == AppointmentStatus.scheduled).length}', icon: Icons.schedule, color: AppColors.warning),
        StatCard(label: 'Completed', value: '${c.appointments.where((a) => a.status == AppointmentStatus.completed).length}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Today', value: '${todayAppts.length}', icon: Icons.today, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Appointment Scheduler', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Book and track counselling sessions', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),

      _actionBtn('+ Book Appointment', () => _showApptModal(context)),
      const SizedBox(height: AppSpacing.md),

      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [
        _filterChip('All', _filter == 'All', () => setState(() => _filter = 'All')),
        _filterChip('Academic', _filter == 'Academic', () => setState(() => _filter = 'Academic')),
        _filterChip('Psychosocial', _filter == 'Psychosocial', () => setState(() => _filter = 'Psychosocial')),
      ]),
      const SizedBox(height: AppSpacing.md),

      if (filtered.isEmpty)
        Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: Text('No appointments found.', style: TextStyle(color: AppColors.textLight))))
      else
        ...filtered.map((a) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${a.date} at ${a.time}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${a.studentName} — ${a.studentClass}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('${a.reason} | ${a.counsellor}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              if (a.notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(a.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
              ],
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    final idx = AppointmentStatus.values.indexOf(a.status);
                    c.updateAppointmentStatus(a.id, AppointmentStatus.values[(idx + 1) % AppointmentStatus.values.length]);
                  },
                  child: _chip(_apptStatusLabel(a.status), _apptStatusColor(a.status)),
                ),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Delete this appointment?', () => c.deleteAppointment(a.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
              ]),
            ])),
            _chip(_typeLabel(a.type), _typeColor(a.type)),
          ]),
        )),
    ]));
  }
}

class _ReferralsPage extends StatelessWidget {
  const _ReferralsPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounsellingProvider>();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total', value: '${c.referrals.length}', icon: Icons.outbound, color: AppColors.primary),
        StatCard(label: 'Pending', value: '${c.referrals.where((r) => r.status == ReferralStatus.pending).length}', icon: Icons.hourglass_empty, color: AppColors.warning),
        StatCard(label: 'Ongoing', value: '${c.referrals.where((r) => r.status == ReferralStatus.ongoing).length}', icon: Icons.sync, color: AppColors.info),
        StatCard(label: 'Completed', value: '${c.referrals.where((r) => r.status == ReferralStatus.completed).length}', icon: Icons.check_circle, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Referral Tracker', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Cases referred to external professionals', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),

      _actionBtn('+ New Referral', () => _showReferralModal(context)),
      const SizedBox(height: AppSpacing.md),

      if (c.referrals.isEmpty)
        Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: Text('No referrals recorded.', style: TextStyle(color: AppColors.textLight))))
      else
        ...c.referrals.map((r) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${r.studentName} — ${r.studentClass}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('Referred to: ${r.referredTo} | ${r.date}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Reason: ${r.reason}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              if (r.notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(r.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
              ],
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    final idx = ReferralStatus.values.indexOf(r.status);
                    c.updateReferralStatus(r.id, ReferralStatus.values[(idx + 1) % ReferralStatus.values.length]);
                  },
                  child: _chip(_referralStatusLabel(r.status), _referralStatusColor(r.status)),
                ),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Delete this referral?', () => c.deleteReferral(r.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
              ]),
            ])),
            _chip(_typeLabel(r.type), _typeColor(r.type)),
          ]),
        )),
    ]));
  }
}

class _CareerPage extends StatelessWidget {
  const _CareerPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounsellingProvider>();
    final categories = c.resources.map((r) => r.category).toSet();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Resources', value: '${c.resources.length}', icon: Icons.menu_book, color: AppColors.primary),
        StatCard(label: 'Categories', value: '${categories.length}', icon: Icons.category, color: AppColors.info),
        StatCard(label: 'Universities', value: '${c.resources.where((r) => r.category == 'University').length}', icon: Icons.school, color: AppColors.success),
        StatCard(label: 'Scholarships', value: '${c.resources.where((r) => r.category == 'Scholarship').length}', icon: Icons.attach_money, color: AppColors.accent),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Career Guidance Resources', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('University, course, and scholarship information', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),

      _actionBtn('+ Add Resource', () => _showResourceModal(context)),
      const SizedBox(height: AppSpacing.md),

      if (c.resources.isEmpty)
        Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: Text('No resources available.', style: TextStyle(color: AppColors.textLight))))
      else
        ...c.resources.map((r) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${r.category} | Updated: ${r.updated}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              if (r.description.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(r.description, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ],
              if (r.link.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text('🔗 ${r.link}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.info)),
              ],
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete this resource?', () => c.deleteResource(r.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
            ])),
          ]),
        )),
    ]));
  }
}

class _CounsellorsPage extends StatelessWidget {
  const _CounsellorsPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounsellingProvider>();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Our Counsellors', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Two coordinators — Academic and Psychosocial', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),

      ...c.counsellors.map((cou) {
        final couCases = c.getCasesByCounsellor(cou.name);
        final couActive = couCases.where((cs) => cs.status == CaseStatus.active || cs.status == CaseStatus.monitor).length;
        final couSessions = c.sessions.where((s) => s.counsellor == cou.name).length;
        final couAppts = c.appointments.where((a) => a.counsellor == cou.name).length;
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border(left: BorderSide(color: _typeColor(cou.type), width: 4)), boxShadow: AppShadows.sm),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(cou.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                Text(cou.title, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ])),
              _chip(_typeLabel(cou.type), _typeColor(cou.type)),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text('📞 ${cou.phone}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('✉️ ${cou.email}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('📍 ${cou.room}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('🕐 ${cou.availability}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(spacing: AppSpacing.sm, children: [
              _workloadBox('$couActive', 'Active Cases'),
              _workloadBox('${couCases.length}', 'Total Cases'),
              _workloadBox('$couSessions', 'Sessions'),
              _workloadBox('$couAppts', 'Appts'),
            ]),
          ]),
        );
      }),
    ]));
  }

  Widget _workloadBox(String num, String label) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Column(children: [
        Text(num, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(label, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
      ]),
    );
  }
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<CounsellingProvider>();
    final academicCases = c.getCasesByType(CounsellorType.academic);
    final psychoCases = c.getCasesByType(CounsellorType.psychosocial);
    final allCategories = c.cases.map((cs) => cs.category).toSet().toList();

    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Reports & Analytics', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Real-time data insights from counselling activities', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),

      StatCardGrid(cards: [
        StatCard(label: 'Total Cases', value: '${c.cases.length}', icon: Icons.folder, color: AppColors.primary),
        StatCard(label: 'Total Sessions', value: '${c.sessions.length}', icon: Icons.event_note, color: AppColors.info),
        StatCard(label: 'Academic Cases', value: '${academicCases.length}', icon: Icons.school, color: AppColors.info),
        StatCard(label: 'Psychosocial Cases', value: '${psychoCases.length}', icon: Icons.psychology, color: AppColors.purple),
      ]),
      const SizedBox(height: AppSpacing.lg),

      _reportSection('Case Status Distribution', [
        ...CaseStatus.values.map((st) {
          final count = c.cases.where((cs) => cs.status == st).length;
          return _progressBar(_statusLabel(st), count, c.cases.length, _statusColor(st));
        }),
      ]),

      _reportSection('Case Categories', [
        ...allCategories.map((cat) {
          final count = c.cases.where((cs) => cs.category == cat).length;
          final catType = c.cases.firstWhere((cs) => cs.category == cat).type;
          return _progressBar(cat, count, c.cases.length, _typeColor(catType));
        }),
      ]),

      _reportSection('Priority Breakdown', [
        ...CasePriority.values.map((pri) {
          final count = c.cases.where((cs) => cs.priority == pri).length;
          return _progressBar('${_priorityLabel(pri)} Priority', count, c.cases.length, _priorityColor(pri));
        }),
      ]),

      _reportSection('Counsellor Workload Comparison', [
        ...c.counsellors.map((cou) {
          final total = c.getCasesByCounsellor(cou.name).length;
          final active = c.getCasesByCounsellor(cou.name).where((cs) => cs.status == CaseStatus.active || cs.status == CaseStatus.monitor).length;
          final sess = c.sessions.where((s) => s.counsellor == cou.name).length;
          final appts = c.appointments.where((a) => a.counsellor == cou.name).length;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(cou.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                const SizedBox(width: AppSpacing.sm),
                _chip(_typeLabel(cou.type), _typeColor(cou.type)),
              ]),
              const SizedBox(height: AppSpacing.xs),
              Wrap(spacing: AppSpacing.md, children: [
                Text('Active: $active', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Total: $total', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Sessions: $sess', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Appts: $appts', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ]),
            ]),
          );
        }),
      ]),

      _reportSection('Referral Outcomes', [
        if (c.referrals.isEmpty)
          Text('No referrals recorded.', style: TextStyle(color: AppColors.textLight))
        else
          ...ReferralStatus.values.map((st) {
            final count = c.referrals.where((r) => r.status == st).length;
            return _progressBar(_referralStatusLabel(st), count, c.referrals.length, _referralStatusColor(st));
          }),
      ]),

      _reportSection('Appointment Status Summary', [
        ...AppointmentStatus.values.map((st) {
          final count = c.appointments.where((a) => a.status == st).length;
          return _progressBar(_apptStatusLabel(st), count, c.appointments.length, _apptStatusColor(st));
        }),
      ]),

      _reportSection('Academic vs Psychosocial', [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: AppColors.info, width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Academic', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.info)),
              Text('Cases: ${academicCases.length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Active: ${academicCases.where((cs) => cs.status == CaseStatus.active || cs.status == CaseStatus.monitor).length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Closed: ${academicCases.where((cs) => cs.status == CaseStatus.closed).length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Sessions: ${c.sessions.where((s) => s.type == CounsellorType.academic).length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Appts: ${c.appointments.where((a) => a.type == CounsellorType.academic).length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ]),
          )),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: AppColors.purple, width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Psychosocial', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.purple)),
              Text('Cases: ${psychoCases.length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Active: ${psychoCases.where((cs) => cs.status == CaseStatus.active || cs.status == CaseStatus.monitor).length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Closed: ${psychoCases.where((cs) => cs.status == CaseStatus.closed).length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Sessions: ${c.sessions.where((s) => s.type == CounsellorType.psychosocial).length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Appts: ${c.appointments.where((a) => a.type == CounsellorType.psychosocial).length}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ]),
          )),
        ]),
      ]),

      _reportSection('Recent Sessions (Last 5)', [
        if (c.sessions.isEmpty)
          Text('No sessions logged.', style: TextStyle(color: AppColors.textLight))
        else
          ...c.sessions.take(5).map((s) {
            final caseInfo = c.getCaseById(s.caseId);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.date, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold, color: AppColors.text)),
                  Text(s.summary, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('${caseInfo?.caseId ?? 'Unknown'} — ${caseInfo?.studentName ?? 'Unknown'} | ${s.counsellor}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
                ])),
                _chip(_typeLabel(s.type), _typeColor(s.type)),
              ]),
            );
          }),
      ]),
    ]));
  }

  Widget _reportSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
      ]),
    );
  }
}

// ── Modal Dialogs ──

void _showCaseModal(BuildContext context) {
  final c = context.read<CounsellingProvider>();
  final nameCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final followUpCtrl = TextEditingController();
  CounsellorType type = CounsellorType.academic;
  String category = caseCategoriesAcademic[0];
  CasePriority priority = CasePriority.medium;
  bool confidential = true;

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Open New Case'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      _inputField('Student Name', nameCtrl, hint: 'e.g. John Mensah'),
      _inputField('Student Class', classCtrl, hint: 'e.g. Form 2B'),
      const SizedBox(height: AppSpacing.sm),
      Text('Counsellor Type', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, children: [
        _selectChip('Academic', type == CounsellorType.academic, () => setState(() { type = CounsellorType.academic; category = caseCategoriesAcademic[0]; })),
        _selectChip('Psychosocial', type == CounsellorType.psychosocial, () => setState(() { type = CounsellorType.psychosocial; category = caseCategoriesPsycho[0]; })),
      ]),
      const SizedBox(height: AppSpacing.sm),
      Text('Category', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, children: (type == CounsellorType.academic ? caseCategoriesAcademic : caseCategoriesPsycho).map((cat) =>
        _selectChip(cat, category == cat, () => setState(() => category = cat))).toList()),
      const SizedBox(height: AppSpacing.sm),
      Text('Priority', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, children: CasePriority.values.map((p) =>
        _selectChip(_priorityLabel(p), priority == p, () => setState(() => priority = p))).toList()),
      _inputField('Description', descCtrl, hint: 'Brief description of the issue...', maxLines: 3),
      _inputField('Notes (optional)', notesCtrl, hint: 'Initial assessment notes...', maxLines: 3),
      _inputField('Follow-up Date (YYYY-MM-DD)', followUpCtrl, hint: 'e.g. 2026-07-15'),
      Row(children: [
        Checkbox(value: confidential, onChanged: (v) => setState(() => confidential = v ?? true)),
        Text('Mark as Confidential', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
      ]),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (nameCtrl.text.trim().isEmpty || descCtrl.text.trim().isEmpty) return;
        final counsellor = c.counsellors.where((cou) => cou.type == type).firstOrNull;
        c.addCase(
          studentName: nameCtrl.text.trim(), studentClass: classCtrl.text.trim(),
          category: category, type: type, description: descCtrl.text.trim(),
          priority: priority, assignedCounsellor: counsellor?.name ?? '',
          notes: notesCtrl.text.trim(), followUpDate: followUpCtrl.text.trim(), confidential: confidential,
        );
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}

void _showSessionModal(BuildContext context, CounsellingCase selectedCase) {
  final c = context.read<CounsellingProvider>();
  final summaryCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final nextActionCtrl = TextEditingController();
  final nextSessionCtrl = TextEditingController();
  CounsellorType type = selectedCase.type;

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: Text('Log Session — ${selectedCase.caseId}'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Case: ${selectedCase.caseId} — ${selectedCase.studentName}', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.sm),
      Text('Type', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, children: [
        _selectChip('Academic', type == CounsellorType.academic, () => setState(() => type = CounsellorType.academic)),
        _selectChip('Psychosocial', type == CounsellorType.psychosocial, () => setState(() => type = CounsellorType.psychosocial)),
      ]),
      _inputField('Session Summary', summaryCtrl, hint: 'e.g. Follow-up assessment'),
      _inputField('Session Notes', notesCtrl, hint: 'Detailed notes...', maxLines: 4),
      _inputField('Next Action', nextActionCtrl, hint: 'e.g. Schedule parent meeting'),
      _inputField('Next Session Date (YYYY-MM-DD)', nextSessionCtrl, hint: 'e.g. 2026-07-20'),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (summaryCtrl.text.trim().isEmpty) return;
        c.addSession(
          caseId: selectedCase.id, counsellor: selectedCase.assignedCounsellor, type: type,
          summary: summaryCtrl.text.trim(), notes: notesCtrl.text.trim(),
          nextAction: nextActionCtrl.text.trim(), nextSessionDate: nextSessionCtrl.text.trim(),
        );
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}

void _showApptModal(BuildContext context) {
  final c = context.read<CounsellingProvider>();
  final nameCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();
  CounsellorType type = CounsellorType.academic;
  String time = '10:00';

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Book Appointment'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Counsellor Type', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, children: [
        _selectChip('Academic', type == CounsellorType.academic, () => setState(() => type = CounsellorType.academic)),
        _selectChip('Psychosocial', type == CounsellorType.psychosocial, () => setState(() => type = CounsellorType.psychosocial)),
      ]),
      const SizedBox(height: AppSpacing.sm),
      Text('Assigned Counsellor: ${c.counsellors.where((cou) => cou.type == type).firstOrNull?.name ?? ''}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      _inputField('Student Name', nameCtrl, hint: 'Student name'),
      _inputField('Student Class', classCtrl, hint: 'e.g. Form 2B'),
      _inputField('Date (YYYY-MM-DD)', dateCtrl, hint: 'e.g. 2026-07-10'),
      Text('Time', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, children: timeSlots.map((t) =>
        _selectChip(t, time == t, () => setState(() => time = t))).toList()),
      _inputField('Reason for Visit', reasonCtrl, hint: 'Brief reason...', maxLines: 2),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (nameCtrl.text.trim().isEmpty || dateCtrl.text.trim().isEmpty) return;
        final counsellor = c.counsellors.where((cou) => cou.type == type).firstOrNull;
        c.addAppointment(
          date: dateCtrl.text.trim(), time: time, studentName: nameCtrl.text.trim(),
          studentClass: classCtrl.text.trim(), type: type,
          counsellor: counsellor?.name ?? '', reason: reasonCtrl.text.trim(),
        );
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}

void _showReferralModal(BuildContext context) {
  final c = context.read<CounsellingProvider>();
  final nameCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final referredToCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  CounsellorType type = CounsellorType.psychosocial;

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('New Referral'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      _inputField('Student Name', nameCtrl, hint: 'Student name'),
      _inputField('Student Class', classCtrl, hint: 'e.g. Form 3C'),
      Text('Counsellor Type', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, children: [
        _selectChip('Academic', type == CounsellorType.academic, () => setState(() => type = CounsellorType.academic)),
        _selectChip('Psychosocial', type == CounsellorType.psychosocial, () => setState(() => type = CounsellorType.psychosocial)),
      ]),
      _inputField('Referred To', referredToCtrl, hint: 'e.g. Clinical Psychologist'),
      _inputField('Reason', reasonCtrl, hint: 'Reason for referral...', maxLines: 2),
      _inputField('Notes (optional)', notesCtrl, hint: 'Additional notes...', maxLines: 2),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (nameCtrl.text.trim().isEmpty || referredToCtrl.text.trim().isEmpty) return;
        c.addReferral(
          studentName: nameCtrl.text.trim(), studentClass: classCtrl.text.trim(),
          referredTo: referredToCtrl.text.trim(), reason: reasonCtrl.text.trim(),
          type: type, notes: notesCtrl.text.trim(),
        );
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}

void _showResourceModal(BuildContext context) {
  final c = context.read<CounsellingProvider>();
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final linkCtrl = TextEditingController();
  String category = resourceCategories[0];

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Add Career Resource'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      _inputField('Resource Title', titleCtrl, hint: 'e.g. UG Admission Requirements'),
      Text('Category', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, children: resourceCategories.map((cat) =>
        _selectChip(cat, category == cat, () => setState(() => category = cat))).toList()),
      _inputField('Description', descCtrl, hint: 'Brief description...', maxLines: 2),
      _inputField('Link (optional)', linkCtrl, hint: 'https://...'),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (titleCtrl.text.trim().isEmpty) return;
        c.addResource(
          title: titleCtrl.text.trim(), category: category,
          description: descCtrl.text.trim(), link: linkCtrl.text.trim(),
        );
        Navigator.pop(ctx);
      }, child: const Text('Save')),
    ],
  )));
}
