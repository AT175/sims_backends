import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/app_models.dart';
import '../../core/state/registry_provider.dart';
import '../../core/widgets/widgets.dart';

// ── Constants ──

const _documentChecklist = ['Birth Certificate', 'JHS Result', 'CSSPS Placement', 'Medical Form', 'Passport Photo', 'Previous Report Card'];
const _classSections = [
  'SHS1 Sci A', 'SHS1 Sci B', 'SHS1 Arts A', 'SHS1 Arts B', 'SHS1 Bus A',
  'SHS2 Sci A', 'SHS2 Sci B', 'SHS2 Arts A', 'SHS2 Arts B', 'SHS2 Bus A',
  'SHS3 Sci A', 'SHS3 Sci B', 'SHS3 Arts A', 'SHS3 Arts B', 'SHS3 Bus A',
];
const _houses = ['Aggrey', 'Mensah', 'Sarbah', 'Barton'];
const _programmes = ['Science', 'Arts', 'Business'];
const _certTypes = ['Transcript', 'Testimonial', 'Transfer Letter', 'Character Reference', 'Other'];
const _corrDirections = ['Incoming', 'Outgoing'];
const _corrPriorities = ['Normal', 'Important', 'Urgent'];
const _studentStatuses = ['All', 'Active', 'Graduated', 'Withdrawn', 'Transferred'];
const _staffStatuses = ['Active', 'On Leave', 'Retired', 'Resigned'];

// ── Helpers ──

Color _admStatusColor(AdmissionStatus s) => switch (s) {
  AdmissionStatus.approved => AppColors.success,
  AdmissionStatus.rejected => AppColors.danger,
  AdmissionStatus.underReview => AppColors.warning,
  AdmissionStatus.received => AppColors.info,
};

Color _studentStatusColor(StudentStatus s) => switch (s) {
  StudentStatus.active => AppColors.success,
  StudentStatus.graduated => AppColors.info,
  StudentStatus.withdrawn => AppColors.warning,
  StudentStatus.transferred => AppColors.textLight,
};

Color _staffStatusColor(StaffStatus s) => switch (s) {
  StaffStatus.active => AppColors.success,
  StaffStatus.onLeave => AppColors.warning,
  StaffStatus.retired => AppColors.info,
  StaffStatus.resigned => AppColors.textLight,
};

Color _certTypeColor(CertType t) => switch (t) {
  CertType.transcript => AppColors.info,
  CertType.testimonial => AppColors.success,
  CertType.transferLetter => AppColors.warning,
  CertType.characterRef => AppColors.purple,
  CertType.other => AppColors.textSecondary,
};

Color _priorityColor(CorrespondencePriority p) => switch (p) {
  CorrespondencePriority.urgent => AppColors.danger,
  CorrespondencePriority.important => AppColors.warning,
  CorrespondencePriority.normal => AppColors.textSecondary,
};

Color _directionColor(CorrespondenceDir d) => d == CorrespondenceDir.incoming ? AppColors.info : AppColors.success;

String _certTypeLabel(CertType t) => switch (t) {
  CertType.transcript => 'Transcript',
  CertType.testimonial => 'Testimonial',
  CertType.transferLetter => 'Transfer Letter',
  CertType.characterRef => 'Character Reference',
  CertType.other => 'Other',
};

CertType _certTypeFromString(String s) => switch (s) {
  'Transcript' => CertType.transcript,
  'Testimonial' => CertType.testimonial,
  'Transfer Letter' => CertType.transferLetter,
  'Character Reference' => CertType.characterRef,
  _ => CertType.other,
};

Programme _programmeFromString(String s) => switch (s) {
  'Science' => Programme.science,
  'Arts' => Programme.arts,
  'Business' => Programme.business,
  _ => Programme.science,
};

StaffStatus _staffStatusFromString(String s) => switch (s) {
  'Active' => StaffStatus.active,
  'On Leave' => StaffStatus.onLeave,
  'Retired' => StaffStatus.retired,
  'Resigned' => StaffStatus.resigned,
  _ => StaffStatus.active,
};

