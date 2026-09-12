/**
 * AI Assignment & Quiz Generator
 * Generates assignments, quizzes, and exams aligned with GES lesson plans.
 * Uses Bloom's Taxonomy cognitive domains:
 *   - Recall (Knowledge)
 *   - Comprehension (Understanding)
 *   - Application
 *   - Analysis
 *   - Evaluation
 *   - Synthesis (Creation)
 */
import { findSubject, getWeekContent, findClassLevel } from './ges-curriculum-data';

export type QuestionFormat = 'MCQ' | 'True/False' | 'Short Answer' | 'Essay' | 'Fill in the Blank';
export type CognitiveLevel = 'Recall' | 'Comprehension' | 'Application' | 'Analysis' | 'Evaluation' | 'Synthesis';
export type AssessmentType = 'Assignment' | 'Quiz' | 'Exam' | 'Class Exercise' | 'Homework';

export interface GenerateAssessmentRequest {
  classForm: string;
  subject: string;
  topic?: string;
  week?: string;
  term?: string;
  lessonPlanTopic?: string;     // The sub-strand/topic from the lesson plan
  strand?: string;
  subStrand?: string;
  indicator?: string;
  assessmentType: AssessmentType;
  questionCount: number;
  formats: QuestionFormat[];     // e.g., ['MCQ', 'True/False', 'Short Answer']
  cognitiveLevels: CognitiveLevel[];  // e.g., ['Recall', 'Application']
  schoolName?: string;
  teacherName?: string;
  duration?: number;             // minutes
  maxScore?: number;
}

export interface GeneratedQuestion {
  number: number;
  format: QuestionFormat;
  cognitiveLevel: CognitiveLevel;
  question: string;
  options?: string[];           // for MCQ
  correctAnswer: string;
  marks: number;
  explanation?: string;
}

export interface GeneratedAssessment {
  title: string;
  assessmentType: AssessmentType;
  classForm: string;
  subject: string;
  topic: string;
  strand: string;
  subStrand: string;
  indicator: string;
  week: string;
  term: string;
  duration: number;
  maxScore: number;
  schoolName: string;
  teacherName: string;
  date: string;
  instructions: string;
  questions: GeneratedQuestion[];
  rawContent: string;
}

// ── Bloom's Taxonomy Question Stems ──
const QUESTION_STEMS: Record<CognitiveLevel, string[]> = {
  Recall: [
    'Define {topic}.',
    'What is {topic}?',
    'List the key features of {topic}.',
    'Name three examples of {topic}.',
    'State the main characteristics of {topic}.',
    'Identify the components of {topic}.',
    'Write down the formula for {topic}.',
    'Recall the definition of {topic}.',
  ],
  Comprehension: [
    'Explain {topic} in your own words.',
    'Describe how {topic} works.',
    'Summarize the key points about {topic}.',
    'Why is {topic} important?',
    'Compare and contrast {topic} with a related concept.',
    'What is the difference between {topic} and other concepts?',
    'How would you classify {topic}?',
    'Interpret the meaning of {topic} in the given context.',
  ],
  Application: [
    'Apply {topic} to solve the following problem: [teacher provides problem].',
    'Calculate {topic} given the following data: [teacher provides data].',
    'Use {topic} to explain a real-life situation.',
    'Demonstrate how {topic} works using an example.',
    'Solve the following using {topic}: [teacher provides question].',
    'How would you use {topic} in everyday life?',
    'Construct a model/diagram showing {topic}.',
    'Practise {topic} by completing the following exercise.',
  ],
  Analysis: [
    'Analyse the relationship between {topic} and {related}.',
    'What are the causes and effects of {topic}?',
    'Break down {topic} into its component parts.',
    'Differentiate between the types of {topic}.',
    'Examine the factors that influence {topic}.',
    'Investigate why {topic} behaves in a certain way.',
    'What evidence supports the concept of {topic}?',
    'Compare and contrast different approaches to {topic}.',
  ],
  Evaluation: [
    'Evaluate the effectiveness of {topic} in [context].',
    'Critically assess the importance of {topic}.',
    'Justify why {topic} is necessary in {subject}.',
    'Argue for or against the use of {topic}.',
    'What is your opinion on {topic}? Support your answer.',
    'Judge the significance of {topic} in real life.',
    'Recommend improvements to {topic}.',
    'Assess the impact of {topic} on society.',
  ],
  Synthesis: [
    'Design a solution using {topic}.',
    'Create a project that demonstrates {topic}.',
    'Propose a new way to apply {topic}.',
    'Develop a plan that incorporates {topic}.',
    'Formulate a hypothesis about {topic}.',
    'Construct an argument that integrates {topic}.',
    'Invent a method to teach {topic} to younger learners.',
    'Compose a piece of work that illustrates {topic}.',
  ],
};

