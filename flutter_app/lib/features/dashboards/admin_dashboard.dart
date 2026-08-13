import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/admin_provider.dart';
import '../../core/state/app_models.dart';
import '../../core/state/boarding_provider.dart';
import '../../core/state/bursar_provider.dart';
import '../../core/state/misc_providers.dart';
import '../../core/state/registry_provider.dart';
import '../../core/state/requisition_provider.dart';
import '../../core/state/security_provider.dart';
import '../../core/widgets/widgets.dart';

class AdminDashboard extends StatelessWidget {
  final String pageKey;
  const AdminDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return _OverviewPage();
      case 'approvals': return _ApprovalsPage();
      case 'compliance': return _CompliancePage();
      case 'admissions': return _AdmissionsPage();
      case 'cssps-upload': return _CsspsUploadPage();
      case 'prospectus': return _ProspectusPage();
      case 'admissions-config': return _AdmissionsConfigPage();
      case 'scratch-cards': return _ScratchCardsPage();
      case 'id-cards': return _IdCardsPage();
      case 'staff': return _StaffPage();
      case 'facilities': return _FacilitiesPage();
      case 'meetings': return _MeetingsPage();
      case 'tasks': return _TasksPage();
      case 'communication': return _CommunicationPage();
      case 'reports': return _ReportsPage();
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

Widget _actionBtn(String label, {Color? color, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      decoration: BoxDecoration(color: color ?? AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(label, style: TextStyle(color: Colors.white, fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _inputLabel(String text) =>
    Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 2),
      child: Text(text, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    );

Widget _textInput(TextEditingController ctrl, {String? hint, int maxLines = 1, TextInputType? keyboardType}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
    ),
  );
}

Widget _chipSelector<T>(List<T> options, T selected, ValueChanged<T> onTap, String Function(T) label) {
  return Wrap(
    spacing: 6,
    runSpacing: 6,
    children: options.map((o) {
      final isActive = o == selected;
      return GestureDetector(
        onTap: () => onTap(o),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceAlt,
            border: Border.all(color: isActive ? AppColors.primary : AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(label(o), style: TextStyle(
            fontSize: AppFontSize.sm,
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          )),
        ),
      );
    }).toList(),
  );
}

void _snackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
}

Future<void> _showFormDialog(BuildContext context, {
  required String title,
  required List<Widget> formFields,
  required VoidCallback onSubmit,
  String submitLabel = 'Submit',
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: formFields)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        TextButton(onPressed: () { onSubmit(); Navigator.pop(ctx); }, child: Text(submitLabel)),
      ],
    ),
  );
}

// ─── CSSPS Upload Page ───

class _CsspsUploadPage extends StatefulWidget {
  @override
  State<_CsspsUploadPage> createState() => _CsspsUploadPageState();
}

class _CsspsUploadPageState extends State<_CsspsUploadPage> {
  final _nameCtrl = TextEditingController();
  final _refCtrl = TextEditingController();
  String _intendedClass = 'SHS1 Sci A';
  Programme _programme = Programme.science;

  final _bulkCtrl = TextEditingController();

  static const _classes = [
    'SHS1 Sci A', 'SHS1 Sci B', 'SHS1 Arts A', 'SHS1 Arts B', 'SHS1 Bus A',
  ];
  static const _programmes = [Programme.science, Programme.arts, Programme.business];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _refCtrl.dispose();
    _bulkCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _nameCtrl.clear();
    _refCtrl.clear();

    _showFormDialog(context,
      title: 'Add CSSPS Placement',
      submitLabel: 'Add',
      formFields: [
        _inputLabel('Student Full Name'),
        _textInput(_nameCtrl, hint: 'e.g. Kofi Asante'),
        _inputLabel('CSSPS Reference'),
        _textInput(_refCtrl, hint: 'e.g. CSSPS/2026/0451'),
        _inputLabel('Intended Class'),
        _chipSelector(_classes, _intendedClass, (v) => setState(() => _intendedClass = v), (s) => s),
        _inputLabel('Programme'),
        _chipSelector(_programmes, _programme, (v) => setState(() => _programme = v), (p) => p.label),
      ],
      onSubmit: () {
        if (_nameCtrl.text.isEmpty || _refCtrl.text.isEmpty) {
          _snackbar(context, 'Name and CSSPS ref are required');
          return;
        }
        context.read<RegistryProvider>().addPlacement(
          fullName: _nameCtrl.text.trim(),
          csspsRef: _refCtrl.text.trim(),
          intendedClass: _intendedClass,
          programme: _programme,
        );
        _snackbar(context, 'Placement added');
      },
    );
  }

  void _showBulkDialog() {
    _bulkCtrl.clear();

    _showFormDialog(context,
      title: 'Bulk Upload Placements (CSV)',
      submitLabel: 'Upload',
      formFields: [
        _inputLabel('CSV Data'),
        _textInput(_bulkCtrl, hint: 'fullName,csspsRef,intendedClass,programme\nKofi Asante,CSSPS/2026/0500,SHS1 Sci A,Science', maxLines: 8),
        _inputLabel('Format'),
        Text('Columns: fullName, csspsRef, intendedClass, programme (Science/Arts/Business)', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
      ],
      onSubmit: () {
        final lines = _bulkCtrl.text.trim().split('\n');
        if (lines.length < 2) {
          _snackbar(context, 'CSV must have a header row and at least one data row');
          return;
        }
        final headers = lines[0].split(',').map((h) => h.trim().toLowerCase()).toList();
        final nameIdx = headers.indexOf('fullname');
        final refIdx = headers.indexOf('csspsref');
        final classIdx = headers.indexOf('intendedclass');
        final progIdx = headers.indexOf('programme');
        if (nameIdx < 0 || refIdx < 0) {
          _snackbar(context, 'CSV must include fullName and csspsRef columns');
          return;
        }
        final items = <({String fullName, String csspsRef, String intendedClass, Programme programme})>[];
        for (var i = 1; i < lines.length; i++) {
          final vals = lines[i].split(',').map((v) => v.trim()).toList();
          if (vals.length < 2) continue;
          final progStr = progIdx >= 0 ? vals[progIdx] : 'Science';
          final prog = progStr.toLowerCase() == 'arts' ? Programme.arts :
                       progStr.toLowerCase() == 'business' ? Programme.business : Programme.science;
          items.add((
            fullName: vals[nameIdx],
            csspsRef: vals[refIdx],
            intendedClass: classIdx >= 0 ? vals[classIdx] : 'SHS1 Sci A',
            programme: prog,
          ));
        }
        if (items.isEmpty) {
          _snackbar(context, 'No valid placement records found');
          return;
        }
        context.read<RegistryProvider>().bulkAddPlacements(items);
        _snackbar(context, '${items.length} placements imported');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Placements', value: '${r.placements.length}', icon: Icons.school, color: AppColors.primaryLight),
        StatCard(label: 'Matched', value: '${r.matchedPlacements}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Unmatched', value: '${r.unmatchedPlacements}', icon: Icons.pending, color: AppColors.warning),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'CSSPS Placement Records',
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          _actionBtn('Bulk CSV', color: AppColors.info, onTap: _showBulkDialog),
          const SizedBox(width: AppSpacing.sm),
          _actionBtn('Add', onTap: _showAddDialog),
        ]),
        child: AppDataTable(
          columns: ['Student Name', 'CSSPS Ref', 'Programme', 'Intended Class', 'Date Loaded', 'Matched', ''],
          rows: r.placements.map((p) => [
            Text(p.fullName), Text(p.csspsRef), Text(p.programme.label),
            Text(p.intendedClass), Text(p.datePreloaded),
            _chip(p.matched ? 'Yes' : 'No', p.matched ? AppColors.success : AppColors.warning),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 18),
              padding: EdgeInsets.zero,
              itemBuilder: (_) => [
                if (!p.matched)
                  const PopupMenuItem(value: 'match', child: Text('Match')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              onSelected: (action) {
                final provider = context.read<RegistryProvider>();
                if (action == 'match') {
                  provider.matchPlacement(p.id);
                  _snackbar(context, 'Placement matched');
                } else if (action == 'delete') {
                  provider.deletePlacement(p.id);
                  _snackbar(context, 'Placement deleted');
                }
              },
            ),
          ]).toList(),
        ),
      ),
    ]);
  }
}