Widget _chip(String text, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
  child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
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

void _showFormModal(BuildContext context, String title, Widget formContent, VoidCallback onSubmit, {String submitLabel = 'Submit'}) {
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

Widget _actionBtn(BuildContext context, String label, VoidCallback onPressed, {Color? color}) => SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: color ?? AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2)),
    onPressed: onPressed,
    child: Text(label, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600)),
  ),
);

Widget _progressBar(int submitted, int total) {
  final pct = total > 0 ? (submitted / total * 100).round() : 0;
  return Row(children: [
    Expanded(child: Container(height: 8, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: pct / 100,
      child: Container(decoration: BoxDecoration(color: pct == 100 ? AppColors.success : AppColors.warning, borderRadius: BorderRadius.circular(AppRadius.sm))),
    ))),
    const SizedBox(width: AppSpacing.sm),
    Text('$submitted/$total docs', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontWeight: FontWeight.w500)),
  ]);
}

// ── Dashboard ──

class RegistryDashboard extends StatelessWidget {
  final String pageKey;
  const RegistryDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'students': return const _StudentsPage();
      case 'admissions': return const _AdmissionsPage();
      case 'certificates': return const _CertificatesPage();
      case 'correspondence': return const _CorrespondencePage();
      case 'staff': return const _StaffPage();
      case 'reports': return const _ReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    final pending = r.admissions.where((a) => a.status == AdmissionStatus.received || a.status == AdmissionStatus.underReview).toList();
    final approved = r.admissions.where((a) => a.status == AdmissionStatus.approved).length;
    final urgent = r.correspondence.where((c) => c.priority == CorrespondencePriority.urgent).toList();
    final activeStaff = r.staff.where((s) => s.status == StaffStatus.active).length;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Students', value: '${r.students.length}', icon: Icons.school, color: AppColors.primary),
          StatCard(label: 'Pending Admissions', value: '${pending.length}', icon: Icons.pending_actions, color: AppColors.warning),
          StatCard(label: 'Unmatched Placements', value: '${r.unmatchedPlacements}', icon: Icons.warning, color: AppColors.danger),
          StatCard(label: 'Certificates Issued', value: '${r.certificates.length}', icon: Icons.description, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        StatCardGrid(cards: [
          StatCard(label: 'Correspondence', value: '${r.correspondence.length}', icon: Icons.mail, color: AppColors.info),
          StatCard(label: 'Staff Records', value: '${r.staff.length}', icon: Icons.badge, color: AppColors.purple),
          StatCard(label: 'Active Students', value: '${r.activeStudentCount}', icon: Icons.people, color: AppColors.success),
          StatCard(label: 'Approved Admissions', value: '$approved', icon: Icons.check_circle, color: AppColors.accent),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (pending.isNotEmpty) ...[
          Text('Admission Pipeline', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...pending.map((a) {
            final submitted = a.documents.where((d) => d.submitted).length;
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.applicantName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                  Text('${a.dateApplied} — ${a.parentName}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.xs),
                  _progressBar(submitted, _documentChecklist.length),
                ])),
                const SizedBox(width: AppSpacing.sm),
                _chip(a.status.name, _admStatusColor(a.status)),
              ]),
            );
          }),
        ],
        if (urgent.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Urgent Correspondence', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...urgent.map((c) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: AppColors.danger, width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.subject, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.danger)),
              Text('${c.date} — ${c.direction.name} — ${c.counterparty}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text(c.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ]),
          )),
        ],
      ]),
    );
  }
}

class _StudentsPage extends StatelessWidget {
  const _StudentsPage();

  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    return _StudentsPageBody(provider: r);
  }
}

class _StudentsPageBody extends StatefulWidget {
  final RegistryProvider provider;
  const _StudentsPageBody({required this.provider});

  @override
  State<_StudentsPageBody> createState() => _StudentsPageBodyState();
}

