/**
 * GES / NaCCA Standards-Based Curriculum Data
 * Knowledge base for AI lesson plan generation.
 * Covers KG1–KG2, Basic 1–6, and JHS (Basic 7–9).
 */

// ── Types ──
export interface GESSubStrand {
  name: string;
  indicator: string;
  content: string;
}

export interface GESStrand {
  name: string;
  subStrands: GESSubStrand[];
}

export interface GESSubject {
  name: string;
  strands: GESStrand[];
}

export interface GESClassLevel {
  key: string;
  label: string;
  level: 'kg' | 'primary' | 'jhs' | 'shs';
  subjects: GESSubject[];
}

// ── Core Competencies ──
export const CORE_COMPETENCIES = [
  'Critical Thinking and Problem Solving (CP)',
  'Creativity and Innovation (CI)',
  'Communication and Collaboration (CC)',
  'Cultural Identity and Global Citizenship (CG)',
  'Personal Development and Leadership (PL)',
  'Digital Literacy (DL)',
];

// ── Lesson Plan Phases ──
export const LESSON_PHASES = {
  starter: {
    name: 'Phase 1: Starter (Introduction)',
    duration: '5–10 minutes',
    description:
      'Activate prior knowledge. Connect to previous lesson. Use games, discussions, songs (KG), or visual stimuli. Should NOT be extended lecture. Gives teacher diagnostic information about where learners are.',
  },
  main: {
    name: 'Phase 2: Main Body (Presentation & Practice)',
    duration: '15–25 minutes',
    description:
      'Introduce concept using varied media: demonstration, storytelling, visuals. Model the skill first, then gradually release responsibility. Guided Practice (15–20 min): Students work with teacher support. Independent/Group Practice: Students apply learning with peers or independently. Differentiate tasks for varied levels.',
  },
  plenary: {
    name: 'Phase 3: Plenary (Closure)',
    duration: '3–5 minutes',
    description:
      'Summarize key points. Students reflect on what they learned and next steps. Quick exit task or question. Tells teacher whether the lesson achieved its purpose.',
  },
};

// ── Assessment Types ──
export const ASSESSMENT_TYPES = [
  'Assessment for Learning (AfL) — formative, during lesson (oral questioning, observation)',
  'Assessment as Learning (AaL) — peer/self assessment',
  'Assessment of Learning (AoL) — summative, end of unit/term (written task, quiz, project)',
];

// ── TLMs by Subject ──
export const TLMS_BY_SUBJECT: Record<string, string[]> = {
  'English Language': ['Textbook', 'Flash cards', 'Picture charts', 'Word cards', 'Real objects', 'Story books', 'Whiteboard and markers', 'Phonics charts'],
  Mathematics: ['Counters', 'Number lines', 'Base-ten blocks', 'Place value charts', 'Geometric shapes', 'Ruler', 'Measuring tape', 'Worksheets', 'Whiteboard and markers'],
  Science: ['Real objects', 'Charts', 'Diagrams', 'Magnifying glass', 'Seeds', 'Leaves', 'Water', 'Soil samples', 'Charts of living things'],
  'Our World Our People': ['Pictures of family', 'Community charts', 'Map of Ghana', 'Posters', 'Cut-outs', 'Real objects from environment'],
  'Religious and Moral Education': ['Bible/Quran stories', 'Pictures of religious leaders', 'Moral story charts', 'Role-play props'],
  History: ['Map of Ghana', 'Pictures of historical figures', 'Timeline charts', 'Story books about Ghana'],
  'Ghanaian Language': ['Local language story books', 'Flash cards in local language', 'Picture charts', 'Real objects'],
  'Creative Arts': ['Crayons', 'Coloured pencils', 'Paper', 'Clay', 'Local craft materials', 'Drawing books', 'Musical instruments (local)'],
  'Physical Education': ['Balls', 'Skipping ropes', 'Cones', 'Whistle', 'Open field', 'Mats'],
  Computing: ['Computer/laptop', 'Projector', 'Keyboard chart', 'Mouse', 'Printed screenshots', 'Internet (if available)'],
  'Social Studies': ['Map of Ghana', 'Globe', 'Charts of governance', 'Pictures of leaders', 'Newspaper clippings'],
  'Career Technology': ['Tools (hammer, saw, sewing machine)', 'Materials (wood, fabric, food items)', 'Safety gear', 'Charts of processes'],
  'Creative Arts and Design': ['Drawing materials', 'Paint', 'Brushes', 'Clay', 'Fabric', 'Recycled materials', 'Design charts'],
  // SHS subjects (note: 'English Language' TLM above covers both basic and SHS)
  'Mathematics (Core)': ['Scientific calculator', 'Graph book', 'Mathematical set', 'Textbook', 'Past WASSCE questions', 'Whiteboard and markers', 'Worksheets'],
  'Integrated Science (Core)': ['Textbook', 'Laboratory equipment', 'Charts and diagrams', 'Specimens', 'Microscope', 'Chemicals and reagents', 'Past WASSCE questions'],
  'Social Studies (Core)': ['Textbook', 'Map of Ghana', 'Constitution of Ghana', 'Newspapers', 'Charts', 'Past WASSCE questions', 'Documentaries'],
  'Information and Communication Technology (Core)': ['Computers/laptops', 'Projector', 'Internet access', 'Software (Office suite)', 'Textbook', 'Storage devices', 'Past WASSCE questions'],
  'Physics (Elective)': ['Textbook', 'Laboratory apparatus', 'Circuit boards', 'Multimeters', 'Weights and pulleys', 'Lenses and mirrors', 'Scientific calculator', 'Past WASSCE questions'],
  'Chemistry (Elective)': ['Textbook', 'Laboratory apparatus', 'Chemicals and reagents', 'Periodic table chart', 'Molecular model kits', 'pH meters and indicators', 'Past WASSCE questions'],
  'Biology (Elective)': ['Textbook', 'Microscope', 'Slides and cover slips', 'Specimens (plants and animals)', 'Charts and models', 'Dissection kits', 'Past WASSCE questions'],
  'Economics (Elective)': ['Textbook', 'Economic journals', 'Graph paper', 'Calculator', 'Newspapers', 'Past WASSCE questions', 'Statistical data'],
  'Government (Elective)': ['Textbook', 'Constitution of Ghana', 'Political maps', 'Newspapers', 'Documentaries', 'Past WASSCE questions', 'Charts of government structure'],
  'Literature in English (Elective)': ['Set texts (prose, poetry, drama)', 'Textbook', 'Literary handbooks', 'Dictionaries', 'Past WASSCE questions', 'Notebooks for analysis'],
  'Geography (Elective)': ['Textbook', 'Topographical maps', 'Atlas', 'Globe', 'Graph paper', 'Geographical instruments', 'Past WASSCE questions'],
  'Accounting (Elective)': ['Textbook', 'Calculator', 'Ledger paper', 'Past WASSCE questions', 'Spreadsheet software', 'Sample financial statements', 'Worksheets'],
  'Business Management (Elective)': ['Textbook', 'Case studies', 'Business journals', 'Past WASSCE questions', 'Charts', 'Sample business plans'],
  'History (Elective)': ['Textbook', 'Historical maps', 'Timelines', 'Documentaries', 'Primary source documents', 'Past WASSCE questions', 'Charts'],
  'French (Elective)': ['Textbook', 'French dictionaries', 'Audio recordings', 'French literature', 'Flash cards', 'Past WASSCE questions', 'French newspapers/magazines'],
  'Elective Mathematics': ['Scientific calculator', 'Graph book', 'Mathematical set', 'Textbook', 'Past WASSCE questions', 'Whiteboard and markers', 'Worksheets'],
  'Physical Education (Core)': ['Sports equipment (balls, bats, rackets)', 'Stopwatch', 'Whistle', 'Measuring tape', 'First aid kit', 'Open field/court', 'Charts of rules'],
};

