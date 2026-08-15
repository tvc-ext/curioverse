import 'package:shared_preferences/shared_preferences.dart';

import '../models/child_profile.dart';

abstract interface class ProfileStore {
  Future<ChildProfile?> load();
  Future<void> save(ChildProfile profile);
  Future<void> clear();
}

class SharedPreferencesProfileStore implements ProfileStore {
  SharedPreferencesProfileStore(this.preferences);

  static const _ageBandKey = 'child_profile.age_band';
  static const _avatarIdKey = 'child_profile.avatar_id';

  final SharedPreferences preferences;

  @override
  Future<ChildProfile?> load() async {
    final ageBand = preferences.getString(_ageBandKey);
    final avatarId = preferences.getString(_avatarIdKey);
    if (ageBand == null || avatarId == null) return null;

    return ChildProfile(
      ageBand: AgeBand.fromName(ageBand),
      avatarId: avatarId,
    );
  }

  @override
  Future<void> save(ChildProfile profile) async {
    await preferences.setString(_ageBandKey, profile.ageBand.name);
    await preferences.setString(_avatarIdKey, profile.avatarId);
  }

  @override
  Future<void> clear() async {
    await preferences.remove(_ageBandKey);
    await preferences.remove(_avatarIdKey);
  }
}

class MemoryProfileStore implements ProfileStore {
  MemoryProfileStore([this.profile]);

  ChildProfile? profile;

  @override
  Future<ChildProfile?> load() async => profile;

  @override
  Future<void> save(ChildProfile profile) async {
    this.profile = profile;
  }

  @override
  Future<void> clear() async {
    profile = null;
  }
}
