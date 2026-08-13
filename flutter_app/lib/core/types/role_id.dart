/// All role identifiers in the system. Maps 1:1 with the React Native app.
enum RoleId {
  governingBoard,
  pta,
  headmaster,
  staff,
  welfareCommittee,
  src,
  electoralCommission,
  asstHeadmasterAcademic,
  subjectHod,
  counselling,
  libraryIct,
  sportsClubs,
  plc,
  teacher,
  asstHeadmasterAdmin,
  bursary,
  accountant,
  stores,
  registry,
  security,
  asstHeadmasterDomestic,
  seniorHousemaster,
  seniorHousemistress,
  housemaster,
  housemistress,
  catering,
  health,
  transport,
  cleaning,
  student,
  parent,
  chaplain,
  academicBoard,
  diningHallMaster,
  examCommittee,
  safeSpace,
  internalAuditor,
  headmasterSecretary,
  systemAdmin,
  voter,
}

/// Extension to convert between enum and string values used by the API.
extension RoleIdExt on RoleId {
  String get value {
    switch (this) {
      case RoleId.governingBoard: return 'governing_board';
      case RoleId.pta: return 'pta';
      case RoleId.headmaster: return 'headmaster';
      case RoleId.staff: return 'staff';
      case RoleId.welfareCommittee: return 'welfare_committee';
      case RoleId.src: return 'src';
      case RoleId.electoralCommission: return 'electoral_commission';
      case RoleId.asstHeadmasterAcademic: return 'asst_headmaster_academic';
      case RoleId.subjectHod: return 'subject_hod';
      case RoleId.counselling: return 'counselling';
      case RoleId.libraryIct: return 'library_ict';
      case RoleId.sportsClubs: return 'sports_clubs';
      case RoleId.plc: return 'plc';
      case RoleId.teacher: return 'teacher';
      case RoleId.asstHeadmasterAdmin: return 'asst_headmaster_admin';
      case RoleId.bursary: return 'bursary';
      case RoleId.accountant: return 'accountant';
      case RoleId.stores: return 'stores';
      case RoleId.registry: return 'registry';
      case RoleId.security: return 'security';
      case RoleId.asstHeadmasterDomestic: return 'asst_headmaster_domestic';
      case RoleId.seniorHousemaster: return 'senior_housemaster';
      case RoleId.seniorHousemistress: return 'senior_housemistress';
      case RoleId.housemaster: return 'housemaster';
      case RoleId.housemistress: return 'housemistress';
      case RoleId.catering: return 'catering';
      case RoleId.health: return 'health';
      case RoleId.transport: return 'transport';
      case RoleId.cleaning: return 'cleaning';
      case RoleId.student: return 'student';
      case RoleId.parent: return 'parent';
      case RoleId.chaplain: return 'chaplain';
      case RoleId.academicBoard: return 'academic_board';
      case RoleId.diningHallMaster: return 'dining_hall_master';
      case RoleId.examCommittee: return 'exam_committee';
      case RoleId.safeSpace: return 'safe_space';
      case RoleId.internalAuditor: return 'internal_auditor';
      case RoleId.headmasterSecretary: return 'headmaster_secretary';
      case RoleId.systemAdmin: return 'system_admin';
      case RoleId.voter: return 'voter';
    }
  }

  String get label {
    switch (this) {
      case RoleId.governingBoard: return 'Governing Board';
      case RoleId.pta: return 'PTA';
      case RoleId.headmaster: return 'Headmaster';
      case RoleId.staff: return 'Staff';
      case RoleId.welfareCommittee: return 'Welfare Committee';
      case RoleId.src: return 'SRC';
      case RoleId.electoralCommission: return 'Electoral Commission';
      case RoleId.asstHeadmasterAcademic: return 'Asst. Headmaster (Academic)';
      case RoleId.subjectHod: return 'Subject HOD';
      case RoleId.counselling: return 'Counselling Unit';
      case RoleId.libraryIct: return 'Library & ICT';
      case RoleId.sportsClubs: return 'Sports & Clubs';
      case RoleId.plc: return 'PLC';
      case RoleId.teacher: return 'Teacher';
      case RoleId.asstHeadmasterAdmin: return 'Asst. Headmaster (Admin)';
      case RoleId.bursary: return 'Bursary';
      case RoleId.accountant: return 'Accountant';
      case RoleId.stores: return 'Stores';
      case RoleId.registry: return 'Registry';
      case RoleId.security: return 'Security';
      case RoleId.asstHeadmasterDomestic: return 'Asst. Headmaster (Domestic)';
      case RoleId.seniorHousemaster: return 'Senior Housemaster';
      case RoleId.seniorHousemistress: return 'Senior Housemistress';
      case RoleId.housemaster: return 'Housemaster';
      case RoleId.housemistress: return 'Housemistress';
      case RoleId.catering: return 'Catering / Kitchen';
      case RoleId.health: return 'Health / Sick Bay';
      case RoleId.transport: return 'Transport';
      case RoleId.cleaning: return 'Cleaning / Labourers';
      case RoleId.student: return 'Student';
      case RoleId.parent: return 'Parent';
      case RoleId.chaplain: return 'Chaplain';
      case RoleId.academicBoard: return 'Academic Board';
      case RoleId.diningHallMaster: return 'Dining Hall Master';
      case RoleId.examCommittee: return 'Examination Committee';
      case RoleId.safeSpace: return 'Safe Space';
      case RoleId.internalAuditor: return 'Internal Auditor';
      case RoleId.headmasterSecretary: return 'Headmaster Secretary';
      case RoleId.systemAdmin: return 'System Administrator';
      case RoleId.voter: return 'Voter';
    }
  }

  static RoleId fromString(String value) {
    return RoleId.values.firstWhere(
      (r) => r.value == value,
      orElse: () => RoleId.headmaster,
    );
  }
}
