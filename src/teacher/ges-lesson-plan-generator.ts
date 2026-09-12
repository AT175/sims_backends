/**
 * GES Lesson Plan Generator Service
 * Generates lesson plans in the GES/NaCCA Standards-Based Curriculum format.
 * Supports iterative refinement through teacher feedback.
 */
import {
  GES_CURRICULUM,
  CORE_COMPETENCIES,
  LESSON_PHASES,
  ASSESSMENT_TYPES,
  TLMS_BY_SUBJECT,
  findClassLevel,
  findSubject,
  getWeekContent,
  getSubjectsForClass,
  getAllClassLevels,
  GESClassLevel,
  GESSubject,
  GESStrand,
  GESSubStrand,
} from './ges-curriculum-data';

export interface GESLessonPlanResult {
  // Header
  schoolName: string;
  district: string;
  region: string;
  teacherName: string;
  classForm: string;
  subject: string;
  week: string;
  term: string;
  date: string;
  duration: string;
  boys: string;
  girls: string;
  averageAge: string;
  // Curriculum alignment
  strand: string;
  subStrand: string;
  indicator: string;
  contentStandard: string;
  coreCompetencies: string[];
  // Lesson content
  learningObjectives: string;
  teachingLearningResources: string[];
  // Three phases
  starter: string;
  mainActivity: string;
  plenary: string;
  // Assessment
  assessment: string;
  // Homework
  homework: string;
  // Differentiation
  differentiation: string;
  // Reflection (to be filled after lesson)
  reflection: string;
  // Raw content for editing
  rawContent: string;
}

export class GESLessonPlanGenerator {
  /**
   * Generate a complete GES-format lesson plan
   */
  generate(req: {
    classForm: string;
    subject: string;
    week: string;
    term?: string;
    topic?: string;
    duration?: string;
    schoolName?: string;
    district?: string;
    region?: string;
    teacherName?: string;
    objectives?: string;
    teachingStyle?: string;
  }): GESLessonPlanResult {
    const classLevel = findClassLevel(req.classForm);
    const subject = findSubject(req.classForm, req.subject);
    const weekNum = parseInt(req.week, 10) || 1;
    const termNum = parseInt(req.term || '1', 10) || 1;
    const weekContent = getWeekContent(req.classForm, req.subject, weekNum, termNum);

    const topic = req.topic || weekContent?.content || subject?.strands[0]?.subStrands[0]?.content || `${req.subject} lesson`;
    const strand = subject?.strands[0]?.name || 'General';
    const subStrand = weekContent?.name || subject?.strands[0]?.subStrands[0]?.name || 'General Topic';
    const indicator = weekContent?.indicator || subject?.strands[0]?.subStrands[0]?.indicator || 'N/A';
    const contentStandard = weekContent?.content || subject?.strands[0]?.subStrands[0]?.content || 'Content as per curriculum';

    const duration = req.duration || (classLevel?.level === 'kg' ? '30 minutes' : '45 minutes');
    const tlms = TLMS_BY_SUBJECT[req.subject] || ['Textbook', 'Whiteboard and markers', 'Charts', 'Real objects'];

    const level = classLevel?.level || 'primary';
    const objectives = req.objectives || this.generateObjectives(topic, req.subject, indicator, level);
    const teachingStyle = req.teachingStyle || (level === 'kg' ? 'Play-based, activity-centred' : level === 'jhs' ? 'Inquiry-based, collaborative' : 'Direct instruction with guided practice');

    const starter = this.generateStarter(topic, level, req.subject);
    const mainActivity = this.generateMainActivity(topic, contentStandard, level, req.subject, teachingStyle);
    const plenary = this.generatePlenary(topic, level);
    const assessment = this.generateAssessment(topic, level, indicator);
    const homework = this.generateHomework(topic, level, req.subject);
    const differentiation = this.generateDifferentiation(level);

    const coreComps = this.selectCoreCompetencies(req.subject, level);

    const result: GESLessonPlanResult = {
      schoolName: req.schoolName || '…………………………………………',
      district: req.district || '…………………………………………',
      region: req.region || '…………………………………………',
      teacherName: req.teacherName || '…………………………………………',
      classForm: classLevel?.label || req.classForm,
      subject: req.subject,
      week: req.week,
      term: req.term || 'Term 1',
      date: new Date().toISOString().slice(0, 10),
      duration,
      boys: '…………',
      girls: '…………',
      averageAge: '…………',
      strand,
      subStrand,
      indicator,
      contentStandard,
      coreCompetencies: coreComps,
      learningObjectives: objectives,
      teachingLearningResources: tlms,
      starter,
      mainActivity,
      plenary,
      assessment,
      homework,
      differentiation,
      reflection: '',
      rawContent: '',
    };

    result.rawContent = this.toGESFormat(result);
    return result;
  }

