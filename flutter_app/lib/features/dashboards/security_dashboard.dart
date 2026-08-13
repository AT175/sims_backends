import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/security_provider.dart';
import '../../core/state/boarding_provider.dart';
import '../../core/widgets/widgets.dart';

const _incidentTypes = ['Theft', 'Trespass', 'Vandalism', 'Fighting', 'Suspicious Activity', 'Other'];
const _incidentSeverities = ['Low', 'Medium', 'High', 'Critical'];
const _incidentStatuses = ['Reported', 'Investigating', 'Escalated', 'Resolved'];
const _shiftNames = ['Morning', 'Afternoon', 'Night'];
const _personTypes = ['Visitor', 'Parent', 'Staff', 'Student'];
const _gates = ['Main Gate', 'Back Gate'];
const _ranks = ['Private', 'Corporal', 'Sergeant', 'Lieutenant'];

String _today() => DateTime.now().toIso8601String().substring(0, 10);
String _nowTime() => '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';

Color _statusColor(String status) {
  switch (status) {
    case 'Resolved': case 'Completed': case 'Yes': case 'On Duty': case 'Checked In': case 'Arrived': return AppColors.success;
    case 'Investigating': case 'Pending': case 'In Progress': case 'Expected': case 'Reported': case 'Active': return AppColors.warning;
    case 'Escalated': case 'No': case 'Off Duty': case 'Denied': case 'Cancelled': case 'Checked Out': case 'Departed': return AppColors.danger;
    default: return AppColors.info;
  }
}

Color _severityColor(String s) {
  switch (s) {
    case 'Critical': return AppColors.danger;
    case 'High': return AppColors.warning;
    case 'Medium': return AppColors.info;
    default: return AppColors.textSecondary;
  }
}

Widget _chip(String text, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
  child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
);

Widget _actionBtn(BuildContext context, String label, VoidCallback onPressed, {Color? color}) => SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: color ?? AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2)),
    onPressed: onPressed,
    child: Text(label, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600)),
  ),
);

Widget _pickerChips(String label, String selected, List<String> options, ValueChanged<String> onSelected) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: options.map((o) => GestureDetector(
      onTap: () => onSelected(o),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected == o ? AppColors.primary : Colors.transparent,
          border: Border.all(color: selected == o ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(o, style: TextStyle(fontSize: AppFontSize.sm, color: selected == o ? Colors.white : AppColors.textSecondary, fontWeight: selected == o ? FontWeight.w600 : FontWeight.normal)),
      ),
    )).toList()),
  ],
);

Widget _formField(String label, TextEditingController ctrl, {String? hint, TextInputType? keyboardType, bool multiline = false}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    TextField(
      controller: ctrl, keyboardType: keyboardType, maxLines: multiline ? 3 : 1,
      decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
    ),
  ],
);

void _showFormModal(BuildContext context, String title, Widget formContent, VoidCallback onSubmit, {String submitLabel = 'Save'}) {
  showModalBottomSheet(
    context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
              GestureDetector(onTap: () => Navigator.pop(ctx), child: Icon(Icons.close, color: AppColors.textLight)),
            ]),
            const SizedBox(height: AppSpacing.md),
            formContent,
            const SizedBox(height: AppSpacing.lg),
            Row(children: [
              Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel'))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                onPressed: () { onSubmit(); Navigator.pop(ctx); },
                child: Text(submitLabel),
              )),
            ]),
          ]),
        ),
      ),
    ),
  );
}

Widget _alertCard(String title, String subtitle, Color color) => Container(
  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
  padding: const EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: color, width: 4))),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: color)),
    Text(subtitle, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
  ]),
);

void _confirmDelete(BuildContext context, String message, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Delete'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
        TextButton(style: TextButton.styleFrom(foregroundColor: AppColors.danger), onPressed: () { onConfirm(); Navigator.pop(ctx); }, child: Text('Delete')),
      ],
    ),
  );
}

