import 'child_profile.dart';

enum QuizDifficulty { easy, medium, hard }

class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.id = '',
    this.difficulty = QuizDifficulty.easy,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String id;
  final QuizDifficulty difficulty;
}

class LearningTopic {
  const LearningTopic({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.colorValue,
    required this.ageBands,
    required this.storyTitle,
    required this.storyPages,
    required this.questions,
  });

  final String id;
  final String emoji;
  final String title;
  final String subtitle;
  final int colorValue;
  final Set<AgeBand> ageBands;
  final String storyTitle;
  final List<String> storyPages;
  final List<QuizQuestion> questions;

  bool supports(AgeBand ageBand) => ageBands.contains(ageBand);
}

const moonTopic = LearningTopic(
  id: 'moon_phases',
  emoji: '🌙',
  title: 'Moon Shapes',
  subtitle: 'Why does the Moon seem to change?',
  colorValue: 0xFFE5E1FF,
  ageBands: {
    AgeBand.explorer6to8,
    AgeBand.adventurer9to11,
    AgeBand.creator12to14,
  },
  storyTitle: 'The Moon’s light-and-shadow dance',
  storyPages: [
    'The Moon does not make its own light. Sunlight shines on half of it—just like a lamp lighting one side of a ball.',
    'As the Moon travels around Earth, we see different amounts of its bright half. Those views are called phases.',
    'The Moon itself is still round. A new moon, crescent, half moon and full moon are different views of the same Moon.',
  ],
  questions: [
    QuizQuestion(
      prompt: 'Where does the Moon’s visible light come from?',
      options: ['The Moon makes it', 'The Sun', 'Earth’s oceans'],
      correctIndex: 1,
      explanation: 'Correct—the Moon reflects sunlight toward Earth.',
    ),
    QuizQuestion(
      prompt: 'Why does the Moon appear to change shape?',
      options: [
        'Clouds cut pieces away',
        'We see different parts of its sunlit half',
        'It grows and shrinks',
      ],
      correctIndex: 1,
      explanation: 'As the Moon orbits Earth, our view of its bright half changes.',
    ),
    QuizQuestion(
      prompt: 'What shape is the Moon all the time?',
      options: ['Round like a ball', 'A flat circle', 'A crescent'],
      correctIndex: 0,
      explanation: 'The Moon is always a round world, even when only a crescent is lit.',
    ),
  ],
);