  /**
   * Refine a lesson plan based on teacher instruction
   */
  refine(lessonPlanText: string, instruction: string, context?: { subject?: string; classForm?: string; topic?: string }): { refinedContent: string; changes: string } {
    const lower = instruction.toLowerCase();
    let refined = lessonPlanText;
    const changes: string[] = [];

    // Handle common refinement requests
    if (lower.includes('add') && lower.includes('activity')) {
      refined = this.addActivity(refined, context?.subject || '', context?.topic || '');
      changes.push('Added a new teaching and learning activity.');
    }

    if (lower.includes('add') && (lower.includes('assessment') || lower.includes('question'))) {
      refined = this.addAssessmentQuestion(refined, context?.topic || '');
      changes.push('Added assessment questions.');
    }

    if (lower.includes('add') && lower.includes('tlm') || lower.includes('add') && lower.includes('resource')) {
      refined = this.addTLM(refined, context?.subject || '');
      changes.push('Added teaching and learning resources.');
    }

    if (lower.includes('add') && lower.includes('objective')) {
      refined = this.addObjective(refined, context?.topic || '', context?.subject || '');
      changes.push('Added learning objectives.');
    }

    if (lower.includes('add') && lower.includes('homework') || lower.includes('add') && lower.includes('assignment')) {
      refined = this.addHomework(refined, context?.topic || '');
      changes.push('Added homework/assignment.');
    }

    if (lower.includes('add') && lower.includes('differentiat')) {
      refined = this.addDifferentiation(refined);
      changes.push('Added differentiation strategies.');
    }

    if (lower.includes('add') && lower.includes('starter') || lower.includes('add') && lower.includes('introduction')) {
      refined = this.addStarterActivity(refined, context?.topic || '');
      changes.push('Added starter/introduction activity.');
    }

    if (lower.includes('add') && lower.includes('plenary') || lower.includes('add') && lower.includes('closure') || lower.includes('add') && lower.includes('conclusion')) {
      refined = this.addPlenary(refined, context?.topic || '');
      changes.push('Added plenary/closure activity.');
    }

    if (lower.includes('add') && lower.includes('core competenc')) {
      refined = this.addCoreCompetency(refined);
      changes.push('Added core competencies.');
    }

    if (lower.includes('make') && lower.includes('longer') || lower.includes('expand') || lower.includes('more detail')) {
      refined = this.expandContent(refined, context?.topic || '', context?.subject || '');
      changes.push('Expanded lesson content with more detail.');
    }

    if (lower.includes('make') && lower.includes('shorter') || lower.includes('shorten') || lower.includes('brief')) {
      refined = this.shortenContent(refined);
      changes.push('Shortened lesson content.');
    }

    if (lower.includes('simplif') || lower.includes('easier') || lower.includes('simple language')) {
      refined = this.simplifyLanguage(refined);
      changes.push('Simplified language for easier understanding.');
    }

    if (lower.includes('add') && lower.includes('group work') || lower.includes('add') && lower.includes('group activity')) {
      refined = this.addGroupWork(refined, context?.topic || '');
      changes.push('Added group work activities.');
    }

    if (lower.includes('add') && lower.includes('game') || lower.includes('add') && lower.includes('play')) {
      refined = this.addGame(refined, context?.topic || '');
      changes.push('Added a game/play activity.');
    }

    if (lower.includes('add') && lower.includes('song') || lower.includes('add') && lower.includes('rhyme')) {
      refined = this.addSong(refined, context?.topic || '');
      changes.push('Added a song/rhyme.');
    }

    if (lower.includes('add') && lower.includes('example') || lower.includes('add') && lower.includes('illustration')) {
      refined = this.addExample(refined, context?.topic || '');
      changes.push('Added examples/illustrations.');
    }

    // If no specific change was made, apply a general enhancement
    if (changes.length === 0) {
      refined = this.applyGeneralInstruction(refined, instruction, context?.topic || '');
      changes.push(`Applied your instruction: "${instruction}"`);
    }

    return { refinedContent: refined, changes: changes.join(' ') };
  }