// ─── Scratch Cards Page ───

class _ScratchCardsPage extends StatefulWidget {
  @override
  State<_ScratchCardsPage> createState() => _ScratchCardsPageState();
}

class _ScratchCardsPageState extends State<_ScratchCardsPage> {
  final _countCtrl = TextEditingController(text: '10');
  final _amountCtrl = TextEditingController(text: '50');
  List<ScratchCard> _lastGenerated = [];

  @override
  void dispose() {
    _countCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _showGenerateDialog() {
    _countCtrl.text = '10';
    _amountCtrl.text = '50';
    _lastGenerated = [];

    _showFormDialog(context,
      title: 'Generate Scratch Cards',
      submitLabel: 'Generate',
      formFields: [
        _inputLabel('Number of Cards'),
        _textInput(_countCtrl, hint: '10', keyboardType: TextInputType.number),
        _inputLabel('Amount per Card (GHC)'),
        _textInput(_amountCtrl, hint: '50', keyboardType: TextInputType.number),
      ],
      onSubmit: () {
        final count = int.tryParse(_countCtrl.text) ?? 0;
        final amount = double.tryParse(_amountCtrl.text) ?? 50;
        if (count <= 0) {
          _snackbar(context, 'Count must be greater than 0');
          return;
        }
        final cards = context.read<RegistryProvider>().generateScratchCards(count, amount);
        setState(() => _lastGenerated = cards);
        _snackbar(context, '$count scratch cards generated');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Cards', value: '${r.scratchCards.length}', icon: Icons.card_giftcard, color: AppColors.primaryLight),
        StatCard(label: 'Available', value: '${r.availableScratchCards}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Used', value: '${r.usedScratchCards}', icon: Icons.cancel, color: AppColors.warning),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Application Fee',
        child: Row(children: [
          Text('Current fee: GHC ${r.applicationFeeAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
          const Spacer(),
          _actionBtn('Change Fee', color: AppColors.info, onTap: () {
            final newAmt = r.applicationFeeAmount == 50 ? 100.0 : r.applicationFeeAmount == 100 ? 150.0 : 50.0;
            r.setApplicationFeeAmount(newAmt);
            _snackbar(context, 'Fee set to GHC $newAmt');
          }),
        ]),
      ),
      const SizedBox(height: AppSpacing.lg),
      if (_lastGenerated.isNotEmpty)
        SectionCard(
          title: 'Last Generated Batch (${_lastGenerated.length} cards)',
          child: AppDataTable(
            columns: ['Serial', 'PIN', 'Amount'],
            rows: _lastGenerated.map((c) => [
              Text(c.serial), Text(c.pin), Text('GHC ${c.amount.toStringAsFixed(0)}'),
            ]).toList(),
          ),
        ),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Scratch Cards',
        trailing: _actionBtn('Generate', onTap: _showGenerateDialog),
        child: AppDataTable(
          columns: ['Serial', 'PIN', 'Amount', 'Status', 'Used By', 'Generated'],
          rows: r.scratchCards.map((c) => [
            Text(c.serial), Text(c.pin), Text('GHC ${c.amount.toStringAsFixed(0)}'),
            _chip(c.used ? 'Used' : 'Available', c.used ? AppColors.warning : AppColors.success),
            Text(c.usedBy ?? '—'), Text(c.generatedAt),
          ]).toList(),
        ),
      ),
    ]);
  }
}

// ─── Prospectus Page ───

class _ProspectusPage extends StatefulWidget {
  @override
  State<_ProspectusPage> createState() => _ProspectusPageState();
}

class _ProspectusPageState extends State<_ProspectusPage> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _yearCtrl = TextEditingController(text: '2026/2027');
  List<String> _selectedAdmissionIds = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  void _showPublishDialog() {
    _titleCtrl.clear();
    _contentCtrl.clear();
    setState(() => _selectedAdmissionIds = []);

    final r = context.read<RegistryProvider>();
    final approved = r.admissions.where((a) => a.status == AdmissionStatus.approved).toList();

    _showFormDialog(context,
      title: 'Publish Prospectus',
      submitLabel: 'Publish',
      formFields: [
        _inputLabel('Title'),
        _textInput(_titleCtrl, hint: 'e.g. Welcome Prospectus 2026/2027'),
        _inputLabel('Academic Year'),
        _textInput(_yearCtrl, hint: '2026/2027'),
        _inputLabel('Content'),
        _textInput(_contentCtrl, hint: 'Prospectus content...', maxLines: 6),
        _inputLabel('Target Approved Admissions'),
        ...approved.map((a) => CheckboxListTile(
          dense: true,
          title: Text(a.applicantName, style: const TextStyle(fontSize: AppFontSize.sm)),
          value: _selectedAdmissionIds.contains(a.id),
          onChanged: (v) => setState(() {
            if (v == true) {
              _selectedAdmissionIds.add(a.id);
            } else {
              _selectedAdmissionIds.remove(a.id);
            }
          }),
        )),
        if (approved.isEmpty)
          Text('No approved admissions available.', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
      ],
      onSubmit: () {
        if (_titleCtrl.text.isEmpty || _contentCtrl.text.isEmpty) {
          _snackbar(context, 'Title and content are required');
          return;
        }
        context.read<RegistryProvider>().publishProspectus(
          title: _titleCtrl.text.trim(),
          academicYear: _yearCtrl.text.trim(),
          content: _contentCtrl.text.trim(),
          targetedAdmissionIds: _selectedAdmissionIds,
        );
        _snackbar(context, 'Prospectus published');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    final approved = r.admissions.where((a) => a.status == AdmissionStatus.approved).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Published Prospectus', value: '${r.prospectus.length}', icon: Icons.article, color: AppColors.primaryLight),
        StatCard(label: 'Approved Admissions', value: '${approved.length}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Parent Accounts', value: '${r.parentAccounts.length}', icon: Icons.people, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Approved Admissions (Eligible)',
        child: AppDataTable(
          columns: ['Applicant', 'Programme', 'Parent', 'Phone', 'Parent Account'],
          rows: approved.map((a) {
            final acct = r.getParentAccountByAdmission(a.id);
            return [
              Text(a.applicantName), Text(a.programme.label), Text(a.parentName), Text(a.parentPhone),
              _chip(acct != null ? acct.username : 'Not created', acct != null ? AppColors.success : AppColors.warning),
            ];
          }).toList(),
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Published Prospectus',
        trailing: _actionBtn('Publish', onTap: _showPublishDialog),
        child: r.prospectus.isEmpty
          ? const Text('No prospectus published yet.', style: TextStyle(color: AppColors.textSecondary))
          : Column(children: r.prospectus.map((p) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(p.title, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold))),
                  GestureDetector(
                    onTap: () {
                      context.read<RegistryProvider>().deleteProspectus(p.id);
                      _snackbar(context, 'Prospectus deleted');
                    },
                    child: Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                  ),
                ]),
                const SizedBox(height: 4),
                Text('Academic Year: ${p.academicYear}  |  Published by: ${p.publishedBy}  |  Date: ${p.datePublished}',
                  style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                Text('Targeted: ${p.targetedAdmissionIds.length} admission(s)',
                  style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.sm),
                Text(p.content, maxLines: 4, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ]),
            )).toList()),
      ),
    ]);
  }
}

