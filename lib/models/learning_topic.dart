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
    storyTitle: 'Coming next',
    storyPages: [],
    questions: [],
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
    storyTitle: 'Coming next',
    storyPages: [],
    questions: [],
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
    storyTitle: 'Coming next',
    storyPages: [],
    questions: [],
  ),
];
