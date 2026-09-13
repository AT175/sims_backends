// PhET simulation catalog mapped to GES curriculum subjects
export interface PhetLab {
  id: string;
  title: string;
  subject: string;
  classForm: string[];
  topic: string;
  url: string;
  description: string;
  level: 'basic' | 'jhs' | 'shs';
}

export const PHET_LABS: PhetLab[] = [
  // Physics — SHS
  { id: 'phet-circuit-dc', title: 'Circuit Construction Kit (DC)', subject: 'Physics (Elective)', classForm: ['shs1', 'shs2', 'shs3'], topic: 'Electric Circuits', url: 'https://phet.colorado.edu/sims/html/circuit-construction-kit-dc/latest/circuit-construction-kit-dc_en.html', description: 'Build circuits with batteries, resistors, and bulbs. Measure voltage and current.', level: 'shs' },
  { id: 'phet-projectile', title: 'Projectile Motion', subject: 'Physics (Elective)', classForm: ['shs1', 'shs2'], topic: 'Motion', url: 'https://phet.colorado.edu/sims/html/projectile-motion/latest/projectile-motion_en.html', description: 'Investigate factors affecting projectile motion including angle, speed, and mass.', level: 'shs' },
  { id: 'phet-wave-string', title: 'Wave on a String', subject: 'Physics (Elective)', classForm: ['shs1', 'shs2'], topic: 'Waves', url: 'https://phet.colorado.edu/sims/html/wave-on-a-string/latest/wave-on-a-string_en.html', description: 'Watch a string vibrate in slow motion. Adjust frequency and amplitude.', level: 'shs' },
  { id: 'phet-forces-motion', title: 'Forces and Motion: Basics', subject: 'Physics (Elective)', classForm: ['shs1'], topic: 'Forces', url: 'https://phet.colorado.edu/sims/html/forces-and-motion-basics/latest/forces-and-motion-basics_en.html', description: 'Explore forces, friction, and motion with tug-of-war.', level: 'shs' },
  { id: 'phet-ohms-law', title: 'Ohm\'s Law', subject: 'Physics (Elective)', classForm: ['shs1', 'shs2'], topic: 'Electricity', url: 'https://phet.colorado.edu/sims/html/ohms-law/latest/ohms-law_en.html', description: 'See how voltage, current, and resistance are related.', level: 'shs' },
  { id: 'phet-bending-light', title: 'Bending Light', subject: 'Physics (Elective)', classForm: ['shs2'], topic: 'Optics', url: 'https://phet.colorado.edu/sims/html/bending-light/latest/bending-light_en.html', description: 'Explore refraction and reflection of light.', level: 'shs' },
  { id: 'phet-charges-fields', title: 'Charges and Fields', subject: 'Physics (Elective)', classForm: ['shs2', 'shs3'], topic: 'Electrostatics', url: 'https://phet.colorado.edu/sims/html/charges-and-fields/latest/charges-and-fields_en.html', description: 'Arrange charges and measure electric fields.', level: 'shs' },

  // Chemistry — SHS
  { id: 'phet-ph-scale', title: 'pH Scale', subject: 'Chemistry (Elective)', classForm: ['shs1', 'shs2'], topic: 'Acids and Bases', url: 'https://phet.colorado.edu/sims/html/ph-scale/latest/ph-scale_en.html', description: 'Test pH of common liquids and learn about acidity.', level: 'shs' },
  { id: 'phet-balancing-chem', title: 'Balancing Chemical Equations', subject: 'Chemistry (Elective)', classForm: ['shs1', 'shs2'], topic: 'Chemical Reactions', url: 'https://phet.colorado.edu/sims/html/balancing-chemical-equations/latest/balancing-chemical-equations_en.html', description: 'Balance equations and learn about conservation of mass.', level: 'shs' },
  { id: 'phet-molecule-shapes', title: 'Molecule Shapes', subject: 'Chemistry (Elective)', classForm: ['shs2'], topic: 'Molecular Geometry', url: 'https://phet.colorado.edu/sims/html/molecule-shapes/latest/molecule-shapes_en.html', description: 'Build 3D molecules and explore VSEPR theory.', level: 'shs' },
  { id: 'phet-reactants-products', title: 'Reactants, Products and Leftovers', subject: 'Chemistry (Elective)', classForm: ['shs1', 'shs2'], topic: 'Stoichiometry', url: 'https://phet.colorado.edu/sims/html/reactants-products-and-leftovers/latest/reactants-products-and-leftovers_en.html', description: 'Create sandwiches and see how limiting reagents work.', level: 'shs' },
  { id: 'phet-states-matter', title: 'States of Matter', subject: 'Chemistry (Elective)', classForm: ['shs1'], topic: 'States of Matter', url: 'https://phet.colorado.edu/sims/html/states-of-matter/latest/states-of-matter_en.html', description: 'Watch different states of matter and phase changes.', level: 'shs' },

  // Biology — SHS
  { id: 'phet-natural-selection', title: 'Natural Selection', subject: 'Biology (Elective)', classForm: ['shs1', 'shs2'], topic: 'Evolution', url: 'https://phet.colorado.edu/sims/html/natural-selection/latest/natural-selection_en.html', description: 'Observe how traits and environment affect survival.', level: 'shs' },
  { id: 'phet-membrane-channels', title: 'Membrane Channels', subject: 'Biology (Elective)', classForm: ['shs2'], topic: 'Cell Membrane', url: 'https://phet.colorado.edu/sims/html/membrane-channels/latest/membrane-channels_en.html', description: 'Explore how molecules pass through cell membranes.', level: 'shs' },
  { id: 'phet-neuron', title: 'Neuron', subject: 'Biology (Elective)', classForm: ['shs2', 'shs3'], topic: 'Nervous System', url: 'https://phet.colorado.edu/sims/html/neuron/latest/neuron_en.html', description: 'Stimulate a neuron and watch the action potential.', level: 'shs' },
  { id: 'phet-build-molecule', title: 'Build a Molecule', subject: 'Integrated Science (Core)', classForm: ['shs1'], topic: 'Atoms and Molecules', url: 'https://phet.colorado.edu/sims/html/build-a-molecule/latest/build-a-molecule_en.html', description: 'Build molecules from atoms and learn chemical formulas.', level: 'shs' },

  // Math — SHS
  { id: 'phet-graphing-lines', title: 'Graphing Lines', subject: 'Mathematics (Core)', classForm: ['shs1'], topic: 'Linear Equations', url: 'https://phet.colorado.edu/sims/html/graphing-lines/latest/graphing-lines_en.html', description: 'Explore slope-intercept form by graphing lines.', level: 'shs' },
  { id: 'phet-trig-tour', title: 'Trig Tour', subject: 'Elective Mathematics', classForm: ['shs2', 'shs3'], topic: 'Trigonometry', url: 'https://phet.colorado.edu/sims/html/trig-tour/latest/trig-tour_en.html', description: 'Explore the unit circle and trigonometric functions.', level: 'shs' },

  // Basic / JHS Science
  { id: 'phet-balancing-act', title: 'Balancing Act', subject: 'Science', classForm: ['basic4', 'basic5', 'basic6', 'basic7', 'basic8', 'basic9'], topic: 'Forces and Levers', url: 'https://phet.colorado.edu/sims/html/balancing-act/latest/balancing-act_en.html', description: 'Learn about levers and balance with different masses.', level: 'basic' },
  { id: 'phet-energy-skate', title: 'Energy Skate Park: Basics', subject: 'Science', classForm: ['basic6', 'basic7', 'basic8', 'basic9'], topic: 'Energy', url: 'https://phet.colorado.edu/sims/html/energy-skate-park-basics/latest/energy-skate-park-basics_en.html', description: 'Learn about kinetic and potential energy with a skater.', level: 'basic' },
  { id: 'phet-friction', title: 'Friction', subject: 'Science', classForm: ['basic5', 'basic6', 'basic7'], topic: 'Friction', url: 'https://phet.colorado.edu/sims/html/friction/latest/friction_en.html', description: 'Explore how friction affects motion.', level: 'basic' },

  // Basic Math
  { id: 'phet-fraction-matcher', title: 'Fraction Matcher', subject: 'Mathematics', classForm: ['basic3', 'basic4', 'basic5'], topic: 'Fractions', url: 'https://phet.colorado.edu/sims/html/fraction-matcher/latest/fraction-matcher_en.html', description: 'Match fractions with visual representations.', level: 'basic' },
  { id: 'phet-number-line', title: 'Number Line: Integers', subject: 'Mathematics', classForm: ['basic4', 'basic5', 'basic6'], topic: 'Integers', url: 'https://phet.colorado.edu/sims/html/number-line-integers/latest/number-line-integers_en.html', description: 'Explore positive and negative numbers on a number line.', level: 'basic' },
];

