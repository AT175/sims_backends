import 'package:flutter/foundation.dart';

class ServiceSchedule {
  final String id, type, day, time, venue, speaker, topic, notes;
  final int attendance;
  const ServiceSchedule({required this.id, required this.type, required this.day, required this.time, required this.venue, required this.speaker, required this.topic, required this.attendance, required this.notes});
}

class PrayerRequest {
  final String id, studentName, studentClass, request, status, visibility, dateSubmitted, notes;
  final String? dateAnswered;
  const PrayerRequest({required this.id, required this.studentName, required this.studentClass, required this.request, required this.status, required this.visibility, required this.dateSubmitted, required this.notes, this.dateAnswered});
}

class SpiritualCounselling {
  final String id, studentName, studentClass, type, date, summary, status, notes;
  final String? followUpDate;
  const SpiritualCounselling({required this.id, required this.studentName, required this.studentClass, required this.type, required this.date, required this.summary, required this.status, required this.notes, this.followUpDate});
}

class ReligiousEvent {
  final String id, title, type, date, venue, coordinator, notes, status;
  final int expectedAttendance;
  final int? actualAttendance;
  const ReligiousEvent({required this.id, required this.title, required this.type, required this.date, required this.venue, required this.expectedAttendance, this.actualAttendance, required this.status, required this.coordinator, required this.notes});
}

class FellowshipGroup {
  final String id, name, leader, day, time, venue, description;
  final int members;
  const FellowshipGroup({required this.id, required this.name, required this.leader, required this.day, required this.time, required this.venue, required this.members, required this.description});
}

class OutreachProgram {
  final String id, title, type, date, location, coordinator, notes, status;
  final int beneficiaries;
  final double budget;
  const OutreachProgram({required this.id, required this.title, required this.type, required this.date, required this.location, required this.beneficiaries, required this.coordinator, required this.budget, required this.status, required this.notes});
}

class ChoirMember {
  final String id, name, voicePart, role, className;
  final int attendance;
  const ChoirMember({required this.id, required this.name, required this.voicePart, required this.role, required this.className, required this.attendance});
}

class BaptismRecord {
  final String id, name, type, date, officiant, className, parentGuardian, notes;
  final bool certificateIssued;
  const BaptismRecord({required this.id, required this.name, required this.type, required this.date, required this.officiant, required this.className, required this.parentGuardian, required this.certificateIssued, required this.notes});
}

class ChaplainProvider extends ChangeNotifier {
  final List<ServiceSchedule> services = [
    ServiceSchedule(id: '1', type: 'Sunday', day: 'Sunday', time: '08:00', venue: 'Main Chapel', speaker: 'Rev. Fr. Owusu', topic: 'Faith and Perseverance', attendance: 850, notes: 'Whole school service'),
    ServiceSchedule(id: '2', type: 'Devotion', day: 'Monday', time: '07:00', venue: 'Assembly Hall', speaker: 'Chaplain Mensah', topic: 'Weekly Devotion', attendance: 900, notes: 'Morning devotion'),
    ServiceSchedule(id: '3', type: "Friday Jumu'ah", day: 'Friday', time: '12:30', venue: 'Prayer Room', speaker: 'Imam Yusuf', topic: 'Friday Prayers', attendance: 120, notes: 'Muslim students'),
    ServiceSchedule(id: '4', type: 'Midweek', day: 'Wednesday', time: '18:00', venue: 'Chapel', speaker: 'Rev. Fr. Owusu', topic: 'Midweek Service', attendance: 300, notes: 'Optional evening service'),
  ];

  final List<PrayerRequest> prayerRequests = [
    PrayerRequest(id: '1', studentName: 'Kwesi Mensah', studentClass: 'Form 2A', request: 'Prayers for exams success', status: 'Answered', visibility: 'Public', dateSubmitted: '2026-06-15', dateAnswered: '2026-07-01', notes: 'Student passed all subjects'),
    PrayerRequest(id: '2', studentName: 'Ama Serwaa', studentClass: 'Form 3B', request: 'Healing for mother', status: 'In Progress', visibility: 'Confidential', dateSubmitted: '2026-07-05', notes: 'Mother is recovering'),
    PrayerRequest(id: '3', studentName: 'Yaw Boateng', studentClass: 'Form 1A', request: 'Guidance for career choice', status: 'Open', visibility: 'Public', dateSubmitted: '2026-07-10', notes: ''),
  ];

  final List<SpiritualCounselling> counselling = [
    SpiritualCounselling(id: '1', studentName: 'Akosua Frimpong', studentClass: 'Form 2C', type: 'Faith Crisis', date: '2026-07-08', summary: 'Doubting faith after family loss', followUpDate: '2026-07-22', status: 'Open', notes: 'Needs ongoing support'),
    SpiritualCounselling(id: '2', studentName: 'Kofi Asante', studentClass: 'Form 3A', type: 'Moral', date: '2026-06-20', summary: 'Behavioral guidance session', status: 'Resolved', notes: 'Student showed improvement'),
  ];