class SecurityDashboard extends StatelessWidget {
  final String pageKey;
  const SecurityDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'gate': return const _GateLogPage();
      case 'exeats': return const _ExeatVerificationPage();
      case 'incidents': return const _IncidentsPage();
      case 'patrol': return const _PatrolPage();
      case 'visitors': return const _VisitorsPage();
      case 'checklist': return const _ChecklistPage();
      case 'guards': return const _GuardsPage();
      case 'reports': return const _ReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SecurityProvider>();
    final criticalIncidents = s.incidents.where((i) => i.severity == 'High' || i.severity == 'Critical').toList();
    final pendingChecklist = s.checklist.where((c) => c.completed == 'Pending').toList();
    final expectedVisitors = s.visitors.where((v) => v.status == 'Expected').toList();

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Gate Logs Today', value: '${s.gateLogs.length}', icon: Icons.security, color: AppColors.primaryLight),
          StatCard(label: 'Active Incidents', value: '${s.activeIncidentsCount}', icon: Icons.report, color: s.activeIncidentsCount > 0 ? AppColors.danger : AppColors.success),
          StatCard(label: 'Expected Visitors', value: '${s.expectedVisitorsCount}', icon: Icons.person_search, color: AppColors.info),
          StatCard(label: 'Checklist', value: '${s.checklistProgress}%', icon: Icons.checklist, color: s.checklistProgress == 100 ? AppColors.success : AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (criticalIncidents.isNotEmpty) ...[
          _alertCard('Critical/High Incidents (${criticalIncidents.length})', criticalIncidents.map((i) => '${i.type} at ${i.location} | ${i.severity} | ${i.status}').join('\n'), AppColors.danger),
        ],
        if (pendingChecklist.isNotEmpty) ...[
          _alertCard('${pendingChecklist.length} Checklist Items Pending', pendingChecklist.take(4).map((c) => '${c.task} \u2014 required by ${c.time}').join('\n'), AppColors.warning),
        ],
        if (expectedVisitors.isNotEmpty) ...[
          _alertCard('Expected Visitors (${expectedVisitors.length})', expectedVisitors.map((v) => '${v.visitorName} \u2014 ${v.expectedDate} at ${v.expectedTime} | Host: ${v.hostName}').join('\n'), AppColors.info),
        ],
        const SizedBox(height: AppSpacing.md),
        Text('Patrol Status', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...s.patrolShifts.map((p) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${p.guardName} \u2014 ${p.gate}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${p.shiftStart} - ${p.shiftEnd}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            _chip(p.status, p.status == 'Completed' ? AppColors.success : AppColors.warning),
          ]),
        )),
        const SizedBox(height: AppSpacing.lg),
        Text('Quick Actions', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _showGateModal(context, s), child: Text('+ Log Entry')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white), onPressed: () => _showIncidentModal(context, s), child: Text('+ Report Incident')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white), onPressed: () => _showVisitorModal(context, s), child: Text('+ Pre-Register')),
        ]),
      ]),
    );
  }

  void _showGateModal(BuildContext context, SecurityProvider s) {
    String personType = _personTypes[0];
    String gate = _gates[0];
    final nameCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final plateCtrl = TextEditingController();
    _showFormModal(context, 'Log Gate Entry', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Visitor Name *', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Person Type', personType, _personTypes, (v) => setState(() => personType = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Gate', gate, _gates, (v) => setState(() => gate = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose', purposeCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Vehicle Plate', plateCtrl, hint: 'Optional'),
      ],
    )), () {
      if (nameCtrl.text.isEmpty) return;
      s.addGateLog(personName: nameCtrl.text, personType: personType, direction: 'In', gate: gate, purpose: purposeCtrl.text, vehiclePlate: plateCtrl.text.isEmpty ? null : plateCtrl.text);
    });
  }

  void _showIncidentModal(BuildContext context, SecurityProvider s) {
    String type = _incidentTypes[0];
    String severity = _incidentSeverities[0];
    final locCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final byCtrl = TextEditingController();
    _showFormModal(context, 'Report Incident', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Incident Type', type, _incidentTypes, (v) => setState(() => type = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Severity', severity, _incidentSeverities, (v) => setState(() => severity = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Location *', locCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Description *', descCtrl, multiline: true),
        const SizedBox(height: AppSpacing.sm),
        _formField('Reported By', byCtrl, hint: 'Your name'),
      ],
    )), () {
      if (locCtrl.text.isEmpty || descCtrl.text.isEmpty) return;
      s.addIncident(type: type, location: locCtrl.text, description: descCtrl.text, severity: severity, reportedBy: byCtrl.text.isEmpty ? 'Security Officer' : byCtrl.text);
    });
  }

  void _showVisitorModal(BuildContext context, SecurityProvider s) {
    final nameCtrl = TextEditingController();
    final hostCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: _today());
    final timeCtrl = TextEditingController(text: '10:00');
    _showFormModal(context, 'Pre-Register Visitor', Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Visitor Name *', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Host *', hostCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose', purposeCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Expected Date', dateCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Expected Time', timeCtrl),
      ],
    ), () {
      if (nameCtrl.text.isEmpty || hostCtrl.text.isEmpty) return;
      s.addVisitor(visitorName: nameCtrl.text, hostName: hostCtrl.text, purpose: purposeCtrl.text, expectedDate: dateCtrl.text, expectedTime: timeCtrl.text);
    });
  }
}

