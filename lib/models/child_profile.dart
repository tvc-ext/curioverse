enum AgeBand {
  explorer6to8('6–8', 'Little Explorer'),
  adventurer9to11('9–11', 'Curious Adventurer'),
  creator12to14('12–14', 'Young Creator');

  const AgeBand(this.label, this.title);

  final String label;
  final String title;

  static AgeBand fromName(String value) {
    return AgeBand.values.firstWhere(
      (band) => band.name == value,
      orElse: () => AgeBand.adventurer9to11,
    );
  }
}

class AvatarChoice {
  const AvatarChoice({
    required this.id,
    required this.emoji,
    required this.alias,
  });

  final String id;
  final String emoji;
  final String alias;
}

const avatarChoices = [
  AvatarChoice(id: 'nova_fox', emoji: '🦊', alias: 'Nova Fox'),
  AvatarChoice(id: 'pixel_panda', emoji: '🐼', alias: 'Pixel Panda'),
  AvatarChoice(id: 'cosmo_cat', emoji: '🐱', alias: 'Cosmo Cat'),
  AvatarChoice(id: 'astro_owl', emoji: '🦉', alias: 'Astro Owl'),
];

class ChildProfile {
  const ChildProfile({
    required this.ageBand,
    required this.avatarId,
  });

  final AgeBand ageBand;
  final String avatarId;

  AvatarChoice get avatar => avatarChoices.firstWhere(
        (choice) => choice.id == avatarId,
        orElse: () => avatarChoices.first,
      );
}
