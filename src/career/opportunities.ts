// Global university, scholarship, and career path database
export interface University {
  id: string;
  name: string;
  country: string;
  type: 'public' | 'private';
  programs: string[];
  subjectRequirements: string[];
  minGrade: string;
  description: string;
}

export interface Scholarship {
  id: string;
  name: string;
  provider: string;
  level: 'undergraduate' | 'masters' | 'phd';
  countries: string[];
  eligibility: string[];
  subjectRequirements: string[];
  deadline: string;
  amount: string;
  description: string;
  url: string;
}

export interface CareerPath {
  id: string;
  name: string;
  category: string;
  subjects: string[];
  description: string;
  universities: string[];
  careers: string[];
  averageSalary: string;
}

export const UNIVERSITIES: University[] = [
  // Ghana
  { id: 'ug-knust', name: 'Kwame Nkrumah University of Science and Technology (KNUST)', country: 'Ghana', type: 'public', programs: ['Engineering', 'Medicine', 'Computer Science', 'Pharmacy', 'Architecture'], subjectRequirements: ['Physics (Elective)', 'Chemistry (Elective)', 'Elective Mathematics', 'Mathematics (Core)', 'English Language'], minGrade: 'A1-B3 in core subjects', description: 'Premier science and technology university in Ghana.' },
  { id: 'ug-ug', name: 'University of Ghana (UG)', country: 'Ghana', type: 'public', programs: ['Law', 'Medicine', 'Business Administration', 'Political Science', 'Economics', 'Languages'], subjectRequirements: ['English Language', 'Mathematics (Core)', 'Social Studies (Core)'], minGrade: 'A1-B3', description: 'Ghana\'s oldest and largest university, strong in humanities and law.' },
  { id: 'ug-ucc', name: 'University of Cape Coast (UCC)', country: 'Ghana', type: 'public', programs: ['Education', 'Business', 'Sciences', 'Medicine', 'Agriculture'], subjectRequirements: ['English Language', 'Mathematics (Core)', 'Integrated Science (Core)'], minGrade: 'A1-C6', description: 'Leading teacher education and sciences university.' },
  { id: 'ug-umat', name: 'University of Mines and Technology (UMaT)', country: 'Ghana', type: 'public', programs: ['Mining Engineering', 'Geological Engineering', 'Petroleum Engineering', 'Computer Science'], subjectRequirements: ['Physics (Elective)', 'Chemistry (Elective)', 'Elective Mathematics'], minGrade: 'A1-B3', description: 'Specialized in mining and geological engineering.' },
  { id: 'ug-uew', name: 'University of Education, Winneba (UEW)', country: 'Ghana', type: 'public', programs: ['Education', 'Psychology', 'Languages', 'Sciences'], subjectRequirements: ['English Language', 'Mathematics (Core)'], minGrade: 'A1-C6', description: 'Specialized in teacher education.' },
  { id: 'ug-upsa', name: 'University of Professional Studies (UPSA)', country: 'Ghana', type: 'public', programs: ['Business Administration', 'Accounting', 'Marketing', 'Banking and Finance'], subjectRequirements: ['English Language', 'Mathematics (Core)', 'Economics (Elective)', 'Accounting (Elective)'], minGrade: 'A1-C6', description: 'Leading business and professional studies university.' },
  { id: 'ug-gimpa', name: 'Ghana Institute of Management and Public Administration (GIMPA)', country: 'Ghana', type: 'public', programs: ['Public Administration', 'Business Administration', 'Law', 'Governance'], subjectRequirements: ['English Language', 'Mathematics (Core)'], minGrade: 'A1-B3', description: 'Premier public administration and management institute.' },
  { id: 'ug-ashesi', name: 'Ashesi University', country: 'Ghana', type: 'private', programs: ['Computer Science', 'Business Administration', 'Engineering', 'Economics'], subjectRequirements: ['Mathematics (Core)', 'English Language', 'Elective Mathematics'], minGrade: 'A1-B3', description: 'Top private university known for leadership and ethics education.' },
  { id: 'ug-uds', name: 'University for Development Studies (UDS)', country: 'Ghana', type: 'public', programs: ['Medicine', 'Agriculture', 'Engineering', 'Development Studies'], subjectRequirements: ['English Language', 'Mathematics (Core)', 'Integrated Science (Core)'], minGrade: 'A1-C6', description: 'Focus on development studies and rural development.' },

  // International
  { id: 'int-oxford', name: 'University of Oxford', country: 'UK', type: 'public', programs: ['All subjects'], subjectRequirements: ['Excellent WASSCE scores (A1-A2)', 'English Language'], minGrade: 'A1-A2', description: 'World\'s top-ranked university. Requires exceptional academic record.' },
  { id: 'int-mit', name: 'Massachusetts Institute of Technology (MIT)', country: 'USA', type: 'private', programs: ['Engineering', 'Computer Science', 'Physics', 'Mathematics'], subjectRequirements: ['Physics (Elective)', 'Elective Mathematics', 'Chemistry (Elective)'], minGrade: 'A1', description: 'World\'s leading STEM university.' },
  { id: 'int-toronto', name: 'University of Toronto', country: 'Canada', type: 'public', programs: ['Engineering', 'Computer Science', 'Business', 'Sciences'], subjectRequirements: ['Mathematics (Core)', 'English Language'], minGrade: 'A1-B3', description: 'Top Canadian university with strong international programs.' },
  { id: 'int-uct', name: 'University of Cape Town', country: 'South Africa', type: 'public', programs: ['Medicine', 'Engineering', 'Law', 'Business'], subjectRequirements: ['Mathematics (Core)', 'English Language', 'Physics (Elective) or Chemistry (Elective)'], minGrade: 'A1-B3', description: 'Africa\'s top-ranked university.' },
  { id: 'int-melbourne', name: 'University of Melbourne', country: 'Australia', type: 'public', programs: ['Engineering', 'Medicine', 'Business', 'Sciences'], subjectRequirements: ['Mathematics (Core)', 'English Language'], minGrade: 'A1-B3', description: 'Top Australian university.' },
];