const learningTopics = [
  moonTopic,
  LearningTopic(
    id: 'dinosaur_detective',
    emoji: '🦖',
    title: 'Dinosaur Detective',
    subtitle: 'Read clues hidden in fossils',
    colorValue: 0xFFD9F7E7,
    ageBands: {
      AgeBand.explorer6to8,
      AgeBand.adventurer9to11,
    },
    storyTitle: 'Fossils are messages from deep time',
    storyPages: [
      'A fossil can be a bone, tooth, footprint or even a nest preserved in rock for millions of years.',
      'Scientists compare shapes and layers of rock to learn how a dinosaur moved, ate and lived.',
      'One clue is rarely enough. Dinosaur detectives combine many clues and change their ideas when new evidence appears.',
    ],
    questions: [
      QuizQuestion(
        prompt: 'Which one can become a fossil clue?',
        options: ['A footprint', 'A rainbow', 'A shadow'],
        correctIndex: 0,
        explanation: 'Footprints can harden and be preserved in layers of rock.',
      ),
      QuizQuestion(
        prompt: 'Why do scientists compare several fossils?',
        options: ['To make a stronger explanation', 'To make them shiny', 'To guess faster'],
        correctIndex: 0,
        explanation: 'Several independent clues give scientists a more reliable picture.',
      ),
      QuizQuestion(
        prompt: 'What should a scientist do when new evidence disagrees?',
        options: ['Hide it', 'Update the idea', 'Break the fossil'],
        correctIndex: 1,
        explanation: 'Science improves when explanations change to match good evidence.',
      ),
    ],
  ),
  LearningTopic(
    id: 'ai_pattern_lab',
    emoji: '🤖',
    title: 'AI Pattern Lab',
    subtitle: 'Teach a tiny machine with examples',
    colorValue: 0xFFFFE3D8,
    ageBands: {
      AgeBand.adventurer9to11,
      AgeBand.creator12to14,
    },
    storyTitle: 'How machines learn from examples',
    storyPages: [
      'An AI model looks for patterns in examples. Show many labelled cats and dogs, and it begins learning useful differences.',
      'Good examples matter. If the examples are wrong, too few, or unfairly selected, the model can learn the wrong pattern.',
      'AI does not understand like a person. People must check its answers, protect private information and decide when not to use it.',
    ],
    questions: [
      QuizQuestion(
        prompt: 'What does an AI model learn from?',
        options: ['Examples and patterns', 'Magic', 'Only batteries'],
        correctIndex: 0,
        explanation: 'Models learn mathematical patterns from the examples they receive.',
      ),
      QuizQuestion(
        prompt: 'What can happen with poor or unfair examples?',
        options: ['The AI may learn a bad pattern', 'Nothing', 'The screen grows'],
        correctIndex: 0,
        explanation: 'Training data strongly affects the quality and fairness of AI results.',
      ),
      QuizQuestion(
        prompt: 'Who should check important AI answers?',
        options: ['A responsible person', 'Nobody', 'Another random answer'],
        correctIndex: 0,
        explanation: 'Human judgement is essential for important, sensitive or uncertain decisions.',
      ),
    ],
  ),
  LearningTopic(
    id: 'ocean_networks',
    emoji: '🐙',
    title: 'Ocean Networks',
    subtitle: 'Discover how sea life connects',
    colorValue: 0xFFD9F2FF,
    ageBands: {
      AgeBand.creator12to14,
    },
    storyTitle: 'A living web beneath the waves',
    storyPages: [
      'Ocean life forms a food web. Tiny phytoplankton use sunlight, small animals eat them, and larger animals depend on both.',
      'Energy moves through the web, while nutrients cycle through water, organisms and the seafloor.',
      'Removing one species or changing temperature can affect distant parts of the network. Healthy variety helps ecosystems recover.',
    ],
    questions: [
      QuizQuestion(
        prompt: 'What starts many ocean food webs?',
        options: ['Phytoplankton using sunlight', 'Plastic', 'Sand alone'],
        correctIndex: 0,
        explanation: 'Phytoplankton capture sunlight and support much of the ocean food web.',
      ),
      QuizQuestion(
        prompt: 'Why can one species affect many others?',
        options: ['Species are connected in a food web', 'Oceans are empty', 'They never interact'],
        correctIndex: 0,
        explanation: 'Food, shelter and nutrient connections link species across an ecosystem.',
      ),
      QuizQuestion(
        prompt: 'What often helps ecosystems recover from change?',
        options: ['Healthy biodiversity', 'Removing every predator', 'More pollution'],
        correctIndex: 0,
        explanation: 'Biodiversity provides multiple relationships and responses to disturbance.',
      ),
    ],
  ),
  LearningTopic(
    id: 'isro_mission_lab',
    emoji: '🇮🇳',
    title: 'ISRO Mission Lab',
    subtitle: 'Explore India’s journeys to space',
    colorValue: 0xFFFFE7C2,
    ageBands: {
      AgeBand.explorer6to8,
      AgeBand.adventurer9to11,
      AgeBand.creator12to14,
    },
    storyTitle: 'From India to the Moon, Mars and Sun',
    storyPages: [
      'ISRO is India’s space agency. Its rockets carry satellites and science missions beyond Earth while teams on the ground guide each journey.',
      'Chandrayaan-3 carried the Vikram lander and Pragyan rover to the Moon. The mission made India the first country to land near the lunar south polar region.',
      'India also sent the Mars Orbiter Mission toward Mars and Aditya-L1 to study the Sun. Each mission uses instruments to turn light, heat and motion into scientific data.',
    ],
    questions: [
      QuizQuestion(
        prompt: 'What was Vikram in the Chandrayaan-3 mission?',
        options: ['A lunar lander', 'A telescope on Earth', 'A submarine'],
        correctIndex: 0,
        explanation: 'Vikram was the lander; Pragyan was the rover it carried.',
      ),
      QuizQuestion(
        prompt: 'What does Aditya-L1 study?',
        options: ['The Sun', 'Ocean reefs', 'Dinosaur fossils'],
        correctIndex: 0,
        explanation: 'Aditya-L1 observes the Sun and helps scientists study solar activity and space weather.',
      ),
      QuizQuestion(
        prompt: 'Why do space missions carry scientific instruments?',
        options: ['To collect measurements', 'Only for decoration', 'To make sound in space'],
        correctIndex: 0,
        explanation: 'Instruments collect measurements that scientists study back on Earth.',
      ),
    ],
  ),
  LearningTopic(
    id: 'india_time_travel',
    emoji: '🏛️',
    title: 'India Time Travel',
    subtitle: 'Follow clues across Indian history',
    colorValue: 0xFFE8F4D8,
    ageBands: {
      AgeBand.explorer6to8,
      AgeBand.adventurer9to11,
      AgeBand.creator12to14,
    },
    storyTitle: 'Many eras, ideas and voices',
    storyPages: [
      'Indian history stretches across thousands of years. Archaeologists study cities of the Indus Valley, including carefully planned streets, wells and drainage systems.',
      'Emperor Ashoka ruled much of the subcontinent in the third century BCE. His messages carved on rocks and pillars encouraged ethical conduct and care for people and animals.',
      'Centuries later, India’s freedom movement brought together many leaders, communities and methods. Independence arrived in 1947, followed by the adoption of India’s Constitution in 1950.',
    ],
    questions: [
      QuizQuestion(
        prompt: 'How do we learn about Indus Valley cities?',
        options: ['Archaeological evidence', 'Satellite television', 'Robot diaries'],
        correctIndex: 0,
        explanation: 'Buildings, objects, seals and other archaeological evidence reveal clues about ancient life.',
      ),
      QuizQuestion(
        prompt: 'Where were many of Ashoka’s messages recorded?',
        options: ['On rocks and pillars', 'In mobile apps', 'On spacecraft'],
        correctIndex: 0,
        explanation: 'Ashokan edicts were inscribed on rocks and pillars across his empire.',
      ),
      QuizQuestion(
        prompt: 'When did the Constitution of India come into effect?',
        options: ['1950', '1850', '2050'],
        correctIndex: 0,
        explanation: 'The Constitution came into effect on 26 January 1950.',
      ),
    ],
  ),
  LearningTopic(
    id: 'seven_wonders',
    emoji: '🌍',
    title: 'Seven Wonders Quest',
    subtitle: 'Visit remarkable places around the world',
    colorValue: 0xFFFFE2D1,
    ageBands: {
      AgeBand.explorer6to8,
      AgeBand.adventurer9to11,
      AgeBand.creator12to14,
    },
    storyTitle: 'Seven extraordinary human-made places',
    storyPages: [
      'The New Seven Wonders are the Great Wall of China, Petra, the Colosseum, Chichén Itzá, Machu Picchu, the Taj Mahal and Christ the Redeemer.',
      'They were created in different places and centuries. Their builders solved challenges involving stone, transport, water, height, decoration and large communities.',
      'The Taj Mahal in Agra was commissioned by the Mughal emperor Shah Jahan. Today, caring for all seven sites helps protect history for future explorers.',
    ],
    questions: [
      QuizQuestion(
        prompt: 'Which New Wonder is in India?',
        options: ['Taj Mahal', 'Machu Picchu', 'Colosseum'],
        correctIndex: 0,
        explanation: 'The Taj Mahal is in Agra, India.',
      ),
      QuizQuestion(
        prompt: 'Why should historic sites be protected?',
        options: ['They preserve evidence and stories', 'To hide them', 'To stop learning'],
        correctIndex: 0,
        explanation: 'Conservation protects physical evidence and cultural stories for future generations.',
      ),
      QuizQuestion(
        prompt: 'Are all seven wonders from the same century?',
        options: ['No', 'Yes', 'They were built yesterday'],
        correctIndex: 0,
        explanation: 'They come from different societies and periods of history.',
      ),
    ],
  ),
  LearningTopic(
    id: 'human_evolution',
    emoji: '🧬',
    title: 'Human Evolution',
    subtitle: 'Follow our changing family tree',
    colorValue: 0xFFE5F0FF,
    ageBands: {
      AgeBand.adventurer9to11,
      AgeBand.creator12to14,
    },
    storyTitle: 'A branching human family tree',
    storyPages: [
      'Humans are primates. We share ancient common ancestors with other apes, but modern humans did not evolve from the apes living today.',
      'Fossils, tools and DNA reveal a branching family tree with several human species. Homo sapiens emerged in Africa roughly 300,000 years ago.',
      'Evolution happens across many generations as inherited traits vary. Culture, cooperation, language and technology also shaped the human journey.',
    ],
    questions: [
      QuizQuestion(
        prompt: 'What shape best describes human evolution?',
        options: ['A branching family tree', 'A straight ladder', 'A single-day change'],
        correctIndex: 0,
        explanation: 'Many related populations and species form branches, not a simple straight line.',
      ),
      QuizQuestion(
        prompt: 'Which evidence helps scientists study human evolution?',
        options: ['Fossils and DNA', 'Only guesses', 'Weather forecasts alone'],
        correctIndex: 0,
        explanation: 'Fossils, archaeology and genetics provide independent evidence.',
      ),
      QuizQuestion(
        prompt: 'Where did Homo sapiens emerge?',
        options: ['Africa', 'The Moon', 'Antarctica'],
        correctIndex: 0,
        explanation: 'Current fossil and genetic evidence places the emergence of Homo sapiens in Africa.',
      ),
    ],
  ),
  LearningTopic(
    id: 'animal_detective',
    emoji: '🐾',
    title: 'Animal Detective',
    subtitle: 'Identify animals using visual clues',
    colorValue: 0xFFDDF6D8,
    ageBands: {
      AgeBand.explorer6to8,
      AgeBand.adventurer9to11,
      AgeBand.creator12to14,
    },
    storyTitle: 'Look closely: every animal carries clues',
    storyPages: [
      'Animal detectives notice body covering, feet, beaks, teeth, ears and tails. A tiger has stripes; an Indian peafowl has a crest and colourful train feathers.',
      'Habitats add clues. Fins and gills suit life in water, while broad wings and feathers help birds move through air.',
      'One picture may not reveal everything. A careful scientist records visible clues, compares reliable references and stays uncertain when evidence is weak.',
    ],
    questions: [
      QuizQuestion(
        prompt: 'Which clue strongly suggests an animal is a bird?',
        options: ['Feathers', 'Fur', 'Scales alone'],
        correctIndex: 0,
        explanation: 'All living birds have feathers.',
      ),
      QuizQuestion(
        prompt: 'Which animal is famous for dark stripes on orange fur?',
        options: ['Tiger', 'Dolphin', 'Peafowl'],
        correctIndex: 0,
        explanation: 'A tiger’s stripe pattern is also unique to the individual.',
      ),
      QuizQuestion(
        prompt: 'What should you do when a photo lacks enough clues?',
        options: ['Say you are uncertain', 'Invent an answer', 'Ignore evidence'],
        correctIndex: 0,
        explanation: 'Responsible identification includes uncertainty when evidence is incomplete.',
      ),
    ],
  ),

];