// ─── Admissions Config Page ───

class _AdmissionsConfigPage extends StatefulWidget {
  @override
  State<_AdmissionsConfigPage> createState() => _AdmissionsConfigPageState();
}

class _AdmissionsConfigPageState extends State<_AdmissionsConfigPage> {
  final _yearCtrl = TextEditingController();

  static const _documentChecklist = [
    'Birth Certificate', 'JHS Result', 'CSSPS Placement',
    'Medical Form', 'Passport Photo', 'Previous Report Card',
  ];

  @override
  void dispose() {
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    final config = r.admissionFormConfig;
    _yearCtrl.text = config.academicYear;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionCard(
        title: 'Academic Year',
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _yearCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              ),
              onChanged: (v) => context.read<RegistryProvider>().updateAcademicYear(v),
            ),
          ),
        ]),
      ),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Photo Requirement',
        child: Row(children: [
          Text(config.photoRequired ? 'Photo Required' : 'Photo Optional',
            style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
          const Spacer(),
          _actionBtn(
            config.photoRequired ? 'Make Optional' : 'Make Required',
            color: config.photoRequired ? AppColors.warning : AppColors.success,
            onTap: () => context.read<RegistryProvider>().togglePhotoRequired(),
          ),
        ]),
      ),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Form Fields',
        child: Column(children: config.fields.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
              Text('Type: ${f.type.name}  |  ${f.required ? 'Required' : 'Optional'}',
                style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
            ])),
            _actionBtn(
              f.enabled ? 'Enabled' : 'Disabled',
              color: f.enabled ? AppColors.success : AppColors.textLight,
              onTap: () => context.read<RegistryProvider>().toggleFormField(f.id),
            ),
          ]),
        )).toList()),
      ),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Required Documents',
        child: Column(children: _documentChecklist.map((doc) {
          final isRequired = config.requiredDocuments.contains(doc);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(children: [
              Text(doc, style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w500)),
              const Spacer(),
              _actionBtn(
                isRequired ? 'Required' : 'Not Required',
                color: isRequired ? AppColors.success : AppColors.textLight,
                onTap: () => context.read<RegistryProvider>().toggleRequiredDoc(doc),
              ),
            ]),
          );
        }).toList()),
      ),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Auto-Assignment Rules',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _infoLine('Admission numbers are auto-generated based on academic year (e.g. 2026/001)'),
          _infoLine('Houses are auto-assigned in round-robin: Aggrey -> Mensah -> Sarbah -> Barton'),
          _infoLine('Classes are auto-assigned based on programme:'),
          _infoLine('  Science -> SHS1 Sci A / SHS1 Sci B', indent: true),
          _infoLine('  Arts -> SHS1 Arts A / SHS1 Arts B', indent: true),
          _infoLine('  Business -> SHS1 Bus A', indent: true),
          _infoLine('Admission can proceed without a student photo'),
        ]),
      ),
    ]);
  }

  Widget _infoLine(String text, {bool indent = false}) => Padding(
    padding: EdgeInsets.only(left: indent ? AppSpacing.md : 0, bottom: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('\u2022 ', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      Expanded(child: Text(text, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
    ]),
  );
}

// ─── ID Cards Page ───

class _IdCardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    final activeStudents = r.students.where((s) => s.status == StudentStatus.active).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Active Students', value: '${activeStudents.length}', icon: Icons.badge, color: AppColors.primaryLight),
        StatCard(label: 'With Photo', value: '${activeStudents.where((s) => s.photoUrl != null).length}', icon: Icons.photo, color: AppColors.success),
        StatCard(label: 'Without Photo', value: '${activeStudents.where((s) => s.photoUrl == null).length}', icon: Icons.photo_camera, color: AppColors.warning),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Active Students (${activeStudents.length})',
        trailing: _actionBtn('Print All', onTap: () => _snackbar(context, 'PDF ID card generation coming soon')),
        child: AppDataTable(
          columns: ['Adm No', 'Name', 'Programme', 'Class', 'House', 'Photo', ''],
          rows: activeStudents.map((s) => [
            Text(s.admNo), Text(s.fullName), Text(s.programme.label),
            Text(s.className), Text(s.house),
            _chip(s.photoUrl != null ? 'Yes' : 'No', s.photoUrl != null ? AppColors.success : AppColors.warning),
            _actionBtn('Print', color: AppColors.info, onTap: () => _snackbar(context, 'ID card for ${s.fullName} - PDF generation coming soon')),
          ]).toList(),
        ),
      ),
    ]);
  }
}

