import 'package:flutter/foundation.dart';
import 'app_models.dart';

/// Registry store — students, admissions, certificates, correspondence, staff.
class RegistryProvider extends ChangeNotifier {
  final List<StudentRecord> _students = [
    StudentRecord(id: '1', admNo: '2026/001', firstName: 'Kwame', lastName: 'Asante', dateOfBirth: '2008-05-14', gender: 'Male', programme: Programme.science, className: 'SHS2 Sci A', house: 'Aggrey', guardianName: 'Mr. Kofi Asante', guardianPhone: '024-555-1001', guardianAddress: 'Kumasi, Ashanti Region', admissionDate: '2025-09-10', status: StudentStatus.active, csspsRef: 'CSSPS/2025/0123'),
    StudentRecord(id: '2', admNo: '2026/002', firstName: 'Ama', lastName: 'Owusu', dateOfBirth: '2009-03-22', gender: 'Female', programme: Programme.arts, className: 'SHS1 Arts B', house: 'Mensah', guardianName: 'Mrs. Akosua Owusu', guardianPhone: '027-555-1002', guardianAddress: 'Accra, Greater Accra', admissionDate: '2026-09-10', status: StudentStatus.active, csspsRef: 'CSSPS/2026/0456'),
    StudentRecord(id: '3', admNo: '2026/003', firstName: 'Yao', lastName: 'Mensah', dateOfBirth: '2007-11-08', gender: 'Male', programme: Programme.business, className: 'SHS3 Bus A', house: 'Aggrey', guardianName: 'Mr. Daniel Mensah', guardianPhone: '020-555-1003', guardianAddress: 'Tema, Greater Accra', admissionDate: '2024-09-10', status: StudentStatus.active, csspsRef: 'CSSPS/2024/0789'),
    StudentRecord(id: '4', admNo: '2025/145', firstName: 'Efua', lastName: 'Darko', dateOfBirth: '2008-07-19', gender: 'Female', programme: Programme.science, className: 'SHS2 Sci B', house: 'Mensah', guardianName: 'Mrs. Grace Darko', guardianPhone: '055-555-1004', guardianAddress: 'Cape Coast, Central', admissionDate: '2025-09-10', status: StudentStatus.active, csspsRef: 'CSSPS/2025/0234'),
    StudentRecord(id: '5', admNo: '2025/146', firstName: 'Kofi', lastName: 'Boateng', dateOfBirth: '2007-09-03', gender: 'Male', programme: Programme.science, className: 'SHS3 Sci A', house: 'Sarbah', guardianName: 'Mr. Samuel Boateng', guardianPhone: '024-555-1005', guardianAddress: 'Sekondi, Western', admissionDate: '2024-09-10', status: StudentStatus.active, csspsRef: 'CSSPS/2024/0567'),
    StudentRecord(id: '6', admNo: '2025/147', firstName: 'Adwoa', lastName: 'Frimpong', dateOfBirth: '2009-01-15', gender: 'Female', programme: Programme.science, className: 'SHS1 Sci A', house: 'Barton', guardianName: 'Mr. Yaw Frimpong', guardianPhone: '027-555-1006', guardianAddress: 'Koforidua, Eastern', admissionDate: '2026-09-10', status: StudentStatus.active, csspsRef: 'CSSPS/2026/0382'),
    StudentRecord(id: '7', admNo: '2024/098', firstName: 'Kojo', lastName: 'Addo', dateOfBirth: '2006-12-01', gender: 'Male', programme: Programme.arts, className: 'SHS3 Arts A', house: 'Sarbah', guardianName: 'Mr. Peter Addo', guardianPhone: '020-555-1007', guardianAddress: 'Accra, Greater Accra', admissionDate: '2024-09-10', status: StudentStatus.active, csspsRef: 'CSSPS/2024/0901'),
    StudentRecord(id: '8', admNo: '2024/099', firstName: 'Grace', lastName: 'Opoku', dateOfBirth: '2006-08-25', gender: 'Female', programme: Programme.business, className: 'SHS3 Bus A', house: 'Barton', guardianName: 'Mrs. Linda Opoku', guardianPhone: '055-555-1008', guardianAddress: 'Sunyani, Bono', admissionDate: '2024-09-10', status: StudentStatus.graduated, csspsRef: 'CSSPS/2024/0678'),
  ];