// ── Class Levels with Subjects and Strands ──
export const GES_CURRICULUM: GESClassLevel[] = [
  // ── KG 1 ──
  {
    key: 'kg1',
    label: 'KG 1',
    level: 'kg',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Pre-Reading Activities', indicator: 'K1.1.1.1.1', content: 'Listening to sounds, rhymes, and simple stories. Identifying environmental sounds.' },
              { name: 'Songs and Rhymes', indicator: 'K1.1.1.2.1', content: 'Singing familiar songs and rhymes. Clapping to rhythm.' },
              { name: 'Story Telling', indicator: 'K1.1.1.3.1', content: 'Listening to and retelling simple stories. Answering questions about stories.' },
              { name: 'Conversation', indicator: 'K1.1.1.4.1', content: 'Engaging in simple conversations about familiar topics. Expressing needs and feelings.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Pre-Writing', indicator: 'K1.1.2.1.1', content: 'Scribbling, drawing, tracing lines and shapes. Developing pencil grip.' },
              { name: 'Phonics', indicator: 'K1.1.2.2.1', content: 'Recognising letter sounds a-z. Matching sounds to pictures.' },
              { name: 'Penmanship', indicator: 'K1.1.2.3.1', content: 'Tracing and writing letters of the alphabet. Forming letters correctly.' },
              { name: 'Writing Letters', indicator: 'K1.1.2.4.1', content: 'Writing capital and small letters. Copying own name.' },
            ],
          },
          {
            name: 'Building Reading Culture',
            subStrands: [
              { name: 'Love for Reading', indicator: 'K1.1.3.1.1', content: 'Handling books with care. Enjoying picture books. Visiting the reading corner.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Counting', indicator: 'K1.2.1.1.1', content: 'Rote counting 1–20. Counting objects up to 10. Matching quantity to number.' },
              { name: 'Representation', indicator: 'K1.2.1.2.1', content: 'Representing numbers using fingers, objects, and marks.' },
              { name: 'Cardinality and Ordinality', indicator: 'K1.2.1.3.1', content: 'Understanding that the last number counted is the total. First, second, third.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: '2D and 3D Shapes', indicator: 'K1.2.2.1.1', content: 'Recognising circle, square, triangle, rectangle. Sorting shapes.' },
            ],
          },
        ],
      },
      {
        name: 'Our World Our People',
        strands: [
          {
            name: 'All About Me',
            subStrands: [
              { name: 'I Am a Wonderful and Unique Creation', indicator: 'K1.3.1.1.1', content: 'Identifying body parts. Appreciating oneself as a unique person.' },
              { name: 'Parts of the Human Body and Their Functions', indicator: 'K1.3.1.2.1', content: 'Naming body parts (head, eyes, nose, mouth, ears, hands, legs). Functions of each part.' },
              { name: 'Caring for the Parts of My Body', indicator: 'K1.3.1.3.1', content: 'Washing hands, brushing teeth, bathing, keeping nails clean.' },
              { name: 'Keeping My Body Healthy', indicator: 'K1.3.1.4.1', content: 'Eating good food, taking vaccination, exercising, sleeping early.' },
              { name: 'My Environment and My Health', indicator: 'K1.3.1.5.1', content: 'Keeping surroundings clean. Disposing of rubbish properly.' },
              { name: 'Protecting from Accidents', indicator: 'K1.3.1.6.1', content: 'Home safety, road safety, avoiding dangerous objects.' },
            ],
          },
          {
            name: 'My Family',
            subStrands: [
              { name: 'Types and Members of My Family', indicator: 'K1.3.2.1.1', content: 'Nuclear and extended family. Naming family members.' },
              { name: 'Origin and History of My Family', indicator: 'K1.3.2.2.1', content: 'Family name, where family comes from, family traditions.' },
              { name: 'Family Celebrations', indicator: 'K1.3.2.3.1', content: 'Birthdays, festivals, religious celebrations.' },
              { name: 'My School Rules', indicator: 'K1.3.2.4.1', content: 'School rules and regulations. Why we follow rules.' },
            ],
          },
        ],
      },
      {
        name: 'Creative Arts',
        strands: [
          {
            name: 'Visual Arts',
            subStrands: [
              { name: 'Drawing and Colouring', indicator: 'K1.4.1.1.1', content: 'Free drawing, colouring shapes, finger painting.' },
            ],
          },
          {
            name: 'Performing Arts',
            subStrands: [
              { name: 'Singing and Movement', indicator: 'K1.4.2.1.1', content: 'Action songs, dance movements, clapping games.' },
            ],
          },
        ],
      },
    ],
  },

  // ── KG 2 ──
  {
    key: 'kg2',
    label: 'KG 2',
    level: 'kg',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Pre-Reading Activities', indicator: 'K2.1.1.1.1', content: 'Listening attentively. Following simple instructions. Identifying beginning sounds.' },
              { name: 'Story Telling', indicator: 'K2.1.1.2.1', content: 'Retelling stories in sequence. Answering "who, what, where" questions.' },
              { name: 'Conversation', indicator: 'K2.1.1.3.1', content: 'Expressing ideas in simple sentences. Taking turns in conversation.' },
              { name: 'Dramatisation and Role-Play', indicator: 'K2.1.1.4.1', content: 'Acting out stories. Role-playing community helpers.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Phonics', indicator: 'K2.1.2.1.1', content: 'Blending sounds to make words. Segmenting words into sounds. CVC words (cat, dog, sit).' },
              { name: 'Word Families', indicator: 'K2.1.2.2.1', content: 'Rhyming words (cat/hat/mat). Common digraphs (ch, sh, th).' },
              { name: 'Writing Letters and Words', indicator: 'K2.1.2.3.1', content: 'Writing all letters correctly. Writing own name and simple words.' },
              { name: 'Labelling Items', indicator: 'K2.1.2.4.1', content: 'Labelling classroom objects. Writing simple captions for pictures.' },
            ],
          },
          {
            name: 'Comprehension',
            subStrands: [
              { name: 'Listening Comprehension', indicator: 'K2.1.3.1.1', content: 'Understanding stories read aloud. Answering questions about stories.' },
              { name: 'Reading Comprehension', indicator: 'K2.1.3.2.1', content: 'Reading simple sentences. Matching pictures to sentences.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Counting and Cardinality', indicator: 'K2.2.1.1.1', content: 'Counting 1–50. Counting objects up to 20. One-to-one correspondence.' },
              { name: 'Number Operations', indicator: 'K2.2.1.2.1', content: 'Simple addition (within 10) using objects. Simple subtraction (within 10) using objects.' },
            ],
          },
          {
            name: 'Geometry and Measurement',
            subStrands: [
              { name: '2D and 3D Shapes', indicator: 'K2.2.2.1.1', content: 'Identifying sphere, cube, cone. Sorting 3D shapes. Making patterns with shapes.' },
              { name: 'Measurement', indicator: 'K2.2.2.2.1', content: 'Comparing length (long/short), height (tall/short), weight (heavy/light).' },
            ],
          },
        ],
      },
      {
        name: 'Our World Our People',
        strands: [
          {
            name: 'My Community',
            subStrands: [
              { name: 'Special Places in My Community', indicator: 'K2.3.1.1.1', content: 'Church, mosque, market, hospital, school, police station. Their importance.' },
              { name: 'Important People in My Community', indicator: 'K2.3.1.2.1', content: 'Community helpers: teacher, doctor, nurse, police, fire fighter, farmer.' },
              { name: 'Special Leaders', indicator: 'K2.3.1.3.1', content: 'Chief, assembly member, headteacher, pastor, imam.' },
            ],
          },
          {
            name: 'Ghana My Country',
            subStrands: [
              { name: "Ghana's Independence", indicator: 'K2.3.2.1.1', content: 'Independence Day celebration. National symbols (flag, anthem, crest).' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 1 ──
  {
    key: 'basic1',
    label: 'Basic 1',
    level: 'primary',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Songs and Rhymes', indicator: 'B1.1.1.1.1', content: 'Learning new songs and rhymes. Identifying rhyming words.' },
              { name: 'Story Telling', indicator: 'B1.1.1.2.1', content: 'Listening to stories. Retelling stories in sequence. Identifying characters and setting.' },
              { name: 'Conversation', indicator: 'B1.1.1.3.1', content: 'Expressing ideas clearly. Asking and answering questions. Taking turns.' },
              { name: 'Dramatisation and Role-Play', indicator: 'B1.1.1.4.1', content: 'Acting out stories. Role-playing real-life situations.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Phonics', indicator: 'B1.1.2.1.1', content: 'Letter sounds a–z. Blending sounds to read CVC words. Segmenting words into sounds.' },
              { name: 'Word Families', indicator: 'B1.1.2.2.1', content: 'Rhyming endings (-at, -an, -ig). Common digraphs (ch, sh, th, ng).' },
              { name: 'Penmanship', indicator: 'B1.1.2.3.1', content: 'Correct letter formation. Writing on lines. Proper spacing.' },
              { name: 'Writing Letters and Words', indicator: 'B1.1.2.4.1', content: 'Writing capital and small letters. Writing own name and common words.' },
              { name: 'Writing Simple Sentences', indicator: 'B1.1.2.5.1', content: 'Writing 2–3 word sentences. Using capital letter and full stop.' },
              { name: 'Labelling Items', indicator: 'B1.1.2.6.1', content: 'Labelling pictures. Writing captions. Using qualifying words (adjectives).' },
            ],
          },
          {
            name: 'Comprehension',
            subStrands: [
              { name: 'Listening Comprehension', indicator: 'B1.1.3.1.1', content: 'Understanding stories read aloud. Answering who/what/where questions.' },
              { name: 'Reading Comprehension', indicator: 'B1.1.3.2.1', content: 'Reading simple passages. Answering questions from passage.' },
            ],
          },
          {
            name: 'Grammar',
            subStrands: [
              { name: 'Using Capitalisation', indicator: 'B1.1.4.1.1', content: 'Capital letter at beginning of sentence. Capital for names of people and places.' },
              { name: 'Using Action Words', indicator: 'B1.1.4.2.1', content: 'Identifying and using verbs (run, jump, eat, write).' },
              { name: 'Using Qualifying Words (Adjectives)', indicator: 'B1.1.4.3.1', content: 'Describing nouns (big, small, red, happy).' },
              { name: 'Using Simple Prepositions', indicator: 'B1.1.4.4.1', content: 'in, on, under, beside, behind, above.' },
            ],
          },
          {
            name: 'Building Reading Culture',
            subStrands: [
              { name: 'Love and Culture of Reading', indicator: 'B1.1.5.1.1', content: 'Visiting library/reading corner. Sharing books with friends. Choosing books independently.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Counting, Representation, Cardinality & Ordinality', indicator: 'B1.2.1.1.1', content: 'Counting 1–100. Reading and writing numbers. Place value (tens and units). Ordinal numbers (1st–10th).' },
            ],
          },
          {
            name: 'Number Operations',
            subStrands: [
              { name: 'Addition', indicator: 'B1.2.2.1.1', content: 'Addition within 20 using objects and number line. Word problems involving addition.' },
              { name: 'Subtraction', indicator: 'B1.2.2.2.1', content: 'Subtraction within 20 using objects and number line. Word problems involving subtraction.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: '2D and 3D Shapes', indicator: 'B1.2.3.1.1', content: 'Identifying and naming shapes (circle, square, triangle, rectangle, sphere, cube). Properties of shapes.' },
            ],
          },
          {
            name: 'Measurement',
            subStrands: [
              { name: 'Length, Mass, Capacity and Time', indicator: 'B1.2.4.1.1', content: 'Measuring length (non-standard units). Comparing mass. Telling time (o\'clock). Days of the week.' },
            ],
          },
          {
            name: 'Data',
            subStrands: [
              { name: 'Data Collection, Organisation, Presentation and Interpretation', indicator: 'B1.2.5.1.1', content: 'Collecting data. Making tally charts. Pictographs with 1:1 correspondence.' },
            ],
          },
        ],
      },
      {
        name: 'Science',
        strands: [
          {
            name: 'Living Things',
            subStrands: [
              { name: 'Living and Non-Living Things', indicator: 'B1.3.1.1.1', content: 'Identifying living things (plants, animals) and non-living things (stones, water). Characteristics of living things.' },
            ],
          },
          {
            name: 'Matter',
            subStrands: [
              { name: 'Properties of Matter', indicator: 'B1.3.2.1.1', content: 'Solids, liquids, gases. Properties of materials (hard, soft, rough, smooth).' },
            ],
          },
          {
            name: 'Environment',
            subStrands: [
              { name: 'Our Environment', indicator: 'B1.3.3.1.1', content: 'Things in the environment. Keeping the environment clean. Plants and animals around us.' },
            ],
          },
        ],
      },
      {
        name: 'Our World Our People',
        strands: [
          {
            name: 'Myself',
            subStrands: [
              { name: 'Knowing Myself', indicator: 'B1.4.1.1.1', content: 'My name, age, gender, family. Things I can do. My likes and dislikes.' },
              { name: 'My Body', indicator: 'B1.4.1.2.1', content: 'External body parts and their functions. Keeping my body clean.' },
            ],
          },
          {
            name: 'My Family',
            subStrands: [
              { name: 'Family Members', indicator: 'B1.4.2.1.1', content: 'Nuclear and extended family. Roles of family members. Family tree.' },
              { name: 'Family Values', indicator: 'B1.4.2.2.1', content: 'Respect, honesty, obedience, love. Family traditions and celebrations.' },
            ],
          },
          {
            name: 'My School',
            subStrands: [
              { name: 'School Community', indicator: 'B1.4.3.1.1', content: 'People in my school. School rules. My classroom.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'God, His Creation and Attributes',
            subStrands: [
              { name: 'Creation Story', indicator: 'B1.5.1.1.1', content: 'God created the world. God created people. Thanking God for creation.' },
            ],
          },
          {
            name: 'Moral Values',
            subStrands: [
              { name: 'Respect and Obedience', indicator: 'B1.5.2.1.1', content: 'Respecting parents and elders. Obeying rules. Consequences of disobedience.' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 2 ──
  {
    key: 'basic2',
    label: 'Basic 2',
    level: 'primary',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Conversation', indicator: 'B2.1.1.1.1', content: 'Asking and answering questions. Expressing opinions. Describing events.' },
              { name: 'Story Telling', indicator: 'B2.1.1.2.1', content: 'Retelling stories with details. Identifying main idea. Sequencing events.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Phonics', indicator: 'B2.1.2.1.1', content: 'Long vowel sounds. Vowel teams (ai, ea, oa). Consonant blends (bl, cr, st).' },
              { name: 'Vocabulary', indicator: 'B2.1.2.2.1', content: 'New words from stories. Word meanings. Using words in sentences.' },
              { name: 'Writing Simple Words and Sentences', indicator: 'B2.1.2.3.1', content: 'Writing 3–5 word sentences. Using describing words. Punctuation (full stop, question mark).' },
              { name: 'Controlled Writing', indicator: 'B2.1.2.4.1', content: 'Copying short passages. Completing sentences. Rearranging words to make sentences.' },
            ],
          },
          {
            name: 'Comprehension',
            subStrands: [
              { name: 'Listening Comprehension', indicator: 'B2.1.3.1.1', content: 'Following multi-step instructions. Understanding main idea of a story.' },
              { name: 'Reading Comprehension', indicator: 'B2.1.3.2.1', content: 'Reading short passages. Answering literal and inferential questions.' },
            ],
          },
          {
            name: 'Grammar',
            subStrands: [
              { name: 'Using Capitalisation', indicator: 'B2.1.4.1.1', content: 'Capital for days, months, holidays. Review of sentence capitals.' },
              { name: 'Using Action Words', indicator: 'B2.1.4.2.1', content: 'Regular and irregular verbs. Present and past tense.' },
              { name: 'Using Simple Prepositions', indicator: 'B2.1.4.3.1', content: 'Prepositions of place and time. Using prepositions in sentences.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Counting, Representation, Cardinality & Ordinality', indicator: 'B2.2.1.1.1', content: 'Counting 1–200. Place value (hundreds, tens, units). Even and odd numbers.' },
            ],
          },
          {
            name: 'Number Operations',
            subStrands: [
              { name: 'Addition', indicator: 'B2.2.2.1.1', content: 'Addition within 100 (with and without regrouping). Word problems.' },
              { name: 'Subtraction', indicator: 'B2.2.2.2.1', content: 'Subtraction within 100 (with and without regrouping). Word problems.' },
              { name: 'Multiplication', indicator: 'B2.2.2.3.1', content: 'Multiplication as repeated addition. Times 2, 5, 10.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: '2D and 3D Shapes', indicator: 'B2.2.3.1.1', content: 'Properties of 2D shapes (sides, corners). Sorting shapes. Symmetry.' },
            ],
          },
          {
            name: 'Measurement',
            subStrands: [
              { name: 'Length, Mass, Capacity and Time', indicator: 'B2.2.4.1.1', content: 'Standard units (cm, m). Measuring mass (kg). Telling time (half past). Months of the year.' },
            ],
          },
        ],
      },
      {
        name: 'Science',
        strands: [
          {
            name: 'Living Things',
            subStrands: [
              { name: 'Animals', indicator: 'B2.3.1.1.1', content: 'Classification of animals (mammals, birds, fish, insects). Animal habitats. Animal needs.' },
            ],
          },
          {
            name: 'Matter',
            subStrands: [
              { name: 'Changes in Matter', indicator: 'B2.3.2.1.1', content: 'Melting, freezing, evaporation. Reversible and irreversible changes.' },
            ],
          },
        ],
      },
      {
        name: 'Our World Our People',
        strands: [
          {
            name: 'My Community',
            subStrands: [
              { name: 'People in My Community', indicator: 'B2.4.1.1.1', content: 'Community helpers and their roles. How community helpers help us. Respecting community helpers.' },
              { name: 'Places in My Community', indicator: 'B2.4.1.2.1', content: 'Important places (market, hospital, school, church). Their functions.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'God, His Creation and Attributes',
            subStrands: [
              { name: 'God\'s Care', indicator: 'B2.5.1.1.1', content: 'How God cares for us. Thanking God through prayer and songs.' },
            ],
          },
          {
            name: 'Moral Values',
            subStrands: [
              { name: 'Honesty and Truthfulness', indicator: 'B2.5.2.1.1', content: 'Telling the truth. Keeping promises. Consequences of lying.' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 3 ──
  {
    key: 'basic3',
    label: 'Basic 3',
    level: 'primary',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Conversation', indicator: 'B3.1.1.1.1', content: 'Describing experiences. Giving directions. Expressing opinions with reasons.' },
              { name: 'Dramatisation and Role-Play', indicator: 'B3.1.1.2.1', content: 'Acting out stories with dialogue. Creating short skits.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Phonics', indicator: 'B3.1.2.1.1', content: 'Diphthongs (oi, oy, ou, ow). Silent letters (k, w, b). Syllable division.' },
              { name: 'Vocabulary', indicator: 'B3.1.2.2.1', content: 'Synonyms, antonyms. Homophones. Using context clues.' },
              { name: 'Writing Simple Words and Sentences', indicator: 'B3.1.2.3.1', content: 'Writing 5–7 word sentences. Using conjunctions (and, but, because).' },
              { name: 'Controlled Writing', indicator: 'B3.1.2.4.1', content: 'Writing short paragraphs. Completing story frames. Rearranging jumbled sentences.' },
            ],
          },
          {
            name: 'Comprehension',
            subStrands: [
              { name: 'Listening Comprehension', indicator: 'B3.1.3.1.1', content: 'Note-taking from oral presentations. Summarising stories.' },
              { name: 'Reading Comprehension', indicator: 'B3.1.3.2.1', content: 'Reading longer passages. Identifying main idea and details. Making predictions.' },
            ],
          },
          {
            name: 'Grammar',
            subStrands: [
              { name: 'Asking and Answering Questions', indicator: 'B3.1.4.1.1', content: 'Wh-questions (who, what, where, when, why, how). Yes/no questions.' },
              { name: 'Using Action Words', indicator: 'B3.1.4.2.1', content: 'Verb tenses (present, past, future). Subject-verb agreement.' },
              { name: 'Using Simple Prepositions', indicator: 'B3.1.4.3.1', content: 'Prepositions of movement (to, from, into, out of).' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Counting, Representation, Cardinality & Ordinality', indicator: 'B3.2.1.1.1', content: 'Counting 1–1000. Place value (thousands, hundreds, tens, units). Rounding to nearest 10 and 100.' },
            ],
          },
          {
            name: 'Number Operations',
            subStrands: [
              { name: 'Addition', indicator: 'B3.2.2.1.1', content: 'Addition within 1000 (with regrouping). Mental addition strategies.' },
              { name: 'Subtraction', indicator: 'B3.2.2.2.1', content: 'Subtraction within 1000 (with regrouping). Mental subtraction strategies.' },
              { name: 'Multiplication', indicator: 'B3.2.2.3.1', content: 'Times tables 2–10. Multiplying 2-digit by 1-digit. Word problems.' },
              { name: 'Division', indicator: 'B3.2.2.4.1', content: 'Division as sharing. Division facts for 2, 5, 10. Word problems.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: '2D and 3D Shapes', indicator: 'B3.2.3.1.1', content: 'Angles (right, acute, obtuse). Lines of symmetry. Making shapes.' },
            ],
          },
          {
            name: 'Measurement',
            subStrands: [
              { name: 'Length, Mass, Capacity and Time', indicator: 'B3.2.4.1.1', content: 'Perimeter of shapes. Mass in kg and g. Capacity in litres. Time to 5 minutes.' },
            ],
          },
          {
            name: 'Data',
            subStrands: [
              { name: 'Data Collection and Interpretation', indicator: 'B3.2.5.1.1', content: 'Bar charts. Pictographs with scales. Interpreting data.' },
            ],
          },
        ],
      },
      {
        name: 'Science',
        strands: [
          {
            name: 'Living Things',
            subStrands: [
              { name: 'Plants', indicator: 'B3.3.1.1.1', content: 'Parts of a plant (roots, stem, leaves, flowers). Functions of plant parts. Types of plants.' },
            ],
          },
          {
            name: 'Matter',
            subStrands: [
              { name: 'States of Matter', indicator: 'B3.3.2.1.1', content: 'Solids, liquids, gases — properties. Changing states. Water cycle.' },
            ],
          },
          {
            name: 'Forces and Energy',
            subStrands: [
              { name: 'Push and Pull', indicator: 'B3.3.3.1.1', content: 'Forces (push, pull). Effects of forces. Friction.' },
            ],
          },
        ],
      },
      {
        name: 'Our World Our People',
        strands: [
          {
            name: 'Our Environment',
            subStrands: [
              { name: 'Environmental Protection', indicator: 'B3.4.1.1.1', content: 'Keeping environment clean. Recycling. Deforestation and its effects.' },
              { name: 'Natural Resources', indicator: 'B3.4.1.2.1', content: 'Water, soil, minerals, forests. Conserving natural resources.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'Religious Practices',
            subStrands: [
              { name: 'Prayer and Worship', indicator: 'B3.5.1.1.1', content: 'Types of prayer. Places of worship. Religious festivals.' },
            ],
          },
          {
            name: 'Moral Values',
            subStrands: [
              { name: 'Compassion and Kindness', indicator: 'B3.5.2.1.1', content: 'Helping others. Sharing with friends. Showing kindness.' },
            ],
          },
        ],
      },
      {
        name: 'History',
        strands: [
          {
            name: 'Ghana, Our Country',
            subStrands: [
              { name: 'Introduction to History', indicator: 'B3.6.1.1.1', content: 'What is history? Sources of history (oral, written, material). Family history.' },
              { name: 'National Symbols', indicator: 'B3.6.1.2.1', content: 'Flag, anthem, crest, currency. Meaning of national symbols.' },
            ],
          },
        ],
      },
      {
        name: 'Creative Arts',
        strands: [
          {
            name: 'Visual Arts',
            subStrands: [
              { name: 'Drawing and Painting', indicator: 'B3.7.1.1.1', content: 'Drawing from observation. Colour mixing. Making greeting cards.' },
            ],
          },
          {
            name: 'Performing Arts',
            subStrands: [
              { name: 'Music and Dance', indicator: 'B3.7.2.1.1', content: 'Singing in groups. Clapping patterns. Traditional dances.' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 4 ──
  {
    key: 'basic4',
    label: 'Basic 4',
    level: 'primary',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Conversation', indicator: 'B4.1.1.1.1', content: 'Debating simple topics. Giving presentations. Interviewing classmates.' },
              { name: 'Dramatisation and Role-Play', indicator: 'B4.1.1.2.1', content: 'Creating and performing short plays. Character development.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Vocabulary', indicator: 'B4.1.2.1.1', content: 'Prefixes (un-, re-, dis-). Suffixes (-ful, -less, -ly). Idioms.' },
              { name: 'Writing Simple Words and Sentences', indicator: 'B4.1.2.2.1', content: 'Writing compound sentences. Using linking words (however, therefore).' },
              { name: 'Controlled Writing', indicator: 'B4.1.2.3.1', content: 'Writing descriptive paragraphs. Letter writing (informal). Story writing.' },
              { name: 'Descriptive Writing', indicator: 'B4.1.2.4.1', content: 'Using sensory details. Describing people, places, events.' },
            ],
          },
          {
            name: 'Comprehension',
            subStrands: [
              { name: 'Reading Comprehension', indicator: 'B4.1.3.1.1', content: 'Reading for detail. Inferencing. Cause and effect. Author\'s purpose.' },
              { name: 'Fluency', indicator: 'B4.1.3.2.1', content: 'Reading with expression. Reading rate. Pausing at punctuation.' },
            ],
          },
          {
            name: 'Grammar',
            subStrands: [
              { name: 'Giving and Responding to Commands', indicator: 'B4.1.4.1.1', content: 'Imperative sentences. Polite requests. Following and giving instructions.' },
              { name: 'Using Simple Prepositions', indicator: 'B4.1.4.2.1', content: 'Complex prepositions (between, among, through, throughout).' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Whole Numbers', indicator: 'B4.2.1.1.1', content: 'Numbers up to 10,000. Place value to 10,000. Rounding to nearest 1000.' },
              { name: 'Fractions', indicator: 'B4.2.1.2.1', content: 'Proper and improper fractions. Equivalent fractions. Comparing fractions.' },
              { name: 'Decimals', indicator: 'B4.2.1.3.1', content: 'Decimals to 2 places. Place value of decimals. Converting fractions to decimals.' },
            ],
          },
          {
            name: 'Number Operations',
            subStrands: [
              { name: 'Addition and Subtraction', indicator: 'B4.2.2.1.1', content: 'Addition and subtraction of 4-digit numbers. Word problems.' },
              { name: 'Multiplication', indicator: 'B4.2.2.2.1', content: 'Multiplying 2-digit by 2-digit. Times tables to 12. Word problems.' },
              { name: 'Division', indicator: 'B4.2.2.3.1', content: 'Division with remainders. Long division (2-digit by 1-digit).' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: '2D and 3D Shapes', indicator: 'B4.2.3.1.1', content: 'Properties of 3D shapes (faces, edges, vertices). Nets of shapes.' },
            ],
          },
          {
            name: 'Measurement',
            subStrands: [
              { name: 'Length, Mass, Capacity and Time', indicator: 'B4.2.4.1.1', content: 'Area of rectangles. Volume of cuboids. Time duration. Money (cedi and pesewa).' },
            ],
          },
        ],
      },
      {
        name: 'Science',
        strands: [
          {
            name: 'Living Things',
            subStrands: [
              { name: 'The Human Body', indicator: 'B4.3.1.1.1', content: 'Skeletal system. Muscular system. Major organs and their functions.' },
              { name: 'Plants and Animals', indicator: 'B4.3.1.2.1', content: 'Life cycles of plants and animals. Adaptation. Food chains.' },
            ],
          },
          {
            name: 'Matter',
            subStrands: [
              { name: 'Properties and Changes', indicator: 'B4.3.2.1.1', content: 'Physical and chemical changes. Mixing and separating materials.' },
            ],
          },
          {
            name: 'Forces and Energy',
            subStrands: [
              { name: 'Light and Sound', indicator: 'B4.3.3.1.1', content: 'Sources of light. Shadows. Reflection. Sources of sound. How sound travels.' },
            ],
          },
        ],
      },
      {
        name: 'Our World Our People',
        strands: [
          {
            name: 'Governance and Citizenship',
            subStrands: [
              { name: 'Rights and Responsibilities', indicator: 'B4.4.1.1.1', content: 'Children\'s rights. Responsibilities at home, school, community.' },
              { name: 'Leadership', indicator: 'B4.4.1.2.1', content: 'Types of leaders. Qualities of a good leader. School and community leaders.' },
            ],
          },
        ],
      },
      {
        name: 'Computing',
        strands: [
          {
            name: 'Introduction to Computing',
            subStrands: [
              { name: 'Parts of a Computer', indicator: 'B4.5.1.1.1', content: 'Input devices (keyboard, mouse). Output devices (monitor, printer). Storage devices.' },
              { name: 'Using a Computer', indicator: 'B4.5.1.2.1', content: 'Starting and shutting down. Using a mouse. Basic keyboard skills.' },
            ],
          },
        ],
      },
      {
        name: 'History',
        strands: [
          {
            name: 'Ghana, Our Country',
            subStrands: [
              { name: 'Pre-Colonial Ghana', indicator: 'B4.6.1.1.1', content: 'Early settlers. Traditional governance. Kingdoms and empires in Ghana.' },
              { name: 'Colonial Era', indicator: 'B4.6.1.2.1', content: 'Arrival of Europeans. The trans-Atlantic slave trade. Colonial rule.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'Religious Practices',
            subStrands: [
              { name: 'Religious Books', indicator: 'B4.7.1.1.1', content: 'The Bible, Quran, and other sacred texts. Stories from sacred texts.' },
            ],
          },
          {
            name: 'Moral Values',
            subStrands: [
              { name: 'Justice and Fairness', indicator: 'B4.7.2.1.1', content: 'Treating others fairly. Sharing resources. Standing up for what is right.' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 5 ──
  {
    key: 'basic5',
    label: 'Basic 5',
    level: 'primary',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Presentation', indicator: 'B5.1.1.1.1', content: 'Oral presentations. Debating. Public speaking skills.' },
              { name: 'Conversation', indicator: 'B5.1.1.2.1', content: 'Group discussions. Interviewing. Reporting events.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Vocabulary', indicator: 'B5.1.2.1.1', content: 'Greek and Latin roots. Figurative language (simile, metaphor, personification).' },
              { name: 'Controlled Writing', indicator: 'B5.1.2.2.1', content: 'Narrative writing. Expository writing. Persuasive writing.' },
              { name: 'Descriptive Writing', indicator: 'B5.1.2.3.1', content: 'Using vivid descriptions. Show, don\'t tell. Building atmosphere.' },
            ],
          },
          {
            name: 'Comprehension',
            subStrands: [
              { name: 'Reading Comprehension', indicator: 'B5.1.3.1.1', content: 'Critical reading. Fact and opinion. Drawing conclusions.' },
              { name: 'Fluency', indicator: 'B5.1.3.2.1', content: 'Reading aloud with expression. Reader\'s theatre.' },
            ],
          },
          {
            name: 'Grammar',
            subStrands: [
              { name: 'Giving and Responding to Commands', indicator: 'B5.1.4.1.1', content: 'Complex instructions. Sequencing instructions. Safety instructions.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Whole Numbers', indicator: 'B5.2.1.1.1', content: 'Numbers up to 1,000,000. Place value. Negative numbers.' },
              { name: 'Fractions', indicator: 'B5.2.1.2.1', content: 'Addition and subtraction of fractions. Multiplying fractions. Dividing fractions.' },
              { name: 'Decimals and Percentages', indicator: 'B5.2.1.3.1', content: 'Decimal operations. Converting between fractions, decimals, percentages.' },
            ],
          },
          {
            name: 'Number Operations',
            subStrands: [
              { name: 'Four Operations', indicator: 'B5.2.2.1.1', content: 'Multi-step word problems. Order of operations (BODMAS). Estimation.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: '2D and 3D Shapes', indicator: 'B5.2.3.1.1', content: 'Coordinates. Translation and reflection. Angles on a line and at a point.' },
            ],
          },
          {
            name: 'Measurement',
            subStrands: [
              { name: 'Length, Mass, Capacity and Time', indicator: 'B5.2.4.1.1', content: 'Area of triangles. Volume of cuboids. Speed, distance, time.' },
            ],
          },
          {
            name: 'Data',
            subStrands: [
              { name: 'Data and Probability', indicator: 'B5.2.5.1.1', content: 'Line graphs. Mean, median, mode. Simple probability.' },
            ],
          },
        ],
      },
      {
        name: 'Science',
        strands: [
          {
            name: 'Living Things',
            subStrands: [
              { name: 'Human Body Systems', indicator: 'B5.3.1.1.1', content: 'Circulatory system. Respiratory system. Digestive system. Nervous system.' },
              { name: 'Reproduction in Plants', indicator: 'B5.3.1.2.1', content: 'Flower parts and functions. Pollination. Seed dispersal. Germination.' },
            ],
          },
          {
            name: 'Matter',
            subStrands: [
              { name: 'Materials and Their Uses', indicator: 'B5.3.2.1.1', content: 'Metals, plastics, ceramics, glass. Properties and uses. Recycling.' },
            ],
          },
          {
            name: 'Forces and Energy',
            subStrands: [
              { name: 'Electricity and Magnetism', indicator: 'B5.3.3.1.1', content: 'Simple circuits. Conductors and insulators. Magnets and their properties.' },
            ],
          },
        ],
      },
      {
        name: 'Our World Our People',
        strands: [
          {
            name: 'Governance and Citizenship',
            subStrands: [
              { name: 'Government of Ghana', indicator: 'B5.4.1.1.1', content: 'Three arms of government (Executive, Legislature, Judiciary). Constitution of Ghana.' },
              { name: 'Democracy', indicator: 'B5.4.1.2.1', content: 'Elections. Voting. Rights and responsibilities of citizens.' },
            ],
          },
        ],
      },
      {
        name: 'Computing',
        strands: [
          {
            name: 'Computer Applications',
            subStrands: [
              { name: 'Word Processing', indicator: 'B5.5.1.1.1', content: 'Typing and formatting text. Saving and opening documents. Printing.' },
              { name: 'Internet Safety', indicator: 'B5.5.1.2.1', content: 'Safe browsing. Personal information online. Cyberbullying.' },
            ],
          },
        ],
      },
      {
        name: 'History',
        strands: [
          {
            name: 'Ghana, Our Country',
            subStrands: [
              { name: 'Road to Independence', indicator: 'B5.6.1.1.1', content: 'Nationalist movements. Key figures (Nkrumah, Danquah, Obetsebi-Lamptey). Independence in 1957.' },
              { name: 'Post-Independence Ghana', indicator: 'B5.6.1.2.1', content: 'First Republic. Military coups. Fourth Republic. Democratic governance.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'Religious Leaders',
            subStrands: [
              { name: 'Prophets and Leaders', indicator: 'B5.7.1.1.1', content: 'Key figures in Christianity, Islam, and Traditional religion. Lessons from their lives.' },
            ],
          },
          {
            name: 'Moral Values',
            subStrands: [
              { name: 'Integrity and Patriotism', indicator: 'B5.7.2.1.1', content: 'Being truthful. Loving one\'s country. National service. Civic duty.' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 6 ──
  {
    key: 'basic6',
    label: 'Basic 6',
    level: 'primary',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Presentation', indicator: 'B6.1.1.1.1', content: 'Debating complex topics. Extempore speech. Panel discussions.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Vocabulary', indicator: 'B6.1.2.1.1', content: 'Advanced vocabulary. Synonyms, antonyms, homographs. Context clues.' },
              { name: 'Controlled Writing', indicator: 'B6.1.2.2.1', content: 'Essay writing (narrative, descriptive, expository, argumentative). Report writing.' },
              { name: 'Descriptive Writing', indicator: 'B6.1.2.3.1', content: 'Creative writing. Poetry. Letter writing (formal and informal).' },
            ],
          },
          {
            name: 'Comprehension',
            subStrands: [
              { name: 'Reading Comprehension', indicator: 'B6.1.3.1.1', content: 'Analysing texts. Evaluating arguments. Comparing texts.' },
              { name: 'Fluency', indicator: 'B6.1.3.2.1', content: 'Reading for purpose. Skimming and scanning. Critical reading.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Whole Numbers and Integers', indicator: 'B6.2.1.1.1', content: 'Operations with integers. Number lines. Absolute value.' },
              { name: 'Fractions, Decimals and Percentages', indicator: 'B6.2.1.2.1', content: 'Advanced operations. Percentage increase/decrease. Ratio and proportion.' },
            ],
          },
          {
            name: 'Number Operations',
            subStrands: [
              { name: 'Four Operations', indicator: 'B6.2.2.1.1', content: 'Multi-step problem solving. Order of operations. Estimation and checking.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: '2D and 3D Shapes', indicator: 'B6.2.3.1.1', content: 'Angles in triangles and quadrilaterals. Area and perimeter. Volume and surface area.' },
            ],
          },
          {
            name: 'Measurement',
            subStrands: [
              { name: 'Length, Mass, Capacity and Time', indicator: 'B6.2.4.1.1', content: 'Converting between units. Area and volume formulas. Speed calculations.' },
            ],
          },
          {
            name: 'Data',
            subStrands: [
              { name: 'Data and Probability', indicator: 'B6.2.5.1.1', content: 'Pie charts. Scatter plots. Probability of events. Tree diagrams.' },
            ],
          },
        ],
      },
      {
        name: 'Science',
        strands: [
          {
            name: 'Living Things',
            subStrands: [
              { name: 'Ecosystems', indicator: 'B6.3.1.1.1', content: 'Ecosystem components. Food webs. Energy flow. Conservation.' },
              { name: 'Human Health', indicator: 'B6.3.1.2.1', content: 'Diseases and prevention. Nutrition. Personal hygiene. Drug abuse.' },
            ],
          },
          {
            name: 'Matter',
            subStrands: [
              { name: 'Atoms and Elements', indicator: 'B6.3.2.1.1', content: 'Introduction to atoms. Elements and compounds. Periodic table basics.' },
            ],
          },
          {
            name: 'Forces and Energy',
            subStrands: [
              { name: 'Energy Sources', indicator: 'B6.3.3.1.1', content: 'Renewable and non-renewable energy. Solar, wind, water. Energy conservation.' },
            ],
          },
        ],
      },
      {
        name: 'Our World Our People',
        strands: [
          {
            name: 'Economic Activities',
            subStrands: [
              { name: 'Production and Consumption', indicator: 'B6.4.1.1.1', content: 'Goods and services. Production processes. Saving and budgeting. Entrepreneurship.' },
            ],
          },
          {
            name: 'Global Issues',
            subStrands: [
              { name: 'Environmental Challenges', indicator: 'B6.4.2.1.1', content: 'Climate change. Pollution. Deforestation. Sustainable development.' },
            ],
          },
        ],
      },
      {
        name: 'Computing',
        strands: [
          {
            name: 'Computer Skills',
            subStrands: [
              { name: 'Spreadsheets', indicator: 'B6.5.1.1.1', content: 'Entering data. Simple formulas. Creating charts.' },
              { name: 'Presentations', indicator: 'B6.5.1.2.1', content: 'Creating slides. Adding text and images. Presenting to an audience.' },
            ],
          },
        ],
      },
      {
        name: 'History',
        strands: [
          {
            name: 'Ghana in the World',
            subStrands: [
              { name: 'Ghana and the AU', indicator: 'B6.6.1.1.1', content: 'Ghana\'s role in African Union. Pan-Africanism. ECOWAS.' },
              { name: 'Global Connections', indicator: 'B6.6.1.2.1', content: 'Ghana and the UN. International trade. Cultural exchange.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'Religious Living',
            subStrands: [
              { name: 'Living a Good Life', indicator: 'B6.7.1.1.1', content: 'Religious values in daily life. Community service. Helping the needy.' },
            ],
          },
          {
            name: 'Moral Values',
            subStrands: [
              { name: 'Leadership and Service', indicator: 'B6.7.2.1.1', content: 'Servant leadership. Leading by example. Community development.' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 7 (JHS 1) ──
  {
    key: 'basic7',
    label: 'Basic 7 (JHS 1)',
    level: 'jhs',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Listening Comprehension', indicator: 'B7.1.1.1.1', content: 'Listening for main ideas and details. Note-taking from oral presentations. Summarising.' },
              { name: 'Speaking', indicator: 'B7.1.1.2.1', content: 'Oral presentations. Debating. Group discussions. Interview skills.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Reading', indicator: 'B7.1.2.1.1', content: 'Reading literature (prose, poetry, drama). Comprehension strategies. Critical reading.' },
              { name: 'Writing', indicator: 'B7.1.2.2.1', content: 'Essay writing (narrative, descriptive, expository, argumentative). Creative writing. Letter writing.' },
              { name: 'Grammar', indicator: 'B7.1.2.3.1', content: 'Parts of speech. Sentence types. Subject-verb agreement. Punctuation.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Numbers and Numeration', indicator: 'B7.2.1.1.1', content: 'Integers. Rational numbers. Indices. Standard form.' },
              { name: 'Basic Algebra', indicator: 'B7.2.1.2.1', content: 'Algebraic expressions. Simplifying expressions. Linear equations in one variable.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: '2D Shapes and Angles', indicator: 'B7.2.2.1.1', content: 'Types of angles. Angle properties. Construction of angles and triangles.' },
            ],
          },
          {
            name: 'Sets and Reasoning',
            subStrands: [
              { name: 'Sets and Operations', indicator: 'B7.2.3.1.1', content: 'Sets, subsets, universal set. Union and intersection. Venn diagrams.' },
            ],
          },
        ],
      },
      {
        name: 'Integrated Science',
        strands: [
          {
            name: 'Diversity of Matter',
            subStrands: [
              { name: 'Living and Non-Living Things', indicator: 'B7.3.1.1.1', content: 'Characteristics of living things. Classification of organisms. Cells and cell theory.' },
              { name: 'Matter and Its Properties', indicator: 'B7.3.1.2.1', content: 'States of matter. Physical and chemical properties. Atoms and molecules.' },
            ],
          },
          {
            name: 'Cycles',
            subStrands: [
              { name: 'Life Cycles', indicator: 'B7.3.2.1.1', content: 'Life cycles of plants and animals. Reproduction in plants and animals.' },
            ],
          },
          {
            name: 'Systems',
            subStrands: [
              { name: 'Cells and Organisms', indicator: 'B7.3.3.1.1', content: 'Cell structure and function. Plant vs animal cells. Levels of organisation.' },
            ],
          },
        ],
      },
      {
        name: 'Social Studies',
        strands: [
          {
            name: 'Self and Environment',
            subStrands: [
              { name: "Ghana's Geography", indicator: 'B7.4.1.1.1', content: 'Location of Ghana. Regions of Ghana. Climate and vegetation.' },
              { name: 'Our Environment', indicator: 'B7.4.1.2.1', content: 'Environmental problems. Conservation. Sustainable development.' },
            ],
          },
          {
            name: 'Governance',
            subStrands: [
              { name: 'Governance and Citizenship', indicator: 'B7.4.2.1.1', content: 'Rights and responsibilities. Constitution of Ghana. Three arms of government.' },
              { name: 'Basic Map Reading', indicator: 'B7.4.2.2.1', content: 'Map symbols. Reading maps. Scale and direction.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'God, His Creation and Attributes',
            subStrands: [
              { name: 'The Nature of God', indicator: 'B7.5.1.1.1', content: 'Attributes of God in Christianity, Islam, and Traditional religion. Worship and prayer.' },
            ],
          },
          {
            name: 'Moral Values',
            subStrands: [
              { name: 'Moral Living', indicator: 'B7.5.2.1.1', content: 'Honesty, truthfulness, integrity. Consequences of immoral behaviour.' },
            ],
          },
        ],
      },
      {
        name: 'Career Technology',
        strands: [
          {
            name: 'Design Thinking',
            subStrands: [
              { name: 'Introduction to Design', indicator: 'B7.6.1.1.1', content: 'Design process. Identifying problems. Generating solutions. Prototyping.' },
            ],
          },
          {
            name: 'Pre-Tech Skills',
            subStrands: [
              { name: 'Tools and Materials', indicator: 'B7.6.2.1.1', content: 'Hand tools. Measuring tools. Safety in the workshop. Materials and their properties.' },
            ],
          },
        ],
      },
      {
        name: 'Computing',
        strands: [
          {
            name: 'Computer Systems',
            subStrands: [
              { name: 'Components of a Computer', indicator: 'B7.7.1.1.1', content: 'Hardware components. Software types. Input/output devices. Storage.' },
              { name: 'Computer Ethics', indicator: 'B7.7.1.2.1', content: 'Computer ethics. Internet safety. Data protection. Cybersecurity basics.' },
            ],
          },
        ],
      },
      {
        name: 'Creative Arts and Design',
        strands: [
          {
            name: 'Visual Arts',
            subStrands: [
              { name: 'Drawing and Design', indicator: 'B7.8.1.1.1', content: 'Observational drawing. Design principles. Colour theory.' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 8 (JHS 2) ──
  {
    key: 'basic8',
    label: 'Basic 8 (JHS 2)',
    level: 'jhs',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Listening and Speaking', indicator: 'B8.1.1.1.1', content: 'Critical listening. Persuasive speaking. Group presentations. Debating.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Reading', indicator: 'B8.1.2.1.1', content: 'Analysing literature. Literary devices. Author\'s purpose and tone.' },
              { name: 'Writing', indicator: 'B8.1.2.2.1', content: 'Advanced essay writing. Research reports. Creative writing. Functional writing.' },
              { name: 'Grammar', indicator: 'B8.1.2.3.1', content: 'Clauses and sentence structure. Active and passive voice. Direct and indirect speech.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Rational Numbers', indicator: 'B8.2.1.1.1', content: 'Operations with fractions and decimals. Percentages. Ratio and proportion.' },
              { name: 'Algebra', indicator: 'B8.2.1.2.1', content: 'Linear equations. Simultaneous equations. Algebraic fractions. Factorisation.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: 'Shapes and Measurements', indicator: 'B8.2.2.1.1', content: 'Pythagoras theorem. Area and perimeter. Volume and surface area. Construction.' },
            ],
          },
          {
            name: 'Data',
            subStrands: [
              { name: 'Statistics', indicator: 'B8.2.3.1.1', content: 'Mean, median, mode. Frequency distributions. Probability of simple events.' },
            ],
          },
        ],
      },
      {
        name: 'Integrated Science',
        strands: [
          {
            name: 'Diversity of Matter',
            subStrands: [
              { name: 'Classification', indicator: 'B8.3.1.1.1', content: 'Kingdoms of living things. Vertebrates and invertebrates. Plant classification.' },
              { name: 'Soil and Water', indicator: 'B8.3.1.2.1', content: 'Soil formation and types. Water cycle. Water purification. Soil conservation.' },
            ],
          },
          {
            name: 'Systems',
            subStrands: [
              { name: 'Human Body Systems', indicator: 'B8.3.2.1.1', content: 'Circulatory, respiratory, digestive, excretory systems. Health and diseases.' },
            ],
          },
          {
            name: 'Energy',
            subStrands: [
              { name: 'Light and Sound', indicator: 'B8.3.3.1.1', content: 'Reflection and refraction of light. Lenses and mirrors. Sound waves.' },
            ],
          },
        ],
      },
      {
        name: 'Social Studies',
        strands: [
          {
            name: 'Governance and Citizenship',
            subStrands: [
              { name: 'Government Systems', indicator: 'B8.4.1.1.1', content: 'Local government. District assemblies. Traditional authority.' },
              { name: 'Human Rights', indicator: 'B8.4.1.2.1', content: 'Human rights and freedoms. Children\'s rights. Women\'s rights.' },
            ],
          },
          {
            name: 'Economic Activities',
            subStrands: [
              { name: 'Economic Resources', indicator: 'B8.4.2.1.1', content: 'Natural, human, capital resources. Production. Distribution. Consumption.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'Religious Leaders',
            subStrands: [
              { name: 'Key Figures', indicator: 'B8.5.1.1.1', content: 'Jesus Christ, Prophet Muhammad, Traditional religious leaders. Lessons from their teachings.' },
            ],
          },
          {
            name: 'Moral Living',
            subStrands: [
              { name: 'Moral Decision-Making', indicator: 'B8.5.2.1.1', content: 'Making moral choices. Peer pressure. Substance abuse. Adolescent challenges.' },
            ],
          },
        ],
      },
      {
        name: 'Career Technology',
        strands: [
          {
            name: 'Home Economics',
            subStrands: [
              { name: 'Food and Nutrition', indicator: 'B8.6.1.1.1', content: 'Food groups. Balanced diet. Food preparation. Food hygiene.' },
              { name: 'Clothing and Textiles', indicator: 'B8.6.1.2.1', content: 'Sewing tools. Fabric types. Basic sewing skills. Care of clothing.' },
            ],
          },
          {
            name: 'Pre-Tech',
            subStrands: [
              { name: 'Metal and Wood Work', indicator: 'B8.6.2.1.1', content: 'Metal properties. Wood properties. Joining methods. Finishing.' },
            ],
          },
        ],
      },
      {
        name: 'Computing',
        strands: [
          {
            name: 'Computer Applications',
            subStrands: [
              { name: 'Word Processing', indicator: 'B8.7.1.1.1', content: 'Advanced formatting. Tables. Mail merge. Templates.' },
              { name: 'Spreadsheets', indicator: 'B8.7.1.2.1', content: 'Formulas and functions. Charts. Data sorting and filtering.' },
            ],
          },
        ],
      },
    ],
  },

  // ── Basic 9 (JHS 3) ──
  {
    key: 'basic9',
    label: 'Basic 9 (JHS 3)',
    level: 'jhs',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Advanced Speaking', indicator: 'B9.1.1.1.1', content: 'Public speaking. Debating complex motions. Interview techniques.' },
            ],
          },
          {
            name: 'Reading and Writing',
            subStrands: [
              { name: 'Reading', indicator: 'B9.1.2.1.1', content: 'Analysing complex texts. Shakespeare (simplified). African literature. Critical analysis.' },
              { name: 'Writing', indicator: 'B9.1.2.2.1', content: 'Examination essays. Summary writing. Report writing. Article writing.' },
              { name: 'Grammar', indicator: 'B9.1.2.3.1', content: 'Advanced grammar. Common errors. Register and style. Editing skills.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics',
        strands: [
          {
            name: 'Number',
            subStrands: [
              { name: 'Advanced Number', indicator: 'B9.2.1.1.1', content: 'Indices and logarithms. Surds. Number bases. Modular arithmetic.' },
              { name: 'Algebra', indicator: 'B9.2.1.2.1', content: 'Quadratic equations. Word problems. Inequalities. Graphs of functions.' },
            ],
          },
          {
            name: 'Geometry',
            subStrands: [
              { name: 'Advanced Geometry', indicator: 'B9.2.2.1.1', content: 'Circle geometry. Trigonometry. Transformations. Loci.' },
            ],
          },
          {
            name: 'Data',
            subStrands: [
              { name: 'Statistics and Probability', indicator: 'B9.2.3.1.1', content: 'Advanced statistics. Probability. Tree diagrams. Sampling.' },
            ],
          },
        ],
      },
      {
        name: 'Integrated Science',
        strands: [
          {
            name: 'Diversity of Matter',
            subStrands: [
              { name: 'Chemical Reactions', indicator: 'B9.3.1.1.1', content: 'Types of reactions. Acids, bases, salts. Oxidation and reduction.' },
              { name: 'Periodic Table', indicator: 'B9.3.1.2.1', content: 'Periodic table. Elements and compounds. Chemical bonding basics.' },
            ],
          },
          {
            name: 'Systems',
            subStrands: [
              { name: 'Reproduction', indicator: 'B9.3.2.1.1', content: 'Human reproductive system. Reproductive health. Genetics and inheritance.' },
            ],
          },
          {
            name: 'Energy',
            subStrands: [
              { name: 'Electricity and Electronics', indicator: 'B9.3.3.1.1', content: 'Ohm\'s law. Electric circuits. Domestic electricity. Electronics basics.' },
            ],
          },
        ],
      },
      {
        name: 'Social Studies',
        strands: [
          {
            name: 'Governance and Citizenship',
            subStrands: [
              { name: 'National Development', indicator: 'B9.4.1.1.1', content: 'National development goals. Youth contribution. Civic responsibility.' },
              { name: 'International Relations', indicator: 'B9.4.1.2.1', content: 'Ghana and international organisations (UN, AU, ECOWAS). Global citizenship.' },
            ],
          },
          {
            name: 'Economic Activities',
            subStrands: [
              { name: 'Economic Development', indicator: 'B9.4.2.1.1', content: 'Economic growth. National budget. Taxation. Entrepreneurship.' },
            ],
          },
        ],
      },
      {
        name: 'Religious and Moral Education',
        strands: [
          {
            name: 'Religious Living',
            subStrands: [
              { name: 'Religious Communities', indicator: 'B9.5.1.1.1', content: 'Religious organisations. Inter-faith dialogue. Religious tolerance.' },
            ],
          },
          {
            name: 'Moral Living',
            subStrands: [
              { name: 'Ethical Decision-Making', indicator: 'B9.5.2.1.1', content: 'Moral reasoning. Social justice. Corruption and its effects. Responsible citizenship.' },
            ],
          },
        ],
      },
      {
        name: 'Career Technology',
        strands: [
          {
            name: 'Career Pathways',
            subStrands: [
              { name: 'Career Planning', indicator: 'B9.6.1.1.1', content: 'Self-assessment. Career options. Subject selection for SHS. Job market trends.' },
            ],
          },
        ],
      },
      {
        name: 'Computing',
        strands: [
          {
            name: 'Advanced Computing',
            subStrands: [
              { name: 'Programming Basics', indicator: 'B9.7.1.1.1', content: 'Introduction to programming. Algorithms. Flowcharts. Basic coding (Scratch/Python).' },
              { name: 'Web Development Basics', indicator: 'B9.7.1.2.1', content: 'HTML basics. CSS basics. Creating simple web pages.' },
            ],
          },
        ],
      },
    ],
  },

  // ── SHS 1 (Senior High School Year 1) ──
  {
    key: 'shs1',
    label: 'SHS 1',
    level: 'shs',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Listening Comprehension', indicator: 'SHS1.ENG.1.1', content: 'Listening for main ideas, supporting details, and implied meanings in speeches, lectures, and broadcasts. Note-taking skills.' },
              { name: 'Speaking and Oral Presentation', indicator: 'SHS1.ENG.1.2', content: 'Oral presentations, debates, panel discussions. Pronunciation, intonation, and stress. Public speaking skills.' },
            ],
          },
          {
            name: 'Reading and Comprehension',
            subStrands: [
              { name: 'Reading Literature', indicator: 'SHS1.ENG.2.1', content: 'Prose, poetry, and drama analysis. Literary devices. African and Ghanaian literature. Character analysis, theme, plot.' },
              { name: 'Reading Comprehension', indicator: 'SHS1.ENG.2.2', content: 'Skimming, scanning, inferential reading. Vocabulary in context. Author\'s purpose and tone. Critical reading.' },
            ],
          },
          {
            name: 'Writing',
            subStrands: [
              { name: 'Composition Writing', indicator: 'SHS1.ENG.3.1', content: 'Narrative, descriptive, expository, argumentative essays. Letter writing (formal and informal). Report writing. Summary writing.' },
              { name: 'Grammar and Usage', indicator: 'SHS1.ENG.3.2', content: 'Parts of speech, sentence structure, clauses, subject-verb agreement. Active and passive voice. Direct and indirect speech. Punctuation.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics (Core)',
        strands: [
          {
            name: 'Number and Numeration',
            subStrands: [
              { name: 'Number Systems', indicator: 'SHS1.MATH.1.1', content: 'Real number system. Rational and irrational numbers. Indices and logarithms. Surds. Modular arithmetic.' },
              { name: 'Sets and Operations', indicator: 'SHS1.MATH.1.2', content: 'Sets, subsets, universal set. Union, intersection, complement. Venn diagrams and applications. Set builder notation.' },
            ],
          },
          {
            name: 'Algebra',
            subStrands: [
              { name: 'Algebraic Expressions', indicator: 'SHS1.MATH.2.1', content: 'Simplifying algebraic expressions. Factorisation. Algebraic fractions. Linear equations and inequalities. Quadratic equations.' },
              { name: 'Relations and Functions', indicator: 'SHS1.MATH.2.2', content: 'Relations, domain and range. Functions (linear, quadratic). Graphs of functions. Function notation.' },
            ],
          },
          {
            name: 'Geometry and Trigonometry',
            subStrands: [
              { name: 'Plane Geometry', indicator: 'SHS1.MATH.3.1', content: 'Angles, triangles, polygons. Properties of circles. Construction. Loci. Coordinate geometry (distance, midpoint, gradient).' },
              { name: 'Trigonometry', indicator: 'SHS1.MATH.3.2', content: 'Trigonometric ratios (sine, cosine, tangent). Angles of elevation and depression. Sine and cosine rules. Bearings.' },
            ],
          },
          {
            name: 'Statistics and Probability',
            subStrands: [
              { name: 'Data Handling', indicator: 'SHS1.MATH.4.1', content: 'Collection, organisation, and presentation of data. Measures of central tendency (mean, median, mode). Measures of dispersion.' },
              { name: 'Probability', indicator: 'SHS1.MATH.4.2', content: 'Basic probability concepts. Experimental and theoretical probability. Sample space. Simple events. Tree diagrams.' },
            ],
          },
        ],
      },
      {
        name: 'Integrated Science (Core)',
        strands: [
          {
            name: 'Diversity of Matter',
            subStrands: [
              { name: 'Cells and Living Organisms', indicator: 'SHS1.SCI.1.1', content: 'Cell theory. Plant and animal cell structure. Levels of organisation. Cell division (mitosis, meiosis). Transport across cell membrane.' },
              { name: 'Classification of Organisms', indicator: 'SHS1.SCI.1.2', content: 'Five-kingdom classification. Characteristics of kingdoms. Binomial nomenclature. Keys for identification.' },
            ],
          },
          {
            name: 'Cycles',
            subStrands: [
              { name: 'Life Cycles and Reproduction', indicator: 'SHS1.SCI.2.1', content: 'Reproduction in plants (vegetative, sexual). Reproduction in animals. Life cycles of selected organisms. Reproductive health.' },
              { name: 'The Cell Cycle', indicator: 'SHS1.SCI.2.2', content: 'Mitosis and meiosis. Chromosomes and genes. DNA structure basics. Inheritance patterns.' },
            ],
          },
          {
            name: 'Systems',
            subStrands: [
              { name: 'Human Body Systems', indicator: 'SHS1.SCI.3.1', content: 'Digestive system. Respiratory system. Circulatory system. Excretory system. Nervous system. Coordination and response.' },
              { name: 'Plant Systems', indicator: 'SHS1.SCI.3.2', content: 'Transport in plants (xylem, phloem). Photosynthesis. Plant nutrition. Plant responses.' },
            ],
          },
          {
            name: 'Energy and Matter',
            subStrands: [
              { name: 'Matter and Its Properties', indicator: 'SHS1.SCI.4.1', content: 'States of matter. Atomic structure. Periodic table. Chemical bonding (ionic, covalent). Chemical equations. Acids, bases, and salts.' },
              { name: 'Energy Sources', indicator: 'SHS1.SCI.4.2', content: 'Forms of energy. Energy transformations. Renewable and non-renewable energy. Heat transfer. Electricity and circuits.' },
            ],
          },
        ],
      },
      {
        name: 'Social Studies (Core)',
        strands: [
          {
            name: 'Self-Awareness and Citizenship',
            subStrands: [
              { name: 'Adolescent Development', indicator: 'SHS1.SOC.1.1', content: 'Physical, emotional, and social changes in adolescence. Self-awareness and self-esteem. Goal setting. Time management.' },
              { name: 'Citizenship and National Identity', indicator: 'SHS1.SOC.1.2', content: 'Rights and responsibilities of citizens. National symbols and values. The Constitution of Ghana. Civic duties.' },
            ],
          },
          {
            name: 'Governance and Politics',
            subStrands: [
              { name: 'Government of Ghana', indicator: 'SHS1.SOC.2.1', content: 'Three arms of government (Executive, Legislature, Judiciary). Local government system. Traditional authority. Chieftaincy.' },
              { name: 'Democracy and Elections', indicator: 'SHS1.SOC.2.2', content: 'Democratic principles. Electoral process in Ghana. Political parties. Voting rights. Peaceful coexistence.' },
            ],
          },
          {
            name: 'Economic Activities',
            subStrands: [
              { name: 'Production and Distribution', indicator: 'SHS1.SOC.3.1', content: 'Factors of production. Types of economic systems. Business ownership. Distribution of goods and services. Entrepreneurship.' },
              { name: 'Resources and Development', indicator: 'SHS1.SOC.3.2', content: 'Natural, human, and capital resources. Sustainable development. Environmental conservation. Economic growth.' },
            ],
          },
        ],
      },
      {
        name: 'Information and Communication Technology (Core)',
        strands: [
          {
            name: 'Computer Systems',
            subStrands: [
              { name: 'Computer Hardware and Software', indicator: 'SHS1.ICT.1.1', content: 'Components of a computer system. Input, output, storage, and processing devices. System software vs application software. Computer architecture.' },
              { name: 'Computer Networks', indicator: 'SHS1.ICT.1.2', content: 'Types of networks (LAN, WAN, MAN). Network topologies. Internet and intranet. Network security basics.' },
            ],
          },
          {
            name: 'Productivity Software',
            subStrands: [
              { name: 'Word Processing', indicator: 'SHS1.ICT.2.1', content: 'Creating, formatting, and editing documents. Tables, columns, and mail merge. Templates and styles.' },
              { name: 'Spreadsheets', indicator: 'SHS1.ICT.2.2', content: 'Entering and formatting data. Formulas and functions. Charts and graphs. Data analysis.' },
              { name: 'Presentations', indicator: 'SHS1.ICT.2.3', content: 'Creating slide presentations. Adding multimedia. Transitions and animations. Delivering presentations.' },
            ],
          },
          {
            name: 'Internet and Web',
            subStrands: [
              { name: 'Internet Safety and Ethics', indicator: 'SHS1.ICT.3.1', content: 'Safe browsing practices. Cybersecurity. Privacy and data protection. Cyberbullying. Computer ethics and intellectual property.' },
              { name: 'Web Development Basics', indicator: 'SHS1.ICT.3.2', content: 'HTML basics. CSS basics. Creating simple web pages. Web hosting concepts.' },
            ],
          },
        ],
      },
      {
        name: 'Physics (Elective)',
        strands: [
          {
            name: 'Mechanics',
            subStrands: [
              { name: 'Motion', indicator: 'SHS1.PHY.1.1', content: 'Distance, displacement, speed, velocity, acceleration. Equations of motion. Motion graphs. Projectiles.' },
              { name: 'Forces', indicator: 'SHS1.PHY.1.2', content: 'Types of forces. Newton\'s laws of motion. Friction. Momentum and impulse. Equilibrium.' },
            ],
          },
          {
            name: 'Energy',
            subStrands: [
              { name: 'Work, Energy and Power', indicator: 'SHS1.PHY.2.1', content: 'Work done. Kinetic and potential energy. Conservation of energy. Power. Efficiency of machines.' },
            ],
          },
        ],
      },
      {
        name: 'Chemistry (Elective)',
        strands: [
          {
            name: 'Atomic Structure and Bonding',
            subStrands: [
              { name: 'Atomic Structure', indicator: 'SHS1.CHEM.1.1', content: 'Subatomic particles. Atomic number and mass number. Isotopes. Electronic configuration. Periodic table trends.' },
              { name: 'Chemical Bonding', indicator: 'SHS1.CHEM.1.2', content: 'Ionic bonding. Covalent bonding. Metallic bonding. Intermolecular forces. Shapes of molecules.' },
            ],
          },
          {
            name: 'Chemical Reactions',
            subStrands: [
              { name: 'Chemical Equations and Stoichiometry', indicator: 'SHS1.CHEM.2.1', content: 'Balancing chemical equations. Mole concept. Stoichiometric calculations. Limiting reagents. Percentage yield.' },
            ],
          },
        ],
      },
      {
        name: 'Biology (Elective)',
        strands: [
          {
            name: 'Cell Biology',
            subStrands: [
              { name: 'Cell Structure and Function', indicator: 'SHS1.BIO.1.1', content: 'Microscopy. Cell organelles and functions. Prokaryotic vs eukaryotic cells. Cell specialisation. Tissues and organs.' },
              { name: 'Cell Transport', indicator: 'SHS1.BIO.1.2', content: 'Diffusion, osmosis, active transport. Facilitated diffusion. Endocytosis and exocytosis. Water potential.' },
            ],
          },
          {
            name: 'Nutrition',
            subStrands: [
              { name: 'Nutrition in Plants and Animals', indicator: 'SHS1.BIO.2.1', content: 'Photosynthesis. Plant nutrition. Human digestive system. Balanced diet. Nutritional deficiencies and disorders.' },
            ],
          },
        ],
      },
      {
        name: 'Economics (Elective)',
        strands: [
          {
            name: 'Basic Economic Concepts',
            subStrands: [
              { name: 'Scope of Economics', indicator: 'SHS1.ECON.1.1', content: 'Definition of economics. Scarcity, choice, and opportunity cost. Production possibility curves. Economic systems.' },
              { name: 'Demand and Supply', indicator: 'SHS1.ECON.1.2', content: 'Law of demand. Law of supply. Market equilibrium. Elasticity of demand and supply. Factors affecting demand and supply.' },
            ],
          },
        ],
      },
      {
        name: 'Government (Elective)',
        strands: [
          {
            name: 'Political Institutions',
            subStrands: [
              { name: 'Basic Concepts of Government', indicator: 'SHS1.GOV.1.1', content: 'Definition of government. Functions of government. Forms of government (democracy, monarchy, dictatorship). State and nation.' },
              { name: 'Constitutions', indicator: 'SHS1.GOV.1.2', content: 'Definition and types of constitutions. Written vs unwritten. Rigid vs flexible. The 1992 Constitution of Ghana.' },
            ],
          },
        ],
      },
      {
        name: 'Literature in English (Elective)',
        strands: [
          {
            name: 'Literary Analysis',
            subStrands: [
              { name: 'Introduction to Literature', indicator: 'SHS1.LIT.1.1', content: 'What is literature? Genres of literature (prose, poetry, drama). Literary terms and devices. Approaches to literary analysis.' },
              { name: 'African Literature', indicator: 'SHS1.LIT.1.2', content: 'Themes in African literature. Major African writers. Ghanaian literature. Oral literature traditions.' },
            ],
          },
        ],
      },
      {
        name: 'Geography (Elective)',
        strands: [
          {
            name: 'Physical Geography',
            subStrands: [
              { name: 'The Earth', indicator: 'SHS1.GEO.1.1', content: 'Earth structure. Rocks and minerals. Earth movements (plate tectonics, earthquakes, volcanoes). Weathering and erosion.' },
              { name: 'Climate and Vegetation', indicator: 'SHS1.GEO.1.2', content: 'Climate elements and factors. Climate types. Vegetation zones. Human impact on climate and vegetation.' },
            ],
          },
        ],
      },
      {
        name: 'Accounting (Elective)',
        strands: [
          {
            name: 'Book-Keeping and Accounting',
            subStrands: [
              { name: 'Introduction to Accounting', indicator: 'SHS1.ACC.1.1', content: 'Purpose of accounting. Users of accounting information. Accounting concepts and conventions. The accounting equation.' },
              { name: 'Books of Original Entry', indicator: 'SHS1.ACC.1.2', content: 'Journals. Cash book. Petty cash book. Ledger accounts. Trial balance. Double-entry bookkeeping.' },
            ],
          },
        ],
      },
      {
        name: 'Business Management (Elective)',
        strands: [
          {
            name: 'Business Organisation',
            subStrands: [
              { name: 'Introduction to Business', indicator: 'SHS1.BM.1.1', content: 'Types of business organisations. Sole proprietorship, partnership, companies. Business objectives. Stakeholders.' },
              { name: 'Management Principles', indicator: 'SHS1.BM.1.2', content: 'Functions of management (planning, organising, directing, controlling). Leadership styles. Motivation. Delegation.' },
            ],
          },
        ],
      },
      {
        name: 'History (Elective)',
        strands: [
          {
            name: 'Ghana Through Time',
            subStrands: [
              { name: 'Pre-Colonial Ghana', indicator: 'SHS1.HIS.1.1', content: 'Early inhabitants of Ghana. Migrations and settlements. Traditional political systems. Economic activities before colonialism.' },
              { name: 'Colonial Rule', indicator: 'SHS1.HIS.1.2', content: 'Arrival of Europeans. British colonisation. Indirect rule. Nationalist movements. Independence in 1957.' },
            ],
          },
        ],
      },
      {
        name: 'French (Elective)',
        strands: [
          {
            name: 'Language Skills',
            subStrands: [
              { name: 'Listening and Speaking', indicator: 'SHS1.FR.1.1', content: 'Basic French pronunciation. Greetings and introductions. Everyday conversations. Listening comprehension in French.' },
              { name: 'Reading and Writing', indicator: 'SHS1.FR.1.2', content: 'Reading simple French texts. French grammar basics (articles, nouns, adjectives, verbs). Writing short compositions in French.' },
            ],
          },
        ],
      },
      {
        name: 'Physical Education (Core)',
        strands: [
          {
            name: 'Physical Fitness and Health',
            subStrands: [
              { name: 'Physical Fitness', indicator: 'SHS1.PE.1.1', content: 'Components of physical fitness. Fitness testing. Exercise programmes. Health-related fitness. Warm-up and cool-down.' },
              { name: 'Sports and Games', indicator: 'SHS1.PE.1.2', content: 'Athletics (track and field). Football, basketball, volleyball. Rules and regulations. Skill development. Teamwork and sportsmanship.' },
            ],
          },
        ],
      },
    ],
  },

  // ── SHS 2 (Senior High School Year 2) ──
  {
    key: 'shs2',
    label: 'SHS 2',
    level: 'shs',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Oral Language',
            subStrands: [
              { name: 'Advanced Listening and Speaking', indicator: 'SHS2.ENG.1.1', content: 'Critical listening to complex texts. Debating and argumentation. Interview techniques. Oral interpretation of literature.' },
            ],
          },
          {
            name: 'Reading and Comprehension',
            subStrands: [
              { name: 'Literary Analysis', indicator: 'SHS2.ENG.2.1', content: 'In-depth analysis of set texts. Character, theme, style, and setting. Comparative literature. Shakespeare (selected works).' },
              { name: 'Critical Reading', indicator: 'SHS2.ENG.2.2', content: 'Analysing arguments. Fact vs opinion. Evaluating evidence. Reading for research. Synthesising multiple sources.' },
            ],
          },
          {
            name: 'Writing',
            subStrands: [
              { name: 'Advanced Composition', indicator: 'SHS2.ENG.3.1', content: 'Advanced essay writing (argumentative, persuasive, reflective). Research papers. Creative writing (short stories, poetry). Article writing.' },
              { name: 'Advanced Grammar', indicator: 'SHS2.ENG.3.2', content: 'Complex sentence structures. Clauses and phrases. Register and style. Common errors. Editing and proofreading.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics (Core)',
        strands: [
          {
            name: 'Algebra and Calculus',
            subStrands: [
              { name: 'Advanced Algebra', indicator: 'SHS2.MATH.1.1', content: 'Quadratic equations and functions. Polynomials. Simultaneous equations. Inequalities. Logarithmic and exponential functions.' },
              { name: 'Introduction to Calculus', indicator: 'SHS2.MATH.1.2', content: 'Limits and continuity. Differentiation from first principles. Rules of differentiation. Applications of derivatives (rates of change, maxima and minima).' },
            ],
          },
          {
            name: 'Geometry and Trigonometry',
            subStrands: [
              { name: 'Coordinate Geometry', indicator: 'SHS2.MATH.2.1', content: 'Equation of a line. Equation of a circle. Conic sections (parabola, ellipse, hyperbola). Transformations.' },
              { name: 'Advanced Trigonometry', indicator: 'SHS2.MATH.2.2', content: 'Trigonometric identities. Trigonometric equations. Inverse trigonometric functions. Compound and multiple angles.' },
            ],
          },
          {
            name: 'Statistics and Probability',
            subStrands: [
              { name: 'Advanced Statistics', indicator: 'SHS2.MATH.3.1', content: 'Correlation and regression. Binomial distribution. Normal distribution. Hypothesis testing basics.' },
              { name: 'Probability', indicator: 'SHS2.MATH.3.2', content: 'Conditional probability. Permutations and combinations. Probability distributions. Bayes\' theorem.' },
            ],
          },
        ],
      },
      {
        name: 'Integrated Science (Core)',
        strands: [
          {
            name: 'Systems and Processes',
            subStrands: [
              { name: 'Human Anatomy and Physiology', indicator: 'SHS2.SCI.1.1', content: 'Skeletal and muscular systems. Nervous and endocrine systems. Immune system. Homeostasis. Diseases and immunity.' },
              { name: 'Plant Physiology', indicator: 'SHS2.SCI.1.2', content: 'Photosynthesis (light and dark reactions). Plant hormones. Plant growth and development. Plant reproduction.' },
            ],
          },
          {
            name: 'Chemistry of Matter',
            subStrands: [
              { name: 'Chemical Reactions', indicator: 'SHS2.SCI.2.1', content: 'Types of chemical reactions. Rates of reaction. Chemical equilibrium. Electrochemistry. Oxidation and reduction.' },
              { name: 'Acids, Bases and Salts', indicator: 'SHS2.SCI.2.2', content: 'pH scale. Acid-base titrations. Indicators. Salt preparation. Buffer solutions. Industrial applications.' },
            ],
          },
          {
            name: 'Physics and Energy',
            subStrands: [
              { name: 'Electricity and Magnetism', indicator: 'SHS2.SCI.3.1', content: 'Electric circuits (series and parallel). Ohm\'s law. Electrical power and energy. Electromagnetism. Electromagnetic induction.' },
              { name: 'Waves and Optics', indicator: 'SHS2.SCI.3.2', content: 'Wave properties. Sound waves. Light waves. Reflection and refraction. Lenses and optical instruments.' },
            ],
          },
        ],
      },
      {
        name: 'Social Studies (Core)',
        strands: [
          {
            name: 'National Development',
            subStrands: [
              { name: 'Economic Development', indicator: 'SHS2.SOC.1.1', content: 'Economic growth and development. National income. Budget and taxation. International trade. Balance of payments.' },
              { name: 'Social Development', indicator: 'SHS2.SOC.1.2', content: 'Education and health. Population and development. Urbanisation. Social services. Poverty and inequality.' },
            ],
          },
          {
            name: 'International Relations',
            subStrands: [
              { name: 'Ghana in the International Community', indicator: 'SHS2.SOC.2.1', content: 'Ghana and the UN. African Union. ECOWAS. Commonwealth. International organisations and treaties.' },
              { name: 'Global Issues', indicator: 'SHS2.SOC.2.2', content: 'Climate change. Globalisation. Human rights. Peace and conflict. Sustainable development goals.' },
            ],
          },
        ],
      },
      {
        name: 'Information and Communication Technology (Core)',
        strands: [
          {
            name: 'Advanced Computing',
            subStrands: [
              { name: 'Database Management', indicator: 'SHS2.ICT.1.1', content: 'Database concepts. Tables, queries, forms, reports. Relational databases. SQL basics. Database design.' },
              { name: 'Programming', indicator: 'SHS2.ICT.1.2', content: 'Programming concepts (variables, loops, conditionals). Problem-solving with algorithms. Introduction to Python or Visual Basic. Flowcharts and pseudocode.' },
            ],
          },
          {
            name: 'Digital Literacy',
            subStrands: [
              { name: 'Web Technologies', indicator: 'SHS2.ICT.2.1', content: 'Advanced HTML and CSS. JavaScript basics. Web design principles. Content management systems.' },
              { name: 'Cybersecurity', indicator: 'SHS2.ICT.2.2', content: 'Network security. Threats and vulnerabilities. Encryption. Data protection. Cybersecurity careers.' },
            ],
          },
        ],
      },
      {
        name: 'Physics (Elective)',
        strands: [
          {
            name: 'Waves and Oscillations',
            subStrands: [
              { name: 'Wave Motion', indicator: 'SHS2.PHY.1.1', content: 'Types of waves. Wave equation. Superposition. Stationary waves. Sound waves. Doppler effect.' },
              { name: 'Optics', indicator: 'SHS2.PHY.1.2', content: 'Reflection and refraction of light. Lenses and mirrors. Optical instruments (microscope, telescope). Wave-particle duality.' },
            ],
          },
          {
            name: 'Electricity and Magnetism',
            subStrands: [
              { name: 'Electric Circuits', indicator: 'SHS2.PHY.2.1', content: 'Ohm\'s law. Series and parallel circuits. Kirchhoff\'s laws. Electrical measurements. Internal resistance.' },
              { name: 'Electromagnetism', indicator: 'SHS2.PHY.2.2', content: 'Magnetic fields. Electromagnetic induction. Transformers. AC circuits. Electromagnetic waves.' },
            ],
          },
        ],
      },
      {
        name: 'Chemistry (Elective)',
        strands: [
          {
            name: 'Chemical Periodicity and Bonding',
            subStrands: [
              { name: 'Periodic Properties', indicator: 'SHS2.CHEM.1.1', content: 'Periodic trends (atomic radius, ionisation energy, electronegativity). Periodic law. Groups and periods.' },
              { name: 'Chemical Bonding and Structure', indicator: 'SHS2.CHEM.1.2', content: 'Ionic, covalent, metallic, and coordinate bonding. Shapes of molecules (VSEPR). Intermolecular forces. Properties of compounds.' },
            ],
          },
          {
            name: 'Organic Chemistry',
            subStrands: [
              { name: 'Hydrocarbons', indicator: 'SHS2.CHEM.2.1', content: 'Alkanes, alkenes, alkynes. Functional groups. Isomerism. Nomenclature. Reactions of hydrocarbons.' },
              { name: 'Organic Compounds', indicator: 'SHS2.CHEM.2.2', content: 'Alcohols, carboxylic acids, esters. Polymers. Biochemical molecules (carbohydrates, proteins, lipids).' },
            ],
          },
        ],
      },
      {
        name: 'Biology (Elective)',
        strands: [
          {
            name: 'Physiology',
            subStrands: [
              { name: 'Respiration and Gas Exchange', indicator: 'SHS2.BIO.1.1', content: 'Aerobic and anaerobic respiration. Respiratory system in humans. Gas exchange. Respiratory diseases.' },
              { name: 'Transport Systems', indicator: 'SHS2.BIO.1.2', content: 'Circulatory system (heart, blood vessels, blood). Lymphatic system. Transport in plants. Cardiovascular diseases.' },
            ],
          },
          {
            name: 'Genetics and Evolution',
            subStrands: [
              { name: 'Genetics', indicator: 'SHS2.BIO.2.1', content: 'Mendelian genetics. Monohybrid and dihybrid crosses. Sex determination. Multiple alleles. Genetic disorders.' },
              { name: 'Evolution', indicator: 'SHS2.BIO.2.2', content: 'Evidence for evolution. Natural selection. Speciation. Human evolution. Classification of organisms.' },
            ],
          },
        ],
      },
      {
        name: 'Economics (Elective)',
        strands: [
          {
            name: 'Microeconomics',
            subStrands: [
              { name: 'Theory of Consumer Behaviour', indicator: 'SHS2.ECON.1.1', content: 'Utility analysis. Indifference curves. Budget lines. Consumer equilibrium. Consumer surplus.' },
              { name: 'Theory of Production', indicator: 'SHS2.ECON.1.2', content: 'Production functions. Law of diminishing returns. Costs of production (fixed, variable, marginal). Economies of scale.' },
            ],
          },
          {
            name: 'Market Structures',
            subStrands: [
              { name: 'Perfect Competition', indicator: 'SHS2.ECON.2.1', content: 'Features of perfect competition. Short-run and long-run equilibrium. Efficiency. Advantages and disadvantages.' },
              { name: 'Imperfect Competition', indicator: 'SHS2.ECON.2.2', content: 'Monopoly. Oligopoly. Monopolistic competition. Price discrimination. Market failure.' },
            ],
          },
        ],
      },
      {
        name: 'Government (Elective)',
        strands: [
          {
            name: 'Government Institutions',
            subStrands: [
              { name: 'The Executive', indicator: 'SHS2.GOV.1.1', content: 'Powers and functions of the executive. The President and cabinet. Civil service. Executive agencies.' },
              { name: 'The Legislature', indicator: 'SHS2.GOV.1.2', content: 'Parliament of Ghana. Functions of parliament. Law-making process. Parliamentary committees. Legislative oversight.' },
              { name: 'The Judiciary', indicator: 'SHS2.GOV.1.3', content: 'Court system in Ghana. Judicial independence. Judicial review. Rule of law. Human rights enforcement.' },
            ],
          },
        ],
      },
      {
        name: 'Literature in English (Elective)',
        strands: [
          {
            name: 'Prose and Poetry',
            subStrands: [
              { name: 'Prose Analysis', indicator: 'SHS2.LIT.1.1', content: 'Analysis of set prose texts. Narrative techniques. Character development. Themes and motifs. Setting and atmosphere.' },
              { name: 'Poetry Analysis', indicator: 'SHS2.LIT.1.2', content: 'Types of poetry. Poetic devices (imagery, metaphor, personification, symbolism). Tone and mood. Scansion and rhythm.' },
            ],
          },
          {
            name: 'Drama',
            subStrands: [
              { name: 'Dramatic Literature', indicator: 'SHS2.LIT.2.1', content: 'Elements of drama (plot, character, dialogue, stage directions). Types of drama (tragedy, comedy, tragicomedy). African drama. Shakespeare.' },
            ],
          },
        ],
      },
      {
        name: 'Geography (Elective)',
        strands: [
          {
            name: 'Human Geography',
            subStrands: [
              { name: 'Population Geography', indicator: 'SHS2.GEO.1.1', content: 'Population distribution and density. Population growth. Migration. Demographic transition. Population policies.' },
              { name: 'Settlement Geography', indicator: 'SHS2.GEO.1.2', content: 'Types of settlements (rural and urban). Urbanisation. Urban problems. Settlement patterns. Housing.' },
            ],
          },
          {
            name: 'Economic Geography',
            subStrands: [
              { name: 'Agriculture and Industry', indicator: 'SHS2.GEO.2.1', content: 'Types of agriculture. Agricultural systems. Industrial location factors. Manufacturing. Mining and energy.' },
              { name: 'Transport and Trade', indicator: 'SHS2.GEO.2.2', content: 'Transport systems (road, rail, water, air). Transport and development. International trade. Regional trade blocs.' },
            ],
          },
        ],
      },
      {
        name: 'Accounting (Elective)',
        strands: [
          {
            name: 'Financial Accounting',
            subStrands: [
              { name: 'Final Accounts', indicator: 'SHS2.ACC.1.1', content: 'Trading account. Profit and loss account. Balance sheet. Adjustments (accruals, prepayments, depreciation, bad debts).' },
              { name: 'Partnership Accounts', indicator: 'SHS2.ACC.1.2', content: 'Partnership formation. Profit sharing. Partners\' capital and current accounts. Admission and retirement of partners. Dissolution.' },
            ],
          },
          {
            name: 'Cost Accounting',
            subStrands: [
              { name: 'Elements of Cost', indicator: 'SHS2.ACC.2.1', content: 'Material cost. Labour cost. Overheads. Cost classification. Cost centres. Job costing.' },
            ],
          },
        ],
      },
      {
        name: 'Business Management (Elective)',
        strands: [
          {
            name: 'Business Operations',
            subStrands: [
              { name: 'Marketing', indicator: 'SHS2.BM.1.1', content: 'Marketing concept. Market segmentation. Marketing mix (4Ps). Consumer behaviour. Advertising and promotion.' },
              { name: 'Human Resource Management', indicator: 'SHS2.BM.1.2', content: 'Recruitment and selection. Training and development. Performance appraisal. Motivation theories. Industrial relations.' },
            ],
          },
        ],
      },
      {
        name: 'History (Elective)',
        strands: [
          {
            name: 'West Africa and the Wider World',
            subStrands: [
              { name: 'Colonial West Africa', indicator: 'SHS2.HIS.1.1', content: 'Scramble for Africa. Colonial administration (British, French, Portuguese). Impact of colonial rule. Nationalist movements in West Africa.' },
              { name: 'Post-Independence West Africa', indicator: 'SHS2.HIS.1.2', content: 'Independence movements. Formation of ECOWAS. Political instability. Economic challenges. Regional cooperation.' },
            ],
          },
        ],
      },
      {
        name: 'French (Elective)',
        strands: [
          {
            name: 'Advanced Language Skills',
            subStrands: [
              { name: 'Grammar and Composition', indicator: 'SHS2.FR.1.1', content: 'French verb tenses (passé composé, imparfait, futur simple). Pronouns. Adjectives and adverbs. Writing compositions and letters in French.' },
              { name: 'Reading and Literature', indicator: 'SHS2.FR.1.2', content: 'Reading French literature. French short stories. African Francophone literature. Comprehension exercises.' },
            ],
          },
        ],
      },
      {
        name: 'Physical Education (Core)',
        strands: [
          {
            name: 'Sports Science',
            subStrands: [
              { name: 'Anatomy and Physiology for Sport', indicator: 'SHS2.PE.1.1', content: 'Skeletal system and movement. Muscular system. Cardiovascular fitness. Flexibility. Sports injuries and prevention.' },
              { name: 'Sports Organisation', indicator: 'SHS2.PE.1.2', content: 'Tournament organisation. Rules of sports. Officiating. Sports administration. Inter-house and inter-schools competitions.' },
            ],
          },
        ],
      },
    ],
  },

  // ── SHS 3 (Senior High School Year 3) ──
  {
    key: 'shs3',
    label: 'SHS 3',
    level: 'shs',
    subjects: [
      {
        name: 'English Language',
        strands: [
          {
            name: 'Examination Preparation',
            subStrands: [
              { name: 'WASSCE Essay Writing', indicator: 'SHS3.ENG.1.1', content: 'WASSCE essay types and formats. Time management in exams. Past question practice. Common errors to avoid. Marking scheme analysis.' },
              { name: 'Comprehension and Summary', indicator: 'SHS3.ENG.1.2', content: 'WASSCE comprehension passages. Summary writing techniques. Vocabulary questions. Critical analysis. Past paper practice.' },
            ],
          },
          {
            name: 'Literature Review',
            subStrands: [
              { name: 'Set Texts Review', indicator: 'SHS3.ENG.2.1', content: 'Comprehensive review of all set texts. Character analysis. Theme identification. Contextual questions. Likely exam questions.' },
              { name: 'Poetry and Drama Review', indicator: 'SHS3.ENG.2.2', content: 'Review of set poems and plays. Key quotations. Dramatic techniques. Poetic devices. Exam-style questions.' },
            ],
          },
        ],
      },
      {
        name: 'Mathematics (Core)',
        strands: [
          {
            name: 'WASSCE Preparation',
            subStrands: [
              { name: 'Algebra and Calculus Review', indicator: 'SHS3.MATH.1.1', content: 'Comprehensive review of algebra, functions, and calculus. Integration techniques. Applications of calculus. WASSCE past questions.' },
              { name: 'Geometry and Statistics Review', indicator: 'SHS3.MATH.1.2', content: 'Review of coordinate geometry, trigonometry, statistics, and probability. Vectors and matrices. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'Integrated Science (Core)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Biology Revision', indicator: 'SHS3.SCI.1.1', content: 'Comprehensive review of cells, genetics, reproduction, nutrition, and ecology. WASSCE past questions. Practical examination preparation.' },
              { name: 'Chemistry Revision', indicator: 'SHS3.SCI.1.2', content: 'Review of atomic structure, bonding, chemical reactions, acids/bases, and organic chemistry. WASSCE past questions. Practical skills.' },
              { name: 'Physics Revision', indicator: 'SHS3.SCI.1.3', content: 'Review of mechanics, waves, electricity, and energy. WASSCE past questions. Problem-solving strategies.' },
            ],
          },
        ],
      },
      {
        name: 'Social Studies (Core)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Governance and Economics Review', indicator: 'SHS3.SOC.1.1', content: 'Comprehensive review of governance, politics, economic activities, and national development. WASSCE past questions. Essay techniques.' },
              { name: 'International Relations Review', indicator: 'SHS3.SOC.1.2', content: 'Review of Ghana\'s foreign policy, international organisations, and global issues. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'Information and Communication Technology (Core)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'ICT Concepts Review', indicator: 'SHS3.ICT.1.1', content: 'Comprehensive review of computer systems, networks, productivity software, programming, and web technologies. WASSCE past questions.' },
              { name: 'Practical Skills', indicator: 'SHS3.ICT.1.2', content: 'Practical examination preparation. Word processing tasks. Spreadsheet tasks. Database tasks. Web design tasks.' },
            ],
          },
        ],
      },
      {
        name: 'Physics (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Mechanics and Waves Review', indicator: 'SHS3.PHY.1.1', content: 'Comprehensive review of motion, forces, energy, waves, and optics. Problem-solving strategies. WASSCE past questions.' },
              { name: 'Electricity and Modern Physics', indicator: 'SHS3.PHY.1.2', content: 'Review of electricity, magnetism, atomic physics, and nuclear physics. WASSCE past questions. Practical examination preparation.' },
            ],
          },
        ],
      },
      {
        name: 'Chemistry (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Physical Chemistry Review', indicator: 'SHS3.CHEM.1.1', content: 'Review of atomic structure, bonding, stoichiometry, energetics, rates of reaction, and equilibrium. WASSCE past questions.' },
              { name: 'Organic and Inorganic Chemistry Review', indicator: 'SHS3.CHEM.1.2', content: 'Review of organic chemistry, periodicity, acids/bases, and qualitative analysis. WASSCE past questions. Practical skills.' },
            ],
          },
        ],
      },
      {
        name: 'Biology (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Cell Biology and Genetics Review', indicator: 'SHS3.BIO.1.1', content: 'Review of cell structure, transport, cell division, genetics, and evolution. WASSCE past questions. Practical drawing skills.' },
              { name: 'Physiology and Ecology Review', indicator: 'SHS3.BIO.1.2', content: 'Review of human physiology, plant physiology, ecology, and conservation. WASSCE past questions. Practical examination preparation.' },
            ],
          },
        ],
      },
      {
        name: 'Economics (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Microeconomics Review', indicator: 'SHS3.ECON.1.1', content: 'Review of demand and supply, consumer theory, production theory, and market structures. WASSCE past questions.' },
              { name: 'Macroeconomics Review', indicator: 'SHS3.ECON.1.2', content: 'Review of national income, money and banking, international trade, and economic development. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'Government (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Political Systems Review', indicator: 'SHS3.GOV.1.1', content: 'Review of basic concepts, constitutions, arms of government, electoral systems, and political ideologies. WASSCE past questions.' },
              { name: 'International Relations Review', indicator: 'SHS3.GOV.1.2', content: 'Review of foreign policy, international organisations, and Ghana\'s international relations. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'Literature in English (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Set Texts Final Review', indicator: 'SHS3.LIT.1.1', content: 'Final review of all WASSCE set texts (African and non-African). Key passages, themes, and characters. Likely exam questions and model answers.' },
              { name: 'Unseen Poems and Passages', indicator: 'SHS3.LIT.1.2', content: 'Techniques for analysing unseen poems and prose passages. Timed practice. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'Geography (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Physical Geography Review', indicator: 'SHS3.GEO.1.1', content: 'Review of earth structure, rocks, climate, vegetation, and landforms. Map reading and interpretation. WASSCE past questions.' },
              { name: 'Human and Economic Geography Review', indicator: 'SHS3.GEO.1.2', content: 'Review of population, settlement, agriculture, industry, transport, and trade. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'Accounting (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Financial Accounting Review', indicator: 'SHS3.ACC.1.1', content: 'Review of final accounts, partnerships, company accounts, and adjustments. WASSCE past questions. Problem-solving techniques.' },
              { name: 'Cost Accounting Review', indicator: 'SHS3.ACC.1.2', content: 'Review of cost elements, job costing, process costing, and budgeting. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'Business Management (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Business Management Review', indicator: 'SHS3.BM.1.1', content: 'Review of management principles, organisational structure, marketing, HRM, and business finance. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'History (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Ghana History Review', indicator: 'SHS3.HIS.1.1', content: 'Review of pre-colonial, colonial, and post-independence Ghana. Key figures and events. WASSCE past questions.' },
              { name: 'West African and World History Review', indicator: 'SHS3.HIS.1.2', content: 'Review of West African history, colonialism, pan-Africanism, and major world events. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'French (Elective)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'French Language Review', indicator: 'SHS3.FR.1.1', content: 'Review of French grammar, vocabulary, comprehension, and composition. Oral examination preparation. WASSCE past questions.' },
              { name: 'French Literature Review', indicator: 'SHS3.FR.1.2', content: 'Review of set French literary texts. Themes, characters, and style. WASSCE past questions.' },
            ],
          },
        ],
      },
      {
        name: 'Elective Mathematics',
        strands: [
          {
            name: 'Advanced Topics',
            subStrands: [
              { name: 'Calculus and Analysis', indicator: 'SHS3.EMATH.1.1', content: 'Integration techniques. Applications of integration (area, volume). Differential equations. Maclaurin and Taylor series.' },
              { name: 'Vectors and Matrices', indicator: 'SHS3.EMATH.1.2', content: 'Vector algebra. Scalar and vector products. Equations of lines and planes. Matrix operations. Determinants. Systems of equations.' },
            ],
          },
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Comprehensive Review', indicator: 'SHS3.EMATH.2.1', content: 'Review of all elective mathematics topics. WASSCE past questions. Problem-solving strategies. Time management.' },
            ],
          },
        ],
      },
      {
        name: 'Physical Education (Core)',
        strands: [
          {
            name: 'WASSCE Revision',
            subStrands: [
              { name: 'Physical Education Review', indicator: 'SHS3.PE.1.1', content: 'Review of physical fitness, sports science, sports organisation, and health education. WASSCE past questions. Practical assessment.' },
            ],
          },
        ],
      },
    ],
  },
];

// ── Helper Functions ──
export function findClassLevel(key: string): GESClassLevel | undefined {
  return GES_CURRICULUM.find((c) => c.key === key);
}

export function findSubject(classKey: string, subjectName: string): GESSubject | undefined {
  const cls = findClassLevel(classKey);
  return cls?.subjects.find((s) => s.name.toLowerCase() === subjectName.toLowerCase());
}

export function getWeekContent(classKey: string, subjectName: string, week: number, term: number): GESSubStrand | null {
  const subject = findSubject(classKey, subjectName);
  if (!subject) return null;
  // Distribute sub-strands across 12 weeks of the term
  const allSubStrands: GESSubStrand[] = [];
  subject.strands.forEach((strand) => {
    strand.subStrands.forEach((ss) => allSubStrands.push(ss));
  });
  if (allSubStrands.length === 0) return null;
  const index = (week - 1) % allSubStrands.length;
  return allSubStrands[index];
}

export function getAllClassLevels(): { key: string; label: string; level: string }[] {
  return GES_CURRICULUM.map((c) => ({ key: c.key, label: c.label, level: c.level }));
}

export function getSubjectsForClass(classKey: string): string[] {
  const cls = findClassLevel(classKey);
  return cls ? cls.subjects.map((s) => s.name) : [];
}