export const SCHOLARSHIPS: Scholarship[] = [
  { id: 'sch-mcf', name: 'Mastercard Foundation Scholars Program', provider: 'Mastercard Foundation', level: 'undergraduate', countries: ['Ghana', 'Kenya', 'South Africa', 'USA', 'UK'], eligibility: ['Academic excellence', 'Financial need', 'Leadership potential', 'Give-back commitment'], subjectRequirements: [], deadline: 'January-March annually', amount: 'Full scholarship (tuition, accommodation, books, stipend)', description: 'Comprehensive scholarship for academically talented young Africans with financial need.', url: 'https://mastercardfdn.org/scholars/' },
  { id: 'sch-chevening', name: 'Chevening Scholarship', provider: 'UK Government', level: 'masters', countries: ['UK'], eligibility: ['Bachelor\'s degree', '2+ years work experience', 'Leadership potential'], subjectRequirements: [], deadline: 'November annually', amount: 'Full masters tuition + living expenses', description: 'UK government\'s international awards scheme for future leaders.', url: 'https://www.chevening.org' },
  { id: 'sch-fulbright', name: 'Fulbright Foreign Student Program', provider: 'US Government', level: 'masters', countries: ['USA'], eligibility: ['Bachelor\'s degree', 'Academic excellence'], subjectRequirements: [], deadline: 'May annually', amount: 'Full masters tuition + living expenses', description: 'Enables graduate students to study in the USA.', url: 'https://foreign.fulbrightonline.org' },
  { id: 'sch-dfids', name: 'Commonwealth Scholarships', provider: 'UK Government', level: 'masters', countries: ['UK'], eligibility: ['Commonwealth citizen', 'Bachelor\'s degree'], subjectRequirements: [], deadline: 'October annually', amount: 'Full scholarship', description: 'For students from Commonwealth countries to study in the UK.', url: 'https://cscuk.fcdo.gov.uk' },
  { id: 'sch-german', name: 'DAAD Scholarship', provider: 'German Academic Exchange Service', level: 'masters', countries: ['Germany'], eligibility: ['Bachelor\'s degree', 'Academic excellence'], subjectRequirements: [], deadline: 'Varies by program', amount: 'Full scholarship + monthly stipend', description: 'Study in Germany with full funding.', url: 'https://www.daad.de' },
  { id: 'sch-australia', name: 'Australia Awards Africa', provider: 'Australian Government', level: 'masters', countries: ['Australia'], eligibility: ['African citizen', 'Bachelor\'s degree', 'Work experience'], subjectRequirements: [], deadline: 'December annually', amount: 'Full scholarship', description: 'Masters scholarships for African professionals.', url: 'https://www.australiaawardsafrica.org' },
  { id: 'sch-chinese', name: 'Chinese Government Scholarship', provider: 'Chinese Government', level: 'undergraduate', countries: ['China'], eligibility: ['Non-Chinese citizen', 'Academic excellence'], subjectRequirements: [], deadline: 'March annually', amount: 'Full scholarship + accommodation + stipend', description: 'Study in China with full government funding.', url: 'http://www.campuschina.org' },
  { id: 'sch-knust-internal', name: 'KNUST Internal Scholarships', provider: 'KNUST', level: 'undergraduate', countries: ['Ghana'], eligibility: ['Admission to KNUST', 'Academic merit', 'Financial need'], subjectRequirements: [], deadline: 'August annually', amount: 'Partial to full tuition', description: 'Various merit and need-based scholarships at KNUST.', url: 'https://www.knust.edu.gh' },
];