class _GateLogPage extends StatelessWidget {
  const _GateLogPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SecurityProvider>();
    final entries = s.gateLogs.where((g) => g.direction == 'In').length;
    final exits = s.gateLogs.where((g) => g.direction == 'Out').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Entries Today', value: '$entries', icon: Icons.login, color: AppColors.success),
          StatCard(label: 'Exits Today', value: '$exits', icon: Icons.logout, color: AppColors.warning),
          StatCard(label: 'Visitors', value: '${s.gateLogs.where((g) => g.personType == 'Visitor').length}', icon: Icons.person, color: AppColors.info),
          StatCard(label: 'Parents', value: '${s.gateLogs.where((g) => g.personType == 'Parent').length}', icon: Icons.family_restroom, color: AppColors.purple),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Log New Entry', () => _showGateModal(context, s)),
        const SizedBox(height: AppSpacing.lg),
        Text('Today\'s Log (${s.gateLogs.length})', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (s.gateLogs.isEmpty)
          Text('No entries logged today.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...s.gateLogs.map((g) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${g.time} \u2014 ${g.personName}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                  Text('${g.personType} | Gate: ${g.gate}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('Purpose: ${g.purpose}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  if (g.vehiclePlate != null) Text('Vehicle: ${g.vehiclePlate}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                ])),
                _chip(g.direction, g.direction == 'In' ? AppColors.success : AppColors.warning),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                if (g.direction == 'In') GestureDetector(
                  onTap: () => s.updateGateLogDirection(g.id, 'Out'),
                  child: Text('Check Out', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
                if (g.direction == 'Out') GestureDetector(
                  onTap: () => s.updateGateLogDirection(g.id, 'In'),
                  child: Text('Check Back In', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(
                  onTap: () => _confirmDelete(context, 'Delete gate log for ${g.personName}?', () => s.deleteGateLog(g.id)),
                  child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600)),
                ),
              ]),
            ]),
          )),
      ]),
    );
  }

  void _showGateModal(BuildContext context, SecurityProvider s) {
    String personType = _personTypes[0];
    String gate = _gates[0];
    final nameCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final plateCtrl = TextEditingController();
    _showFormModal(context, 'Log Gate Entry', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Visitor Name *', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Person Type', personType, _personTypes, (v) => setState(() => personType = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Gate', gate, _gates, (v) => setState(() => gate = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose', purposeCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Vehicle Plate', plateCtrl, hint: 'Optional'),
      ],
    )), () {
      if (nameCtrl.text.isEmpty) return;
      s.addGateLog(personName: nameCtrl.text, personType: personType, direction: 'In', gate: gate, purpose: purposeCtrl.text, vehiclePlate: plateCtrl.text.isEmpty ? null : plateCtrl.text);
    });
  }
}