  /**
   * Get available class levels
   */
  getClassLevels() {
    return getAllClassLevels();
  }

  /**
   * Get subjects for a class
   */
  getSubjects(classKey: string) {
    return getSubjectsForClass(classKey);
  }

  /**
   * Get week content for a class/subject/week
   */
  getWeekInfo(classKey: string, subjectName: string, week: number, term: number) {
    return getWeekContent(classKey, subjectName, week, term);
  }

  // ── Private generation helpers ──

  private generateObjectives(topic: string, subject: string, indicator: string, level: string): string {
    const verbs = level === 'kg' ? ['identify', 'name', 'describe', 'match', 'sort'] : level === 'jhs' ? ['analyse', 'evaluate', 'construct', 'apply', 'investigate'] : ['identify', 'describe', 'explain', 'demonstrate', 'apply'];
    const verb = verbs[0];
    const verb2 = verbs[1];
    const verb3 = verbs[2];
    return `By the end of the lesson, learners should be able to:
1. ${verb} the key concepts related to ${topic}.
2. ${verb2} examples of ${topic} in everyday life.
3. ${verb3} the importance of ${topic} in ${subject}.
(Indicator: ${indicator})`;
  }

  private generateStarter(topic: string, level: string, subject: string): string {
    if (level === 'kg') {
      return `**Phase 1: Starter (5–10 minutes)**
• Begin with a familiar song or rhyme related to ${topic}.
• Show learners a picture or real object connected to ${topic}.
• Ask simple questions: "What do you see?" "Have you seen this before?"
• Allow learners to touch and explore the object.
• Connect to previous lesson: "Last time we learned about… Today we will learn about ${topic}."`;
    }
    if (level === 'jhs') {
      return `**Phase 1: Starter (5–7 minutes)**
• Pose a thought-provoking question related to ${topic}: "Why is ${topic} important in our daily lives?"
• Allow learners to discuss in pairs for 2 minutes.
• Invite 2–3 learners to share their thoughts.
• Connect to previous lesson and state today's learning objectives.
• Write the lesson topic on the board.`;
    }
    return `**Phase 1: Starter (5–10 minutes)**
• Review the previous lesson briefly by asking 2–3 recall questions.
• Introduce ${topic} using a picture, chart, or real object.
• Ask: "What do you know about ${topic}?" and list learners' responses on the board.
• State the lesson objectives clearly.
• Link ${topic} to learners' everyday experiences.`;
  }

  private generateMainActivity(topic: string, contentStandard: string, level: string, subject: string, teachingStyle: string): string {
    if (level === 'kg') {
      return `**Phase 2: Main Body (15–20 minutes)**

**Step 1: Introduction (5 minutes)**
• Show learners pictures/real objects related to ${topic}.
• Name and describe ${topic} using simple language.
• Encourage learners to repeat key words after you.

**Step 2: Guided Activity (7 minutes)**
• Demonstrate the activity: e.g., sorting, matching, colouring, or tracing related to ${topic}.
• Guide learners to do the activity in small groups.
• Move around to support individual learners.

**Step 3: Independent Activity (5–8 minutes)**
• Give each learner a worksheet or activity card on ${topic}.
• Allow learners to work at their own pace.
• Praise effort and correct gently.

**Step 4: Sharing (3 minutes)**
• Invite learners to show their work.
• Clap for each learner's effort.`;
    }
    if (level === 'jhs') {
      return `**Phase 2: Main Body (20–25 minutes)**

**Step 1: Presentation (7 minutes)**
• Explain the key concepts of ${topic} using diagrams, charts, or real examples.
• Write key terms and definitions on the board.
• Use questioning to check understanding: "What does ${topic} mean?" "Can you give an example?"

**Step 2: Group Investigation (8 minutes)**
• Divide the class into mixed-ability groups of 4–5 learners.
• Give each group a task or investigation question related to ${topic}.
• Groups discuss and record their findings.
• Teacher moves around to facilitate and guide.

**Step 3: Group Presentations (7 minutes)**
• Each group presents their findings to the class.
• Other groups ask questions and provide feedback.
• Teacher clarifies misconceptions and adds key points.

**Step 4: Application (3 minutes)**
• Provide a real-life scenario where ${topic} is applied.
• Ask learners to explain how they would apply what they have learned.`;
    }
    return `**Phase 2: Main Body (15–25 minutes)**

**Step 1: Presentation (7 minutes)**
• Explain the concept of ${topic} using the teaching and learning resources.
• Write key points on the board.
• Use examples from the local environment.
• Check understanding through questioning.

**Step 2: Guided Practice (8 minutes)**
• Work through 2–3 examples together with the class.
• Call learners to the board to try examples.
• Provide immediate feedback and correction.

**Step 3: Independent/Group Practice (7 minutes)**
• Give learners exercises or activities on ${topic}.
• Learners work individually or in pairs.
• Teacher moves around to support struggling learners.
• Fast finishers get extension questions.

**Step 4: Discussion (3 minutes)**
• Discuss the answers as a class.
• Address common mistakes and misconceptions.`;
  }

