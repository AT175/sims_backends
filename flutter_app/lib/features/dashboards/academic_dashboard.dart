import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/app_models.dart';
import '../../core/state/academic_provider.dart';
import '../../core/state/registry_provider.dart';
import '../../core/state/requisition_provider.dart';
import '../../core/widgets/widgets.dart';

/// Academic dashboard — 14 pages.
class AcademicDashboard extends StatelessWidget {
  final String pageKey;

  const AcademicDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview':
        return _OverviewPage();
      case 'monitor':
        return _MonitorPage();
      case 'insights':
        return _InsightsPage();
      case 'timetable':
        return _TimetablePage();
      case 'exams':
        return _ExamsPage();
      case 'reports':
        return _ReportCardsPage();
      case 'transcripts':
        return _TranscriptsPage();
      case 'spip':
        return _SpipPage();
      case 'curriculum':
        return _CurriculumPage();
      case 'calendar':
        return _CalendarPage();
      case 'hod':
        return _HodApprovalsPage();
      case 'supplies':
        return _SuppliesPage();
      case 'plc':
        return _PlcPage();
      case 'academic-reports':
        return _AcademicReportsPage();
      default:
        return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

// ── Helpers ──

Color _examStatusColor(ExamStatus s) => switch (s) {
  ExamStatus.scheduled => AppColors.warning,
  ExamStatus.ongoing => AppColors.info,
  ExamStatus.completed => AppColors.success,
  ExamStatus.cancelled => AppColors.danger,
};

Color _reportCardStatusColor(ReportCardStatus s) => switch (s) {
  ReportCardStatus.notGenerated => AppColors.textLight,
  ReportCardStatus.generated => AppColors.info,
  ReportCardStatus.underReview => AppColors.warning,
  ReportCardStatus.released => AppColors.success,
};

Color _transcriptStatusColor(TranscriptStatus s) => switch (s) {
  TranscriptStatus.draft => AppColors.textLight,
  TranscriptStatus.pendingReview => AppColors.warning,
  TranscriptStatus.approved => AppColors.success,
  TranscriptStatus.released => AppColors.info,
  TranscriptStatus.rejected => AppColors.danger,
};

Color _hodStatusColor(HodApprovalStatus s) => switch (s) {
  HodApprovalStatus.pending => AppColors.warning,
  HodApprovalStatus.approved => AppColors.success,
  HodApprovalStatus.deferred => AppColors.info,
  HodApprovalStatus.rejected => AppColors.danger,
};

Widget _badge(String text, Color color) {
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

Future<bool> _confirmDialog(BuildContext context, String title, String message) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete', style: TextStyle(color: AppColors.danger))),
      ],
    ),
  );
  return result ?? false;
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

