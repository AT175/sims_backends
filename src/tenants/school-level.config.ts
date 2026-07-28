/**
 * School Level Configuration
 * Defines which roles, modules, grading schemes, and class levels
 * are available for each type of pre-tertiary school in Ghana.
 */

export type SchoolLevel = 'kg' | 'primary' | 'jhs' | 'shs' | 'combined';

export interface LevelConfig {
  label: string;
  shortLabel: string;
  /** Roles that are NOT applicable for this school level */
  excludedRoles: string[];
  /** Default grading scheme */
  defaultGradingScheme: string;
  /** Default class levels offered */
  defaultClassLevels: string[];
  /** Default class level display names */
  defaultClassLevelNames: Record<string, string>;
  /** Whether CSSPS placement is used */
  usesCssps: boolean;
  /** Whether boarding/house system is typical */
  typicallyBoarding: boolean;
  /** Default modules enabled */
  defaultModules: string[];
}

export const SCHOOL_LEVEL_CONFIGS: Record<SchoolLevel, LevelConfig> = {
  kg: {
    label: 'Kindergarten',
    shortLabel: 'KG',
    excludedRoles: [
      'src', 'electoral_commission', 'dining_hall_master', 'exam_committee',
      'academic_board', 'governing_board', 'subject_hod', 'senior_housemaster',
      'senior_housemistress', 'housemaster', 'housemistress', 'catering',
      'cleaning', 'stores', 'transport', 'internal_auditor', 'welfare_committee',
      'chaplain', 'sports_clubs', 'plc', 'safe_space',
    ],
    defaultGradingScheme: 'descriptive',
    defaultClassLevels: ['kg1', 'kg2'],
    defaultClassLevelNames: { kg1: 'KG 1', kg2: 'KG 2' },
    usesCssps: false,
    typicallyBoarding: false,
    defaultModules: ['attendance', 'fees', 'parent_portal', 'communication', 'health'],
  },
  primary: {
    label: 'Primary School',
    shortLabel: 'Primary',
    excludedRoles: [
      'src', 'electoral_commission', 'dining_hall_master', 'exam_committee',
      'academic_board', 'governing_board', 'subject_hod', 'senior_housemaster',
      'senior_housemistress', 'housemaster', 'housemistress', 'catering',
      'cleaning', 'stores', 'internal_auditor', 'welfare_committee',
      'chaplain', 'plc', 'safe_space',
    ],
    defaultGradingScheme: 'continuous',
    defaultClassLevels: ['basic1', 'basic2', 'basic3', 'basic4', 'basic5', 'basic6'],
    defaultClassLevelNames: {
      basic1: 'Basic 1', basic2: 'Basic 2', basic3: 'Basic 3',
      basic4: 'Basic 4', basic5: 'Basic 5', basic6: 'Basic 6',
    },
    usesCssps: false,
    typicallyBoarding: false,
    defaultModules: ['attendance', 'exams', 'fees', 'parent_portal', 'communication', 'health', 'transport', 'reports', 'curriculum', 'timetable'],
  },
  jhs: {
    label: 'Junior High School',
    shortLabel: 'JHS',
    excludedRoles: [
      'src', 'electoral_commission', 'dining_hall_master', 'exam_committee',
      'academic_board', 'governing_board', 'subject_hod', 'senior_housemaster',
      'senior_housemistress', 'housemaster', 'housemistress', 'catering',
      'cleaning', 'stores', 'internal_auditor', 'welfare_committee',
      'chaplain', 'plc', 'safe_space',
    ],
    defaultGradingScheme: 'bece',
    defaultClassLevels: ['jhs1', 'jhs2', 'jhs3'],
    defaultClassLevelNames: { jhs1: 'JHS 1', jhs2: 'JHS 2', jhs3: 'JHS 3' },
    usesCssps: false,
    typicallyBoarding: false,
    defaultModules: ['attendance', 'exams', 'fees', 'parent_portal', 'communication', 'health', 'transport', 'reports', 'curriculum', 'timetable', 'bece_prep'],
  },
  shs: {
    label: 'Senior High School',
    shortLabel: 'SHS',
    excludedRoles: [],
    defaultGradingScheme: 'wassce',
    defaultClassLevels: ['shs1', 'shs2', 'shs3'],
    defaultClassLevelNames: { shs1: 'SHS 1', shs2: 'SHS 2', shs3: 'SHS 3' },
    usesCssps: true,
    typicallyBoarding: true,
    defaultModules: [
      'attendance', 'exams', 'fees', 'parent_portal', 'communication', 'health',
      'transport', 'reports', 'curriculum', 'timetable', 'boarding', 'catering',
      'stores', 'security', 'sports', 'library', 'counselling', 'chaplain',
      'src', 'elections', 'dining', 'cleaning', 'welfare', 'plc',
    ],
  },
  combined: {
    label: 'Combined (KG/Primary/JHS/SHS)',
    shortLabel: 'Combined',
    excludedRoles: [],
    defaultGradingScheme: 'wassce',
    defaultClassLevels: ['kg1', 'kg2', 'basic1', 'basic2', 'basic3', 'basic4', 'basic5', 'basic6', 'jhs1', 'jhs2', 'jhs3', 'shs1', 'shs2', 'shs3'],
    defaultClassLevelNames: {
      kg1: 'KG 1', kg2: 'KG 2',
      basic1: 'Basic 1', basic2: 'Basic 2', basic3: 'Basic 3',
      basic4: 'Basic 4', basic5: 'Basic 5', basic6: 'Basic 6',
      jhs1: 'JHS 1', jhs2: 'JHS 2', jhs3: 'JHS 3',
      shs1: 'SHS 1', shs2: 'SHS 2', shs3: 'SHS 3',
    },
    usesCssps: true,
    typicallyBoarding: true,
    defaultModules: [
      'attendance', 'exams', 'fees', 'parent_portal', 'communication', 'health',
      'transport', 'reports', 'curriculum', 'timetable', 'boarding', 'catering',
      'stores', 'security', 'sports', 'library', 'counselling', 'chaplain',
      'src', 'elections', 'dining', 'cleaning', 'welfare', 'plc',
    ],
  },
};