  private generatePlenary(topic: string, level: string): string {
    if (level === 'kg') {
      return `**Phase 3: Plenary/Closure (3–5 minutes)**
• Sing a closing song related to ${topic}.
• Ask 2–3 learners to say one thing they learned today.
• Praise all learners for their participation.
• Tell learners what they will learn next time.`;
    }
    return `**Phase 3: Plenary/Closure (3–5 minutes)**
• Summarize the key points of the lesson on ${topic}.
• Ask 2–3 learners to share one new thing they learned.
• Give a quick exit question to check understanding.
• Preview the next lesson topic.
• Assign homework.`;
  }

  private generateAssessment(topic: string, level: string, indicator: string): string {
    if (level === 'kg') {
      return `**Assessment (AfL — Assessment for Learning)**
• Observe learners during activities — are they engaged and attempting tasks?
• Ask simple oral questions: "Show me…" "Point to…" "What is this?"
• Check if learners can complete the activity independently.
• Note any learners who need additional support.
(Aligned to indicator: ${indicator})`;
    }
    if (level === 'jhs') {
      return `**Assessment (AfL, AaL, AoL)**
• **AfL**: Oral questioning during the lesson — "Explain why…" "What would happen if…?"
• **AaL**: Peer assessment during group presentations — groups evaluate each other.
• **AoL**: Short written exit ticket with 2–3 questions:
  1. Define ${topic}.
  2. Give two examples of ${topic}.
  3. Explain the importance of ${topic}.
(Aligned to indicator: ${indicator})`;
    }
    return `**Assessment (AfL — Assessment for Learning)**
• Oral questioning during the lesson: "What is ${topic}?" "Can you give an example?"
• Observation of learners during guided and independent practice.
• Exit ticket: 2 questions on ${topic} for learners to answer before leaving.
• Mark exit tickets to identify learners who need support.
(Aligned to indicator: ${indicator})`;
  }

  private generateHomework(topic: string, level: string, subject: string): string {
    if (level === 'kg') {
      return `**Homework/Extension Activity**
• Ask learners to find something at home related to ${topic} and bring it to school tomorrow.
• Or: Draw/colour something about ${topic}.`;
    }
    if (level === 'jhs') {
      return `**Homework/Assignment**
1. Research and write a short paragraph (5–7 sentences) on ${topic}.
2. Find two real-life examples of ${topic} in your community and describe them.
3. Prepare one question about ${topic} to ask in the next lesson.`;
    }
    return `**Homework/Assignment**
1. Write down 3 things you learned about ${topic} today.
2. ${subject === 'Mathematics' ? `Solve exercise' problems on' ${topic} from your textbook.` : `Read about ${topic} in your textbook and write 2 sentences about it.`}
3. Find one example of ${topic} at home and be ready to share.`;
  }

  private generateDifferentiation(level: string): string {
    if (level === 'kg') {
      return `**Differentiation / Inclusion**
• **Support**: Provide additional guidance and simpler tasks for learners who struggle. Use more visual aids.
• **Challenge**: Give fast finishers additional activities or ask them to help peers.
• **SEN**: Ensure all learners can access activities. Adapt materials for learners with special needs.`;
    }
    return `**Differentiation / Inclusion**
• **Support**: Provide simplified examples, additional scaffolding, and one-on-one support for struggling learners.
• **Challenge**: Give extension questions and more complex tasks to advanced learners.
• **Mixed-ability grouping**: Pair stronger learners with those who need support during group work.
• **SEN**: Adapt resources and provide additional time for learners with special educational needs.`;
  }