class _StudentsPageBodyState extends State<_StudentsPageBody> {
  String _search = '';
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final r = widget.provider;
    var filtered = r.searchStudents(_search);
    if (_filterStatus != 'All') {
      final statusMap = {
        'Active': StudentStatus.active, 'Graduated': StudentStatus.graduated,
        'Withdrawn': StudentStatus.withdrawn, 'Transferred': StudentStatus.transferred,
      };
      filtered = filtered.where((s) => s.status == statusMap[_filterStatus]).toList();
    }

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Students', value: '${r.students.length}', icon: Icons.school, color: AppColors.primary),
          StatCard(label: 'Active', value: '${r.activeStudentCount}', icon: Icons.people, color: AppColors.success),
          StatCard(label: 'Graduated', value: '${r.students.where((s) => s.status == StudentStatus.graduated).length}', icon: Icons.school, color: AppColors.info),
          StatCard(label: 'Houses', value: '${_houses.length}', icon: Icons.home, color: AppColors.purple),
        ]),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          decoration: InputDecoration(hintText: 'Search by name, adm no, class, house...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: _studentStatuses.map((s) => GestureDetector(
          onTap: () => setState(() => _filterStatus = s),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: _filterStatus == s ? AppColors.primary : Colors.transparent,
              border: Border.all(color: _filterStatus == s ? AppColors.primary : AppColors.border),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(s, style: TextStyle(fontSize: AppFontSize.sm, color: _filterStatus == s ? Colors.white : AppColors.textSecondary, fontWeight: _filterStatus == s ? FontWeight.w600 : FontWeight.normal)),
          ),
        )).toList()),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Student Record', () => _showAddStudentModal(context, r)),
        const SizedBox(height: AppSpacing.lg),
        ...filtered.map((s) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.fullName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${s.admNo} | ${s.className} | ${s.programme.label} | ${s.house}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Guardian: ${s.guardianName} — ${s.guardianPhone}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            ])),
            _chip(s.status.name, _studentStatusColor(s.status)),
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete ${s.fullName}?', () => r.deleteStudent(s.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
        if (filtered.isEmpty)
          Text('No students found.', style: TextStyle(color: AppColors.textLight, fontStyle: FontStyle.italic)),
      ]),
    );
  }

  void _showAddStudentModal(BuildContext context, RegistryProvider r) {
    String gender = 'Male', programme = 'Science', className = _classSections[0], house = _houses[0];
    final admNoCtrl = TextEditingController();
    final firstCtrl = TextEditingController();
    final lastCtrl = TextEditingController();
    final dobCtrl = TextEditingController();
    final guardianCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final csspsCtrl = TextEditingController();
    _showFormModal(context, 'Add Student Record', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Admission Number', admNoCtrl, hint: '2026/005'),
        const SizedBox(height: AppSpacing.sm),
        _formField('First Name', firstCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Last Name', lastCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Date of Birth (YYYY-MM-DD)', dobCtrl, hint: '2009-03-15'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Gender', gender, ['Male', 'Female'], (v) => setState(() => gender = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Programme', programme, _programmes, (v) => setState(() => programme = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Class', className, _classSections, (v) => setState(() => className = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('House', house, _houses, (v) => setState(() => house = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Guardian Name', guardianCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Guardian Phone', phoneCtrl, hint: '024-XXX-XXXX', keyboardType: TextInputType.phone),
        const SizedBox(height: AppSpacing.sm),
        _formField('Guardian Address', addressCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('CSSPS Ref (optional)', csspsCtrl, hint: 'CSSPS/2026/XXXX'),
      ],
    )), () {
      if (admNoCtrl.text.isEmpty || firstCtrl.text.isEmpty || lastCtrl.text.isEmpty) return;
      r.addStudent(
        admNo: admNoCtrl.text, firstName: firstCtrl.text, lastName: lastCtrl.text,
        dateOfBirth: dobCtrl.text, gender: gender, programme: _programmeFromString(programme),
        className: className, house: house,
        guardianName: guardianCtrl.text, guardianPhone: phoneCtrl.text, guardianAddress: addressCtrl.text,
        csspsRef: csspsCtrl.text.isEmpty ? null : csspsCtrl.text,
      );
    }, submitLabel: 'Add Student');
  }
}

