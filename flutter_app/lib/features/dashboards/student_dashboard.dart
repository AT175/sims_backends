import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/student_provider.dart';
import '../../core/widgets/widgets.dart';

class StudentDashboard extends StatelessWidget {
  final String pageKey;
  const StudentDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'profile': return const _ProfilePage();
      case 'timetable': return const _TimetablePage();
      case 'classes': return const _ClassesPage();
      case 'materials': return _MaterialsPage();
      case 'assignments': return const _AssignmentsPage();
      case 'results': return const _ResultsPage();
      case 'attendance': return const _AttendancePage();
      case 'fees': return const _FeesPage();
      case 'library': return const _LibraryPage();
      case 'health': return _HealthPage();
      case 'elections': return const _ElectionsPage();
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

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    final p = s.profile;
    return SectionCard(title: 'My Profile', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _row('Name', p.name), _row('Adm No', p.admNo), _row('Class', p.className),
      _row('House', p.house), _row('Gender', p.gender), _row('Date of Birth', p.dateOfBirth),
      _row('Programme', p.programme), _row('Guardian', p.guardianName), _row('Guardian Phone', p.guardianPhone),
    ]));
  }
  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      SizedBox(width: 140, child: Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: AppFontSize.sm))),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ]),
  );
}

class _TimetablePage extends StatelessWidget {
  const _TimetablePage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    return SectionCard(title: 'My Timetable', child: AppDataTable(
      columns: ['Day', 'Period', 'Time', 'Subject', 'Room'],
      rows: s.timetable.map((t) => [
        Text(t.day), Text('P${t.period}'), Text('${t.startTime}-${t.endTime}'),
        Text(t.subject), Text(t.room),
      ]).toList(),
    ));
  }
}

class _ClassesPage extends StatelessWidget {
  const _ClassesPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    final subjects = s.timetable.map((t) => t.subject).toSet().toList();
    return SectionCard(title: 'My Classes', child: AppDataTable(
      columns: ['Subject', 'Class'],
      rows: subjects.map((sub) => [Text(sub), Text(s.profile.className)]).toList(),
    ));
  }
}

class _MaterialsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'Learning Materials', child: Center(
      child: Text('Materials uploaded by teachers will appear here.', style: TextStyle(color: AppColors.textSecondary)),
    ));
  }
}

class _AssignmentsPage extends StatelessWidget {
  const _AssignmentsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total', value: '${s.assignments.length}', icon: Icons.assignment, color: AppColors.primaryLight),
        StatCard(label: 'Pending', value: '${s.pendingAssignments}', icon: Icons.pending, color: AppColors.warning),
        StatCard(label: 'Submitted', value: '${s.assignments.where((a) => a.status == 'Submitted').length}', icon: Icons.check, color: AppColors.info),
        StatCard(label: 'Graded', value: '${s.assignments.where((a) => a.status == 'Graded').length}', icon: Icons.grade, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Assignments', child: AppDataTable(
        columns: ['Title', 'Subject', 'Due Date', 'Max Score', 'Score', 'Status'],
        rows: s.assignments.map((a) => [
          Text(a.title), Text(a.subject), Text(a.dueDate), Text(a.maxScore),
          Text(a.score != null ? '${a.score}' : '—'),
          _chip(a.status, a.status == 'Graded' ? AppColors.success : a.status == 'Submitted' ? AppColors.info : AppColors.warning),
        ]).toList(),
      )),
    ]);
  }
}

class _ResultsPage extends StatelessWidget {
  const _ResultsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Average Score', value: s.avgScore, icon: Icons.school, color: AppColors.primaryLight),
        StatCard(label: 'Subjects', value: '${s.results.length}', icon: Icons.book, color: AppColors.info),
        StatCard(label: 'A1 Grades', value: '${s.results.where((r) => r.grade == 'A1').length}', icon: Icons.star, color: AppColors.success),
        StatCard(label: 'Best Subject', value: s.results.isEmpty ? '—' : s.results.reduce((a, b) => int.parse(a.score) > int.parse(b.score) ? a : b).subject, icon: Icons.emoji_events, color: AppColors.accent),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Results', child: AppDataTable(
        columns: ['Exam', 'Subject', 'Score', 'Max', 'Grade', 'Remarks'],
        rows: s.results.map((r) => [
          Text(r.exam), Text(r.subject), Text(r.score), Text(r.maxScore),
          _chip(r.grade, r.grade == 'A1' ? AppColors.success : r.grade == 'B2' ? AppColors.info : AppColors.warning),
          Text(r.remarks),
        ]).toList(),
      )),
    ]);
  }
}

class _AttendancePage extends StatelessWidget {
  const _AttendancePage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    return SectionCard(title: 'Attendance', child: AppDataTable(
      columns: ['Term', 'Total Days', 'Present', 'Absent', 'Late', 'Percentage'],
      rows: s.attendance.map((a) => [
        Text(a.term), Text(a.totalDays), Text(a.present), Text(a.absent), Text(a.late),
        _chip(a.percentage, AppColors.success),
      ]).toList(),
    ));
  }
}

class _FeesPage extends StatelessWidget {
  const _FeesPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    return SectionCard(title: 'Fees / Capitation', child: AppDataTable(
      columns: ['Term', 'Fee Type', 'Amount Due', 'Amount Paid', 'Balance', 'Status', 'Due Date'],
      rows: s.fees.map((f) => [
        Text(f.term), Text(f.feeType), Text('GHS ${f.amountDue}'), Text('GHS ${f.amountPaid}'),
        Text('GHS ${f.balance}'),
        _chip(f.status, f.status == 'Cleared' ? AppColors.success : AppColors.warning),
        Text(f.dueDate),
      ]).toList(),
    ));
  }
}

class _LibraryPage extends StatelessWidget {
  const _LibraryPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    return SectionCard(title: 'Library Account', child: AppDataTable(
      columns: ['Book', 'Author', 'Borrow Date', 'Due Date', 'Status'],
      rows: s.libraryBooks.map((b) => [
        Text(b.bookTitle), Text(b.author), Text(b.borrowDate), Text(b.dueDate),
        _chip(b.status, b.status == 'Returned' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _HealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'Health Record', child: Center(
      child: Text('Health records available in the Sick Bay.', style: TextStyle(color: AppColors.textSecondary)),
    ));
  }
}

class _ElectionsPage extends StatelessWidget {
  const _ElectionsPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    return SectionCard(title: 'Elections', child: AppDataTable(
      columns: ['Title', 'Date', 'Status', 'Result'],
      rows: s.elections.map((e) => [
        Text(e.title), Text(e.date),
        _chip(e.status, e.status == 'Upcoming' ? AppColors.warning : AppColors.info),
        Text(e.result),
      ]).toList(),
    ));
  }
}

class _FeedbackPage extends StatelessWidget {
  const _FeedbackPage();
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentProvider>();
    return SectionCard(title: 'Grievance / Feedback', child: AppDataTable(
      columns: ['Date', 'Subject', 'Body', 'Status', 'Response'],
      rows: s.feedback.map((f) => [
        Text(f.date), Text(f.subject), Text(f.body),
        _chip(f.status, f.status == 'Acknowledged' ? AppColors.success : AppColors.warning),
        Text(f.response),
      ]).toList(),
    ));
  }
}