  private selectCoreCompetencies(subject: string, level: string): string[] {
    const comps = ['Critical Thinking and Problem Solving (CP)', 'Communication and Collaboration (CC)'];
    if (subject === 'Creative Arts' || subject === 'Creative Arts and Design') comps.push('Creativity and Innovation (CI)');
    if (subject === 'Our World Our People' || subject === 'Social Studies' || subject === 'History') comps.push('Cultural Identity and Global Citizenship (CG)');
    if (subject === 'Computing') comps.push('Digital Literacy (DL)');
    comps.push('Personal Development and Leadership (PL)');
    return comps.slice(0, 4);
  }

  // ── Refinement helpers ──

  private addActivity(text: string, subject: string, topic: string): string {
    const activity = `\n\n**Additional Activity: Group Work**
• Divide learners into groups of 3–4.
• Give each group a task related to ${topic || 'the lesson'}.
• Groups present their work to the class.
• Teacher provides feedback.`;
    return text.replace(/(\*\*Phase 3:)/, activity + '\n\n$1');
  }

  private addAssessmentQuestion(text: string, topic: string): string {
    const questions = `\n\n**Additional Assessment Questions**
1. What is ${topic || 'the main concept'}?
2. Give two examples of ${topic || 'the topic'}.
3. Why is ${topic || 'the topic'} important?
4. How can you apply ${topic || 'the topic'} in your daily life?`;
    return text.replace(/(\*\*Homework)/, questions + '\n\n$1');
  }

  private addTLM(text: string, subject: string): string {
    const tlms = TLMS_BY_SUBJECT[subject] || ['Charts', 'Real objects', 'Flash cards'];
    const addition = `\n• ${tlms[Math.floor(Math.random() * tlms.length)]}`;
    return text.replace(/(Teaching and Learning Resources[\s\S]*?)(\n\n)/, `$1${addition}$2`);
  }

  private addObjective(text: string, topic: string, subject: string): string {
    const obj = `\n4. Apply knowledge of ${topic || 'the topic'} to solve real-life problems in ${subject || 'the subject'}.`;
    return text.replace(/(By the end of the lesson[\s\S]*?)(\n\n)/, `$1${obj}$2`);
  }

  private addHomework(text: string, topic: string): string {
    const hw = `\n4. Discuss ${topic || 'the topic'} with a family member and write down what they said.`;
    return text.replace(/(\*\*Homework[\s\S]*?)(\n\n)/, `$1${hw}$2`);
  }

  private addDifferentiation(text: string): string {
    const diff = `\n• **Visual learners**: Use more diagrams, charts, and visual aids.
• **Kinesthetic learners**: Include hands-on activities and movement.
• **Auditory learners**: Use oral explanations, discussions, and songs.`;
    return text.replace(/(\*\*Differentiation[\s\S]*?)(\n\n)/, `$1${diff}$2`);
  }

  private addStarterActivity(text: string, topic: string): string {
    const starter = `\n\n**Additional Starter Activity**
• Show a short video clip or picture about ${topic || 'the topic'}.
• Ask learners to predict what the lesson will be about.`;
    return text.replace(/(\*\*Phase 2:)/, starter + '\n\n$1');
  }

  private addPlenary(text: string, topic: string): string {
    const plenary = `\n\n**Additional Closure Activity**
• Think-Pair-Share: "What was the most important thing you learned about ${topic || 'the topic'} today?"
• One-word summary: Each learner says one word that describes what they learned.`;
    return text.replace(/(\*\*Assessment)/, plenary + '\n\n$1');
  }

  private addCoreCompetency(text: string): string {
    const comp = `\n• Cultural Identity and Global Citizenship (CG)`;
    return text.replace(/(Core Competencies[\s\S]*?)(\n\n)/, `$1${comp}$2`);
  }

  private expandContent(text: string, topic: string, subject: string): string {
    // Add more detail to the main activity
    const expansion = `\n\n**Extended Explanation**
• Provide a detailed step-by-step breakdown of ${topic || 'the topic'}.
• Use multiple examples from different contexts.
• Include common misconceptions and how to address them.
• Cross-reference with other topics in ${subject || 'the subject'}.`;
    return text.replace(/(\*\*Phase 3:)/, expansion + '\n\n$1');
  }

  private shortenContent(text: string): string {
    // Remove the additional/extended sections
    return text
      .replace(/\n\n\*\*Additional Activity[\s\S]*?(?=\n\n\*\*)/g, '')
      .replace(/\n\n\*\*Additional Assessment Questions[\s\S]*?(?=\n\n\*\*)/g, '')
      .replace(/\n\n\*\*Extended Explanation[\s\S]*?(?=\n\n\*\*)/g, '')
      .replace(/\n\n\*\*Additional Starter Activity[\s\S]*?(?=\n\n\*\*)/g, '')
      .replace(/\n\n\*\*Additional Closure Activity[\s\S]*?(?=\n\n\*\*)/g, '');
  }

