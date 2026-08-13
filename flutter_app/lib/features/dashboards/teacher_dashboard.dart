import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/teacher_provider.dart';
import '../../core/widgets/widgets.dart';

class TeacherDashboard extends StatelessWidget {
  final String pageKey;
  const TeacherDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'subjects': return const _SubjectsPage();
      case 'timetable': return const _TimetablePage();
      case 'lessonPlans': return const _LessonPlansPage();
      case 'materials': return const _MaterialsPage();
      case 'av': return const _AVPage();
      case 'live': return const _LivePage();
      case 'assignments': return const _AssignmentsPage();
      case 'gradebook': return const _GradebookPage();
      case 'attendance': return const _AttendancePage();
      case 'roster': return const _RosterPage();
      case 'syllabus': return const _SyllabusPage();
      case 'remedial': return const _RemedialPage();
      case 'announcements': return const _AnnouncementsPage();
      case 'plc': return const _PLCPage();
      case 'menu': return const _MenuPage();
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
    final t = context.watch<TeacherProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'My Classes', value: '${t.subjects.length}', icon: Icons.class_, color: AppColors.primaryLight),
        StatCard(label: 'Total Students', value: '${t.totalStudents}', icon: Icons.people, color: AppColors.info),
        StatCard(label: 'Assignments', value: '${t.assignments.length}', icon: Icons.assignment, color: AppColors.warning),
        StatCard(label: 'Lesson Plans', value: '${t.lessonPlans.length}', icon: Icons.menu_book, color: AppColors.purple),
      ]),
      const SizedBox(height: AppSpacing.lg),
      SectionCard(title: 'Today\'s Timetable', child: AppDataTable(
        columns: ['Period', 'Time', 'Subject', 'Class', 'Room'],
        rows: t.timetable.where((e) => e.day == 'Monday').map((e) => [
          Text('P${e.period}'), Text('${e.startTime}-${e.endTime}'),
          Text(e.subject), Text(e.classForm), Text(e.room),
        ]).toList(),
      )),
    ]);
  }
}

class _SubjectsPage extends StatelessWidget {
  const _SubjectsPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'My Subjects & Classes', child: AppDataTable(
      columns: ['Subject', 'Class', 'Students', 'HOD', 'Type'],
      rows: t.subjects.map((s) => [
        Text(s.subject), Text(s.classForm), Text('${s.students}'), Text(s.hod),
        _chip(s.isElective ? 'Elective' : 'Core', s.isElective ? AppColors.purple : AppColors.info),
      ]).toList(),
    ));
  }
}

class _TimetablePage extends StatelessWidget {
  const _TimetablePage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'My Timetable', child: AppDataTable(
      columns: ['Day', 'Period', 'Time', 'Subject', 'Class', 'Room'],
      rows: t.timetable.map((e) => [
        Text(e.day), Text('P${e.period}'), Text('${e.startTime}-${e.endTime}'),
        Text(e.subject), Text(e.classForm), Text(e.room),
      ]).toList(),
    ));
  }
}

class _LessonPlansPage extends StatelessWidget {
  const _LessonPlansPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Lesson Plans', child: AppDataTable(
      columns: ['Date', 'Subject', 'Class', 'Topic', 'Status'],
      rows: t.lessonPlans.map((l) => [
        Text(l.date), Text(l.subject), Text(l.classForm), Text(l.topic),
        _chip(l.status, l.status == 'Taught' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _MaterialsPage extends StatelessWidget {
  const _MaterialsPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Lesson Materials', child: AppDataTable(
      columns: ['Title', 'Type', 'Class', 'Subject', 'Topic', 'Date'],
      rows: t.materials.map((m) => [
        Text(m.title), Text(m.type), Text(m.classForm), Text(m.subject),
        Text(m.topic), Text(m.dateUploaded),
      ]).toList(),
    ));
  }
}

class _AVPage extends StatelessWidget {
  const _AVPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Audio & Video Library', child: AppDataTable(
      columns: ['Title', 'Type', 'Duration', 'Class', 'Subject', 'Topic', 'Date'],
      rows: t.avRecordings.map((a) => [
        Text(a.title), Text(a.type), Text(a.duration), Text(a.classForm),
        Text(a.subject), Text(a.topic), Text(a.dateRecorded),
      ]).toList(),
    ));
  }
}