class _OverviewPage extends StatelessWidget {
  _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final a = context.watch<AdminProvider>();
    final staff = context.watch<StaffProvider>();
    final reg = context.watch<RegistryProvider>();
    final req = context.watch<RequisitionProvider>();
    final sec = context.watch<SecurityProvider>();
    final boarding = context.watch<BoardingProvider>();
    final bursar = context.watch<BursarProvider>();
    final pendingLeave = staff.pendingLeave;
    final pendingRequisitions = req.pending.length;
    final pendingProcurement = bursar.procurement.where((p) => p.status == 'Requisitioned').length;
    final pendingExeats = boarding.pendingExeats;
    final openIncidents = sec.openIncidents;
    final activeStudents = reg.activeStudentCount;
    final pendingAdmissions = reg.pendingAdmissions;
    final overdueCompliance = a.overdueCompliance;
    final openFacilities = a.openFacilities;
    final pendingTasks = a.pendingTasks;
    final scheduledMeetings = a.scheduledMeetings;
    final totalStaff = staff.directory.length;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Staff', value: '$totalStaff', icon: Icons.people, color: AppColors.primary),
          StatCard(label: 'Active Students', value: '$activeStudents', icon: Icons.school, color: AppColors.info),
          StatCard(label: 'Pending Leave', value: '$pendingLeave', icon: Icons.pending_actions, color: AppColors.warning),
          StatCard(label: 'Pending Exeats', value: '$pendingExeats', icon: Icons.logout, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.sm),
        StatCardGrid(cards: [
          StatCard(label: 'Pending Requisitions', value: '$pendingRequisitions', icon: Icons.inventory, color: AppColors.warning),
          StatCard(label: 'Pending Procurement', value: '$pendingProcurement', icon: Icons.shopping_cart, color: AppColors.warning),
          StatCard(label: 'Open Incidents', value: '$openIncidents', icon: Icons.security, color: AppColors.danger),
          StatCard(label: 'Open Facilities', value: '$openFacilities', icon: Icons.build, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.sm),
        StatCardGrid(cards: [
          StatCard(label: 'Overdue Compliance', value: '$overdueCompliance', icon: Icons.assignment_late, color: AppColors.danger),
          StatCard(label: 'Pending Tasks', value: '$pendingTasks', icon: Icons.task, color: AppColors.warning),
          StatCard(label: 'Scheduled Meetings', value: '$scheduledMeetings', icon: Icons.event, color: AppColors.info),
          StatCard(label: 'Pending Admissions', value: '$pendingAdmissions', icon: Icons.assignment, color: AppColors.warning),
        ]),
        if (a.compliance.where((c) => c.status == 'Overdue').isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Urgent Alerts', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.danger)),
          const SizedBox(height: AppSpacing.sm),
          ...a.compliance.where((c) => c.status == 'Overdue').map((c) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Text('OVERDUE: ${c.document} — Due ${c.dueDate} (${c.authority})', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600)),
          )),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text('Quick Actions', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _actionBtn('Review Approvals (${pendingLeave + pendingProcurement + pendingExeats})', onTap: () {}),
          _actionBtn('Compliance Tracker', color: AppColors.info, onTap: () {}),
          _actionBtn('Assign Task', color: AppColors.warning, onTap: () {}),
          _actionBtn('Generate Full Report', color: AppColors.primaryLight, onTap: () {}),
        ]),
      ]),
    );
  }
}

class _ApprovalsPage extends StatelessWidget {
  _ApprovalsPage();
  @override
  Widget build(BuildContext context) {
    final staff = context.watch<StaffProvider>();
    final bursar = context.watch<BursarProvider>();
    final boarding = context.watch<BoardingProvider>();
    final req = context.watch<RequisitionProvider>();
    final pendingLeave = staff.leaveRequests.where((l) => l.status == 'Pending').toList();
    final pendingProcurement = bursar.procurement.where((p) => p.status == 'Requisitioned').toList();
    final pendingExeats = boarding.exeats.where((e) => e.status == 'Pending').toList();
    final pendingRequisitions = req.pending;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionCard(
          title: 'Staff Leave Requests (${pendingLeave.length} pending)',
          child: pendingLeave.isEmpty
            ? const Text('No pending leave requests.', style: TextStyle(color: AppColors.textSecondary))
            : AppDataTable(
                columns: ['Staff', 'Type', 'Dates', 'Reason', ''],
                rows: pendingLeave.map((l) => [
                  Text(l.staffName), Text(l.type),
                  Text('${l.startDate} — ${l.endDate}'),
                  Text(l.reason, maxLines: 2, overflow: TextOverflow.ellipsis),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'approve', child: Text('Approve')),
                      const PopupMenuItem(value: 'reject', child: Text('Reject')),
                    ],
                    onSelected: (action) {
                      final provider = context.read<StaffProvider>();
                      if (action == 'approve') {
                        provider.reviewLeave(l.id, 'Approved', 'Asst. Headmaster (Admin)', '');
                        _snackbar(context, 'Leave approved');
                      } else if (action == 'reject') {
                        provider.reviewLeave(l.id, 'Rejected', 'Asst. Headmaster (Admin)', '');
                        _snackbar(context, 'Leave rejected');
                      }
                    },
                  ),
                ]).toList(),
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Procurement Requests (${pendingProcurement.length} pending)',
          child: pendingProcurement.isEmpty
            ? const Text('No pending procurement requests.', style: TextStyle(color: AppColors.textSecondary))
            : AppDataTable(
                columns: ['Date', 'Item', 'Dept', 'Est. Cost', ''],
                rows: pendingProcurement.map((p) => [
                  Text(p.date), Text(p.item), Text(p.department),
                  Text('GH₵ ${p.estimatedCost.toStringAsFixed(2)}'),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'approve', child: Text('Approve')),
                      const PopupMenuItem(value: 'reject', child: Text('Reject')),
                    ],
                    onSelected: (action) {
                      final provider = context.read<BursarProvider>();
                      if (action == 'approve') {
                        provider.approveProcurement(p.id);
                        _snackbar(context, 'Procurement approved');
                      } else if (action == 'reject') {
                        provider.rejectProcurement(p.id);
                        _snackbar(context, 'Procurement rejected');
                      }
                    },
                  ),
                ]).toList(),
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Exeat Approvals (${pendingExeats.length} pending)',
          child: pendingExeats.isEmpty
            ? const Text('No pending exeat requests.', style: TextStyle(color: AppColors.textSecondary))
            : AppDataTable(
                columns: ['Exeat No', 'Student', 'Reason', 'Departure', ''],
                rows: pendingExeats.map((e) => [
                  Text(e.exeatNo), Text(e.studentName), Text(e.reason),
                  Text(e.departureDate),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'approve', child: Text('Approve')),
                      const PopupMenuItem(value: 'reject', child: Text('Reject')),
                    ],
                    onSelected: (action) {
                      final provider = context.read<BoardingProvider>();
                      if (action == 'approve') {
                        provider.approveExeat(e.id, 'Asst. Headmaster (Admin)');
                        _snackbar(context, 'Exeat approved');
                      } else if (action == 'reject') {
                        provider.rejectExeat(e.id, 'Asst. Headmaster (Admin)');
                        _snackbar(context, 'Exeat rejected');
                      }
                    },
                  ),
                ]).toList(),
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Cross-Departmental Requisitions (${pendingRequisitions.length} pending)',
          child: pendingRequisitions.isEmpty
            ? const Text('No pending requisitions.', style: TextStyle(color: AppColors.textSecondary))
            : AppDataTable(
                columns: ['Date', 'Item', 'Dept', 'Qty', 'Priority', 'Status'],
                rows: pendingRequisitions.map((r) => [
                  Text(r.date), Text(r.itemName), Text(r.department),
                  Text('${r.quantity} ${r.unit}'),
                  _chip(r.priority, r.priority == 'Urgent' ? AppColors.danger : r.priority == 'High' ? AppColors.warning : AppColors.info),
                  _chip(r.status, AppColors.warning),
                ]).toList(),
              ),
        ),
      ]),
    );
  }
}