class _ExeatVerificationPage extends StatefulWidget {
  const _ExeatVerificationPage();
  @override
  State<_ExeatVerificationPage> createState() => _ExeatVerificationPageState();
}

class _ExeatVerificationPageState extends State<_ExeatVerificationPage> {
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final b = context.watch<BoardingProvider>();
    final approved = b.exeats.where((e) => e.status == 'Approved').toList();
    final checkedOut = b.exeats.where((e) => e.status == 'Checked Out').toList();
    final checkedIn = b.exeats.where((e) => e.status == 'Checked In').toList();
    final searchResult = _search.trim().isNotEmpty ? b.exeats.where((e) =>
      e.exeatNo.toLowerCase().contains(_search.toLowerCase()) ||
      e.admissionNo.toLowerCase().contains(_search.toLowerCase()) ||
      e.studentName.toLowerCase().contains(_search.toLowerCase())
    ).toList() : <Exeat>[];

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Approved (Ready)', value: '${approved.length}', icon: Icons.hourglass_empty, color: AppColors.warning),
          StatCard(label: 'Checked Out', value: '${checkedOut.length}', icon: Icons.logout, color: AppColors.info),
          StatCard(label: 'Total Active', value: '${approved.length + checkedOut.length}', icon: Icons.security, color: AppColors.primary),
          StatCard(label: 'Returned', value: '${checkedIn.length}', icon: Icons.login, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Exeat Verification \u2014 Gate Check', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.xs),
        Text('All approved exeats are listed below \u2014 verify and check students in/out at the gate', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(hintText: 'Search by Exeat No, Admission No, or Student Name...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_search.trim().isNotEmpty && searchResult.isNotEmpty) ...[
          ...searchResult.map((e) => _exeatCard(context, e, b)),
        ],
        if (_search.trim().isNotEmpty && searchResult.isEmpty) ...[
          Container(padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Text('No exeat found matching "$_search"', style: TextStyle(color: AppColors.textSecondary))),
        ],
        const SizedBox(height: AppSpacing.md),
        Text('Approved \u2014 Ready for Check Out (${approved.length})', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (approved.isEmpty)
          Text('No students awaiting check out.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...approved.map((e) => _exeatCard(context, e, b, showCheckOut: true)),
        const SizedBox(height: AppSpacing.lg),
        Text('Checked Out \u2014 Awaiting Return (${checkedOut.length})', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (checkedOut.isEmpty)
          Text('No students currently outside.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...checkedOut.map((e) => _exeatCard(context, e, b, showCheckIn: true)),
        if (checkedIn.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Recently Returned (${checkedIn.length})', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...checkedIn.map((e) => _exeatCard(context, e, b)),
        ],
      ]),
    );
  }

  Widget _exeatCard(BuildContext context, Exeat e, BoardingProvider b, {bool showCheckOut = false, bool showCheckIn = false}) {
    final color = e.status == 'Approved' ? AppColors.warning : e.status == 'Checked Out' ? AppColors.info : e.status == 'Checked In' ? AppColors.success : AppColors.textSecondary;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: color, width: 4))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${e.studentName} (${e.admissionNo})', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('Exeat: ${e.exeatNo} | ${e.house} House | Class: ${e.className}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Destination: ${e.destination} | Return: ${e.returnDate}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Reason: ${e.reason} \u2014 ${e.reasonDetail}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Guardian: ${e.guardianName} (${e.guardianPhone}) | Transport: ${e.transportMode}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Approved by: ${e.approvedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
          ])),
          _chip(e.status, color),
        ]),
        if (showCheckOut) ...[
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white), onPressed: () => b.checkOutExeat(e.id, 'Security Officer'), child: Text('Check Out \u2192')),
        ],
        if (showCheckIn) ...[
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white), onPressed: () => b.checkInExeat(e.id, 'Security Officer'), child: Text('Check In \u2192')),
        ],
      ]),
    );
  }
}

