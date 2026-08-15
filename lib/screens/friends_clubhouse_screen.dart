import 'package:flutter/material.dart';

import '../models/child_profile.dart';

class FriendsClubhouseScreen extends StatefulWidget {
  const FriendsClubhouseScreen({
    required this.profile,
    required this.alreadyCompleted,
    required this.onCompleted,
    super.key,
  });

  final ChildProfile profile;
  final bool alreadyCompleted;
  final Future<void> Function(String activityId, int reward) onCompleted;

  @override
  State<FriendsClubhouseScreen> createState() =>
      _FriendsClubhouseScreenState();
}

class _FriendsClubhouseScreenState extends State<FriendsClubhouseScreen> {
  int? selectedAnswer;
  bool completedNow = false;
  bool saving = false;

  static const crew = [
    ('🐼', 'Pixel Panda', 'Pattern spotter'),
    ('🐱', 'Cosmo Cat', 'Question captain'),
    ('🦉', 'Astro Owl', 'Fact checker'),
  ];

  Future<void> finishMission() async {
    if (selectedAnswer != 1 || saving) return;
    setState(() => saving = true);
    await widget.onCompleted('clubhouse_team_mission', 25);
    if (!mounted) return;
    setState(() {
      saving = false;
      completedNow = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final completed = widget.alreadyCompleted || completedNow;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        Text(
          'Explorer Clubhouse',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 6),
        const Text(
          'A safe, device-only teamwork space using fictional aliases—no public chat or real names.',
        ),
        const SizedBox(height: 18),
        Card(
          color: const Color(0xFFE8E3FF),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(widget.profile.avatar.emoji,
                    style: const TextStyle(fontSize: 52)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.profile.avatar.alias}’s discovery crew',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Private practice crew · 4 explorers'),
                    ],
                  ),
                ),
                const Icon(Icons.verified_user_rounded, color: Colors.green),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Meet your crew',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 10),
        ...crew.map(
          (member) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(child: Text(member.$1)),
                title: Text(member.$2,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text(member.$3),
                trailing: const Icon(Icons.stars_rounded,
                    color: Color(0xFFFFA000)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          color: const Color(0xFF292065),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: completed
                ? const Column(
                    children: [
                      Text('🏆', style: TextStyle(fontSize: 62)),
                      SizedBox(height: 8),
                      Text(
                        'Team mission complete!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Your crew earned the Evidence Expert badge.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFDCD8FF)),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WEEKLY TEAM MISSION · +25 ENERGY',
                        style: TextStyle(
                          color: Color(0xFFFFCB67),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Your crew finds two different answers online. What should the team do?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _answer(0, 'Pick the most exciting answer'),
                      _answer(1, 'Compare trustworthy sources and evidence'),
                      _answer(2, 'Forward both answers immediately'),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: selectedAnswer == 1 && !saving
                            ? finishMission
                            : null,
                        icon: const Icon(Icons.groups_rounded),
                        label: Text(saving ? 'Saving…' : 'Complete as a team'),
                      ),
                      if (selectedAnswer != null && selectedAnswer != 1)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Try again: great teams check evidence before sharing.',
                            style: TextStyle(color: Color(0xFFFFCB67)),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _answer(int index, String label) {
    final selected = selectedAnswer == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? const Color(0xFFFFF1C7) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => selectedAnswer = index),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Icon(selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off),
                const SizedBox(width: 10),
                Expanded(child: Text(label)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