class _AdmissionsPage extends StatelessWidget {
  const _AdmissionsPage();
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Applications', value: '${r.admissions.length}', icon: Icons.pending_actions, color: AppColors.primary),
          StatCard(label: 'Pending', value: '${r.pendingAdmissions}', icon: Icons.hourglass_empty, color: AppColors.warning),
          StatCard(label: 'Approved', value: '${r.admissions.where((a) => a.status == AdmissionStatus.approved).length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Unmatched Placements', value: '${r.unmatchedPlacements}', icon: Icons.warning, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Pre-load Placement Record', () => _showPlacementModal(context, r)),
        const SizedBox(height: AppSpacing.lg),
        Text('Pending Applications', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...r.admissions.map((a) {
          final submitted = a.documents.where((d) => d.submitted).length;
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: GestureDetector(
              onTap: () => _showAdmissionDetailModal(context, r, a.id),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.applicantName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                  Text('${a.dateApplied} — ${a.parentName} — ${a.parentPhone}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.xs),
                  _progressBar(submitted, _documentChecklist.length),
                ])),
                const SizedBox(width: AppSpacing.sm),
                _chip(a.status.name, _admStatusColor(a.status)),
              ]),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.lg),
        Text('Pre-loaded Placements', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...r.placements.map((p) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.fullName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${p.csspsRef} | ${p.intendedClass} | ${p.programme.label}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            _chip(p.matched ? 'Matched' : 'Unmatched', p.matched ? AppColors.success : AppColors.warning),
            if (!p.matched) ...[
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(onTap: () => r.matchPlacement(p.id), child: Text('Match', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
            ],
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete placement for ${p.fullName}?', () => r.deletePlacement(p.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]),
    );
  }

  void _showPlacementModal(BuildContext context, RegistryProvider r) {
    String programme = 'Science', intendedClass = _classSections[0];
    final nameCtrl = TextEditingController();
    final csspsCtrl = TextEditingController();
    _showFormModal(context, 'Pre-load Placement Record', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Student Full Name', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('CSSPS Placement Ref', csspsCtrl, hint: 'CSSPS/2026/XXXX'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Programme', programme, _programmes, (v) => setState(() => programme = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Intended Class', intendedClass, _classSections, (v) => setState(() => intendedClass = v)),
      ],
    )), () {
      if (nameCtrl.text.isEmpty) return;
      r.addPlacement(fullName: nameCtrl.text, csspsRef: csspsCtrl.text, intendedClass: intendedClass, programme: _programmeFromString(programme));
    }, submitLabel: 'Add Placement');
  }

  void _showAdmissionDetailModal(BuildContext context, RegistryProvider r, String admissionId) {
    final a = r.admissions.firstWhere((x) => x.id == admissionId);
    showModalBottomSheet(
      context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(a.applicantName, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
              GestureDetector(onTap: () => Navigator.pop(ctx), child: Icon(Icons.close, color: AppColors.textLight)),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text('Applied: ${a.dateApplied}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Parent: ${a.parentName} (${a.parentPhone})', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Email: ${a.parentEmail}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Status: ${a.status.name}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Docs Verified: ${a.documentsVerified ? 'Yes' : 'No'}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            if (a.processedBy != null) Text('Processed by: ${a.processedBy}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            Text('Document Checklist', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            ...a.documents.map((doc) => GestureDetector(
              onTap: () => r.toggleDocument(a.id, doc.type),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.sm)),
                child: Row(children: [
                  Container(width: 22, height: 22, decoration: BoxDecoration(
                    color: doc.submitted ? AppColors.success : Colors.transparent,
                    border: Border.all(color: doc.submitted ? AppColors.success : AppColors.border, width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ), child: doc.submitted ? Icon(Icons.check, size: 14, color: Colors.white) : null),
                  const SizedBox(width: AppSpacing.sm),
                  Text(doc.type, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
                ]),
              ),
            )),
            const SizedBox(height: AppSpacing.sm),
            Text('Notes', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            Text(a.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
            const SizedBox(height: AppSpacing.lg),
            if (!a.documentsVerified)
              SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white), onPressed: () { r.verifyDocuments(a.id); Navigator.pop(ctx); }, child: Text('Verify Documents'))),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              if (a.status != AdmissionStatus.underReview && a.status != AdmissionStatus.approved && a.status != AdmissionStatus.rejected)
                Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white), onPressed: () { r.updateAdmissionStatus(a.id, AdmissionStatus.underReview, 'Registrar'); Navigator.pop(ctx); }, child: Text('Under Review'))),
              if (a.status != AdmissionStatus.approved)
                Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white), onPressed: () { r.updateAdmissionStatus(a.id, AdmissionStatus.approved, 'Registrar'); Navigator.pop(ctx); }, child: Text('Approve'))),
              if (a.status != AdmissionStatus.rejected)
                Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white), onPressed: () { r.updateAdmissionStatus(a.id, AdmissionStatus.rejected, 'Registrar'); Navigator.pop(ctx); }, child: Text('Reject'))),
            ]),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(width: double.infinity, child: TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Close'))),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(width: double.infinity, child: TextButton(style: TextButton.styleFrom(foregroundColor: AppColors.danger), onPressed: () { r.deleteAdmission(a.id); Navigator.pop(ctx); }, child: Text('Delete Application'))),
          ]),
        ),
      ),
    );
  }
}