class _LivePage extends StatelessWidget {
  const _LivePage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Live / Virtual Class', child: AppDataTable(
      columns: ['Subject', 'Class', 'Scheduled Time', 'Topic', 'Participants', 'Status'],
      rows: t.liveSessions.map((l) => [
        Text(l.subject), Text(l.classForm), Text(l.scheduledTime), Text(l.topic),
        Text('${l.participants}'),
        _chip(l.status, l.status == 'Ended' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _AssignmentsPage extends StatelessWidget {
  const _AssignmentsPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Assignments & Assessments', child: AppDataTable(
      columns: ['Title', 'Class', 'Subject', 'Due Date', 'Max Score', 'Status'],
      rows: t.assignments.map((a) => [
        Text(a.title), Text(a.classForm), Text(a.subject), Text(a.dueDate),
        Text('${a.maxScore}'),
        _chip(a.status, a.status == 'Published' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _GradebookPage extends StatelessWidget {
  const _GradebookPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Gradebook', child: AppDataTable(
      columns: ['Student', 'Adm No', 'Class', 'CW', 'HW', 'Test', 'Exam', 'Total', 'Grade'],
      rows: t.gradebook.map((g) => [
        Text(g.studentName), Text(g.admNo), Text(g.classForm),
        Text('${g.classwork}/${g.classworkMax}'), Text('${g.homework}/${g.homeworkMax}'),
        Text('${g.test}/${g.testMax}'), Text('${g.exam}/${g.examMax}'),
        Text('${g.total}/${g.totalMax}'),
        _chip(g.grade, g.grade == 'A1' ? AppColors.success : g.grade == 'B3' ? AppColors.info : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _AttendancePage extends StatelessWidget {
  const _AttendancePage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Class Attendance', child: AppDataTable(
      columns: ['Student', 'Adm No', 'Date', 'Status'],
      rows: t.attendance.map((a) => [
        Text(a.studentName), Text(a.admNo), Text(a.date),
        _chip(a.status, a.status == 'Present' ? AppColors.success : a.status == 'Late' ? AppColors.warning : AppColors.danger),
      ]).toList(),
    ));
  }
}

class _RosterPage extends StatelessWidget {
  const _RosterPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Student Roster', child: AppDataTable(
      columns: ['Name', 'Adm No', 'Class', 'Avg Score', 'Attendance', 'Last Grade', 'Guardian', 'Phone'],
      rows: t.roster.map((r) => [
        Text(r.name), Text(r.admNo), Text(r.classForm), Text(r.avgScore),
        Text(r.attendancePct), Text(r.lastGrade), Text(r.guardianName), Text(r.guardianPhone),
      ]).toList(),
    ));
  }
}

class _SyllabusPage extends StatelessWidget {
  const _SyllabusPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Syllabus Tracker', child: AppDataTable(
      columns: ['Subject', 'Class', 'Week', 'Topic', 'Sub-Topics', 'Status'],
      rows: t.syllabus.map((s) => [
        Text(s.subject), Text(s.classForm), Text('W${s.week}'), Text(s.topic),
        Text(s.subTopics),
        _chip(s.status, s.status == 'Completed' ? AppColors.success : s.status == 'In Progress' ? AppColors.warning : AppColors.info),
      ]).toList(),
    ));
  }
}

class _RemedialPage extends StatelessWidget {
  const _RemedialPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Remedial Support', child: AppDataTable(
      columns: ['Student', 'Adm No', 'Class', 'Subject', 'Area', 'Intervention', 'Started', 'Progress'],
      rows: t.remedial.map((r) => [
        Text(r.studentName), Text(r.admNo), Text(r.classForm), Text(r.subject),
        Text(r.area), Text(r.intervention), Text(r.dateStarted),
        _chip(r.progress, r.progress == 'Improving' ? AppColors.success : AppColors.warning),
      ]).toList(),
    ));
  }
}

class _AnnouncementsPage extends StatelessWidget {
  const _AnnouncementsPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TeacherProvider>();
    return SectionCard(title: 'Class Announcements', child: AppDataTable(
      columns: ['Title', 'Class', 'Date', 'Priority', 'Posted By'],
      rows: t.announcements.map((a) => [
        Text(a.title), Text(a.classForm), Text(a.date),
        _chip(a.priority, a.priority == 'Important' ? AppColors.warning : AppColors.info),
        Text(a.postedBy),
      ]).toList(),
    ));
  }
}

class _PLCPage extends StatelessWidget {
  const _PLCPage();
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'PLC', child: Center(
      child: Text('PLC details available in PLC Dashboard', style: TextStyle(color: AppColors.textSecondary)),
    ));
  }
}

class _MenuPage extends StatelessWidget {
  const _MenuPage();
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: "Today's Menu", child: Center(
      child: Text('Menu available in Catering Dashboard', style: TextStyle(color: AppColors.textSecondary)),
    ));
  }
}