  final List<AdmissionApplication> _admissions = [
    AdmissionApplication(id: '1', applicantName: 'Kofi Asante', parentName: 'Mr. Kofi Asante Sr.', parentPhone: '024-555-2001', parentEmail: 'kofi.asante@email.com', dateApplied: '2026-07-06', status: AdmissionStatus.received, documentsVerified: false, programme: Programme.science, csspsRef: 'CSSPS/2026/0451', notes: 'Awaiting medical form and previous report card.', documents: [
      DocumentItem(type: 'Birth Certificate', submitted: true), DocumentItem(type: 'JHS Result', submitted: true), DocumentItem(type: 'CSSPS Placement', submitted: true), DocumentItem(type: 'Medical Form', submitted: false), DocumentItem(type: 'Passport Photo', submitted: true), DocumentItem(type: 'Previous Report Card', submitted: false),
    ]),
    AdmissionApplication(id: '2', applicantName: 'Adwoa Frimpong', parentName: 'Mrs. Frimpong', parentPhone: '027-555-2002', parentEmail: 'frimpong@email.com', dateApplied: '2026-07-05', status: AdmissionStatus.underReview, documentsVerified: false, programme: Programme.science, csspsRef: 'CSSPS/2026/0382', notes: 'All docs except report card received. Reviewing.', documents: [
      DocumentItem(type: 'Birth Certificate', submitted: true), DocumentItem(type: 'JHS Result', submitted: true), DocumentItem(type: 'CSSPS Placement', submitted: true), DocumentItem(type: 'Medical Form', submitted: true), DocumentItem(type: 'Passport Photo', submitted: true), DocumentItem(type: 'Previous Report Card', submitted: false),
    ]),
    AdmissionApplication(id: '3', applicantName: 'Kojo Addo', parentName: 'Mr. Addo', parentPhone: '020-555-2003', parentEmail: 'addo@email.com', dateApplied: '2026-07-04', status: AdmissionStatus.approved, documentsVerified: true, programme: Programme.arts, csspsRef: 'CSSPS/2024/0901', notes: 'All documents verified. Admission approved.', processedBy: 'Registrar', documents: [
      DocumentItem(type: 'Birth Certificate', submitted: true), DocumentItem(type: 'JHS Result', submitted: true), DocumentItem(type: 'CSSPS Placement', submitted: true), DocumentItem(type: 'Medical Form', submitted: true), DocumentItem(type: 'Passport Photo', submitted: true), DocumentItem(type: 'Previous Report Card', submitted: true),
    ]),
    AdmissionApplication(id: '4', applicantName: 'Selina Adjei', parentName: 'Mrs. Adjei', parentPhone: '055-555-2004', parentEmail: 'adjei@email.com', dateApplied: '2026-07-08', status: AdmissionStatus.received, documentsVerified: false, programme: Programme.arts, csspsRef: 'CSSPS/2026/0519', notes: 'Only birth certificate and photo submitted.', documents: [
      DocumentItem(type: 'Birth Certificate', submitted: true), DocumentItem(type: 'JHS Result', submitted: false), DocumentItem(type: 'CSSPS Placement', submitted: false), DocumentItem(type: 'Medical Form', submitted: false), DocumentItem(type: 'Passport Photo', submitted: true), DocumentItem(type: 'Previous Report Card', submitted: false),
    ]),
  ];

  final List<Certificate> _certificates = [
    Certificate(id: '1', studentName: 'Yao Mensah', admNo: '2026/003', type: CertType.transcript, dateIssued: '2026-06-28', issuedBy: 'Registrar', purpose: 'University application'),
    Certificate(id: '2', studentName: 'Grace Opoku', admNo: '2024/099', type: CertType.testimonial, dateIssued: '2026-06-15', issuedBy: 'Registrar', purpose: 'Graduation testimonial'),
    Certificate(id: '3', studentName: 'Kofi Boateng', admNo: '2025/146', type: CertType.transferLetter, dateIssued: '2026-05-20', issuedBy: 'Registrar', purpose: 'School transfer'),
    Certificate(id: '4', studentName: 'Kojo Addo', admNo: '2024/098', type: CertType.characterRef, dateIssued: '2026-06-30', issuedBy: 'Headmaster', purpose: 'Scholarship application'),
  ];