  final List<ReligiousEvent> events = [
    ReligiousEvent(id: '1', title: 'Annual Spiritual Renewal Week', type: 'Special', date: '2026-08-15', venue: 'Main Chapel', expectedAttendance: 1000, actualAttendance: null, status: 'Planned', coordinator: 'Chaplain Mensah', notes: 'Week-long program'),
    ReligiousEvent(id: '2', title: 'Easter Cantata', type: 'Special', date: '2026-04-05', venue: 'Assembly Hall', expectedAttendance: 900, actualAttendance: 870, status: 'Completed', coordinator: 'Choir Director', notes: 'Very successful'),
    ReligiousEvent(id: '3', title: 'Ramadan Iftar Gathering', type: 'Special', date: '2026-03-20', venue: 'Dining Hall', expectedAttendance: 150, actualAttendance: 140, status: 'Completed', coordinator: 'Imam Yusuf', notes: 'Muslim community event'),
  ];

  final List<FellowshipGroup> fellowships = [
    FellowshipGroup(id: '1', name: 'Scripture Union', leader: 'Grace Adjei', day: 'Friday', time: '18:00', venue: 'Classroom Block A', members: 45, description: 'Bible study and fellowship'),
    FellowshipGroup(id: '2', name: 'Muslim Students Association', leader: 'Imam Yusuf', day: 'Friday', time: '12:30', venue: 'Prayer Room', members: 120, description: 'Islamic fellowship and Quran study'),
    FellowshipGroup(id: '3', name: 'Catholic Students Movement', leader: 'Rev. Fr. Owusu', day: 'Sunday', time: '09:30', venue: 'Chapel', members: 80, description: 'Catholic faith formation'),
    FellowshipGroup(id: '4', name: 'Pentecost Students Union', leader: 'Daniel Tuffour', day: 'Saturday', time: '16:00', venue: 'Assembly Hall', members: 60, description: 'Pentecostal fellowship'),
  ];

  final List<OutreachProgram> outreach = [
    OutreachProgram(id: '1', title: 'Orphanage Visit - Hope Home', type: 'Visit', date: '2026-07-20', location: "Hope Children's Home", beneficiaries: 50, coordinator: 'Chaplain Mensah', budget: 500, status: 'Planned', notes: 'Donation of food and clothing'),
    OutreachProgram(id: '2', title: 'Community Cleanup', type: 'Community Service', date: '2026-06-15', location: 'Tema Community 5', beneficiaries: 0, coordinator: 'SRC + Chaplaincy', budget: 100, status: 'Completed', notes: '50 students participated'),
    OutreachProgram(id: '3', title: 'Christmas Charity Drive', type: 'Donation', date: '2025-12-18', location: 'Various', beneficiaries: 200, coordinator: 'Chaplain Mensah', budget: 1500, status: 'Completed', notes: 'Distributed to 3 orphanages'),
  ];

  final List<ChoirMember> choir = [
    ChoirMember(id: '1', name: 'Ama Serwaa', voicePart: 'Soprano', role: 'Lead', className: 'Form 3B', attendance: 95),
    ChoirMember(id: '2', name: 'Kwesi Mensah', voicePart: 'Tenor', role: 'Member', className: 'Form 2A', attendance: 88),
    ChoirMember(id: '3', name: 'Akosua Frimpong', voicePart: 'Alto', role: 'Member', className: 'Form 2C', attendance: 90),
    ChoirMember(id: '4', name: 'Yaw Boateng', voicePart: 'Bass', role: 'Director', className: 'Form 1A', attendance: 92),
    ChoirMember(id: '5', name: 'Kofi Asante', voicePart: 'Instrumentalist', role: 'Organist', className: 'Form 3A', attendance: 85),
  ];

  final List<BaptismRecord> baptisms = [
    BaptismRecord(id: '1', name: 'Kwabena Osei', type: 'Baptism', date: '2026-05-12', officiant: 'Rev. Fr. Owusu', className: 'Form 2B', parentGuardian: 'Mr. Osei', certificateIssued: true, notes: 'Water baptism'),
    BaptismRecord(id: '2', name: 'Adwoa Nyamekye', type: 'Dedication', date: '2026-06-01', officiant: 'Chaplain Mensah', className: 'Form 1A', parentGuardian: 'Mrs. Nyamekye', certificateIssued: true, notes: 'Child dedication'),
    BaptismRecord(id: '3', name: 'Nana Kwame', type: 'Confirmation', date: '2026-04-20', officiant: 'Bishop Addo', className: 'Form 3C', parentGuardian: 'Mr. Kwame Sr.', certificateIssued: true, notes: 'Confirmation sacrament'),
  ];

  int get openPrayerRequests => prayerRequests.where((p) => p.status == 'Open' || p.status == 'In Progress').length;
  int get totalFellowshipMembers => fellowships.fold(0, (s, f) => s + f.members);
  int get plannedEvents => events.where((e) => e.status == 'Planned').length;
}
