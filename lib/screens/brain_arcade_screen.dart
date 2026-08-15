import 'package:flutter/material.dart';

import '../models/child_profile.dart';
import 'pattern_game_screen.dart';

class BrainArcadeScreen extends StatefulWidget {
  const BrainArcadeScreen({required this.ageBand, required this.completedGameIds, required this.onCompleted, super.key});
  final AgeBand ageBand;
  final Set<String> completedGameIds;
  final Future<void> Function(String, int) onCompleted;
  @override State<BrainArcadeScreen> createState() => _BrainArcadeScreenState();
}

class _BrainArcadeScreenState extends State<BrainArcadeScreen> {
  Widget? active;
  @override Widget build(BuildContext context) {
    if (active != null) return Column(children: [
      Align(alignment: Alignment.centerLeft, child: TextButton.icon(onPressed: () => setState(() => active = null), icon: const Icon(Icons.arrow_back), label: const Text('Brain Arcade'))),
      Expanded(child: active!),
    ]);
    final hard = widget.ageBand == AgeBand.creator12to14;
    final games = <_Game>[
      _Game('🧩', 'Pattern Sprint', 'Sequences of shapes, numbers and letters', const Color(0xFFFFE0C2), () => PatternGameScreen(ageBand: widget.ageBand, alreadyCompleted: widget.completedGameIds.contains('game_pattern_sprint'), onCompleted: widget.onCompleted)),
      _Game('🕳️', 'Missing Tile', 'Complete visual and number grids', const Color(0xFFE4E0FF), () => PuzzleRound(title: 'Missing Tile', emoji: '🕳️', gameId: 'game_missing_tile', puzzles: hard ? hardMissing : missing, onCompleted: widget.onCompleted)),
      _Game('🔎', 'Odd One Out', 'Discover the hidden rule', const Color(0xFFDDF6E4), () => PuzzleRound(title: 'Odd One Out', emoji: '🔎', gameId: 'game_odd_one_out', puzzles: hard ? hardOdd : odd, onCompleted: widget.onCompleted)),
      _Game('🔐', 'Code Breaker', 'Decode clever transformations', const Color(0xFFFFE2EA), () => PuzzleRound(title: 'Code Breaker', emoji: '🔐', gameId: 'game_code_breaker', puzzles: hard ? hardCodes : codes, onCompleted: widget.onCompleted)),
    ];
    return ListView(key: const ValueKey('brain-arcade'), padding: const EdgeInsets.all(20), children: [
      Text('Brain Arcade', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
      Text('Four challenges tuned for ${widget.ageBand.title}'), const SizedBox(height: 18),
      for (final game in games) Padding(padding: const EdgeInsets.only(bottom: 14), child: Card(color: game.color, child: InkWell(borderRadius: BorderRadius.circular(24), onTap: () => setState(() => active = game.open()), child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
        Text(game.emoji, style: const TextStyle(fontSize: 46)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(game.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), Text(game.subtitle), const SizedBox(height: 5), const Text('Play · Earn curiosity energy', style: TextStyle(fontWeight: FontWeight.w700))])), const Icon(Icons.play_circle_fill, size: 32),
      ]))))),
    ]);
  }
}

class _Game { const _Game(this.emoji, this.title, this.subtitle, this.color, this.open); final String emoji, title, subtitle; final Color color; final Widget Function() open; }
class Puzzle { const Puzzle(this.prompt, this.options, this.answer, this.reason); final String prompt; final List<String> options; final int answer; final String reason; }

class PuzzleRound extends StatefulWidget {
  const PuzzleRound({required this.title, required this.emoji, required this.gameId, required this.puzzles, required this.onCompleted, super.key});
  final String title, emoji, gameId; final List<Puzzle> puzzles; final Future<void> Function(String, int) onCompleted;
  @override State<PuzzleRound> createState() => _PuzzleRoundState();
}
class _PuzzleRoundState extends State<PuzzleRound> {
  int index = 0, score = 0; int? selected; bool done = false;
  Future<void> next() async { if (index + 1 < widget.puzzles.length) { setState(() { index++; selected = null; }); } else { setState(() => done = true); await widget.onCompleted(widget.gameId, 20); } }
  @override Widget build(BuildContext context) {
    if (done) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('🏆', style: TextStyle(fontSize: 80)), Text('${widget.title} complete!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)), Text('You solved $score of ${widget.puzzles.length}.'), const Chip(label: Text('+20 curiosity energy')), FilledButton.icon(onPressed: () => setState(() { index = score = 0; selected = null; done = false; }), icon: const Icon(Icons.replay), label: const Text('Play again'))]));
    final puzzle = widget.puzzles[index];
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('${widget.title} · ${index + 1} of ${widget.puzzles.length}', style: const TextStyle(fontWeight: FontWeight.w800)), LinearProgressIndicator(value: (index + 1) / widget.puzzles.length), const SizedBox(height: 22), Text(widget.emoji, style: const TextStyle(fontSize: 48)),
      Card(color: const Color(0xFF292065), child: Padding(padding: const EdgeInsets.all(24), child: Text(puzzle.prompt, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, height: 1.4, fontWeight: FontWeight.w900)))), const SizedBox(height: 14),
      for (var i = 0; i < puzzle.options.length; i++) Padding(padding: const EdgeInsets.only(bottom: 9), child: FilledButton.tonal(key: ValueKey('${widget.gameId}-answer-$i'), onPressed: selected == null ? () => setState(() { selected = i; if (i == puzzle.answer) score++; }) : null, style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(55), backgroundColor: selected != null && i == puzzle.answer ? const Color(0xFFD8F5E5) : selected == i ? const Color(0xFFFFDFDF) : null), child: Text(puzzle.options[i]))),
      if (selected != null) ...[Card(color: const Color(0xFFFFF1C7), child: Padding(padding: const EdgeInsets.all(15), child: Text('💡 ${puzzle.reason}'))), FilledButton(onPressed: next, child: Text(index + 1 < widget.puzzles.length ? 'Next challenge' : 'Finish game'))],
    ]);
  }
}