class _CompliancePage extends StatefulWidget {
  @override
  State<_CompliancePage> createState() => _CompliancePageState();
}

class _CompliancePageState extends State<_CompliancePage> {
  final _docCtrl = TextEditingController();
  final _authCtrl = TextEditingController();
  final _dueCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _docCtrl.dispose();
    _authCtrl.dispose();
    _dueCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _docCtrl.clear();
    _authCtrl.clear();
    _dueCtrl.clear();
    _notesCtrl.clear();

    _showFormDialog(context,
      title: 'Add Compliance Item',
      submitLabel: 'Add',
      formFields: [
        _inputLabel('Document'),
        _textInput(_docCtrl, hint: 'e.g. Termly Enrollment Return'),
        _inputLabel('Authority'),
        _textInput(_authCtrl, hint: 'e.g. GES'),
        _inputLabel('Due Date (YYYY-MM-DD)'),
        _textInput(_dueCtrl, hint: '2026-08-01', keyboardType: TextInputType.datetime),
        _inputLabel('Notes'),
        _textInput(_notesCtrl, hint: 'Optional notes', maxLines: 2),
      ],
      onSubmit: () {
        if (_docCtrl.text.isEmpty || _authCtrl.text.isEmpty || _dueCtrl.text.isEmpty) {
          _snackbar(context, 'Document, authority and due date are required');
          return;
        }
        context.read<AdminProvider>().addCompliance(ComplianceItem(
          id: '', document: _docCtrl.text.trim(), authority: _authCtrl.text.trim(),
          dueDate: _dueCtrl.text.trim(), status: 'Not Started', notes: _notesCtrl.text.trim(),
        ));
        _snackbar(context, 'Compliance item added');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = context.watch<AdminProvider>();
    return SectionCard(
      title: 'Compliance Tracker',
      trailing: _actionBtn('Add', onTap: _showAddDialog),
      child: AppDataTable(
        columns: ['Document', 'Authority', 'Due Date', 'Status', 'Submitted', 'Notes', ''],
        rows: a.compliance.map((c) => [
          Text(c.document), Text(c.authority), Text(c.dueDate),
          _chip(c.status, c.status == 'Submitted' ? AppColors.success : c.status == 'Overdue' ? AppColors.danger : c.status == 'In Progress' ? AppColors.warning : AppColors.info),
          Text(c.submittedDate ?? '—'),
          Text(c.notes, maxLines: 2, overflow: TextOverflow.ellipsis),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18),
            padding: EdgeInsets.zero,
            itemBuilder: (_) => [
              if (c.status != 'In Progress')
                const PopupMenuItem(value: 'progress', child: Text('Mark In Progress')),
              if (c.status != 'Submitted')
                const PopupMenuItem(value: 'submit', child: Text('Mark Submitted')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (action) {
              final provider = context.read<AdminProvider>();
              if (action == 'progress') {
                provider.updateCompliance(c.id, status: 'In Progress');
                _snackbar(context, 'Marked in progress');
              } else if (action == 'submit') {
                provider.updateCompliance(c.id, status: 'Submitted');
                _snackbar(context, 'Marked submitted');
              } else if (action == 'delete') {
                provider.deleteCompliance(c.id);
                _snackbar(context, 'Compliance item deleted');
              }
            },
          ),
        ]).toList(),
      ),
    );
  }
}

class _AdmissionsPage extends StatelessWidget {
  _AdmissionsPage();
  @override
  Widget build(BuildContext context) {
    final r = context.watch<RegistryProvider>();
    final activeStudents = r.students.where((s) => s.status == StudentStatus.active).toList();
    final pending = r.admissions.where((a) => a.status == AdmissionStatus.received || a.status == AdmissionStatus.underReview).length;
    final approved = r.admissions.where((a) => a.status == AdmissionStatus.approved).length;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Applications', value: '${r.admissions.length}', icon: Icons.assignment, color: AppColors.primary),
          StatCard(label: 'Pending Review', value: '$pending', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Approved', value: '$approved', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Active Students', value: '${activeStudents.length}', icon: Icons.school, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Admission Applications',
          child: AppDataTable(
            columns: ['Applicant', 'Programme', 'Parent/Guardian', 'Date', 'Status', ''],
            rows: r.admissions.map((a) => [
              Text(a.applicantName), Text(a.programme.label), Text(a.parentName), Text(a.dateApplied),
              _chip(a.status.name, a.status == AdmissionStatus.approved ? AppColors.success : a.status == AdmissionStatus.rejected ? AppColors.danger : AppColors.warning),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                padding: EdgeInsets.zero,
                itemBuilder: (_) => [
                  if (a.status != AdmissionStatus.approved)
                    const PopupMenuItem(value: 'approve', child: Text('Approve')),
                  if (a.status != AdmissionStatus.rejected)
                    const PopupMenuItem(value: 'reject', child: Text('Reject')),
                ],
                onSelected: (action) {
                  final provider = context.read<RegistryProvider>();
                  if (action == 'approve') {
                    provider.updateAdmissionStatus(a.id, AdmissionStatus.approved, 'Asst. Headmaster (Admin)');
                    _snackbar(context, 'Admission approved');
                  } else if (action == 'reject') {
                    provider.updateAdmissionStatus(a.id, AdmissionStatus.rejected, 'Asst. Headmaster (Admin)');
                    _snackbar(context, 'Admission rejected');
                  }
                },
              ),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'CSSPS Placements',
          child: AppDataTable(
            columns: ['Student Name', 'CSSPS Ref', 'Intended Class', 'Matched', ''],
            rows: r.placements.map((p) => [
              Text(p.fullName), Text(p.csspsRef), Text(p.intendedClass),
              _chip(p.matched ? 'Yes' : 'No', p.matched ? AppColors.success : AppColors.warning),
              if (!p.matched)
                _actionBtn('Match', color: AppColors.success, onTap: () {
                  context.read<RegistryProvider>().matchPlacement(p.id);
                  _snackbar(context, 'Placement matched');
                })
              else
                const Text('—'),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Recently Enrolled Students',
          child: AppDataTable(
            columns: ['Adm No', 'Name', 'Programme', 'Class', 'House', 'Status'],
            rows: activeStudents.take(10).map((s) => [
              Text(s.admNo), Text('${s.firstName} ${s.lastName}'), Text(s.programme.label),
              Text(s.className), Text(s.house),
              _chip(s.status == StudentStatus.active ? 'Active' : 'Inactive', s.status == StudentStatus.active ? AppColors.success : AppColors.textLight),
            ]).toList(),
          ),
        ),
      ]),
    );
  }
}

class _StaffPage extends StatelessWidget {
  _StaffPage();
  @override
  Widget build(BuildContext context) {
    final staff = context.watch<StaffProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionCard(
          title: 'Staff Directory (${staff.directory.length})',
          child: AppDataTable(
            columns: ['Name', 'Role', 'Position', 'Dept', 'Phone', 'Status'],
            rows: staff.directory.map((s) => [
              Text(s.name), Text(s.position), Text(s.position), Text(s.department), Text(s.phone),
              _chip(s.status, s.status == 'Active' ? AppColors.success : s.status == 'On Leave' ? AppColors.warning : AppColors.textLight),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'All Leave Requests',
          child: AppDataTable(
            columns: ['Staff', 'Type', 'Dates', 'Status', 'Reviewed By'],
            rows: staff.leaveRequests.map((l) => [
              Text(l.staffName), Text(l.type),
              Text('${l.startDate} — ${l.endDate}'),
              _chip(l.status, l.status == 'Approved' ? AppColors.success : l.status == 'Rejected' ? AppColors.danger : AppColors.warning),
              Text(l.reviewedBy ?? '—'),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Staff Notices', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...staff.notices.map((n) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(n.title, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold, color: AppColors.text)),
              _chip(n.priority, n.priority == 'Urgent' ? AppColors.danger : n.priority == 'Important' ? AppColors.warning : AppColors.textSecondary),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Text(n.body, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Text('Posted by ${n.author} • ${n.date}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
          ]),
        )),
      ]),
    );
  }
}

class _FacilitiesPage extends StatefulWidget {
  @override
  State<_FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<_FacilitiesPage> {
  final _titleCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _assignCtrl = TextEditingController();
  final _reportedByCtrl = TextEditingController(text: 'Asst. Headmaster (Admin)');
  String _category = 'Electrical';
  String _priority = 'Medium';

  static const _categories = ['Electrical', 'Plumbing', 'Furniture', 'Building', 'Equipment', 'Grounds', 'Other'];
  static const _priorities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locCtrl.dispose();
    _descCtrl.dispose();
    _assignCtrl.dispose();
    _reportedByCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _titleCtrl.clear();
    _locCtrl.clear();
    _descCtrl.clear();
    _assignCtrl.clear();

    _showFormDialog(context,
      title: 'Report Facility Issue',
      submitLabel: 'Add',
      formFields: [
        _inputLabel('Title'),
        _textInput(_titleCtrl, hint: 'e.g. Broken window'),
        _inputLabel('Location'),
        _textInput(_locCtrl, hint: 'e.g. Block B, Room 12'),
        _inputLabel('Category'),
        _chipSelector(_categories, _category, (v) => setState(() => _category = v), (s) => s),
        _inputLabel('Priority'),
        _chipSelector(_priorities, _priority, (v) => setState(() => _priority = v), (s) => s),
        _inputLabel('Assigned To (optional)'),
        _textInput(_assignCtrl, hint: 'e.g. Maintenance Team'),
        _inputLabel('Description'),
        _textInput(_descCtrl, hint: 'Brief description', maxLines: 2),
      ],
      onSubmit: () {
        if (_titleCtrl.text.isEmpty || _locCtrl.text.isEmpty) {
          _snackbar(context, 'Title and location are required');
          return;
        }
        context.read<AdminProvider>().addFacility(FacilityIssue(
          id: '', title: _titleCtrl.text.trim(), location: _locCtrl.text.trim(),
          category: _category, priority: _priority, status: 'Reported',
          reportedDate: '', reportedBy: _reportedByCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          assignedTo: _assignCtrl.text.isEmpty ? null : _assignCtrl.text.trim(),
        ));
        _snackbar(context, 'Facility issue reported');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = context.watch<AdminProvider>();
    final openCount = a.facilities.where((f) => f.status != 'Resolved').length;
    final criticalCount = a.facilities.where((f) => f.priority == 'Critical').length;
    final resolvedCount = a.facilities.where((f) => f.status == 'Resolved').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Issues', value: '${a.facilities.length}', icon: Icons.build, color: AppColors.primary),
          StatCard(label: 'Open', value: '$openCount', icon: Icons.warning, color: AppColors.warning),
          StatCard(label: 'Critical', value: '$criticalCount', icon: Icons.dangerous, color: AppColors.danger),
          StatCard(label: 'Resolved', value: '$resolvedCount', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Facilities',
          trailing: _actionBtn('Report', onTap: _showAddDialog),
          child: AppDataTable(
            columns: ['Title', 'Location', 'Category', 'Priority', 'Status', 'Reported', 'Assigned To', ''],
            rows: a.facilities.map((f) => [
              Text(f.title), Text(f.location), Text(f.category),
              _chip(f.priority, f.priority == 'Critical' ? AppColors.danger : f.priority == 'High' ? AppColors.danger : f.priority == 'Medium' ? AppColors.warning : AppColors.info),
              _chip(f.status, f.status == 'Resolved' ? AppColors.success : f.status == 'In Progress' ? AppColors.info : AppColors.warning),
              Text(f.reportedDate), Text(f.assignedTo ?? '—'),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                padding: EdgeInsets.zero,
                itemBuilder: (_) => [
                  if (f.status == 'Reported')
                    const PopupMenuItem(value: 'assign', child: Text('Mark Assigned')),
                  if (f.status == 'Assigned' || f.status == 'Reported')
                    const PopupMenuItem(value: 'progress', child: Text('Mark In Progress')),
                  if (f.status != 'Resolved')
                    const PopupMenuItem(value: 'resolve', child: Text('Mark Resolved')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                onSelected: (action) {
                  final provider = context.read<AdminProvider>();
                  if (action == 'assign') {
                    provider.updateFacility(f.id, status: 'Assigned');
                    _snackbar(context, 'Marked assigned');
                  } else if (action == 'progress') {
                    provider.updateFacility(f.id, status: 'In Progress');
                    _snackbar(context, 'Marked in progress');
                  } else if (action == 'resolve') {
                    provider.updateFacility(f.id, status: 'Resolved');
                    _snackbar(context, 'Marked resolved');
                  } else if (action == 'delete') {
                    provider.deleteFacility(f.id);
                    _snackbar(context, 'Facility issue deleted');
                  }
                },
              ),
            ]).toList(),
          ),
        ),
      ]),
    );
  }
}

class _MeetingsPage extends StatefulWidget {
  @override
  State<_MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<_MeetingsPage> {
  final _titleCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _facCtrl = TextEditingController();
  final _agendaCtrl = TextEditingController();

  // Complete meeting form
  final _minutesCtrl = TextEditingController();
  final _decisionsCtrl = TextEditingController();
  final _actionsCtrl = TextEditingController();
  final _attendeesCtrl = TextEditingController(text: '0');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _locCtrl.dispose();
    _facCtrl.dispose();
    _agendaCtrl.dispose();
    _minutesCtrl.dispose();
    _decisionsCtrl.dispose();
    _actionsCtrl.dispose();
    _attendeesCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _titleCtrl.clear();
    _dateCtrl.clear();
    _timeCtrl.clear();
    _locCtrl.clear();
    _facCtrl.clear();
    _agendaCtrl.clear();

    _showFormDialog(context,
      title: 'Schedule Meeting',
      submitLabel: 'Add',
      formFields: [
        _inputLabel('Title'),
        _textInput(_titleCtrl, hint: 'e.g. Term 3 Review'),
        _inputLabel('Date (YYYY-MM-DD)'),
        _textInput(_dateCtrl, hint: '2026-08-01', keyboardType: TextInputType.datetime),
        _inputLabel('Time'),
        _textInput(_timeCtrl, hint: '15:00'),
        _inputLabel('Location'),
        _textInput(_locCtrl, hint: 'e.g. Main Hall'),
        _inputLabel('Facilitator'),
        _textInput(_facCtrl, hint: 'e.g. Headmaster'),
        _inputLabel('Agenda'),
        _textInput(_agendaCtrl, hint: 'Agenda items', maxLines: 3),
      ],
      onSubmit: () {
        if (_titleCtrl.text.isEmpty || _dateCtrl.text.isEmpty) {
          _snackbar(context, 'Title and date are required');
          return;
        }
        context.read<AdminProvider>().addMeeting(AdminMeeting(
          id: '', title: _titleCtrl.text.trim(), date: _dateCtrl.text.trim(),
          time: _timeCtrl.text.trim(), location: _locCtrl.text.trim(),
          facilitator: _facCtrl.text.trim(), agenda: _agendaCtrl.text.trim(),
          status: 'Scheduled', attendees: 0,
        ));
        _snackbar(context, 'Meeting scheduled');
      },
    );
  }

  void _showCompleteDialog(AdminMeeting m) {
    _minutesCtrl.clear();
    _decisionsCtrl.clear();
    _actionsCtrl.clear();
    _attendeesCtrl.text = '0';

    _showFormDialog(context,
      title: 'Complete Meeting',
      submitLabel: 'Complete',
      formFields: [
        _inputLabel('Minutes'),
        _textInput(_minutesCtrl, hint: 'Meeting minutes', maxLines: 3),
        _inputLabel('Key Decisions'),
        _textInput(_decisionsCtrl, hint: 'Decisions made', maxLines: 2),
        _inputLabel('Action Items'),
        _textInput(_actionsCtrl, hint: 'Action items', maxLines: 2),
        _inputLabel('Attendees'),
        _textInput(_attendeesCtrl, hint: '0', keyboardType: TextInputType.number),
      ],
      onSubmit: () {
        context.read<AdminProvider>().completeMeeting(
          m.id, _minutesCtrl.text.trim(), _decisionsCtrl.text.trim(),
          _actionsCtrl.text.trim(), int.tryParse(_attendeesCtrl.text) ?? 0,
        );
        _snackbar(context, 'Meeting completed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = context.watch<AdminProvider>();
    final scheduled = a.meetings.where((m) => m.status == 'Scheduled').length;
    final completed = a.meetings.where((m) => m.status == 'Completed').length;
    final cancelled = a.meetings.where((m) => m.status == 'Cancelled').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Scheduled', value: '$scheduled', icon: Icons.event, color: AppColors.info),
          StatCard(label: 'Completed', value: '$completed', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Cancelled', value: '$cancelled', icon: Icons.cancel, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Meetings', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          _actionBtn('Schedule', onTap: _showAddDialog),
        ]),
        const SizedBox(height: AppSpacing.sm),
        ...a.meetings.map((m) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(m.title, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold, color: AppColors.text)),
              _chip(m.status, m.status == 'Completed' ? AppColors.success : m.status == 'Cancelled' ? AppColors.danger : AppColors.warning),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Text('${m.date} at ${m.time} • ${m.location}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Text('Facilitator: ${m.facilitator}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
            if (m.agenda.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text('Agenda: ${m.agenda}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            if (m.status == 'Completed' && m.minutes != null && m.minutes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppRadius.sm)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Minutes:', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.bold, color: AppColors.text)),
                  Text(m.minutes!, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                  if (m.keyDecisions != null && m.keyDecisions!.isNotEmpty)
                    Text('Decisions: ${m.keyDecisions}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                  if (m.actionItems != null && m.actionItems!.isNotEmpty)
                    Text('Actions: ${m.actionItems}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
                ]),
              ),
            ],
            if (m.status == 'Scheduled') ...[
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                _actionBtn('Record Minutes', color: AppColors.success, onTap: () => _showCompleteDialog(m)),
                const SizedBox(width: AppSpacing.sm),
                _actionBtn('Cancel', color: AppColors.danger, onTap: () {
                  context.read<AdminProvider>().cancelMeeting(m.id);
                  _snackbar(context, 'Meeting cancelled');
                }),
              ]),
            ],
          ]),
        )),
      ]),
    );
  }
}

