import 'package:flutter/foundation.dart';

class Club {
  final String id, name, category, patron, meetingDay;
  final int memberCount;
  const Club({required this.id, required this.name, required this.category, required this.patron, required this.memberCount, required this.meetingDay});
}

class Fixture {
  final String id, date, sport, match, venue, status;
  final String? scoreHome, scoreAway, result;
  const Fixture({required this.id, required this.date, required this.sport, required this.match, required this.venue, required this.status, this.scoreHome, this.scoreAway, this.result});
}

class ParticipationRecord {
  final String id, date, activity;
  final int participantCount;
  const ParticipationRecord({required this.id, required this.date, required this.activity, required this.participantCount});
}

class SportsEquipment {
  final String id, item, condition, location;
  final int quantity;
  const SportsEquipment({required this.id, required this.item, required this.quantity, required this.condition, required this.location});
}

class Achievement {
  final String id, date, achievement, level;
  final String? recipients;
  const Achievement({required this.id, required this.date, required this.achievement, required this.level, this.recipients});
}

class SportsAccessRecord {
  final String id, personName, role, resource, accessLevel, grantedDate, grantedBy;
  const SportsAccessRecord({required this.id, required this.personName, required this.role, required this.resource, required this.accessLevel, required this.grantedDate, required this.grantedBy});
}

class SportsProvider extends ChangeNotifier {
  final List<Club> clubs = [
    Club(id: '1', name: 'Debate Society', category: 'Academic', patron: 'Mrs. Boateng', memberCount: 45, meetingDay: 'Friday'),
    Club(id: '2', name: 'Science Club', category: 'Academic', patron: 'Mr. Adjei', memberCount: 62, meetingDay: 'Wednesday'),
    Club(id: '3', name: 'Drama Club', category: 'Arts & Culture', patron: 'Mrs. Mensah', memberCount: 38, meetingDay: 'Tuesday'),
    Club(id: '4', name: 'Math Club', category: 'Academic', patron: 'Mr. Mensah', memberCount: 52, meetingDay: 'Thursday'),
    Club(id: '5', name: 'Red Cross', category: 'Service', patron: 'Mr. Tetteh', memberCount: 40, meetingDay: 'Saturday'),
  ];

  final List<Fixture> fixtures = [
    Fixture(id: '1', date: '2026-07-12', sport: 'Football', match: 'Aggrey vs Danquah', venue: 'School field', status: 'Upcoming'),
    Fixture(id: '2', date: '2026-07-12', sport: 'Volleyball', match: 'Mensah vs Yaa Asantewaa', venue: 'Court A', status: 'Upcoming'),
    Fixture(id: '3', date: '2026-07-20', sport: 'Athletics', match: 'Inter-school Relay', venue: 'Kumasi Stadium', status: 'Upcoming'),
    Fixture(id: '4', date: '2026-06-15', sport: 'Football', match: 'School vs KNUST SHS', venue: 'School field', status: 'Completed', scoreHome: '3', scoreAway: '1', result: 'Won 3-1'),
  ];

  final List<ParticipationRecord> participation = [
    ParticipationRecord(id: '1', date: '2026-07-05', activity: 'Science Club meeting', participantCount: 58),
    ParticipationRecord(id: '2', date: '2026-07-04', activity: 'Football practice', participantCount: 32),
    ParticipationRecord(id: '3', date: '2026-07-03', activity: 'Debate practice', participantCount: 40),
  ];

  final List<SportsEquipment> equipment = [
    SportsEquipment(id: 'e1', item: 'Footballs', quantity: 15, condition: 'Good', location: 'Sports Store'),
    SportsEquipment(id: 'e2', item: 'Volleyballs', quantity: 8, condition: 'Fair', location: 'Sports Store'),
    SportsEquipment(id: 'e3', item: 'Basketballs', quantity: 6, condition: 'Good', location: 'Sports Store'),
    SportsEquipment(id: 'e4', item: 'Volleyball Net', quantity: 2, condition: 'Needs Repair', location: 'Court A'),
    SportsEquipment(id: 'e5', item: 'Athletics Spikes', quantity: 20, condition: 'Fair', location: 'Sports Store'),
  ];

  final List<Achievement> achievements = [
    Achievement(id: '1', date: '2026-06-15', achievement: 'Inter-school Football Champions', level: 'Zonal', recipients: 'Football Team'),
    Achievement(id: '2', date: '2026-05-20', achievement: 'Debate Competition Winners', level: 'Regional', recipients: 'Debate Society'),
    Achievement(id: '3', date: '2026-04-10', achievement: 'Science Quiz Runners-up', level: 'School', recipients: 'Science Club'),
  ];

  final List<SportsAccessRecord> accessRecords = [
    SportsAccessRecord(id: '1', personName: 'Mr. Tetteh', role: 'Sports Coordinator', resource: 'Sports Management', accessLevel: 'Full', grantedDate: '2026-01-05', grantedBy: 'Headmaster'),
    SportsAccessRecord(id: '2', personName: 'Coach Mensah', role: 'Coach', resource: 'Fixtures & Results', accessLevel: 'Full', grantedDate: '2026-01-08', grantedBy: 'Sports Coordinator'),
  ];

  int get upcomingFixtures => fixtures.where((f) => f.status == 'Upcoming').length;
  int get totalClubMembers => clubs.fold(0, (s, c) => s + c.memberCount);
}