class _IncidentsPage extends StatelessWidget {
  const _IncidentsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SecurityProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Incidents', value: '${s.incidents.length}', icon: Icons.report, color: AppColors.primary),
          StatCard(label: 'Active', value: '${s.activeIncidentsCount}', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Critical/High', value: '${s.criticalIncidentsCount}', icon: Icons.dangerous, color: AppColors.danger),
          StatCard(label: 'Resolved', value: '${s.incidents.where((i) => i.status == 'Resolved').length}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Report Incident', () => _showIncidentModal(context, s), color: AppColors.danger),
        const SizedBox(height: AppSpacing.lg),
        Text('All Incidents', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (s.incidents.isEmpty)
          Text('No incidents reported.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...s.incidents.map((i) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _severityColor(i.severity), width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${i.type} at ${i.location}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                  Text('${i.date} at ${i.time} | Reported by ${i.reportedBy}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  _chip(i.severity, _severityColor(i.severity)),
                  const SizedBox(height: 4),
                  _chip(i.status, _statusColor(i.status)),
                ]),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Text(i.description, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
              if (i.action.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text('Action: ${i.action}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
              ],
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    final idx = _incidentStatuses.indexOf(i.status);
                    final next = _incidentStatuses[(idx + 1) % _incidentStatuses.length];
                    s.updateIncidentStatus(i.id, next);
                  },
                  child: Text('Status: ${i.status} \u2192', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(
                  onTap: () => _confirmDelete(context, 'Delete incident ${i.type} at ${i.location}?', () => s.deleteIncident(i.id)),
                  child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600)),
                ),
              ]),
            ]),
          )),
      ]),
    );
  }

  void _showIncidentModal(BuildContext context, SecurityProvider s) {
    String type = _incidentTypes[0];
    String severity = _incidentSeverities[0];
    final locCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final byCtrl = TextEditingController();
    _showFormModal(context, 'Report Incident', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Incident Type', type, _incidentTypes, (v) => setState(() => type = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Severity', severity, _incidentSeverities, (v) => setState(() => severity = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Location *', locCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Description *', descCtrl, multiline: true),
        const SizedBox(height: AppSpacing.sm),
        _formField('Reported By', byCtrl, hint: 'Your name'),
      ],
    )), () {
      if (locCtrl.text.isEmpty || descCtrl.text.isEmpty) return;
      s.addIncident(type: type, location: locCtrl.text, description: descCtrl.text, severity: severity, reportedBy: byCtrl.text.isEmpty ? 'Security Officer' : byCtrl.text);
    });
  }
}