class _TasksPage extends StatefulWidget {
  @override
  State<_TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<_TasksPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _assignCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  final _dueCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _priority = 'Normal';

  static const _priorities = ['Low', 'Normal', 'High', 'Urgent'];
  static const _statuses = ['Pending', 'In Progress', 'Completed', 'Overdue'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _assignCtrl.dispose();
    _deptCtrl.dispose();
    _dueCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _titleCtrl.clear();
    _descCtrl.clear();
    _assignCtrl.clear();
    _deptCtrl.clear();
    _dueCtrl.clear();
    _notesCtrl.clear();

    _showFormDialog(context,
      title: 'Assign Task',
      submitLabel: 'Assign',
      formFields: [
        _inputLabel('Title'),
        _textInput(_titleCtrl, hint: 'e.g. Compile Staff Report'),
        _inputLabel('Description'),
        _textInput(_descCtrl, hint: 'Task description', maxLines: 2),
        _inputLabel('Assigned To'),
        _textInput(_assignCtrl, hint: 'e.g. Registrar'),
        _inputLabel('Department'),
        _textInput(_deptCtrl, hint: 'e.g. Registry'),
        _inputLabel('Due Date (YYYY-MM-DD)'),
        _textInput(_dueCtrl, hint: '2026-08-01', keyboardType: TextInputType.datetime),
        _inputLabel('Priority'),
        _chipSelector(_priorities, _priority, (v) => setState(() => _priority = v), (s) => s),
        _inputLabel('Notes'),
        _textInput(_notesCtrl, hint: 'Optional notes'),
      ],
      onSubmit: () {
        if (_titleCtrl.text.isEmpty || _assignCtrl.text.isEmpty || _dueCtrl.text.isEmpty) {
          _snackbar(context, 'Title, assignee and due date are required');
          return;
        }
        context.read<AdminProvider>().addTask(TaskAssignment(
          id: '', title: _titleCtrl.text.trim(), description: _descCtrl.text.trim(),
          assignedTo: _assignCtrl.text.trim(), department: _deptCtrl.text.trim(),
          dueDate: _dueCtrl.text.trim(), priority: _priority, status: 'Pending',
          assignedBy: 'Asst. Headmaster (Admin)', notes: _notesCtrl.text.trim(),
        ));
        _snackbar(context, 'Task assigned');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = context.watch<AdminProvider>();
    final pendingCount = a.tasks.where((t) => t.status == 'Pending').length;
    final inProgressCount = a.tasks.where((t) => t.status == 'In Progress').length;
    final completedCount = a.tasks.where((t) => t.status == 'Completed').length;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Tasks', value: '${a.tasks.length}', icon: Icons.task, color: AppColors.primary),
          StatCard(label: 'Pending', value: '$pendingCount', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'In Progress', value: '$inProgressCount', icon: Icons.play_circle, color: AppColors.info),
          StatCard(label: 'Completed', value: '$completedCount', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Task Assignments',
          trailing: _actionBtn('Assign', onTap: _showAddDialog),
          child: AppDataTable(
            columns: ['Title', 'Assigned To', 'Department', 'Due Date', 'Priority', 'Status', ''],
            rows: a.tasks.map((t) => [
              Text(t.title), Text(t.assignedTo), Text(t.department), Text(t.dueDate),
              _chip(t.priority, t.priority == 'Urgent' ? AppColors.danger : t.priority == 'High' ? AppColors.warning : AppColors.info),
              _chip(t.status, t.status == 'Completed' ? AppColors.success : t.status == 'In Progress' ? AppColors.info : t.status == 'Overdue' ? AppColors.danger : AppColors.warning),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                padding: EdgeInsets.zero,
                itemBuilder: (_) => [
                  ..._statuses.where((s) => s != t.status).map((s) =>
                    PopupMenuItem(value: s, child: Text('Mark $s'))),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                onSelected: (action) {
                  final provider = context.read<AdminProvider>();
                  if (action == 'delete') {
                    provider.deleteTask(t.id);
                    _snackbar(context, 'Task deleted');
                  } else {
                    provider.updateTaskStatus(t.id, action);
                    _snackbar(context, 'Task marked $action');
                  }
                },
              ),
            ]).toList(),
          ),
        ),
      ]),
    );
  }
}