const missing = [Puzzle('🔴 🔵 🔴\n🔵 🔴 🔵\n🔴 ? 🔴', ['🔴','🔵','🟢'], 1, 'The colours alternate.'), Puzzle('1 2 3\n2 3 4\n3 4 ?', ['4','5','6'], 1, 'Every line increases by one.'), Puzzle('▲ ● ▲\n● ▲ ●\n▲ ? ▲', ['▲','●','■'], 1, 'The shapes alternate.'), Puzzle('🍎 🍎 2\n🍌 🍌 4\n🍎 🍌 ?', ['3','6','8'], 0, 'Apple is 1 and banana is 2.'), Puzzle('2 4 6\n3 6 9\n4 8 ?', ['10','12','16'], 1, 'Each row uses a multiplier.')];
const hardMissing = [Puzzle('2 4 8\n3 6 12\n5 10 ?', ['15','20','25'], 1, 'Each row doubles.'), Puzzle('1 1 2\n2 3 5\n5 8 ?', ['11','12','13'], 2, 'Add the previous two values.'), Puzzle('3 9 27\n2 6 18\n4 12 ?', ['24','36','48'], 1, 'Multiply by three.'), Puzzle('16 8 4\n20 10 5\n28 14 ?', ['6','7','8'], 1, 'Each step halves.'), Puzzle('A C F\nB D G\nD F ?', ['H','I','J'], 1, 'Jump two then three letters.')];
const odd = [Puzzle('🐶 🐱 🐰 🚗', ['🐶','🐰','🚗'], 2, 'A car is not an animal.'), Puzzle('2 4 7 8', ['2','7','8'], 1, 'Seven is odd.'), Puzzle('Mars Earth Jupiter Moon', ['Earth','Jupiter','Moon'], 2, 'The Moon is not a planet.'), Puzzle('🐋 🐬 🦈 🦁', ['🐋','🦈','🦁'], 2, 'The lion is not ocean life.'), Puzzle('🔺 🔷 ⭕ 🍎', ['🔷','⭕','🍎'], 2, 'The apple is not a shape.')];
const hardOdd = [Puzzle('8 27 64 100', ['27','64','100'], 2, '100 is not a cube.'), Puzzle('11 13 17 21', ['13','17','21'], 2, '21 is not prime.'), Puzzle('Mercury Venus Earth Europa', ['Venus','Earth','Europa'], 2, 'Europa is a moon.'), Puzzle('Triangle Square Pentagon Sphere', ['Square','Pentagon','Sphere'], 2, 'Sphere is 3D.'), Puzzle('Photosynthesis Respiration Evaporation Germination', ['Respiration','Evaporation','Germination'], 1, 'Evaporation is not a living process.')];
const codes = [Puzzle('CAT → DBU. DOG → ?', ['EPH','EOH','FPH'], 0, 'Move every letter forward one.'), Puzzle('2 → 6, 3 → 9, 5 → ?', ['10','15','20'], 1, 'Multiply by three.'), Puzzle('A=1 B=2 C=3. CAB totals…', ['5','6','7'], 1, '3 + 1 + 2 = 6.'), Puzzle('RED → 18-5-4. BLUE starts…', ['2-12','1-11','3-13'], 0, 'Use alphabet positions.'), Puzzle('MOON=4665. MOM=?', ['464','466','456'], 0, 'Replace letters with their digits.')];
const hardCodes = [Puzzle('CODE → DQGI (+1,+2,+3,+4). MIND → ?', ['NKQH','NKRH','OJQH'], 0, 'Shift successive letters.'), Puzzle('3→12, 5→30, 7→?', ['42','49','56'], 2, 'Use n × (n+1).'), Puzzle('AZ BY CX ?', ['DW','DX','EV'], 0, 'One side rises while the other falls.'), Puzzle('2#3=13, 3#4=25, 4#5=?', ['31','41','45'], 1, 'Add the squares.'), Puzzle('ACE=9, BED=11, FACE=?', ['14','15','16'], 1, 'Add alphabet positions.')];