export const CAREER_PATHS: CareerPath[] = [
  { id: 'career-engineering', name: 'Engineering', category: 'STEM', subjects: ['Physics (Elective)', 'Elective Mathematics', 'Chemistry (Elective)'], description: 'Design, build, and maintain machines, structures, and systems.', universities: ['KNUST', 'UMaT', 'MIT', 'University of Toronto'], careers: ['Mechanical Engineer', 'Civil Engineer', 'Electrical Engineer', 'Software Engineer'], averageSalary: 'GHS 3,000-15,000/month' },
  { id: 'career-medicine', name: 'Medicine & Health', category: 'Healthcare', subjects: ['Chemistry (Elective)', 'Biology (Elective)', 'Physics (Elective)'], description: 'Diagnose, treat, and prevent illness and disease.', universities: ['UG', 'KNUST', 'UCC', 'University of Cape Town'], careers: ['Doctor', 'Surgeon', 'Pharmacist', 'Nurse', 'Public Health Specialist'], averageSalary: 'GHS 4,000-20,000/month' },
  { id: 'career-business', name: 'Business & Finance', category: 'Business', subjects: ['Economics (Elective)', 'Accounting (Elective)', 'Business Management (Elective)', 'Mathematics (Core)'], description: 'Manage organizations, finances, and investments.', universities: ['UPSA', 'UG', 'GIMPA', 'Ashesi', 'University of Melbourne'], careers: ['Accountant', 'Financial Analyst', 'Marketing Manager', 'Entrepreneur', 'Bank Manager'], averageSalary: 'GHS 2,500-12,000/month' },
  { id: 'career-law', name: 'Law', category: 'Humanities', subjects: ['English Language', 'Government (Elective)', 'History (Elective)'], description: 'Advise on legal matters and represent clients in court.', universities: ['UG', 'GIMPA', 'University of Oxford'], careers: ['Lawyer', 'Judge', 'Legal Advisor', 'Corporate Counsel'], averageSalary: 'GHS 3,000-15,000/month' },
  { id: 'career-computing', name: 'Computer Science & IT', category: 'STEM', subjects: ['Elective Mathematics', 'Mathematics (Core)', 'English Language'], description: 'Design software, build systems, and solve problems with technology.', universities: ['KNUST', 'Ashesi', 'MIT', 'University of Toronto'], careers: ['Software Developer', 'Data Scientist', 'IT Manager', 'Cybersecurity Specialist'], averageSalary: 'GHS 3,000-20,000/month' },
  { id: 'career-education', name: 'Education & Teaching', category: 'Education', subjects: ['English Language', 'Mathematics (Core)'], description: 'Teach and train the next generation.', universities: ['UCC', 'UEW', 'UDS'], careers: ['Teacher', 'Headmaster', 'Education Administrator', 'Curriculum Developer'], averageSalary: 'GHS 2,000-6,000/month' },
  { id: 'career-agriculture', name: 'Agriculture & Agribusiness', category: 'Sciences', subjects: ['Biology (Elective)', 'Chemistry (Elective)', 'Geography (Elective)'], description: 'Food production, farming, and agricultural business.', universities: ['UDS', 'UCC', 'KNUST'], careers: ['Agricultural Scientist', 'Farm Manager', 'Agribusiness Consultant', 'Food Technologist'], averageSalary: 'GHS 2,500-8,000/month' },
  { id: 'career-arts', name: 'Arts & Media', category: 'Arts', subjects: ['Literature in English', 'History (Elective)', 'Government (Elective)'], description: 'Creative expression through writing, media, and communication.', universities: ['UG', 'University of Cape Town', 'University of Melbourne'], careers: ['Journalist', 'Author', 'Broadcaster', 'Public Relations Officer', 'Content Creator'], averageSalary: 'GHS 2,000-10,000/month' },
];