class _CommunicationPage extends StatefulWidget {
  @override
  State<_CommunicationPage> createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<_CommunicationPage> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  String _priority = 'Normal';
  String _audience = 'All Staff';

  static const _priorities = ['Normal', 'Important', 'Urgent'];
  static const _audiences = ['All Staff', 'Teaching Staff', 'Non-Teaching Staff', 'All Students', 'Parents'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _titleCtrl.clear();
    _bodyCtrl.clear();

    _showFormDialog(context,
      title: 'New Announcement',
      submitLabel: 'Post',
      formFields: [
        _inputLabel('Title'),
        _textInput(_titleCtrl, hint: 'e.g. Staff Meeting Reminder'),
        _inputLabel('Body'),
        _textInput(_bodyCtrl, hint: 'Announcement body', maxLines: 3),
        _inputLabel('Priority'),
        _chipSelector(_priorities, _priority, (v) => setState(() => _priority = v), (s) => s),
        _inputLabel('Audience'),
        _chipSelector(_audiences, _audience, (v) => setState(() => _audience = v), (s) => s),
      ],
      onSubmit: () {
        if (_titleCtrl.text.isEmpty || _bodyCtrl.text.isEmpty) {
          _snackbar(context, 'Title and body are required');
          return;
        }
        context.read<AdminProvider>().addAnnouncement(AdminAnnouncement(
          id: '', title: _titleCtrl.text.trim(), body: _bodyCtrl.text.trim(),
          date: '', priority: _priority, audience: _audience,
          postedBy: 'Asst. Headmaster (Admin)',
        ));
        _snackbar(context, 'Announcement posted');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = context.watch<AdminProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Communication', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          _actionBtn('New', onTap: _showAddDialog),
        ]),
        const SizedBox(height: AppSpacing.sm),
        if (a.announcements.isEmpty)
          const Text('No announcements posted.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...a.announcements.map((an) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(an.title, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold, color: AppColors.text)),
                _chip(an.priority, an.priority == 'Urgent' ? AppColors.danger : an.priority == 'Important' ? AppColors.warning : AppColors.textSecondary),
              ]),
              const SizedBox(height: AppSpacing.xs),
              Text(an.body, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Posted by ${an.postedBy} • ${an.date}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
                GestureDetector(
                  onTap: () {
                    context.read<AdminProvider>().deleteAnnouncement(an.id);
                    _snackbar(context, 'Announcement deleted');
                  },
                  child: Text('Delete', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.danger, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.sm)),
                child: Text('Audience: ${an.audience}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.primary)),
              ),
            ]),
          )),
      ]),
    );
  }
}