  private simplifyLanguage(text: string): string {
    return text
      .replace(/investigate/g, 'look at')
      .replace(/analyse/g, 'study')
      .replace(/evaluate/g, 'check')
      .replace(/construct/g, 'build')
      .replace(/demonstrate/g, 'show')
      .replace(/facilitate/g, 'help')
      .replace(/misconceptions/g, 'wrong ideas')
      .replace(/scaffolding/g, 'support')
      .replace(/differentiation/g, 'different ways to help');
  }

  private addGroupWork(text: string, topic: string): string {
    const gw = `\n\n**Group Work Activity**
• Form heterogeneous groups of 4–5 learners.
• Assign roles: leader, recorder, presenter, timekeeper.
• Task: Discuss and list 5 things about ${topic || 'the topic'}.
• Groups present findings; class discusses.`;
    return text.replace(/(\*\*Phase 3:)/, gw + '\n\n$1');
  }

  private addGame(text: string, topic: string): string {
    const game = `\n\n**Educational Game**
• Play a game related to ${topic || 'the topic'}: e.g., "Simon Says" with topic-related commands, or a matching game.
• Keep it fun and brief (3–5 minutes).
• Use the game to reinforce key concepts.`;
    return text.replace(/(\*\*Phase 3:)/, game + '\n\n$1');
  }

  private addSong(text: string, topic: string): string {
    const song = `\n\n**Song/Rhyme**
• Teach a simple song or rhyme about ${topic || 'the topic'}.
• Use a familiar tune with new words about the topic.
• Learners sing together with actions.`;
    return text.replace(/(\*\*Phase 3:)/, song + '\n\n$1');
  }

  private addExample(text: string, topic: string): string {
    const example = `\n\n**Additional Examples**
• Example 1: [Teacher provides a concrete example of ${topic || 'the topic'} from everyday life]
• Example 2: [Teacher provides a second example from a different context]
• Example 3: [Learners create their own example]`;
    return text.replace(/(\*\*Phase 3:)/, example + '\n\n$1');
  }

  private applyGeneralInstruction(text: string, instruction: string, topic: string): string {
    // Append the teacher's instruction as a note and make a reasonable modification
    const note = `\n\n**Teacher's Note**
• ${instruction}
• (Please review and adjust the lesson plan accordingly.)`;
    return text + note;
  }

  // ── Format converter ──

  private toGESFormat(plan: GESLessonPlanResult): string {
    return `GENERAL INFORMATION
═══════════════════
Name of School: ${plan.schoolName}
District: ${plan.district}
Region: ${plan.region}
Name of Class Teacher: ${plan.teacherName}
Class: ${plan.classForm}
Subject: ${plan.subject}
Week: ${plan.week}
Term: ${plan.term}
Date: ${plan.date}
Duration: ${plan.duration}
Boys: ${plan.boys}    Girls: ${plan.girls}
Average Age of Pupils: ${plan.averageAge}

CURRICULUM ALIGNMENT
═══════════════════
Strand: ${plan.strand}
Sub-Strand: ${plan.subStrand}
Indicator: ${plan.indicator}
Content Standard: ${plan.contentStandard}

CORE COMPETENCIES
═════════════════
${plan.coreCompetencies.map((c, i) => `${i + 1}. ${c}`).join('\n')}

LEARNING OBJECTIVES
═══════════════════
${plan.learningObjectives}

TEACHING AND LEARNING RESOURCES (TLMs)
══════════════════════════════════════
${plan.teachingLearningResources.map((r, i) => `${i + 1}. ${r}`).join('\n')}

LESSON DELIVERY
═══════════════

${plan.starter}

${plan.mainActivity}

${plan.plenary}

ASSESSMENT
═══════════
${plan.assessment}

HOMEWORK / ASSIGNMENT
═════════════════════
${plan.homework}

DIFFERENTIATION / INCLUSION
═══════════════════════════
${plan.differentiation}

REFLECTION (To be completed after lesson)
═════════════════════════════════════════
${plan.reflection || '..........................................................................................'}

═══════════════════════════════════════════════════════════════
Vetted by: .................................... Signature: .................... Date: ............
═══════════════════════════════════════════════════════════════`;
  }
}
