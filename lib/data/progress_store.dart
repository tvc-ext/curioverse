import 'package:shared_preferences/shared_preferences.dart';

class LearningProgress {
  const LearningProgress({
    this.energy = 120,
    this.completedTopicIds = const {},
  });

  final int energy;
  final Set<String> completedTopicIds;

  bool completed(String topicId) => completedTopicIds.contains(topicId);

  LearningProgress complete(String topicId, int reward) {
    if (completed(topicId)) return this;
    return LearningProgress(
      energy: energy + reward,
      completedTopicIds: {...completedTopicIds, topicId},
    );
  }
}

abstract interface class ProgressStore {
  Future<LearningProgress> load();
  Future<void> save(LearningProgress progress);
  Future<void> clear();
}

class SharedPreferencesProgressStore implements ProgressStore {
  SharedPreferencesProgressStore(this.preferences);

  static const _energyKey = 'learning_progress.energy';
  static const _completedKey = 'learning_progress.completed_topics';

  final SharedPreferences preferences;

  @override
  Future<LearningProgress> load() async => LearningProgress(
        energy: preferences.getInt(_energyKey) ?? 120,
        completedTopicIds:
            (preferences.getStringList(_completedKey) ?? const []).toSet(),
      );

  @override
  Future<void> save(LearningProgress progress) async {
    await preferences.setInt(_energyKey, progress.energy);
    await preferences.setStringList(
      _completedKey,
      progress.completedTopicIds.toList()..sort(),
    );
  }

  @override
  Future<void> clear() async {
    await preferences.remove(_energyKey);
    await preferences.remove(_completedKey);
  }
}

class MemoryProgressStore implements ProgressStore {
  MemoryProgressStore([this.progress = const LearningProgress()]);

  LearningProgress progress;

  @override
  Future<LearningProgress> load() async => progress;

  @override
  Future<void> save(LearningProgress progress) async {
    this.progress = progress;
  }

  @override
  Future<void> clear() async {
    progress = const LearningProgress();
  }
}