class _ReportsPage extends StatelessWidget {
  _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final a = context.watch<AdminProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Compliance', value: '${a.compliance.length}', icon: Icons.assignment, color: AppColors.primaryLight),
        StatCard(label: 'Facilities', value: '${a.facilities.length}', icon: Icons.build, color: AppColors.warning),
        StatCard(label: 'Meetings', value: '${a.meetings.length}', icon: Icons.event, color: AppColors.info),
        StatCard(label: 'Tasks', value: '${a.tasks.length}', icon: Icons.task, color: AppColors.purple),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(
        title: 'Available Reports',
        child: Column(
          children: [
            _reportTile(context, 'Full Administrative Report', 'Complete overview of all administrative operations', Icons.summarize),
            _reportTile(context, 'Staff Summary', 'Staff directory, leave requests, and statistics', Icons.people),
            _reportTile(context, 'Procurement Report', 'Procurement, requisitions, petty cash, and imprest', Icons.shopping_cart),
            _reportTile(context, 'Compliance Status Report', 'All compliance items with deadlines and status', Icons.assignment_late),
            _reportTile(context, 'Security Summary', 'Incidents, gate logs, and security statistics', Icons.security),
            _reportTile(context, 'Facility Report', 'All facility issues and maintenance status', Icons.build),
            _reportTile(context, 'Exeat Report', 'Student exeat records and statistics', Icons.logout),
            _reportTile(context, 'Task Assignment Report', 'All task assignments and completion status', Icons.task),
            _reportTile(context, 'Admissions Report', 'Admission applications, placements, and enrolled students', Icons.school),
          ],
        ),
      ),
    ]);
  }

  Widget _reportTile(BuildContext context, String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryLight),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
      trailing: Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: () => _snackbar(context, 'PDF report generation coming soon'),
    );
  }
}