class _CertificatesPage extends StatelessWidget {
  const _CertificatesPage();
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Issued', value: '${r.certificates.length}', icon: Icons.description, color: AppColors.primary),
          StatCard(label: 'Transcripts', value: '${r.certificates.where((c) => c.type == CertType.transcript).length}', icon: Icons.school, color: AppColors.info),
          StatCard(label: 'Testimonials', value: '${r.certificates.where((c) => c.type == CertType.testimonial).length}', icon: Icons.verified, color: AppColors.success),
          StatCard(label: 'Transfer Letters', value: '${r.certificates.where((c) => c.type == CertType.transferLetter).length}', icon: Icons.swap_horiz, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Issue Certificate', () => _showCertModal(context, r)),
        const SizedBox(height: AppSpacing.lg),
        ...r.certificates.map((c) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.studentName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('${c.admNo} — ${c.dateIssued}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text(c.purpose, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textLight)),
              ])),
              _chip(_certTypeLabel(c.type), _certTypeColor(c.type)),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              Text('Issued by ${c.issuedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              const Spacer(),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete this certificate?', () => r.deleteCertificate(c.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showCertModal(BuildContext context, RegistryProvider r) {
    String type = 'Transcript';
    final nameCtrl = TextEditingController();
    final admNoCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    _showFormModal(context, 'Issue Certificate', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Student Name', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Admission Number', admNoCtrl, hint: '2026/001'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Certificate Type', type, _certTypes, (v) => setState(() => type = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose', purposeCtrl, hint: 'Reason for issuance...', multiline: true),
      ],
    )), () {
      if (nameCtrl.text.isEmpty || admNoCtrl.text.isEmpty) return;
      r.issueCertificate(studentName: nameCtrl.text, admNo: admNoCtrl.text, type: _certTypeFromString(type), purpose: purposeCtrl.text);
    }, submitLabel: 'Issue');
  }
}