  final List<Correspondence> _correspondence = [
    Correspondence(id: '1', date: '2026-07-06', direction: CorrespondenceDir.incoming, subject: 'GES Circular — Term 3 Calendar', counterparty: 'GES HQ', priority: CorrespondencePriority.important, loggedBy: 'Registry Clerk', notes: 'Circular received via email. Circulated to all HODs.'),
    Correspondence(id: '2', date: '2026-07-04', direction: CorrespondenceDir.outgoing, subject: 'Term 2 Academic Report', counterparty: 'Regional Education Office', priority: CorrespondencePriority.normal, loggedBy: 'Registrar', notes: 'Submitted via regional portal.'),
    Correspondence(id: '3', date: '2026-06-28', direction: CorrespondenceDir.incoming, subject: 'Scholarship Nomination Letter', counterparty: 'Ghana Scholarship Secretariat', priority: CorrespondencePriority.urgent, loggedBy: 'Registry Clerk', notes: 'Nomination for 2 students. Forwarded to Headmaster.'),
    Correspondence(id: '4', date: '2026-06-20', direction: CorrespondenceDir.outgoing, subject: 'Student Transfer Request — Kofi Boateng', counterparty: 'Mfantsipim School', priority: CorrespondencePriority.normal, loggedBy: 'Registrar', notes: 'Transfer documents sent.'),
    Correspondence(id: '5', date: '2026-06-15', direction: CorrespondenceDir.incoming, subject: 'Parent Appeal — Fee Adjustment', counterparty: 'PTA Chairman', priority: CorrespondencePriority.important, loggedBy: 'Registry Clerk', notes: 'Appeal received and forwarded to Bursary.'),
  ];

  final List<RegistryStaff> _staff = [
    RegistryStaff(id: '1', name: 'J. Mensah', position: 'Senior Teacher', role: 'teacher', department: 'Mathematics', dateOfEmployment: '2018-09-01', qualifications: ['B.Ed Mathematics', 'M.Ed Curriculum'], phone: '024-100-2001', status: StaffStatus.active),
    RegistryStaff(id: '2', name: 'G. Adjei', position: 'HOD Science', role: 'subject_hod', department: 'Science', dateOfEmployment: '2016-09-01', qualifications: ['B.Sc Chemistry', 'PGDE'], phone: '027-100-2002', status: StaffStatus.active),
    RegistryStaff(id: '3', name: 'A. Tetteh', position: 'Accountant', role: 'accountant', department: 'Finance', dateOfEmployment: '2015-01-15', qualifications: ['B.Com', 'ACA'], phone: '055-100-2004', status: StaffStatus.onLeave),
    RegistryStaff(id: '4', name: 'R. Amponsah', position: 'Asst. Headmaster (Academic)', role: 'asst_headmaster_academic', department: 'Administration', dateOfEmployment: '2012-09-01', qualifications: ['B.Ed', 'M.Ed Administration'], phone: '027-100-2010', status: StaffStatus.active),
    RegistryStaff(id: '5', name: 'L. Frimpong', position: 'Librarian', role: 'library_ict', department: 'Library', dateOfEmployment: '2019-09-01', qualifications: ['B.A Information Studies', 'MLIS'], phone: '055-100-2008', status: StaffStatus.active),
  ];

