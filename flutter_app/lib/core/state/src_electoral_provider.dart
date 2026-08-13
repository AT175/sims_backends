import 'package:flutter/foundation.dart';

// ── SRC Models ──

class SrcAnnouncement {
  final String title, date, author, body;
  const SrcAnnouncement({required this.title, required this.date, required this.author, required this.body});
}

class SrcEvent {
  final String title, date, venue, organizer, status, budget;
  const SrcEvent({required this.title, required this.date, required this.venue, required this.organizer, required this.status, required this.budget});
}

class SrcGrievance {
  final String id, date, studentName, className, category, complaint, status, response;
  const SrcGrievance({required this.id, required this.date, required this.studentName, required this.className, required this.category, required this.complaint, required this.status, required this.response});
}

class SrcPrefect {
  final String name, position, className, house;
  const SrcPrefect({required this.name, required this.position, required this.className, required this.house});
}

class SrcBudgetItem {
  final String category, allocated, spent, remaining;
  const SrcBudgetItem({required this.category, required this.allocated, required this.spent, required this.remaining});
}

class SrcInitiative {
  final String title, date, description, status;
  const SrcInitiative({required this.title, required this.date, required this.description, required this.status});
}

class SrcFeedback {
  final String id, date, studentName, subject, body, rating;
  const SrcFeedback({required this.id, required this.date, required this.studentName, required this.subject, required this.body, required this.rating});
}

class SrcProvider extends ChangeNotifier {
  final List<SrcAnnouncement> announcements = [
    SrcAnnouncement(title: 'Welcome Back!', date: '2026-07-05', author: 'SRC President', body: 'Welcome back to Term 3. Let\'s make it great!'),
    SrcAnnouncement(title: 'Inter-House Sports', date: '2026-07-08', author: 'Sports Prefect', body: 'Inter-house sports week begins 20th July. Sign up with your house prefect.'),
  ];

  final List<SrcEvent> events = [
    SrcEvent(title: 'SRC Week Celebration', date: '2026-07-22', venue: 'School Field', organizer: 'SRC Executive', status: 'Planned', budget: 'GHS 2,000'),
    SrcEvent(title: 'Inter-House Quiz', date: '2026-07-15', venue: 'Assembly Hall', organizer: 'Academic Prefect', status: 'Completed', budget: 'GHS 500'),
  ];

  final List<SrcGrievance> grievances = [
    SrcGrievance(id: 'g1', date: '2026-07-06', studentName: 'Anonymous', className: 'SHS2', category: 'Facilities', complaint: 'Broken water fountain near Block A', status: 'Resolved', response: 'Maintenance team notified and repaired.'),
    SrcGrievance(id: 'g2', date: '2026-07-03', studentName: 'Anonymous', className: 'SHS1', category: 'Food', complaint: 'Limited vegetarian options in dining hall', status: 'Pending', response: ''),
  ];

  final List<SrcPrefect> prefects = [
    SrcPrefect(name: 'Kwabena Osei', position: 'SRC President', className: 'SHS3 Sci A', house: 'Opoku Ware'),
    SrcPrefect(name: 'Akosua Mensah', position: 'Vice President', className: 'SHS3 Arts B', house: 'Butler'),
    SrcPrefect(name: 'Yaw Asante', position: 'Sports Prefect', className: 'SHS3 Bus A', house: 'Butler'),
    SrcPrefect(name: 'Ama Boateng', position: 'Academic Prefect', className: 'SHS3 Sci B', house: 'Opoku Ware'),
  ];

  final List<SrcBudgetItem> budget = [
    SrcBudgetItem(category: 'Events', allocated: '3000', spent: '500', remaining: '2500'),
    SrcBudgetItem(category: 'Welfare', allocated: '1000', spent: '200', remaining: '800'),
    SrcBudgetItem(category: 'Stationery', allocated: '500', spent: '150', remaining: '350'),
  ];

  final List<SrcInitiative> initiatives = [
    SrcInitiative(title: 'Peer Tutoring Program', date: '2026-07-01', description: 'SHS3 students tutoring SHS1 students in core subjects.', status: 'Active'),
    SrcInitiative(title: 'Green Campus Drive', date: '2026-06-15', description: 'Tree planting and campus cleanup initiative.', status: 'Completed'),
  ];

  final List<SrcFeedback> feedback = [
    SrcFeedback(id: 'f1', date: '2026-07-07', studentName: 'Anonymous', subject: 'SRC Events', body: 'More social events would be great!', rating: '4/5'),
    SrcFeedback(id: 'f2', date: '2026-07-05', studentName: 'Anonymous', subject: 'Grievance Response', body: 'Quick response on water fountain issue.', rating: '5/5'),
  ];
}

// ── Electoral Commission Models ──

class ElectionEvent {
  final String title, date, status, description;
  final String? results;
  const ElectionEvent({required this.title, required this.date, required this.status, required this.description, this.results});
}

class Candidate {
  final String name, position, className, manifesto, voteCount;
  final bool approved;
  const Candidate({required this.name, required this.position, required this.className, required this.manifesto, required this.voteCount, required this.approved});
}

class Voter {
  final String name, className, voterId, status;
  const Voter({required this.name, required this.className, required this.voterId, required this.status});
}

class BallotPosition {
  final String position, candidates, totalVotes, status;
  const BallotPosition({required this.position, required this.candidates, required this.totalVotes, required this.status});
}

class ElectoralProvider extends ChangeNotifier {
  final List<ElectionEvent> calendar = [
    ElectionEvent(title: 'SRC General Elections 2026/2027', date: '2026-09-15', status: 'Scheduled', description: 'Election for SRC executive positions.'),
    ElectionEvent(title: 'Prefect Elections', date: '2026-09-20', status: 'Scheduled', description: 'Election for senior prefect positions.'),
  ];

  final List<Candidate> candidates = [
    Candidate(name: 'Kwabena Osei', position: 'SRC President', className: 'SHS3 Sci A', manifesto: 'Better welfare, more events, transparent governance.', voteCount: '0', approved: true),
    Candidate(name: 'Akosua Mensah', position: 'SRC President', className: 'SHS3 Arts B', manifesto: 'Academic support, peer tutoring, improved facilities.', voteCount: '0', approved: true),
    Candidate(name: 'Yaw Asante', position: 'Sports Prefect', className: 'SHS3 Bus A', manifesto: 'More inter-house competitions, better equipment.', voteCount: '0', approved: true),
    Candidate(name: 'Ama Boateng', position: 'Academic Prefect', className: 'SHS3 Sci B', manifesto: 'Study groups, exam prep sessions.', voteCount: '0', approved: false),
  ];

  final List<Voter> voters = [
    Voter(name: 'Kwame Asante', className: 'SHS2 Sci A', voterId: 'V-2026-001', status: 'Registered'),
    Voter(name: 'Ama Owusu', className: 'SHS1 Arts B', voterId: 'V-2026-002', status: 'Registered'),
    Voter(name: 'Yao Mensah', className: 'SHS3 Bus A', voterId: 'V-2026-003', status: 'Registered'),
  ];

  final List<BallotPosition> ballots = [
    BallotPosition(position: 'SRC President', candidates: '2', totalVotes: '0', status: 'Open'),
    BallotPosition(position: 'Sports Prefect', candidates: '1', totalVotes: '0', status: 'Open'),
    BallotPosition(position: 'Academic Prefect', candidates: '1', totalVotes: '0', status: 'Pending'),
  ];

  int get pendingCandidates => candidates.where((c) => !c.approved).length;
  int get registeredVoters => voters.length;
}
