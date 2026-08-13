import 'package:flutter/foundation.dart';

class PatientVisit {
  final String id, studentName, className, date, time, complaint, diagnosis, treatment, attendant, status;
  final bool referred;
  final String? referralDestination;
  const PatientVisit({required this.id, required this.studentName, required this.className, required this.date, required this.time, required this.complaint, required this.diagnosis, required this.treatment, required this.attendant, required this.status, required this.referred, this.referralDestination});
}

class MedItem {
  final String id, name, category, unit;
  final int quantity, reorderLevel;
  final double unitPrice;
  final String expiryDate;
  const MedItem({required this.id, required this.name, required this.category, required this.quantity, required this.reorderLevel, required this.unit, required this.unitPrice, required this.expiryDate});
}

class Referral {
  final String id, studentName, className, date, destination, reason, referredBy, status;
  final String? feedback;
  const Referral({required this.id, required this.studentName, required this.className, required this.date, required this.destination, required this.reason, required this.referredBy, required this.status, this.feedback});
}

class HealthRecord {
  final String id, studentName, className, bloodGroup, allergies, chronicConditions, vaccinations, lastCheckup, notes;
  const HealthRecord({required this.id, required this.studentName, required this.className, required this.bloodGroup, required this.allergies, required this.chronicConditions, required this.vaccinations, required this.lastCheckup, required this.notes});
}

class HealthProvider extends ChangeNotifier {
  final List<PatientVisit> visits = [
    PatientVisit(id: 'v1', studentName: 'Kwame Asante', className: 'SHS2 Sci A', date: '2026-07-10', time: '08:30', complaint: 'Headache and fever', diagnosis: 'Malaria (mild)', treatment: 'Antimalarial tablets, rest', attendant: 'Nurse Adwoa', status: 'Treated', referred: false),
    PatientVisit(id: 'v2', studentName: 'Ama Owusu', className: 'SHS1 Arts B', date: '2026-07-10', time: '10:15', complaint: 'Stomach pain', diagnosis: 'Indigestion', treatment: 'Antacid, hydration', attendant: 'Nurse Adwoa', status: 'Treated', referred: false),
    PatientVisit(id: 'v3', studentName: 'Yao Mensah', className: 'SHS3 Bus A', date: '2026-07-09', time: '14:00', complaint: 'Ankle sprain (football)', diagnosis: 'Ligament sprain', treatment: 'Ice, bandage, rest 2 days', attendant: 'Nurse Adwoa', status: 'Monitoring', referred: true, referralDestination: 'KATH'),
    PatientVisit(id: 'v4', studentName: 'Efua Darko', className: 'SHS2 Sci B', date: '2026-07-09', time: '09:00', complaint: 'Sore throat', diagnosis: 'Pharyngitis', treatment: 'Lozenges, warm fluids', attendant: 'Nurse Adwoa', status: 'Treated', referred: false),
    PatientVisit(id: 'v5', studentName: 'Kofi Boateng', className: 'SHS3 Sci A', date: '2026-07-08', time: '16:30', complaint: 'Cut on finger', diagnosis: 'Laceration', treatment: 'Cleaned, dressed', attendant: 'Nurse Adwoa', status: 'Treated', referred: false),
  ];

  final List<MedItem> meds = [
    MedItem(id: 'm1', name: 'Paracetamol', category: 'Analgesic', quantity: 500, reorderLevel: 200, unit: 'tablets', unitPrice: 0.5, expiryDate: '2027-06-30'),
    MedItem(id: 'm2', name: 'Amoxicillin', category: 'Antibiotic', quantity: 120, reorderLevel: 80, unit: 'capsules', unitPrice: 1.2, expiryDate: '2027-03-15'),
    MedItem(id: 'm3', name: 'Antacid', category: 'Gastro', quantity: 60, reorderLevel: 50, unit: 'tablets', unitPrice: 0.8, expiryDate: '2026-12-31'),
    MedItem(id: 'm4', name: 'ORS Sachets', category: 'Rehydration', quantity: 40, reorderLevel: 30, unit: 'sachets', unitPrice: 1.5, expiryDate: '2027-01-31'),
    MedItem(id: 'm5', name: 'Bandages', category: 'First Aid', quantity: 25, reorderLevel: 15, unit: 'rolls', unitPrice: 3.0, expiryDate: '2028-01-01'),
    MedItem(id: 'm6', name: 'Cotton Wool', category: 'First Aid', quantity: 8, reorderLevel: 10, unit: 'packs', unitPrice: 5.0, expiryDate: '2028-01-01'),
  ];

  final List<Referral> referrals = [
    Referral(id: 'r1', studentName: 'Yao Mensah', className: 'SHS3 Bus A', date: '2026-07-09', destination: 'KATH', reason: 'Ankle X-ray needed', referredBy: 'Nurse Adwoa', status: 'Pending', feedback: null),
    Referral(id: 'r2', studentName: 'Adwoa Frimpong', className: 'SHS1 Sci A', date: '2026-06-20', destination: 'Manhyia Hospital', reason: 'Persistent abdominal pain', referredBy: 'Nurse Adwoa', status: 'Completed', feedback: 'Gastritis diagnosed, medication prescribed'),
  ];

  final List<HealthRecord> records = [
    HealthRecord(id: 'h1', studentName: 'Kwame Asante', className: 'SHS2 Sci A', bloodGroup: 'O+', allergies: 'None', chronicConditions: 'None', vaccinations: 'Up to date', lastCheckup: '2026-01-15', notes: 'Healthy'),
    HealthRecord(id: 'h2', studentName: 'Ama Owusu', className: 'SHS1 Arts B', bloodGroup: 'A+', allergies: 'Penicillin', chronicConditions: 'Asthma (mild)', vaccinations: 'Up to date', lastCheckup: '2026-01-20', notes: 'Inhaler available at sick bay'),
    HealthRecord(id: 'h3', studentName: 'Yao Mensah', className: 'SHS3 Bus A', bloodGroup: 'B+', allergies: 'None', chronicConditions: 'None', vaccinations: 'Up to date', lastCheckup: '2026-02-01', notes: 'Active in sports'),
  ];

  int get todayVisits => visits.where((v) => v.date == '2026-07-10').length;
  int get pendingReferrals => referrals.where((r) => r.status == 'Pending').length;
  int get lowStockMeds => meds.where((m) => m.quantity <= m.reorderLevel).length;
}