// ── MCQ Distractor Generator ──
function generateMCQOptions(topic: string, cognitiveLevel: CognitiveLevel, subject: string): { options: string[]; correctAnswer: string } {
  const correct = `The correct definition/application of ${topic}`;
  const distractors = [
    `A common misconception about ${topic}`,
    `The opposite of ${topic}`,
    `A related but incorrect concept to ${topic}`,
    `An incomplete description of ${topic}`,
  ];
  // Shuffle
  const all = [correct, ...distractors].sort(() => Math.random() - 0.5);
  const labels = ['A', 'B', 'C', 'D', 'E'];
  const options = all.map((opt, i) => `${labels[i]}. ${opt}`);
  const correctIdx = all.indexOf(correct);
  return { options, correctAnswer: labels[correctIdx] };
}

// ── True/False Generator ──
function generateTrueFalse(topic: string, cognitiveLevel: CognitiveLevel): { options: string[]; correctAnswer: string } {
  const statements = [
    { text: `${topic} is a key concept in this subject.`, answer: 'True' },
    { text: `${topic} has no real-world application.`, answer: 'False' },
    { text: `Understanding ${topic} helps in solving related problems.`, answer: 'True' },
    { text: `${topic} is unrelated to the previous lesson.`, answer: 'False' },
    { text: `The concept of ${topic} can be applied in daily life.`, answer: 'True' },
    { text: `${topic} is only theoretical and has no practical use.`, answer: 'False' },
  ];
  const selected = statements[Math.floor(Math.random() * statements.length)];
  return { options: ['True', 'False'], correctAnswer: selected.answer };
}

// ── Fill in the Blank Generator ──
function generateFillBlank(topic: string): { question: string; correctAnswer: string } {
  const templates = [
    { q: `The term used to describe ${topic} is called ________________.`, a: topic },
    { q: `_______________ is the process/concept where ${topic} is applied.`, a: topic },
    { q: `A key feature of ${topic} is that it ________________.`, a: '[teacher to verify]' },
    { q: `In ${topic}, the main principle is ________________.`, a: '[teacher to verify]' },
  ];
  const selected = templates[Math.floor(Math.random() * templates.length)];
  return { question: selected.q, correctAnswer: selected.a };
}

// ── Assessment Instructions ──
function getInstructions(assessmentType: AssessmentType, duration: number, maxScore: number): string {
  const base = `INSTRUCTIONS: Read all questions carefully before answering. This ${assessmentType.toLowerCase()} consists of questions aligned with the GES/NaCCA curriculum.`;
  const time = `Time allowed: ${duration} minutes.`;
  const score = `Total marks: ${maxScore}.`;
  const rules = assessmentType === 'Exam'
    ? 'Answer ALL questions. Write your index number and class on the answer booklet. No communication during the examination.'
    : assessmentType === 'Quiz'
    ? 'Answer ALL questions. Choose the best answer for each question.'
    : 'Answer all questions to the best of your ability. Show your working where applicable.';
  return `${base}\n${time}\n${score}\n${rules}`;
}

