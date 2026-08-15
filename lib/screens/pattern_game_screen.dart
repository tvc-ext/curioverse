import 'package:flutter/material.dart';

import '../models/child_profile.dart';

class PatternPuzzle {
  const PatternPuzzle({
    required this.sequence,
    required this.options,
    required this.correctIndex,
    required this.hint,
  });

  final String sequence;
  final List<String> options;
  final int correctIndex;
  final String hint;
}

const _youngPuzzles = [
  PatternPuzzle(
    sequence: '🔴  🔵  🔴  🔵  ?',
    options: ['🔴', '🟢', '🔵'],
    correctIndex: 0,
    hint: 'The colours take turns.',
  ),
  PatternPuzzle(
    sequence: '🌱  🌿  🌳  🌱  🌿  ?',
    options: ['🌳', '🌱', '🌸'],
    correctIndex: 0,
    hint: 'A plant grows through three stages.',
  ),
  PatternPuzzle(
    sequence: '🐣  🐣  🐔  🐣  🐣  ?',
    options: ['🐣', '🐔', '🥚'],
    correctIndex: 1,
    hint: 'Two chicks, then one chicken.',
  ),
  PatternPuzzle(
    sequence: '⭐  🌙  ⭐  🌙  ?',
    options: ['☀️', '⭐', '🌙'],
    correctIndex: 1,
    hint: 'Star, moon, star, moon...',
  ),
  PatternPuzzle(
    sequence: '1  2  1  2  1  ?',
    options: ['3', '1', '2'],
    correctIndex: 2,
    hint: 'The numbers alternate.',
  ),
];

const _olderPuzzles = [
  PatternPuzzle(
    sequence: '2  4  8  16  ?',
    options: ['18', '24', '32'],
    correctIndex: 2,
    hint: 'Each number is doubled.',
  ),
  PatternPuzzle(
    sequence: '1  4  9  16  ?',
    options: ['20', '25', '32'],
    correctIndex: 1,
    hint: 'These are square numbers.',
  ),
  PatternPuzzle(
    sequence: '▲  ●  ●  ▲  ●  ●  ?',
    options: ['▲', '●', '■'],
    correctIndex: 0,
    hint: 'One triangle is followed by two circles.',
  ),
  PatternPuzzle(
    sequence: '3  6  12  24  ?',
    options: ['30', '36', '48'],
    correctIndex: 2,
    hint: 'Keep multiplying by two.',
  ),
  PatternPuzzle(
    sequence: 'A  C  F  J  ?',
    options: ['M', 'N', 'O'],
    correctIndex: 2,
    hint: 'Skip 1 letter, then 2, then 3, then 4.',
  ),
];

class PatternGameScreen extends StatefulWidget {
  const PatternGameScreen({
    required this.ageBand,
    required this.alreadyCompleted,
    required this.onCompleted,
    super.key,
  });

  final AgeBand ageBand;
  final bool alreadyCompleted;
  final Future<void> Function(String gameId, int reward) onCompleted;

  @override
  State<PatternGameScreen> createState() => _PatternGameScreenState();
}

enum _GameView { intro, playing, result }

class _PatternGameScreenState extends State<PatternGameScreen> {
  _GameView view = _GameView.intro;
  int puzzleIndex = 0;
  int? selectedIndex;
  int score = 0;
  bool saving = false;

  List<PatternPuzzle> get puzzles =>
      widget.ageBand == AgeBand.explorer6to8 ? _youngPuzzles : _olderPuzzles;

  void start() {
    setState(() {
      view = _GameView.playing;
      puzzleIndex = 0;
      selectedIndex = null;
      score = 0;
    });
  }

  void answer(int index) {
    if (selectedIndex != null) return;
    setState(() {
      selectedIndex = index;
      if (index == puzzles[puzzleIndex].correctIndex) score++;
    });
  }

  Future<void> next() async {
    if (puzzleIndex < puzzles.length - 1) {
      setState(() {
        puzzleIndex++;
        selectedIndex = null;
      });
      return;
    }
    setState(() {
      view = _GameView.result;
      saving = true;
    });
    await widget.onCompleted('game_pattern_sprint', 20);
    if (mounted) setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) => switch (view) {
        _GameView.intro => _intro(context),
        _GameView.playing => _playing(context),
        _GameView.result => _result(context),
      };

  Widget _intro(BuildContext context) {
    return Center(
      key: const ValueKey('pattern-intro'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFFFB45B), Color(0xFFFF6B8A)],
                ),
              ),
              child: const Center(
                child: Text('🧩', style: TextStyle(fontSize: 88)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pattern Sprint',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Spot what comes next in five fast brain puzzles.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 16),
            Chip(
              avatar: const Icon(Icons.bolt, color: Color(0xFFFF8A00)),
              label: Text(
                widget.alreadyCompleted
                    ? 'Replay for fun'
                    : 'Earn 20 curiosity energy',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: start,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Pattern Sprint'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playing(BuildContext context) {
    final puzzle = puzzles[puzzleIndex];
    return ListView(
      key: const ValueKey('pattern-playing'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        Text(
          'Puzzle ${puzzleIndex + 1} of ${puzzles.length}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (puzzleIndex + 1) / puzzles.length,
          minHeight: 8,
        ),
        const SizedBox(height: 28),
        Card(
          color: const Color(0xFF28205F),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 16),
            child: Text(
              puzzle.sequence,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'What comes next?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 12),
        ...List.generate(puzzle.options.length, (index) {
          final correct = index == puzzle.correctIndex;
          final selected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FilledButton.tonal(
              onPressed: () => answer(index),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(58),
                backgroundColor: selectedIndex != null && correct
                    ? const Color(0xFFD8F5E5)
                    : selected
                        ? const Color(0xFFFFDFDF)
                        : null,
              ),
              child: Text(
                puzzle.options[index],
                style: const TextStyle(fontSize: 22),
              ),
            ),
          );
        }),
        if (selectedIndex != null) ...[
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFFFFF1C7),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('💡 ${puzzle.hint}'),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: next,
            child: Text(
              puzzleIndex < puzzles.length - 1
                  ? 'Next puzzle'
                  : 'Finish sprint',
            ),
          ),
        ],
      ],
    );
  }

  Widget _result(BuildContext context) {
    return Center(
      key: const ValueKey('pattern-result'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 88)),
            const SizedBox(height: 16),
            Text(
              'Sprint complete!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'You cracked $score of ${puzzles.length} patterns.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Chip(
              avatar: const Icon(Icons.bolt, color: Color(0xFFFF8A00)),
              label: Text(
                widget.alreadyCompleted
                    ? 'Great replay!'
                    : '+20 curiosity energy',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: saving ? null : start,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Play again'),
            ),
          ],
        ),
      ),
    );
  }
}
