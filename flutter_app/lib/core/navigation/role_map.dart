import '../types/role_id.dart';

/// Maps each RoleId to its dashboard route key string.
String roleToDashboardKey(RoleId role) {
  switch (role) {
    case RoleId.governingBoard: return 'GoverningBoard';
    case RoleId.pta: return 'PTA';
    case RoleId.headmaster: return 'Headmaster';
    case RoleId.staff: return 'Staff';
    case RoleId.welfareCommittee: return 'WelfareCommittee';
    case RoleId.src: return 'SRC';
    case RoleId.electoralCommission: return 'ElectoralCommission';
    case RoleId.asstHeadmasterAcademic: return 'Academic';
    case RoleId.subjectHod: return 'SubjectHOD';
    case RoleId.counselling: return 'Counselling';
    case RoleId.libraryIct: return 'LibraryICT';
    case RoleId.sportsClubs: return 'SportsClubs';
    case RoleId.plc: return 'PLC';
    case RoleId.teacher: return 'Teacher';
    case RoleId.asstHeadmasterAdmin: return 'Admin';
    case RoleId.bursary: return 'Bursary';
    case RoleId.accountant: return 'Accountant';
    case RoleId.stores: return 'Stores';
    case RoleId.registry: return 'Registry';
    case RoleId.security: return 'Security';
    case RoleId.asstHeadmasterDomestic: return 'Domestic';
    case RoleId.seniorHousemaster: return 'SeniorHousemaster';
    case RoleId.seniorHousemistress: return 'SeniorHousemaster';
    case RoleId.housemaster: return 'House';
    case RoleId.housemistress: return 'House';
    case RoleId.catering: return 'Catering';
    case RoleId.health: return 'Health';
    case RoleId.transport: return 'Transport';
    case RoleId.cleaning: return 'Cleaning';
    case RoleId.student: return 'Student';
    case RoleId.parent: return 'Parent';
    case RoleId.chaplain: return 'Chaplain';
    case RoleId.academicBoard: return 'AcademicBoard';
    case RoleId.diningHallMaster: return 'DiningHall';
    case RoleId.examCommittee: return 'ExamCommittee';
    case RoleId.safeSpace: return 'SafeSpace';
    case RoleId.internalAuditor: return 'InternalAuditor';
    case RoleId.headmasterSecretary: return 'HeadmasterSecretary';
    case RoleId.systemAdmin: return 'SystemAdmin';
    case RoleId.voter: return 'Verification';
  }
}