/**
 * Grading scheme definitions
 */
export interface GradeBand {
  min: number;
  max: number;
  grade: string;
  remark: string;
}

export const GRADING_SCHEMES: Record<string, { label: string; bands: GradeBand[] }> = {
  wassce: {
    label: 'WASSCE (A1-F9)',
    bands: [
      { min: 75, max: 100, grade: 'A1', remark: 'Excellent' },
      { min: 70, max: 74, grade: 'B2', remark: 'Very Good' },
      { min: 65, max: 69, grade: 'B3', remark: 'Good' },
      { min: 60, max: 64, grade: 'C4', remark: 'Credit' },
      { min: 55, max: 59, grade: 'C5', remark: 'Credit' },
      { min: 50, max: 54, grade: 'C6', remark: 'Credit' },
      { min: 45, max: 49, grade: 'D7', remark: 'Pass' },
      { min: 40, max: 44, grade: 'E8', remark: 'Pass' },
      { min: 0, max: 39, grade: 'F9', remark: 'Fail' },
    ],
  },
  bece: {
    label: 'BECE (1-9)',
    bands: [
      { min: 90, max: 100, grade: '1', remark: 'Highest' },
      { min: 80, max: 89, grade: '2', remark: 'High' },
      { min: 70, max: 79, grade: '3', remark: 'High' },
      { min: 60, max: 69, grade: '4', remark: 'High' },
      { min: 55, max: 59, grade: '5', remark: 'Average' },
      { min: 50, max: 54, grade: '6', remark: 'Average' },
      { min: 40, max: 49, grade: '7', remark: 'Low' },
      { min: 30, max: 39, grade: '8', remark: 'Low' },
      { min: 0, max: 29, grade: '9', remark: 'Lowest' },
    ],
  },
  continuous: {
    label: 'Continuous Assessment (%)',
    bands: [
      { min: 80, max: 100, grade: 'A', remark: 'Excellent' },
      { min: 70, max: 79, grade: 'B', remark: 'Very Good' },
      { min: 60, max: 69, grade: 'C', remark: 'Good' },
      { min: 50, max: 59, grade: 'D', remark: 'Pass' },
      { min: 0, max: 49, grade: 'F', remark: 'Fail' },
    ],
  },
  descriptive: {
    label: 'Descriptive (KG/Early Years)',
    bands: [
      { min: 80, max: 100, grade: 'Proficient', remark: 'Proficient' },
      { min: 60, max: 79, grade: 'Developing', remark: 'Developing' },
      { min: 40, max: 59, grade: 'Beginning', remark: 'Beginning' },
      { min: 0, max: 39, grade: 'Needs Support', remark: 'Needs Support' },
    ],
  },
};

/**
 * Get the level config for a tenant's school level
 */
export function getLevelConfig(schoolLevel: string): LevelConfig {
  return SCHOOL_LEVEL_CONFIGS[schoolLevel as SchoolLevel] || SCHOOL_LEVEL_CONFIGS.shs;
}

/**
 * Get the grading scheme for a tenant
 */
export function getGradingScheme(scheme: string) {
  return GRADING_SCHEMES[scheme] || GRADING_SCHEMES.wassce;
}

/**
 * Convert a raw mark to a grade based on the grading scheme
 */
export function markToGrade(mark: number, scheme: string): { grade: string; remark: string } {
  const config = getGradingScheme(scheme);
  const band = config.bands.find((b) => mark >= b.min && mark <= b.max);
  return band ? { grade: band.grade, remark: band.remark } : { grade: 'F9', remark: 'Fail' };
}

/**
 * Get the default disabled roles for a school level
 */
export function getDefaultDisabledRoles(schoolLevel: string): string[] {
  return getLevelConfig(schoolLevel).excludedRoles;
}

/**
 * Get the default class levels for a school level
 */
export function getDefaultClassLevels(schoolLevel: string): string[] {
  return getLevelConfig(schoolLevel).defaultClassLevels;
}

/**
 * Get the default class level names for a school level
 */
export function getDefaultClassLevelNames(schoolLevel: string): Record<string, string> {
  return getLevelConfig(schoolLevel).defaultClassLevelNames;
}