class _OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    final registry = context.watch<RegistryProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatCardGrid(cards: [
          StatCard(label: 'Active Students', value: '${registry.activeStudentCount}', icon: Icons.school, color: AppColors.primaryLight),
          StatCard(label: 'Scheduled Exams', value: '${academic.scheduledExams}', icon: Icons.assignment, color: AppColors.warning),
          StatCard(label: 'Pending HOD Approvals', value: '${academic.pendingApprovals}', icon: Icons.pending, color: AppColors.danger),
          StatCard(label: 'Avg Coverage', value: '${academic.avgCoverage.toStringAsFixed(1)}%', icon: Icons.track_changes, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Curriculum Coverage Summary',
          child: AppDataTable(
            columns: ['Subject', 'Class', 'Coverage', 'Status'],
            rows: academic.curriculum.map((c) => [
              Text(c.subject),
              Text(c.classForm),
              Text('${c.coveragePct.toStringAsFixed(1)}%'),
              _statusChip(c.status.name),
            ]).toList(),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    final color = status == 'completed' ? AppColors.success : status == 'inProgress' ? AppColors.warning : AppColors.textLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(status, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _MonitorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatCardGrid(cards: [
          StatCard(label: 'Scheduled Exams', value: '${academic.scheduledExams}', icon: Icons.schedule, color: AppColors.info),
          StatCard(label: 'Pending HOD', value: '${academic.pendingApprovals}', icon: Icons.pending, color: AppColors.danger),
          StatCard(label: 'Pending Reports', value: '${academic.pendingReportCards}', icon: Icons.assignment, color: AppColors.warning),
          StatCard(label: 'Pending Transcripts', value: '${academic.pendingTranscripts}', icon: Icons.receipt, color: AppColors.warning),
          StatCard(label: 'Avg Coverage', value: '${academic.avgCoverage.toStringAsFixed(1)}%', icon: Icons.track_changes, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Teacher Activity Monitor',
          child: AppDataTable(
            columns: ['Teacher', 'Dept', 'Plans', 'Materials', 'Assignments', 'Att%', 'Cov%', 'Status'],
            rows: academic.teacherActivity.map((t) => [
              Text(t.teacherName),
              Text(t.department),
              Text('${t.lessonPlansThisTerm}'),
              Text('${t.materialsUploaded}'),
              Text('${t.assignmentsCreated}'),
              Text('${t.attendanceMarkedPct}%'),
              Text('${t.syllabusCoverage}%'),
              _statusChip(t.status),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Curriculum Coverage Alerts',
          child: academic.curriculum.where((c) => c.coveragePct < 70).isEmpty
              ? const Text('No coverage alerts. All subjects on track.', style: TextStyle(color: AppColors.textSecondary))
              : Column(
                  children: academic.curriculum.where((c) => c.coveragePct < 70).map((c) => ListTile(
                    leading: Icon(Icons.warning, color: AppColors.warning),
                    title: Text('${c.subject} — ${c.classForm}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
                    subtitle: Text('Coverage: ${c.coveragePct.toStringAsFixed(1)}% | HOD: ${c.hod}', style: const TextStyle(fontSize: AppFontSize.xs)),
                  )).toList(),
                ),
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    final color = status == 'Active' ? AppColors.success : status == 'On Leave' ? AppColors.warning : AppColors.textLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(status, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _InsightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionCard(
          title: 'Admission Insights',
          child: AppDataTable(
            columns: ['Class', 'Applied', 'Admitted', 'Pending', 'Capacity', 'Filled'],
            rows: academic.admissionInsights.map((i) => [
              Text(i.classForm),
              Text('${i.applied}'),
              Text('${i.admitted}'),
              Text('${i.pending}'),
              Text('${i.capacity}'),
              Text('${i.filled}'),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Subject Performance Trends',
          child: AppDataTable(
            columns: ['Subject', 'Dept', 'HOD', 'Avg', 'Pass Rate', 'Coverage', 'Teachers', 'Students', 'Trend'],
            rows: academic.subjectPerformance.map((s) => [
              Text(s.subject),
              Text(s.department),
              Text(s.hod),
              Text('${s.avgScore.toStringAsFixed(0)}%'),
              Text('${s.passRate.toStringAsFixed(0)}%'),
              Text('${s.coveragePct.toStringAsFixed(0)}%'),
              Text('${s.teacherCount}'),
              Text('${s.studentCount}'),
              Text(s.trend == 'up' ? '↑' : s.trend == 'down' ? '↓' : '→'),
            ]).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Teacher Productivity',
          child: AppDataTable(
            columns: ['Teacher', 'Dept', 'Plans', 'Materials', 'Att%', 'Cov%'],
            rows: academic.teacherActivity.map((t) => [
              Text(t.teacherName),
              Text(t.department),
              Text('${t.lessonPlansThisTerm}'),
              Text('${t.materialsUploaded}'),
              Text('${t.attendanceMarkedPct}%'),
              Text('${t.syllabusCoverage}%'),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}

class _TimetablePage extends StatefulWidget {
  @override
  State<_TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<_TimetablePage> {
  final _classCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _teacherCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  final _startCtrl = TextEditingController(text: '07:30');
  final _endCtrl = TextEditingController(text: '08:20');
  String _selectedDay = 'Monday';
  int _selectedPeriod = 1;

  @override
  void dispose() {
    _classCtrl.dispose();
    _subjectCtrl.dispose();
    _teacherCtrl.dispose();
    _roomCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _classCtrl.clear();
    _subjectCtrl.clear();
    _teacherCtrl.clear();
    _roomCtrl.clear();
    _selectedDay = 'Monday';
    _selectedPeriod = 1;

    _showFormDialog(context,
      title: 'Add Timetable Entry',
      submitLabel: 'Add',
      formFields: [
        _inputLabel('Class'),
        _textInput(_classCtrl, hint: 'e.g. SHS1 Sci A'),
        _inputLabel('Day'),
        _chipSelector(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], _selectedDay, (v) => setState(() => _selectedDay = v), (s) => s),
        _inputLabel('Period'),
        _chipSelector([1, 2, 3, 4, 5, 6, 7, 8], _selectedPeriod, (v) => setState(() => _selectedPeriod = v), (n) => 'P$n'),
        _inputLabel('Subject'),
        _textInput(_subjectCtrl, hint: 'e.g. Core Mathematics'),
        _inputLabel('Teacher'),
        _textInput(_teacherCtrl, hint: 'e.g. Mr. Mensah'),
        _inputLabel('Room'),
        _textInput(_roomCtrl, hint: 'e.g. A1'),
        _inputLabel('Start Time'),
        _textInput(_startCtrl, hint: '07:30'),
        _inputLabel('End Time'),
        _textInput(_endCtrl, hint: '08:20'),
      ],
      onSubmit: () {
        if (_classCtrl.text.isEmpty || _subjectCtrl.text.isEmpty) {
          _snackbar(context, 'Class and subject are required');
          return;
        }
        context.read<AcademicProvider>().addTimetable(TimetableEntry(
          id: '',
          classForm: _classCtrl.text.trim(),
          day: _selectedDay,
          period: _selectedPeriod,
          startTime: _startCtrl.text.trim(),
          endTime: _endCtrl.text.trim(),
          subject: _subjectCtrl.text.trim(),
          teacher: _teacherCtrl.text.trim(),
          room: _roomCtrl.text.trim(),
          status: TimetableStatus.draft,
        ));
        _snackbar(context, 'Timetable entry added');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return SectionCard(
      title: 'Timetable Manager',
      trailing: _actionBtn('Add Entry', onTap: _showAddDialog),
      child: AppDataTable(
        columns: ['Class', 'Day', 'Period', 'Subject', 'Teacher', 'Room', 'Status', ''],
        rows: academic.timetables.map((t) => [
          Text(t.classForm),
          Text(t.day),
          Text('P${t.period}'),
          Text(t.subject),
          Text(t.teacher),
          Text(t.room),
          _badge(t.status.name, t.status == TimetableStatus.published ? AppColors.success : AppColors.warning),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18),
            padding: EdgeInsets.zero,
            itemBuilder: (_) => [
              if (t.status != TimetableStatus.published)
                const PopupMenuItem(value: 'publish', child: Text('Publish')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (action) {
              if (action == 'publish') {
                context.read<AcademicProvider>().publishTimetable(t.id);
                _snackbar(context, 'Timetable entry published');
              } else if (action == 'delete') {
                context.read<AcademicProvider>().deleteTimetable(t.id);
                _snackbar(context, 'Timetable entry deleted');
              }
            },
          ),
        ]).toList(),
      ),
    );
  }
}

class _ExamsPage extends StatefulWidget {
  @override
  State<_ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<_ExamsPage> {
  final _titleCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _classCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _startCtrl = TextEditingController(text: '08:00');
  final _endCtrl = TextEditingController(text: '10:00');
  final _venueCtrl = TextEditingController();
  final _invigilatorCtrl = TextEditingController();
  final _maxScoreCtrl = TextEditingController(text: '50');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subjectCtrl.dispose();
    _classCtrl.dispose();
    _dateCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _venueCtrl.dispose();
    _invigilatorCtrl.dispose();
    _maxScoreCtrl.dispose();
    super.dispose();
  }

  void _showAddExamDialog() {
    _titleCtrl.clear();
    _subjectCtrl.clear();
    _classCtrl.clear();
    _dateCtrl.clear();
    _venueCtrl.clear();
    _invigilatorCtrl.clear();

    _showFormDialog(context,
      title: 'Schedule New Exam',
      submitLabel: 'Add Exam',
      formFields: [
        _inputLabel('Exam Title'),
        _textInput(_titleCtrl, hint: 'e.g. Mid-Sem 1 Physics'),
        _inputLabel('Subject'),
        _textInput(_subjectCtrl, hint: 'e.g. Physics'),
        _inputLabel('Class'),
        _textInput(_classCtrl, hint: 'e.g. SHS2 Sci A'),
        _inputLabel('Date (YYYY-MM-DD)'),
        _textInput(_dateCtrl, hint: '2026-07-20', keyboardType: TextInputType.datetime),
        _inputLabel('Start Time'),
        _textInput(_startCtrl, hint: '08:00', keyboardType: TextInputType.datetime),
        _inputLabel('End Time'),
        _textInput(_endCtrl, hint: '10:00', keyboardType: TextInputType.datetime),
        _inputLabel('Venue'),
        _textInput(_venueCtrl, hint: 'e.g. Hall A'),
        _inputLabel('Invigilator'),
        _textInput(_invigilatorCtrl, hint: 'e.g. Mr. Mensah'),
        _inputLabel('Max Score'),
        _textInput(_maxScoreCtrl, hint: '50', keyboardType: TextInputType.number),
      ],
      onSubmit: () {
        if (_titleCtrl.text.isEmpty || _subjectCtrl.text.isEmpty) {
          _snackbar(context, 'Title and subject are required');
          return;
        }
        context.read<AcademicProvider>().addExam(Exam(
          id: '',
          title: _titleCtrl.text.trim(),
          subject: _subjectCtrl.text.trim(),
          classForm: _classCtrl.text.trim(),
          date: _dateCtrl.text.trim(),
          startTime: _startCtrl.text.trim(),
          endTime: _endCtrl.text.trim(),
          venue: _venueCtrl.text.trim(),
          maxScore: int.tryParse(_maxScoreCtrl.text) ?? 50,
          status: ExamStatus.scheduled,
          resultsStatus: ResultsEntryStatus.notStarted,
          invigilator: _invigilatorCtrl.text.trim(),
          term: 'Term 3',
        ));
        _snackbar(context, 'Exam scheduled');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatCardGrid(cards: [
          StatCard(label: 'Scheduled', value: '${academic.exams.where((e) => e.status == ExamStatus.scheduled).length}', icon: Icons.schedule, color: AppColors.warning),
          StatCard(label: 'Completed', value: '${academic.exams.where((e) => e.status == ExamStatus.completed).length}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Exam Schedule',
          trailing: _actionBtn('Add Exam', onTap: _showAddExamDialog),
          child: AppDataTable(
            columns: ['Title', 'Subject', 'Class', 'Date', 'Time', 'Venue', 'Status', ''],
            rows: academic.exams.map((e) => [
              Text(e.title),
              Text(e.subject),
              Text(e.classForm),
              Text(e.date),
              Text('${e.startTime}-${e.endTime}'),
              Text(e.venue),
              _badge(e.status.name, _examStatusColor(e.status)),
              GestureDetector(
                onTap: () async {
                  if (await _confirmDialog(context, 'Delete Exam', 'Delete "${e.title}"?')) {
                    context.read<AcademicProvider>().deleteExam(e.id);
                    _snackbar(context, 'Exam deleted');
                  }
                },
                child: Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
              ),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}

class _ReportCardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionCard(
          title: 'Report Cards',
          trailing: _actionBtn('Generate', color: AppColors.success, onTap: () {
            context.read<AcademicProvider>().generateReportCards('SHS2 Sci A', 'Term 3', '2025/2026');
            _snackbar(context, 'Report cards generated for SHS2 Sci A');
          }),
          child: AppDataTable(
            columns: ['Student', 'Class', 'Term', 'Average', 'Position', 'Status', ''],
            rows: academic.reportCards.map((r) => [
              Text(r.studentName),
              Text(r.classForm),
              Text(r.term),
              Text(r.average.toStringAsFixed(1)),
              Text(r.classPosition),
              _badge(r.status.name, _reportCardStatusColor(r.status)),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                padding: EdgeInsets.zero,
                itemBuilder: (_) => [
                  if (r.status == ReportCardStatus.generated)
                    const PopupMenuItem(value: 'review', child: Text('Mark Under Review')),
                  if (r.status == ReportCardStatus.underReview)
                    const PopupMenuItem(value: 'release', child: Text('Release')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                onSelected: (action) {
                  final provider = context.read<AcademicProvider>();
                  if (action == 'review') {
                    provider.reviewReportCard(r.id, 'Academic Head');
                    _snackbar(context, 'Marked under review');
                  } else if (action == 'release') {
                    provider.releaseReportCard(r.id);
                    _snackbar(context, 'Report card released');
                  } else if (action == 'delete') {
                    provider.deleteReportCard(r.id);
                    _snackbar(context, 'Report card deleted');
                  }
                },
              ),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}

class _TranscriptsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total', value: '${academic.transcripts.length}', icon: Icons.receipt, color: AppColors.primaryLight),
          StatCard(label: 'Pending Review', value: '${academic.transcripts.where((t) => t.status == TranscriptStatus.pendingReview).length}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Approved', value: '${academic.transcripts.where((t) => t.status == TranscriptStatus.approved).length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Released', value: '${academic.transcripts.where((t) => t.status == TranscriptStatus.released).length}', icon: Icons.publish, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Student Transcripts',
          child: AppDataTable(
            columns: ['Student', 'Adm No', 'Class', 'Year', 'Terms', 'Avg', 'Position', 'Status', ''],
            rows: academic.transcripts.map((t) => [
              Text(t.studentName),
              Text(t.admNo),
              Text(t.classForm),
              Text(t.academicYear),
              Text(t.termsCovered.join(', ')),
              Text(t.cumulativeAverage.toStringAsFixed(1)),
              Text(t.overallPosition),
              _badge(t.status.name, _transcriptStatusColor(t.status)),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                padding: EdgeInsets.zero,
                itemBuilder: (_) => [
                  if (t.status == TranscriptStatus.pendingReview)
                    const PopupMenuItem(value: 'approve', child: Text('Approve')),
                  if (t.status == TranscriptStatus.pendingReview)
                    const PopupMenuItem(value: 'reject', child: Text('Reject')),
                  if (t.status == TranscriptStatus.approved)
                    const PopupMenuItem(value: 'release', child: Text('Release')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                onSelected: (action) {
                  final provider = context.read<AcademicProvider>();
                  if (action == 'approve') {
                    provider.approveTranscript(t.id, 'Academic Head');
                    _snackbar(context, 'Transcript approved');
                  } else if (action == 'reject') {
                    provider.rejectTranscript(t.id, 'Does not meet requirements');
                    _snackbar(context, 'Transcript rejected');
                  } else if (action == 'release') {
                    provider.releaseTranscript(t.id);
                    _snackbar(context, 'Transcript released');
                  } else if (action == 'delete') {
                    provider.deleteTranscript(t.id);
                    _snackbar(context, 'Transcript deleted');
                  }
                },
              ),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}

class _SpipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionCard(
          title: 'School Improvement Plan (SPIP) — 2024/2025',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Priority: High', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              const Text('Vision: Raise academic achievement across all subjects through targeted instruction, empowered teachers, and structured monitoring.'),
              const SizedBox(height: AppSpacing.md),
              const Text('Goals:', style: TextStyle(fontWeight: FontWeight.w600)),
              _goalRow('Raise Core Maths pass rate', 'On Track', '67% (Term 2)'),
              _goalRow('Improve English essay writing', 'On Track', '57% (mid-Term 2)'),
              _goalRow('Standardize syllabus coverage', 'At Risk', '72% average'),
              _goalRow('Teacher PD on evidence-based practices', 'On Track', '60% trained'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _goalRow(String title, String status, String progress) {
    final color = status == 'On Track' ? AppColors.success : status == 'At Risk' ? AppColors.warning : AppColors.danger;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: AppFontSize.sm))),
          Text(progress, style: const TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary)),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Text(status, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _CurriculumPage extends StatefulWidget {
  @override
  State<_CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<_CurriculumPage> {
  final _subjectCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  final _hodCtrl = TextEditingController();
  final _classCtrl = TextEditingController();
  final _topicsCtrl = TextEditingController(text: '40');
  final _coveredCtrl = TextEditingController(text: '0');

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _deptCtrl.dispose();
    _hodCtrl.dispose();
    _classCtrl.dispose();
    _topicsCtrl.dispose();
    _coveredCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _subjectCtrl.clear();
    _deptCtrl.clear();
    _hodCtrl.clear();
    _classCtrl.clear();

    _showFormDialog(context,
      title: 'Add Curriculum Entry',
      submitLabel: 'Add',
      formFields: [
        _inputLabel('Subject'),
        _textInput(_subjectCtrl, hint: 'e.g. Physics'),
        _inputLabel('Department'),
        _textInput(_deptCtrl, hint: 'e.g. Science'),
        _inputLabel('HOD'),
        _textInput(_hodCtrl, hint: 'e.g. Mr. Adjei'),
        _inputLabel('Class'),
        _textInput(_classCtrl, hint: 'e.g. SHS2 Sci A'),
        _inputLabel('Total Syllabus Topics'),
        _textInput(_topicsCtrl, hint: '40', keyboardType: TextInputType.number),
        _inputLabel('Topics Covered'),
        _textInput(_coveredCtrl, hint: '0', keyboardType: TextInputType.number),
      ],
      onSubmit: () {
        if (_subjectCtrl.text.isEmpty || _classCtrl.text.isEmpty) {
          _snackbar(context, 'Subject and class are required');
          return;
        }
        context.read<AcademicProvider>().addCurriculum(CurriculumSubject(
          id: '',
          subject: _subjectCtrl.text.trim(),
          department: _deptCtrl.text.trim(),
          hod: _hodCtrl.text.trim(),
          classForm: _classCtrl.text.trim(),
          syllabusTopics: int.tryParse(_topicsCtrl.text) ?? 40,
          topicsCovered: int.tryParse(_coveredCtrl.text) ?? 0,
          coveragePct: 0,
          status: CurriculumStatus.notStarted,
          lastUpdated: '',
        ));
        _snackbar(context, 'Curriculum entry added');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return SectionCard(
      title: 'Curriculum Tracker',
      trailing: _actionBtn('Add', onTap: _showAddDialog),
      child: AppDataTable(
        columns: ['Subject', 'HOD', 'Class', 'Topics', 'Covered', 'Coverage', ''],
        rows: academic.curriculum.map((c) => [
          Text(c.subject),
          Text(c.hod),
          Text(c.classForm),
          Text('${c.syllabusTopics}'),
          Text('${c.topicsCovered}'),
          Text('${c.coveragePct.toStringAsFixed(1)}%'),
          GestureDetector(
            onTap: () async {
              if (await _confirmDialog(context, 'Delete Entry', 'Delete "${c.subject} — ${c.classForm}"?')) {
                context.read<AcademicProvider>().deleteCurriculum(c.id);
                _snackbar(context, 'Curriculum entry deleted');
              }
            },
            child: Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
          ),
        ]).toList(),
      ),
    );
  }
}

class _CalendarPage extends StatefulWidget {
  @override
  State<_CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<_CalendarPage> {
  final _titleCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedType = 'Holiday';
  String _selectedTerm = 'Term 3';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _dateCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _titleCtrl.clear();
    _dateCtrl.clear();
    _endCtrl.clear();
    _descCtrl.clear();

    _showFormDialog(context,
      title: 'Add Calendar Event',
      submitLabel: 'Add',
      formFields: [
        _inputLabel('Event Title'),
        _textInput(_titleCtrl, hint: 'e.g. Mid-Term Break'),
        _inputLabel('Type'),
        _chipSelector(['Holiday', 'Exam', 'Meeting', 'Activity', 'Deadline'], _selectedType, (v) => setState(() => _selectedType = v), (s) => s),
        _inputLabel('Term'),
        _chipSelector(['Term 1', 'Term 2', 'Term 3'], _selectedTerm, (v) => setState(() => _selectedTerm = v), (s) => s),
        _inputLabel('Start Date (YYYY-MM-DD)'),
        _textInput(_dateCtrl, hint: '2026-08-01', keyboardType: TextInputType.datetime),
        _inputLabel('End Date (optional)'),
        _textInput(_endCtrl, hint: '2026-08-07', keyboardType: TextInputType.datetime),
        _inputLabel('Description'),
        _textInput(_descCtrl, hint: 'Brief description', maxLines: 2),
      ],
      onSubmit: () {
        if (_titleCtrl.text.isEmpty || _dateCtrl.text.isEmpty) {
          _snackbar(context, 'Title and date are required');
          return;
        }
        context.read<AcademicProvider>().addCalendarEvent(CalendarEvent(
          id: '',
          title: _titleCtrl.text.trim(),
          type: _selectedType,
          date: _dateCtrl.text.trim(),
          endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          term: _selectedTerm,
        ));
        _snackbar(context, 'Calendar event added');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionCard(
          title: 'Academic Terms',
          child: Column(
            children: academic.terms.map((t) => ListTile(
              leading: Icon(t.isCurrent ? Icons.check_circle : Icons.calendar_today, color: t.isCurrent ? AppColors.success : AppColors.textLight),
              title: Text('${t.term} — ${t.academicYear}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm)),
              subtitle: Text('${t.startDate} to ${t.endDate} | Mid-term: ${t.midTermBreak}', style: const TextStyle(fontSize: AppFontSize.xs)),
              trailing: t.isCurrent
                  ? _badge('Current', AppColors.success)
                  : GestureDetector(
                      onTap: () {
                        context.read<AcademicProvider>().setCurrentTerm(t.id);
                        _snackbar(context, '${t.term} set as current');
                      },
                      child: Text('Set Current', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
            )).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Calendar Events',
          trailing: _actionBtn('Add Event', onTap: _showAddDialog),
          child: AppDataTable(
            columns: ['Title', 'Type', 'Date', 'End Date', 'Term', 'Description', ''],
            rows: academic.calendar.map((e) => [
              Text(e.title),
              Text(e.type),
              Text(e.date),
              Text(e.endDate ?? '—'),
              Text(e.term),
              Text(e.description),
              GestureDetector(
                onTap: () {
                  context.read<AcademicProvider>().deleteCalendarEvent(e.id);
                  _snackbar(context, 'Event deleted');
                },
                child: Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
              ),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}

class _HodApprovalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return SectionCard(
      title: 'HOD Approvals',
      child: AppDataTable(
        columns: ['Type', 'From', 'Department', 'Date', 'Status', ''],
        rows: academic.hodApprovals.map((a) => [
          Text(a.type),
          Text(a.from),
          Text(a.department),
          Text(a.date),
          _badge(a.status.name, _hodStatusColor(a.status)),
          if (a.status == HodApprovalStatus.pending)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 18),
              padding: EdgeInsets.zero,
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'approve', child: Text('Approve')),
                const PopupMenuItem(value: 'defer', child: Text('Defer')),
                const PopupMenuItem(value: 'reject', child: Text('Reject')),
              ],
              onSelected: (action) {
                final provider = context.read<AcademicProvider>();
                if (action == 'approve') {
                  provider.approveHod(a.id, 'Academic Head', '');
                  _snackbar(context, 'Approved');
                } else if (action == 'defer') {
                  provider.deferHod(a.id, 'Academic Head', '');
                  _snackbar(context, 'Deferred');
                } else if (action == 'reject') {
                  provider.rejectHod(a.id, 'Academic Head', '');
                  _snackbar(context, 'Rejected');
                }
              },
            )
          else
            const SizedBox(width: 24),
        ]).toList(),
      ),
    );
  }
}

class _SuppliesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final req = context.watch<RequisitionProvider>();
    final myReqs = req.getByDepartment('Academic');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Requests', value: '${myReqs.length}', icon: Icons.inventory, color: AppColors.primaryLight),
          StatCard(label: 'Pending', value: '${myReqs.where((r) => r.status == 'Pending').length}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Issued', value: '${myReqs.where((r) => r.status == 'Issued').length}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'Stationery Requests',
          child: myReqs.isEmpty
              ? const Text('No requests yet.', style: TextStyle(color: AppColors.textSecondary))
              : AppDataTable(
                  columns: ['Item', 'Date', 'Qty', 'Unit', 'Priority', 'Status'],
                  rows: myReqs.map((r) => [
                    Text(r.itemName),
                    Text(r.date),
                    Text('${r.quantity}'),
                    Text(r.unit),
                    Text(r.priority),
                    Text(r.status),
                  ]).toList(),
                ),
        ),
      ],
    );
  }
}

class _PlcPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final academic = context.watch<AcademicProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total', value: '${academic.plcRequisitions.length}', icon: Icons.inventory, color: AppColors.primaryLight),
          StatCard(label: 'Pending', value: '${academic.plcPending.length}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Approved', value: '${academic.plcApproved.length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Rejected', value: '${academic.plcRejected.length}', icon: Icons.cancel, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          title: 'PLC Requisitions',
          child: academic.plcRequisitions.isEmpty
              ? const Text('No PLC requisitions.', style: TextStyle(color: AppColors.textSecondary))
              : AppDataTable(
                  columns: ['Item', 'Date', 'Qty', 'Unit', 'Purpose', 'Requested By', 'Status', ''],
                  rows: academic.plcRequisitions.map((r) => [
                    Text(r.itemName),
                    Text(r.date),
                    Text('${r.quantity}'),
                    Text(r.unit),
                    Text(r.purpose),
                    Text(r.requestedBy),
                    _badge(r.status, r.status == 'Approved' ? AppColors.success : r.status == 'Rejected' ? AppColors.danger : AppColors.warning),
                    if (r.status == 'Pending')
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18),
                        padding: EdgeInsets.zero,
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'approve', child: Text('Approve')),
                          const PopupMenuItem(value: 'reject', child: Text('Reject')),
                        ],
                        onSelected: (action) {
                          final provider = context.read<AcademicProvider>();
                          if (action == 'approve') {
                            provider.approveRequisition(r.id, 'Academic Head');
                            _snackbar(context, 'Requisition approved');
                          } else if (action == 'reject') {
                            provider.rejectRequisition(r.id, 'Academic Head');
                            _snackbar(context, 'Requisition rejected');
                          }
                        },
                      )
                    else
                      const SizedBox(width: 24),
                  ]).toList(),
                ),
        ),
      ],
    );
  }
}

class _AcademicReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Reports & PDF',
      child: Column(
        children: [
          _reportItem('Term 2 Academic Report', 'PDF', '2025-04-15'),
          _reportItem('WASSCE Performance Analysis', 'PDF', '2025-08-10'),
          _reportItem('Department Performance Summary', 'PDF', '2025-04-12'),
        ],
      ),
    );
  }

  Widget _reportItem(String title, String type, String date) {
    return ListTile(
      leading: Icon(Icons.picture_as_pdf, color: AppColors.danger),
      title: Text(title, style: const TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w500)),
      subtitle: Text('$type — $date', style: const TextStyle(fontSize: AppFontSize.xs)),
      trailing: const Icon(Icons.download, size: 20),
    );
  }
}