class _CorrespondencePage extends StatelessWidget {
  const _CorrespondencePage();
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    final urgent = r.correspondence.where((c) => c.priority == CorrespondencePriority.urgent).length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Entries', value: '${r.correspondence.length}', icon: Icons.mail, color: AppColors.primary),
          StatCard(label: 'Urgent', value: '$urgent', icon: Icons.priority_high, color: AppColors.danger),
          StatCard(label: 'Incoming', value: '${r.correspondence.where((c) => c.direction == CorrespondenceDir.incoming).length}', icon: Icons.inbox, color: AppColors.info),
          StatCard(label: 'Outgoing', value: '${r.correspondence.where((c) => c.direction == CorrespondenceDir.outgoing).length}', icon: Icons.outbox, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Log Correspondence', () => _showCorrModal(context, r)),
        const SizedBox(height: AppSpacing.lg),
        ...r.correspondence.map((c) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.subject, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('${c.date} — ${c.counterparty}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text(c.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textLight)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                _chip(c.direction.name, _directionColor(c.direction)),
                const SizedBox(height: 4),
                _chip(c.priority.name, _priorityColor(c.priority)),
              ]),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              Text('Logged by ${c.loggedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              const Spacer(),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete this correspondence entry?', () => r.deleteCorrespondence(c.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showCorrModal(BuildContext context, RegistryProvider r) {
    String direction = 'Incoming', priority = 'Normal';
    final subjectCtrl = TextEditingController();
    final counterpartyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Log Correspondence', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Direction', direction, _corrDirections, (v) => setState(() => direction = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Subject', subjectCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('From / To', counterpartyCtrl, hint: 'GES HQ, Regional Office...'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Priority', priority, _corrPriorities, (v) => setState(() => priority = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, hint: 'Brief description...', multiline: true),
      ],
    )), () {
      if (subjectCtrl.text.isEmpty || counterpartyCtrl.text.isEmpty) return;
      r.logCorrespondence(
        direction: direction == 'Incoming' ? CorrespondenceDir.incoming : CorrespondenceDir.outgoing,
        subject: subjectCtrl.text, counterparty: counterpartyCtrl.text,
        priority: priority == 'Urgent' ? CorrespondencePriority.urgent : priority == 'Important' ? CorrespondencePriority.important : CorrespondencePriority.normal,
        notes: notesCtrl.text,
      );
    }, submitLabel: 'Log');
  }
}