  final List<PlacementRecord> _placements = [
    PlacementRecord(id: '1', fullName: 'Kofi Asante', csspsRef: 'CSSPS/2026/0451', intendedClass: 'SHS1 Sci A', programme: Programme.science, preloadedBy: 'Registry Clerk', datePreloaded: '2026-07-01', matched: true),
    PlacementRecord(id: '2', fullName: 'Adwoa Frimpong', csspsRef: 'CSSPS/2026/0382', intendedClass: 'SHS1 Sci A', programme: Programme.science, preloadedBy: 'Registry Clerk', datePreloaded: '2026-07-01', matched: true),
    PlacementRecord(id: '3', fullName: 'Selina Adjei', csspsRef: 'CSSPS/2026/0519', intendedClass: 'SHS1 Arts B', programme: Programme.arts, preloadedBy: 'Registry Clerk', datePreloaded: '2026-07-02', matched: false),
    PlacementRecord(id: '4', fullName: 'Daniel Osei', csspsRef: 'CSSPS/2026/0633', intendedClass: 'SHS1 Bus A', programme: Programme.business, preloadedBy: 'Registry Clerk', datePreloaded: '2026-07-03', matched: false),
  ];

  final List<ScratchCard> _scratchCards = [
    ScratchCard(id: 'sc1', pin: '1234-5678', serial: 'SC-001', amount: 50, used: true, usedBy: 'Adwoa Frimpong', usedAt: '2026-07-05', batchId: 'batch1', generatedAt: '2026-06-01'),
    ScratchCard(id: 'sc2', pin: '2345-6789', serial: 'SC-002', amount: 50, used: false, batchId: 'batch1', generatedAt: '2026-06-01'),
    ScratchCard(id: 'sc3', pin: '3456-7890', serial: 'SC-003', amount: 50, used: false, batchId: 'batch1', generatedAt: '2026-06-01'),
    ScratchCard(id: 'sc4', pin: '4567-8901', serial: 'SC-004', amount: 50, used: false, batchId: 'batch1', generatedAt: '2026-06-01'),
    ScratchCard(id: 'sc5', pin: '5678-9012', serial: 'SC-005', amount: 50, used: false, batchId: 'batch1', generatedAt: '2026-06-01'),
  ];

  final List<Prospectus> _prospectus = [
    Prospectus(id: '1', title: 'Welcome Prospectus 2026/2027', academicYear: '2026/2027', content: 'Dear Parent,\n\nWelcome to Ghana Senior High School! Your ward has been successfully admitted.\n\nKey Information:\n- School Fees: GHC 3,500 per term (boarding), GHC 2,000 (day)\n- Reporting Date: 10th September 2026\n- Items Required: Bedding, cutlery, toiletries, school uniform (2 sets), PE kit\n- House assignment and class allocation have been completed\n- First PTA meeting: 25th September 2026 at 10:00 AM\n\nPlease report to the school office on the reporting date with this prospectus and all required documents.\n\nRegards,\nHeadmaster', publishedBy: 'Headmaster', datePublished: '2026-07-10', targetedAdmissionIds: ['3']),
  ];

  final List<ParentAccount> _parentAccounts = [
    ParentAccount(id: '1', username: 'parent_addo', password: 'parent123', parentName: 'Mr. Addo', parentPhone: '020-555-2003', parentEmail: 'addo@email.com', wardName: 'Kojo Addo', wardAdmNo: '2024/098', wardClass: 'SHS3 Arts A', wardHouse: 'Sarbah', wardProgramme: Programme.arts, createdAt: '2024-09-12', admissionId: '3'),
  ];