// Custom Ghana-specific labs
export interface CustomLab {
  id: string;
  title: string;
  subject: string;
  classForm: string[];
  topic: string;
  description: string;
  type: 'soil' | 'water' | 'circuit' | 'plant' | 'market';
  level: 'basic' | 'jhs' | 'shs';
}

export const CUSTOM_LABS: CustomLab[] = [
  { id: 'gh-soil-testing', title: 'Ghana Soil Testing Lab', subject: 'Integrated Science (Core)', classForm: ['shs1', 'shs2'], topic: 'Soil Science', description: 'Test soil samples from different Ghanaian regions for pH, nutrients, and suitability for crops like cocoa, cassava, and maize.', type: 'soil', level: 'shs' },
  { id: 'gh-water-quality', title: 'Water Quality Testing', subject: 'Integrated Science (Core)', classForm: ['shs1'], topic: 'Environmental Science', description: 'Test water from Volta Lake, boreholes, and taps for safety, pH, and contamination levels.', type: 'water', level: 'shs' },
  { id: 'gh-circuit-builder', title: 'Local Circuit Building', subject: 'Physics (Elective)', classForm: ['shs1', 'shs2'], topic: 'Electric Circuits', description: 'Build circuits using locally available materials. Learn wiring for Ghanaian homes.', type: 'circuit', level: 'shs' },
  { id: 'gh-plant-growth', title: 'Plant Growth Simulation', subject: 'Biology (Elective)', classForm: ['shs1'], topic: 'Plant Biology', description: 'Simulate growing Ghanaian crops (cocoa, yam, plantain) under different conditions.', type: 'plant', level: 'shs' },
  { id: 'gh-market-math', title: 'Market Mathematics', subject: 'Mathematics', classForm: ['basic4', 'basic5', 'basic6', 'basic7'], topic: 'Money and Commerce', description: 'Practice math through Ghanaian market scenarios — buying and selling in Cedis, calculating profit.', type: 'market', level: 'basic' },
];