export class AssessmentGenerator {
  generate(req: GenerateAssessmentRequest): GeneratedAssessment {
    const classLevel = findClassLevel(req.classForm);
    const subject = findSubject(req.classForm, req.subject);
    const weekNum = parseInt(req.week || '1', 10) || 1;
    const termNum = parseInt(req.term || '1', 10) || 1;
    const weekContent = getWeekContent(req.classForm, req.subject, weekNum, termNum);

    const topic = req.lessonPlanTopic || req.topic || weekContent?.content || subject?.strands[0]?.subStrands[0]?.content || `${req.subject} topic`;
    const strand = req.strand || subject?.strands[0]?.name || 'General';
    const subStrand = req.subStrand || weekContent?.name || subject?.strands[0]?.subStrands[0]?.name || 'General Topic';
    const indicator = req.indicator || weekContent?.indicator || subject?.strands[0]?.subStrands[0]?.indicator || 'N/A';

    const level = classLevel?.level || 'primary';
    const duration = req.duration || (req.assessmentType === 'Exam' ? 120 : req.assessmentType === 'Quiz' ? 30 : 60);
    const marksPerQuestion = req.assessmentType === 'Exam' ? (level === 'shs' ? 5 : 3) : 2;
    const maxScore = req.maxScore || req.questionCount * marksPerQuestion;

    // Generate questions
    const questions: GeneratedQuestion[] = [];
    for (let i = 0; i < req.questionCount; i++) {
      const format = req.formats[i % req.formats.length];
      const cognitiveLevel = req.cognitiveLevels[i % req.cognitiveLevels.length];
      const stems = QUESTION_STEMS[cognitiveLevel];
      const stem = stems[i % stems.length].replace(/\{topic\}/g, topic).replace(/\{subject\}/g, req.subject).replace(/\{related\}/g, subStrand);

      let question = stem;
      let options: string[] | undefined;
      let correctAnswer = '';

      if (format === 'MCQ') {
        const mcq = generateMCQOptions(topic, cognitiveLevel, req.subject);
        options = mcq.options;
        correctAnswer = mcq.correctAnswer;
        question = stem;
      } else if (format === 'True/False') {
        const tf = generateTrueFalse(topic, cognitiveLevel);
        options = tf.options;
        correctAnswer = tf.correctAnswer;
        question = `True or False: ${stem.replace(/\.$/, '')}`;
      } else if (format === 'Fill in the Blank') {
        const fb = generateFillBlank(topic);
        question = fb.question;
        correctAnswer = fb.correctAnswer;
      } else if (format === 'Short Answer') {
        correctAnswer = `[Expected: A brief answer about ${topic} at the ${cognitiveLevel} level]`;
      } else if (format === 'Essay') {
        correctAnswer = `[Expected: A detailed essay about ${topic} demonstrating ${cognitiveLevel} skills]`;
      }

      questions.push({
        number: i + 1,
        format,
        cognitiveLevel,
        question,
        options,
        correctAnswer,
        marks: marksPerQuestion,
        explanation: `This question tests ${cognitiveLevel.toLowerCase()} of ${topic}.`,
      });
    }

    const title = `${req.assessmentType}: ${req.subject} - ${subStrand} (${req.classForm.toUpperCase()}, Week ${req.week || 1})`;
    const date = new Date().toISOString().slice(0, 10);

    const result: GeneratedAssessment = {
      title,
      assessmentType: req.assessmentType,
      classForm: req.classForm,
      subject: req.subject,
      topic,
      strand,
      subStrand,
      indicator,
      week: req.week || '1',
      term: req.term || 'Term 1',
      duration,
      maxScore,
      schoolName: req.schoolName || '…………………………………………',
      teacherName: req.teacherName || '…………………………………………',
      date,
      instructions: getInstructions(req.assessmentType, duration, maxScore),
      questions,
      rawContent: '',
    };

    result.rawContent = this.toTextFormat(result);
    return result;
  }

  private toTextFormat(a: GeneratedAssessment): string {
    let text = `${a.title}\n`;
    text += `${'='.repeat(70)}\n\n`;
    text += `School: ${a.schoolName}\n`;
    text += `Teacher: ${a.teacherName}\n`;
    text += `Class: ${a.classForm}    Subject: ${a.subject}\n`;
    text += `Week: ${a.week}    Term: ${a.term}    Date: ${a.date}\n`;
    text += `Duration: ${a.duration} minutes    Total Marks: ${a.maxScore}\n`;
    text += `Strand: ${a.strand}\n`;
    text += `Sub-Strand: ${a.subStrand}\n`;
    text += `Indicator: ${a.indicator}\n`;
    text += `Topic: ${a.topic}\n\n`;
    text += `${a.instructions}\n\n`;
    text += `${'='.repeat(70)}\n\n`;

    // Group by format
    const byFormat: Record<string, GeneratedQuestion[]> = {};
    a.questions.forEach((q) => {
      if (!byFormat[q.format]) byFormat[q.format] = [];
      byFormat[q.format].push(q);
    });

    let sectionNum = 1;
    for (const [format, qs] of Object.entries(byFormat)) {
      text += `SECTION ${sectionNum}: ${format.toUpperCase()} QUESTIONS\n`;
      text += `${'-'.repeat(50)}\n`;
      text += `(Cognitive Level: ${qs[0].cognitiveLevel} | Marks per question: ${qs[0].marks})\n\n`;

      qs.forEach((q, i) => {
        text += `${q.number}. ${q.question} [${q.marks} marks]\n`;
        if (q.options) {
          q.options.forEach((opt) => { text += `   ${opt}\n`; });
        }
        text += `   (Cognitive Level: ${q.cognitiveLevel})\n`;
        text += `   Answer: ${q.correctAnswer}\n`;
        text += `   Explanation: ${q.explanation}\n\n`;
      });
      sectionNum++;
    }

    text += `${'='.repeat(70)}\n`;
    text += `MARKING SCHEME / ANSWER KEY\n`;
    text += `${'='.repeat(70)}\n\n`;
    a.questions.forEach((q) => {
      text += `Q${q.number}: ${q.correctAnswer} [${q.marks} marks]\n`;
    });
    text += `\nTotal: ${a.maxScore} marks\n`;
    text += `${'='.repeat(70)}\n`;

    return text;
  }
}
