import 'package:flutter/foundation.dart';

class PLCMeeting {
  final String id, date, topic, facilitator, location, status, agenda;
  final int attendees;
  const PLCMeeting({required this.id, required this.date, required this.topic, required this.facilitator, required this.location, required this.status, required this.agenda, required this.attendees});
}

class PLCDutyEntry {
  final String id, day, coordinator, duty, time;
  const PLCDutyEntry({required this.id, required this.day, required this.coordinator, required this.duty, required this.time});
}

class PLCObservation {
  final String id, date, observer, teacher, subject, classForm, focusArea, feedback, rating;
  const PLCObservation({required this.id, required this.date, required this.observer, required this.teacher, required this.subject, required this.classForm, required this.focusArea, required this.feedback, required this.rating});
}

class PLCLessonStudy {
  final String id, date, subject, classForm, topic, leadTeacher, status, reflection;
  const PLCLessonStudy({required this.id, required this.date, required this.subject, required this.classForm, required this.topic, required this.leadTeacher, required this.status, required this.reflection});
}

class PLCPerformanceReview {
  final String id, teacher, period, rating, strengths, areasForGrowth, reviewer, date;
  const PLCPerformanceReview({required this.id, required this.teacher, required this.period, required this.rating, required this.strengths, required this.areasForGrowth, required this.reviewer, required this.date});
}

class PLCResource {
  final String id, title, type, uploadedBy, date;
  const PLCResource({required this.id, required this.title, required this.type, required this.uploadedBy, required this.date});
}

class PLCActionItem {
  final String id, action, owner, dueDate, status, priority;
  const PLCActionItem({required this.id, required this.action, required this.owner, required this.dueDate, required this.status, required this.priority});
}

class PLCProvider extends ChangeNotifier {
  final List<PLCMeeting> meetings = [
    PLCMeeting(id: '1', date: '2026-07-10', topic: 'Differentiation strategies in math', facilitator: 'Mrs. Adjei', location: 'Staff Common Room', status: 'Completed', agenda: 'Sharing best practices for differentiated instruction', attendees: 12),
    PLCMeeting(id: '2', date: '2026-07-17', topic: 'Assessment for learning', facilitator: 'Mr. Osei', location: 'Conference Room', status: 'Scheduled', agenda: 'Formative assessment techniques and peer review', attendees: 0),
    PLCMeeting(id: '3', date: '2026-06-26', topic: 'ICT integration in teaching', facilitator: 'Mr. Mensah', location: 'ICT Lab', status: 'Completed', agenda: 'Using digital tools in classroom delivery', attendees: 15),
  ];

  final List<PLCDutyEntry> dutyRoster = [
    PLCDutyEntry(id: '1', day: 'Monday', coordinator: 'Mrs. Adjei', duty: 'Morning devotion oversight', time: '07:00'),
    PLCDutyEntry(id: '2', day: 'Tuesday', coordinator: 'Mr. Osei', duty: 'Lesson observation round', time: '09:00'),
    PLCDutyEntry(id: '3', day: 'Wednesday', coordinator: 'Mr. Mensah', duty: 'PLC meeting facilitation', time: '15:30'),
    PLCDutyEntry(id: '4', day: 'Thursday', coordinator: 'Mrs. Boateng', duty: 'Resource center monitoring', time: '14:00'),
    PLCDutyEntry(id: '5', day: 'Friday', coordinator: 'Mr. Tetteh', duty: 'Weekly review compilation', time: '16:00'),
  ];

  final List<PLCObservation> observations = [
    PLCObservation(id: '1', date: '2026-07-09', observer: 'Mrs. Adjei', teacher: 'Mr. Mensah', subject: 'Mathematics', classForm: 'SHS2 Sci A', focusArea: 'Student engagement', feedback: 'Good use of questioning techniques. Students actively involved.', rating: 'Good'),
    PLCObservation(id: '2', date: '2026-07-05', observer: 'Mr. Osei', teacher: 'Mrs. Boateng', subject: 'English', classForm: 'SHS1 Arts B', focusArea: 'Differentiation', feedback: 'Effective scaffolding for weaker students.', rating: 'Excellent'),
    PLCObservation(id: '3', date: '2026-06-28', observer: 'Mr. Mensah', teacher: 'Mr. Tetteh', subject: 'Science', classForm: 'SHS3 Sci A', focusArea: 'Assessment for learning', feedback: 'Good exit ticket usage. Could improve wait time.', rating: 'Good'),
  ];

  final List<PLCLessonStudy> lessonStudies = [
    PLCLessonStudy(id: '1', date: '2026-07-08', subject: 'Mathematics', classForm: 'SHS2 Sci A', topic: 'Integration by substitution', leadTeacher: 'Mr. Mensah', status: 'Completed', reflection: 'Students responded well to visual approach. Need more practice problems.'),
    PLCLessonStudy(id: '2', date: '2026-07-03', subject: 'English', classForm: 'SHS1 Arts B', topic: 'Comprehension strategies', leadTeacher: 'Mrs. Boateng', status: 'Completed', reflection: 'Peer reading approach effective. Will repeat next term.'),
    PLCLessonStudy(id: '3', date: '2026-07-15', subject: 'Science', classForm: 'SHS3 Sci A', topic: 'Organic chemistry reactions', leadTeacher: 'Mr. Tetteh', status: 'Planned', reflection: ''),
  ];

  final List<PLCPerformanceReview> performanceReviews = [
    PLCPerformanceReview(id: '1', teacher: 'Mr. Mensah', period: 'Term 3 2025/2026', rating: 'Excellent', strengths: 'Strong subject knowledge, innovative teaching methods', areasForGrowth: 'More consistent use of formative assessment', reviewer: 'Mrs. Adjei', date: '2026-07-01'),
    PLCPerformanceReview(id: '2', teacher: 'Mrs. Boateng', period: 'Term 3 2025/2026', rating: 'Good', strengths: 'Excellent rapport with students, creative lesson design', areasForGrowth: 'Time management during lessons', reviewer: 'Mr. Osei', date: '2026-07-02'),
  ];

  final List<PLCResource> resources = [
    PLCResource(id: '1', title: 'Differentiated Instruction Guide', type: 'Document', uploadedBy: 'Mrs. Adjei', date: '2026-06-15'),
    PLCResource(id: '2', title: 'Formative Assessment Toolkit', type: 'Document', uploadedBy: 'Mr. Osei', date: '2026-06-20'),
    PLCResource(id: '3', title: 'Lesson Observation Template', type: 'Template', uploadedBy: 'Mr. Mensah', date: '2026-06-10'),
  ];

  final List<PLCActionItem> actionItems = [
    PLCActionItem(id: '1', action: 'Compile differentiation strategy guide', owner: 'Mrs. Adjei', dueDate: '2026-07-20', status: 'In Progress', priority: 'High'),
    PLCActionItem(id: '2', action: 'Schedule peer observation cycle', owner: 'Mr. Osei', dueDate: '2026-07-18', status: 'Pending', priority: 'Medium'),
    PLCActionItem(id: '3', action: 'Upload lesson study reflections', owner: 'Mr. Mensah', dueDate: '2026-07-15', status: 'Completed', priority: 'Low'),
  ];

  int get scheduledMeetings => meetings.where((m) => m.status == 'Scheduled').length;
  int get pendingActions => actionItems.where((a) => a.status != 'Completed').length;
}
