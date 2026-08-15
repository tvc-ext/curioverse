import 'package:curioverse/models/child_profile.dart';
import 'package:curioverse/models/learning_topic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ISRO and Indian history adventures serve every age band', () {
    final isro =
        learningTopics.singleWhere((topic) => topic.id == 'isro_mission_lab');
    final history =
        learningTopics.singleWhere((topic) => topic.id == 'india_time_travel');

    for (final ageBand in AgeBand.values) {
      expect(isro.supports(ageBand), isTrue);
      expect(history.supports(ageBand), isTrue);
    }

    expect(isro.storyPages, hasLength(3));
    expect(isro.questions, hasLength(3));
    expect(history.storyPages, hasLength(3));
    expect(history.questions, hasLength(3));
  });

  test('wonders, evolution and animal packs include stories and quizzes', () {
    for (final id in [
      'seven_wonders',
      'human_evolution',
      'animal_detective',
    ]) {
      final topic = learningTopics.singleWhere((candidate) => candidate.id == id);
      expect(topic.storyPages, hasLength(3));
      expect(topic.questions, hasLength(3));
    }
  });
}
