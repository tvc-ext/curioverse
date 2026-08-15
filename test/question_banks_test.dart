import 'dart:math';

import 'package:curioverse/data/question_banks.dart';
import 'package:curioverse/models/child_profile.dart';
import 'package:curioverse/models/learning_topic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const topicIds = [
    'moon_phases',
    'dinosaur_detective',
    'ai_pattern_lab',
    'ocean_networks',
    'isro_mission_lab',
    'india_time_travel',
    'seven_wonders',
    'human_evolution',
    'animal_detective',
  ];

  test('older explorers receive a meaningfully harder session', () {
    final young = createQuizSession(
      'moon_phases',
      ageBand: AgeBand.explorer6to8,
      random: Random(17),
    );
    final teen = createQuizSession(
      'moon_phases',
      ageBand: AgeBand.creator12to14,
      random: Random(17),
    );

    expect(
      teen.where((q) => q.difficulty == QuizDifficulty.hard).length,
      greaterThanOrEqualTo(7),
    );
    expect(
      teen.where((q) => q.difficulty == QuizDifficulty.easy),
      isEmpty,
    );
    expect(
      teen.where((q) => q.difficulty == QuizDifficulty.hard).length,
      greaterThan(
        young.where((q) => q.difficulty == QuizDifficulty.hard).length,
      ),
    );
  });

  for (final topicId in topicIds) {
    test('$topicId has a deep, levelled, non-repeating bank', () {
      final bank = questionBankFor(topicId);
      expect(bank, hasLength(greaterThanOrEqualTo(50)));
      expect(bank.map((q) => q.id).toSet(), hasLength(bank.length));
      expect(bank.map((q) => q.prompt).toSet(), hasLength(bank.length));
      expect(
        bank.map((q) => q.difficulty).toSet(),
        containsAll(QuizDifficulty.values),
      );

      final session = createQuizSession(topicId);
      expect(session, hasLength(10));
      final concepts = session.map((q) => q.id.split('-v').first).toSet();
      expect(concepts, hasLength(10));
    });
  }
}