class _StaffPage extends StatelessWidget {
  const _StaffPage();
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    final active = r.staff.where((s) => s.status == StaffStatus.active).length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Staff', value: '${r.staff.length}', icon: Icons.badge, color: AppColors.primary),
          StatCard(label: 'Active', value: '$active', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'On Leave', value: '${r.staff.where((s) => s.status == StaffStatus.onLeave).length}', icon: Icons.beach_access, color: AppColors.warning),
          StatCard(label: 'Departments', value: '${r.staff.map((s) => s.department).toSet().length}', icon: Icons.category, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Staff Record', () => _showStaffModal(context, r)),
        const SizedBox(height: AppSpacing.lg),
        ...r.staff.map((s) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${s.position} — ${s.department}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Employed: ${s.dateOfEmployment}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              Text(s.qualifications.join(', '), style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              Text('Tel: ${s.phone}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            _chip(s.status.name, _staffStatusColor(s.status)),
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete ${s.name}?', () => r.deleteStaff(s.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]),
    );
  }

  void _showStaffModal(BuildContext context, RegistryProvider r) {
    String status = 'Active';
    final nameCtrl = TextEditingController();
    final positionCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final deptCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final qualsCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    _showFormModal(context, 'Add Staff Record', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Full Name', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Position', positionCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Role', roleCtrl, hint: 'hod_academic, bursary, admin...'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Department', deptCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Date of Employment', dateCtrl, hint: '2020-09-01'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Qualifications', qualsCtrl, hint: 'B.Ed, M.Ed...'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Phone', phoneCtrl, hint: '024-XXX-XXXX', keyboardType: TextInputType.phone),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Status', status, _staffStatuses, (v) => setState(() => status = v)),
      ],
    )), () {
      if (nameCtrl.text.isEmpty || positionCtrl.text.isEmpty) return;
      r.addStaff(
        name: nameCtrl.text, position: positionCtrl.text,
        department: deptCtrl.text, role: roleCtrl.text.isEmpty ? 'teacher' : roleCtrl.text,
        phone: phoneCtrl.text,
        qualifications: qualsCtrl.text.isEmpty ? [] : qualsCtrl.text.split(',').map((e) => e.trim()).toList(),
        status: _staffStatusFromString(status),
      );
    }, submitLabel: 'Add Staff');
  }
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    final activeStudents = r.activeStudentCount;
    final totalStudents = r.students.length;
    final activePct = totalStudents > 0 ? (activeStudents / totalStudents * 100).round() : 0;
    final pending = r.pendingAdmissions;
    final approved = r.admissions.where((a) => a.status == AdmissionStatus.approved).length;
    final totalAdm = r.admissions.length;
    final pendingPct = totalAdm > 0 ? (pending / totalAdm * 100).round() : 0;
    final approvedPct = totalAdm > 0 ? (approved / totalAdm * 100).round() : 0;
    final matchedPct = r.placements.isNotEmpty ? (r.matchedPlacements / r.placements.length * 100).round() : 0;
    final activeStaff = r.staff.where((s) => s.status == StaffStatus.active).length;
    final activeStaffPct = r.staff.isNotEmpty ? (activeStaff / r.staff.length * 100).round() : 0;

    final reportTypes = [
      {'name': 'Operations Overview', 'desc': '$totalStudents students, $totalAdm admissions', 'color': AppColors.primary},
      {'name': 'Student Records', 'desc': '$totalStudents total, $activeStudents active', 'color': AppColors.info},
      {'name': 'Admissions Report', 'desc': '$pending pending, $approved approved', 'color': AppColors.warning},
      {'name': 'Certificates', 'desc': '${r.certificates.length} issued', 'color': AppColors.success},
      {'name': 'Correspondence', 'desc': '${r.correspondence.length} entries', 'color': AppColors.purple},
      {'name': 'Staff Records', 'desc': '${r.staff.length} records, $activeStaff active', 'color': AppColors.accent},
    ];

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Certificates Issued', value: '${r.certificates.length}', icon: Icons.description, color: AppColors.info),
          StatCard(label: 'Correspondence', value: '${r.correspondence.length}', icon: Icons.mail, color: AppColors.purple),
          StatCard(label: 'Active Staff', value: '$activeStaff', icon: Icons.people, color: AppColors.success),
          StatCard(label: 'Graduated', value: '${r.students.where((s) => s.status == StudentStatus.graduated).length}', icon: Icons.school, color: AppColors.accent),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Registry Reports', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        Text('Generate printable PDF reports for registry operations', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: AppSpacing.md)),
            onPressed: () => _showPdfPlaceholder(context, 'Full Registry Report'),
            child: Text('Generate Full Report (PDF)', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: reportTypes.map((rt) {
          final color = rt['color'] as Color;
          return GestureDetector(
            onTap: () => _showPdfPlaceholder(context, rt['name'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Text(rt['name'] as String, style: TextStyle(color: Colors.white, fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
            ),
          );
        }).toList()),
        const SizedBox(height: AppSpacing.lg),
        _reportSection(context, 'Student Status', () => _showPdfPlaceholder(context, 'Student Records'), Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: _reportBar('Active', activePct, activeStudents, totalStudents, AppColors.success),
        )),
        const SizedBox(height: AppSpacing.lg),
        _reportSection(context, 'Admission Pipeline', () => _showPdfPlaceholder(context, 'Admissions Report'), Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(children: [
            _reportBar('Pending', pendingPct, pending, totalAdm, AppColors.warning),
            const SizedBox(height: AppSpacing.sm),
            _reportBar('Approved', approvedPct, approved, totalAdm, AppColors.success),
            const SizedBox(height: AppSpacing.sm),
            _reportBar('Matched Placements', matchedPct, r.matchedPlacements, r.placements.length, AppColors.info),
          ]),
        )),
        const SizedBox(height: AppSpacing.lg),
        _reportSection(context, 'Staff Status', () => _showPdfPlaceholder(context, 'Staff Records'), Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: _reportBar('Active', activeStaffPct, activeStaff, r.staff.length, AppColors.success),
        )),
      ]),
    );
  }

  Widget _reportSection(BuildContext context, String title, VoidCallback onPdf, Widget child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
        GestureDetector(onTap: onPdf, child: Text('PDF', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.bold))),
      ]),
      const SizedBox(height: AppSpacing.sm),
      child,
    ]);
  }

  void _showPdfPlaceholder(BuildContext context, String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$reportName PDF generation - coming soon'), duration: const Duration(seconds: 2)));
  }

  Widget _reportBar(String label, int pct, int count, int total, Color color) => Row(children: [
    SizedBox(width: 120, child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
    const SizedBox(width: AppSpacing.sm),
    Expanded(child: Container(height: 12, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: pct / 100,
      child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.sm))),
    ))),
    const SizedBox(width: AppSpacing.sm),
    SizedBox(width: 50, child: Text('$count/$total', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text), textAlign: TextAlign.right)),
  ]);
}