  AdmissionFormConfig _admissionFormConfig = const AdmissionFormConfig(
    academicYear: '2026/2027',
    photoRequired: false,
    requiredDocuments: ['Birth Certificate', 'JHS Result', 'CSSPS Placement', 'Medical Form', 'Passport Photo', 'Previous Report Card'],
    fields: [
      AdmissionFormField(id: 'firstName', label: 'First Name', type: FormFieldType.text, required: true, enabled: true),
      AdmissionFormField(id: 'lastName', label: 'Last Name', type: FormFieldType.text, required: true, enabled: true),
      AdmissionFormField(id: 'dateOfBirth', label: 'Date of Birth', type: FormFieldType.date, required: true, enabled: true),
      AdmissionFormField(id: 'gender', label: 'Gender', type: FormFieldType.gender, required: true, enabled: true),
      AdmissionFormField(id: 'programme', label: 'Programme of Study', type: FormFieldType.programme, required: true, enabled: true),
      AdmissionFormField(id: 'csspsRef', label: 'CSSPS Placement Reference', type: FormFieldType.csspsRef, required: true, enabled: true),
      AdmissionFormField(id: 'photo', label: 'Student Photo', type: FormFieldType.photo, required: false, enabled: true),
      AdmissionFormField(id: 'parentName', label: 'Parent/Guardian Name', type: FormFieldType.text, required: true, enabled: true),
      AdmissionFormField(id: 'parentPhone', label: 'Parent/Guardian Phone', type: FormFieldType.phone, required: true, enabled: true),
      AdmissionFormField(id: 'parentEmail', label: 'Parent/Guardian Email', type: FormFieldType.email, required: false, enabled: true),
      AdmissionFormField(id: 'guardianAddress', label: 'Guardian Address', type: FormFieldType.address, required: false, enabled: true),
    ],
  );

  double _applicationFeeAmount = 50;

  // ── Getters ──
  List<StudentRecord> get students => List.unmodifiable(_students);
  List<AdmissionApplication> get admissions => List.unmodifiable(_admissions);
  List<Certificate> get certificates => List.unmodifiable(_certificates);
  List<Correspondence> get correspondence => List.unmodifiable(_correspondence);
  List<RegistryStaff> get staff => List.unmodifiable(_staff);
  List<PlacementRecord> get placements => List.unmodifiable(_placements);
  List<ScratchCard> get scratchCards => List.unmodifiable(_scratchCards);
  List<Prospectus> get prospectus => List.unmodifiable(_prospectus);
  List<ParentAccount> get parentAccounts => List.unmodifiable(_parentAccounts);
  AdmissionFormConfig get admissionFormConfig => _admissionFormConfig;
  double get applicationFeeAmount => _applicationFeeAmount;

  int get activeStudentCount => _students.where((s) => s.status == StudentStatus.active).length;
  int get pendingAdmissions => _admissions.where((a) => a.status == AdmissionStatus.received || a.status == AdmissionStatus.underReview).length;
  int get matchedPlacements => _placements.where((p) => p.matched).length;
  int get unmatchedPlacements => _placements.where((p) => !p.matched).length;
  int get availableScratchCards => _scratchCards.where((c) => !c.used).length;
  int get usedScratchCards => _scratchCards.where((c) => c.used).length;

  // ── ID helpers ──
  int _idCounter = 700;
  String _nextId() => (++_idCounter).toString();
  String _todayISO() => DateTime.now().toIso8601String().split('T')[0];

  // ── Student CRUD ──
  void addStudent({
    required String admNo, required String firstName, required String lastName,
    required String dateOfBirth, required String gender, required Programme programme,
    required String className, required String house,
    required String guardianName, required String guardianPhone, required String guardianAddress,
    String? csspsRef,
  }) {
    _students.insert(0, StudentRecord(
      id: _nextId(), admNo: admNo, firstName: firstName, lastName: lastName,
      dateOfBirth: dateOfBirth, gender: gender, programme: programme,
      className: className, house: house,
      guardianName: guardianName, guardianPhone: guardianPhone, guardianAddress: guardianAddress,
      admissionDate: _todayISO(), status: StudentStatus.active, csspsRef: csspsRef,
    ));
    notifyListeners();
  }

