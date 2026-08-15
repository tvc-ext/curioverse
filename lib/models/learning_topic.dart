import 'child_profile.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
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
];