class _PatrolPage extends StatelessWidget {
  const _PatrolPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SecurityProvider>();
    final completed = s.patrolShifts.where((p) => p.status == 'Completed').length;
    final active = s.patrolShifts.where((p) => p.status != 'Completed').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Shifts', value: '${s.patrolShifts.length}', icon: Icons.schedule, color: AppColors.primary),
          StatCard(label: 'Completed', value: '$completed', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Active', value: '$active', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Guards', value: '${s.onDutyGuards}', icon: Icons.shield, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Patrol Shift', () => _showPatrolModal(context, s)),
        const SizedBox(height: AppSpacing.lg),
        Text('Patrol Roster', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...s.patrolShifts.map((p) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${p.guardName} \u2014 ${p.gate}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${p.shiftStart} - ${p.shiftEnd} | ${p.date}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              _chip(p.status, p.status == 'Completed' ? AppColors.success : AppColors.warning),
              const SizedBox(height: 4),
              Row(children: [
                GestureDetector(onTap: () => s.togglePatrolShift(p.id), child: Text(p.status == 'Completed' ? 'Reopen' : 'Complete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Delete patrol shift for ${p.guardName}?', () => s.deletePatrolShift(p.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showPatrolModal(BuildContext context, SecurityProvider s) {
    String shift = _shiftNames[0];
    String gate = _gates[0];
    String guardName = s.guards.isNotEmpty ? s.guards.first.name : '';
    final startCtrl = TextEditingController(text: '06:00');
    final endCtrl = TextEditingController(text: '14:00');
    _showFormModal(context, 'Add Patrol Shift', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Shift', shift, _shiftNames, (v) => setState(() => shift = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Gate', gate, _gates, (v) => setState(() => gate = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Guard', guardName, s.guards.map((g) => g.name).toList(), (v) => setState(() => guardName = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Start Time', startCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('End Time', endCtrl),
      ],
    )), () {
      if (guardName.isEmpty) return;
      s.addPatrolShift(guardName: guardName, gate: gate, shiftStart: startCtrl.text, shiftEnd: endCtrl.text);
    });
  }
}

class _VisitorsPage extends StatelessWidget {
  const _VisitorsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SecurityProvider>();
    final expected = s.visitors.where((v) => v.status == 'Expected').length;
    final arrived = s.visitors.where((v) => v.status == 'Checked In' || v.status == 'Arrived').length;
    final departed = s.visitors.where((v) => v.status == 'Checked Out' || v.status == 'Departed').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total', value: '${s.visitors.length}', icon: Icons.people, color: AppColors.primary),
          StatCard(label: 'Expected', value: '$expected', icon: Icons.hourglass_empty, color: AppColors.warning),
          StatCard(label: 'Arrived', value: '$arrived', icon: Icons.login, color: AppColors.success),
          StatCard(label: 'Departed', value: '$departed', icon: Icons.logout, color: AppColors.textSecondary),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Pre-Register Visitor', () => _showVisitorModal(context, s)),
        const SizedBox(height: AppSpacing.lg),
        Text('Visitors', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (s.visitors.isEmpty)
          Text('No visitors registered.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...s.visitors.map((v) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(v.visitorName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                  Text('Expected: ${v.expectedDate} at ${v.expectedTime}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('Purpose: ${v.purpose} | Host: ${v.hostName}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                ])),
                _chip(v.status, _statusColor(v.status)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                if (v.status == 'Expected') GestureDetector(
                  onTap: () => s.updateVisitorStatus(v.id, 'Checked In'),
                  child: Text('Mark Arrived', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
                if (v.status == 'Checked In') GestureDetector(
                  onTap: () => s.updateVisitorStatus(v.id, 'Checked Out'),
                  child: Text('Mark Departed', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
                if (v.status != 'Checked Out' && v.status != 'Departed') ...[
                  const SizedBox(width: AppSpacing.md),
                  GestureDetector(onTap: () => s.updateVisitorStatus(v.id, 'Cancelled'), child: Text('Cancel', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.warning, fontWeight: FontWeight.w600))),
                ],
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Delete visitor ${v.visitorName}?', () => s.deleteVisitor(v.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          )),
      ]),
    );
  }

  void _showVisitorModal(BuildContext context, SecurityProvider s) {
    final nameCtrl = TextEditingController();
    final hostCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: _today());
    final timeCtrl = TextEditingController(text: '10:00');
    _showFormModal(context, 'Pre-Register Visitor', Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Visitor Name *', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Host *', hostCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose', purposeCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Expected Date', dateCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Expected Time', timeCtrl),
      ],
    ), () {
      if (nameCtrl.text.isEmpty || hostCtrl.text.isEmpty) return;
      s.addVisitor(visitorName: nameCtrl.text, hostName: hostCtrl.text, purpose: purposeCtrl.text, expectedDate: dateCtrl.text, expectedTime: timeCtrl.text);
    });
  }
}

class _ChecklistPage extends StatelessWidget {
  const _ChecklistPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SecurityProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Completed', value: '${s.completedChecklistCount}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Pending', value: '${s.pendingChecklistCount}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Progress', value: '${s.checklistProgress}%', icon: Icons.pie_chart, color: s.checklistProgress == 100 ? AppColors.success : AppColors.primary),
          StatCard(label: 'Total Items', value: '${s.checklist.length}', icon: Icons.list, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Checklist Item', () => _showChecklistModal(context, s)),
        const SizedBox(height: AppSpacing.md),
        Container(height: 8, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(
          alignment: Alignment.centerLeft, widthFactor: s.checklistProgress / 100,
          child: Container(decoration: BoxDecoration(color: s.checklistProgress == 100 ? AppColors.success : AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.sm))),
        )),
        const SizedBox(height: AppSpacing.lg),
        Text('Checklist Items', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...s.checklist.map((c) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            GestureDetector(
              onTap: () => s.toggleChecklistItem(c.id, 'Security Officer'),
              child: Container(width: 24, height: 24, decoration: BoxDecoration(
                color: c.completed == 'Yes' ? AppColors.success : Colors.transparent,
                border: Border.all(color: c.completed == 'Yes' ? AppColors.success : AppColors.border),
                borderRadius: BorderRadius.circular(4),
              ), child: c.completed == 'Yes' ? Icon(Icons.check, size: 16, color: Colors.white) : null),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.task, style: TextStyle(fontSize: AppFontSize.md, fontWeight: c.completed == 'Yes' ? FontWeight.normal : FontWeight.w600, color: c.completed == 'Yes' ? AppColors.textSecondary : AppColors.text, decoration: c.completed == 'Yes' ? TextDecoration.lineThrough : null)),
              Text('Required by ${c.time} | ${c.guardName} | ${c.date}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            ])),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete checklist item "${c.task}"?', () => s.deleteChecklistItem(c.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]),
    );
  }

  void _showChecklistModal(BuildContext context, SecurityProvider s) {
    final taskCtrl = TextEditingController();
    final timeCtrl = TextEditingController(text: '08:00');
    final guardCtrl = TextEditingController(text: s.guards.isNotEmpty ? s.guards.first.name : '');
    _showFormModal(context, 'Add Checklist Item', Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Checklist Item *', taskCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Required By Time', timeCtrl, hint: 'e.g. 22:00'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Guard Name', guardCtrl),
      ],
    ), () {
      if (taskCtrl.text.isEmpty) return;
      s.addChecklistItem(task: taskCtrl.text, time: timeCtrl.text, guardName: guardCtrl.text.isEmpty ? 'Security Officer' : guardCtrl.text);
    });
  }
}

class _GuardsPage extends StatelessWidget {
  const _GuardsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SecurityProvider>();
    final onLeave = s.guards.where((g) => g.status == 'Off Duty').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Guards', value: '${s.guards.length}', icon: Icons.shield, color: AppColors.primary),
          StatCard(label: 'Active', value: '${s.onDutyGuards}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Off Duty', value: '$onLeave', icon: Icons.pause_circle, color: AppColors.warning),
          StatCard(label: 'Shifts Today', value: '${s.patrolShifts.length}', icon: Icons.schedule, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Guard', () => _showGuardModal(context, s)),
        const SizedBox(height: AppSpacing.lg),
        Text('Guard Roster', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...s.guards.map((g) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: g.status == 'On Duty' ? AppColors.success : AppColors.warning, width: 4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('Phone: ${g.phone}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Rank: ${g.rank} | Shift: ${g.shift} | Gate: ${g.assignedGate ?? "\u2014"}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ])),
              _chip(g.status, g.status == 'On Duty' ? AppColors.success : AppColors.warning),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              GestureDetector(onTap: () => s.toggleGuardStatus(g.id), child: Text(g.status == 'On Duty' ? 'Mark Off Duty' : 'Mark Active', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete guard ${g.name}?', () => s.deleteGuard(g.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showGuardModal(BuildContext context, SecurityProvider s) {
    String rank = _ranks[0];
    String shift = _shiftNames[0];
    String gate = _gates[0];
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    _showFormModal(context, 'Add Guard', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Guard Name *', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Phone', phoneCtrl),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Rank', rank, _ranks, (v) => setState(() => rank = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Shift', shift, _shiftNames, (v) => setState(() => shift = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Assigned Gate', gate, _gates, (v) => setState(() => gate = v)),
      ],
    )), () {
      if (nameCtrl.text.isEmpty) return;
      s.addGuard(name: nameCtrl.text, phone: phoneCtrl.text, rank: rank, shift: shift, assignedGate: gate);
    });
  }
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SecurityProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Gate Entries Today', value: '${s.gateLogs.length}', icon: Icons.security, color: AppColors.primary),
          StatCard(label: 'Total Incidents', value: '${s.incidents.length}', icon: Icons.report, color: AppColors.danger),
          StatCard(label: 'Active Incidents', value: '${s.activeIncidentsCount}', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Checklist', value: '${s.checklistProgress}%', icon: Icons.checklist, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, 'Generate Full Report', () {}),
        const SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _reportBtn('Activity Summary', AppColors.primary),
          _reportBtn('Gate Log', AppColors.info),
          _reportBtn('Incidents', AppColors.danger),
          _reportBtn('Patrol Schedule', AppColors.warning),
          _reportBtn('Visitors', AppColors.success),
          _reportBtn('Checklist', AppColors.purple),
          _reportBtn('Guard Roster', AppColors.textSecondary),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Incident Severity Breakdown', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(children: _incidentSeverities.map((sev) {
            final count = s.incidents.where((i) => i.severity == sev).length;
            final pct = s.incidents.isNotEmpty ? (count / s.incidents.length * 100).round() : 0;
            return Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Row(children: [
              SizedBox(width: 80, child: Text(sev, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Container(height: 10, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: pct / 100, child: Container(decoration: BoxDecoration(color: _severityColor(sev), borderRadius: BorderRadius.circular(AppRadius.sm)))))),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(width: 30, child: Text('$count', textAlign: TextAlign.right, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text))),
            ]));
          }).toList()),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Incident Status Breakdown', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(children: _incidentStatuses.map((st) {
            final count = s.incidents.where((i) => i.status == st).length;
            final pct = s.incidents.isNotEmpty ? (count / s.incidents.length * 100).round() : 0;
            return Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Row(children: [
              SizedBox(width: 100, child: Text(st, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Container(height: 10, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: pct / 100, child: Container(decoration: BoxDecoration(color: _statusColor(st), borderRadius: BorderRadius.circular(AppRadius.sm)))))),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(width: 30, child: Text('$count', textAlign: TextAlign.right, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text))),
            ]));
          }).toList()),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Incident Types', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(children: _incidentTypes.map((t) {
            final count = s.incidents.where((i) => i.type == t).length;
            if (count == 0) return SizedBox.shrink();
            final pct = s.incidents.isNotEmpty ? (count / s.incidents.length * 100).round() : 0;
            return Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Row(children: [
              SizedBox(width: 140, child: Text(t, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Container(height: 10, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: pct / 100, child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.sm)))))),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(width: 30, child: Text('$count', textAlign: TextAlign.right, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text))),
            ]));
          }).toList()),
        ),
      ]),
    );
  }

  Widget _reportBtn(String label, Color color) => ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm)),
    onPressed: () {},
    child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
  );
}