  void updateStudent(String id, {StudentStatus? status, String? className, String? house, String? guardianName, String? guardianPhone}) {
    final idx = _students.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _students[idx];
    _students[idx] = StudentRecord(
      id: s.id, admNo: s.admNo, firstName: s.firstName, lastName: s.lastName,
      dateOfBirth: s.dateOfBirth, gender: s.gender, programme: s.programme,
      className: className ?? s.className, house: house ?? s.house,
      guardianName: guardianName ?? s.guardianName, guardianPhone: guardianPhone ?? s.guardianPhone,
      guardianAddress: s.guardianAddress, admissionDate: s.admissionDate,
      status: status ?? s.status, photoUrl: s.photoUrl, csspsRef: s.csspsRef,
    );
    notifyListeners();
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  List<StudentRecord> searchStudents(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return _students;
    return _students.where((s) =>
      s.admNo.toLowerCase().contains(q) ||
      s.fullName.toLowerCase().contains(q) ||
      s.className.toLowerCase().contains(q) ||
      s.house.toLowerCase().contains(q) ||
      s.guardianName.toLowerCase().contains(q)
    ).toList();
  }

  // ── Admission CRUD ──
  void addAdmission({
    required String applicantName, required String parentName,
    required String parentPhone, required String parentEmail,
    required Programme programme, String? csspsRef, String notes = '',
  }) {
    _admissions.insert(0, AdmissionApplication(
      id: _nextId(), applicantName: applicantName, parentName: parentName,
      parentPhone: parentPhone, parentEmail: parentEmail,
      dateApplied: _todayISO(), status: AdmissionStatus.received,
      documentsVerified: false, programme: programme, csspsRef: csspsRef, notes: notes,
      documents: _admissionFormConfig.requiredDocuments.map((d) => DocumentItem(type: d, submitted: false)).toList(),
    ));
    notifyListeners();
  }

  void updateAdmissionStatus(String id, AdmissionStatus status, String processedBy) {
    final idx = _admissions.indexWhere((a) => a.id == id);
    if (idx < 0) return;
    _admissions[idx] = _admissions[idx].copyWith(
      status: status,
      processedBy: processedBy,
      documentsVerified: status == AdmissionStatus.approved ? true : null,
    );
    notifyListeners();
  }

  void toggleDocument(String admissionId, String docType) {
    final idx = _admissions.indexWhere((a) => a.id == admissionId);
    if (idx < 0) return;
    final docs = _admissions[idx].documents.map((d) =>
      d.type == docType ? d.copyWith(submitted: !d.submitted) : d).toList();
    _admissions[idx] = _admissions[idx].copyWith(documents: docs);
    notifyListeners();
  }

  void verifyDocuments(String id) {
    final idx = _admissions.indexWhere((a) => a.id == id);
    if (idx < 0) return;
    _admissions[idx] = _admissions[idx].copyWith(documentsVerified: true);
    notifyListeners();
  }

  void deleteAdmission(String id) {
    _admissions.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // ── Certificate CRUD ──
  void issueCertificate({required String studentName, required String admNo, required CertType type, required String purpose, String issuedBy = 'Registrar'}) {
    _certificates.insert(0, Certificate(
      id: _nextId(), studentName: studentName, admNo: admNo, type: type,
      dateIssued: _todayISO(), issuedBy: issuedBy, purpose: purpose,
    ));
    notifyListeners();
  }

  void deleteCertificate(String id) {
    _certificates.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // ── Correspondence CRUD ──
  void logCorrespondence({required CorrespondenceDir direction, required String subject, required String counterparty, required CorrespondencePriority priority, String notes = ''}) {
    _correspondence.insert(0, Correspondence(
      id: _nextId(), date: _todayISO(), direction: direction,
      subject: subject, counterparty: counterparty, priority: priority,
      loggedBy: 'Registry Clerk', notes: notes,
    ));
    notifyListeners();
  }

  void deleteCorrespondence(String id) {
    _correspondence.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // ── Staff CRUD ──
  int _staffIdCounter = 100;
  void addStaff({required String name, required String position, required String department, required String role, String phone = '', List<String> qualifications = const [], StaffStatus status = StaffStatus.active}) {
    _staff.insert(0, RegistryStaff(
      id: (++_staffIdCounter).toString(),
      name: name, position: position, department: department, role: role,
      dateOfEmployment: _todayISO(),
      qualifications: qualifications, phone: phone, status: status,
    ));
    notifyListeners();
  }

  void updateStaff(String id, {StaffStatus? status, String? position, String? department}) {
    final idx = _staff.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final s = _staff[idx];
    _staff[idx] = RegistryStaff(
      id: s.id, name: s.name, position: position ?? s.position, role: s.role,
      department: department ?? s.department, dateOfEmployment: s.dateOfEmployment,
      qualifications: s.qualifications, phone: s.phone, status: status ?? s.status,
    );
    notifyListeners();
  }

  void deleteStaff(String id) {
    _staff.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ── Placement CRUD ──
  void addPlacement({required String fullName, required String csspsRef, required String intendedClass, required Programme programme}) {
    _placements.insert(0, PlacementRecord(
      id: _nextId(), fullName: fullName, csspsRef: csspsRef,
      intendedClass: intendedClass, programme: programme,
      preloadedBy: 'Registry Clerk', datePreloaded: _todayISO(), matched: false,
    ));
    notifyListeners();
  }

  void bulkAddPlacements(List<({String fullName, String csspsRef, String intendedClass, Programme programme})> items) {
    for (final p in items) {
      _placements.insert(0, PlacementRecord(
        id: _nextId(), fullName: p.fullName, csspsRef: p.csspsRef,
        intendedClass: p.intendedClass, programme: p.programme,
        preloadedBy: 'Registry Clerk', datePreloaded: _todayISO(), matched: false,
      ));
    }
    notifyListeners();
  }

  void matchPlacement(String id) {
    final idx = _placements.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      _placements[idx] = _placements[idx].copyWith(matched: true);
      notifyListeners();
    }
  }

  void deletePlacement(String id) {
    _placements.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ── Scratch Card CRUD ──
  List<ScratchCard> generateScratchCards(int count, double amount) {
    final batchId = 'batch_${DateTime.now().millisecondsSinceEpoch}';
    final generatedAt = _todayISO();
    final cards = <ScratchCard>[];
    final rand = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < count; i++) {
      final num = (_scratchCards.length + i + 1).toString().padLeft(3, '0');
      final pin = '${1000 + (rand + i * 7) % 9000}-${1000 + (rand + i * 13) % 9000}';
      cards.add(ScratchCard(
        id: 'sc_${batchId}_$i', pin: pin, serial: 'SC-$num',
        amount: amount, used: false, batchId: batchId, generatedAt: generatedAt,
      ));
    }
    _scratchCards.addAll(cards);
    notifyListeners();
    return cards;
  }

  void setApplicationFeeAmount(double amount) {
    _applicationFeeAmount = amount;
    notifyListeners();
  }

  // ── Prospectus CRUD ──
  void publishProspectus({required String title, required String academicYear, required String content, required List<String> targetedAdmissionIds}) {
    _prospectus.insert(0, Prospectus(
      id: _nextId(), title: title, academicYear: academicYear,
      content: content, publishedBy: 'Asst. Headmaster (Admin)',
      datePublished: _todayISO(), targetedAdmissionIds: targetedAdmissionIds,
    ));
    notifyListeners();
  }

  void deleteProspectus(String id) {
    _prospectus.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ── Admission Form Config ──
  void updateAdmissionFormConfig(AdmissionFormConfig config) {
    _admissionFormConfig = config;
    notifyListeners();
  }

  void toggleFormField(String fieldId) {
    _admissionFormConfig = _admissionFormConfig.copyWith(
      fields: _admissionFormConfig.fields.map((f) =>
        f.id == fieldId ? f.copyWith(enabled: !f.enabled) : f).toList(),
    );
    notifyListeners();
  }

  void toggleRequiredDoc(String doc) {
    final docs = _admissionFormConfig.requiredDocuments;
    final has = docs.contains(doc);
    _admissionFormConfig = _admissionFormConfig.copyWith(
      requiredDocuments: has ? docs.where((d) => d != doc).toList() : [...docs, doc],
    );
    notifyListeners();
  }

  void togglePhotoRequired() {
    _admissionFormConfig = _admissionFormConfig.copyWith(
      photoRequired: !_admissionFormConfig.photoRequired,
    );
    notifyListeners();
  }

  void updateAcademicYear(String year) {
    _admissionFormConfig = _admissionFormConfig.copyWith(academicYear: year);
    notifyListeners();
  }

  // ── Parent Account ──
  ParentAccount? getParentAccountByAdmission(String admissionId) {
    try {
      return _parentAccounts.firstWhere((a) => a.admissionId == admissionId);
    } catch (_) { return null; }
  }
}
