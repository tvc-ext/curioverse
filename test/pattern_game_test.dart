import 'package:curioverse/models/child_profile.dart';
import 'package:curioverse/screens/pattern_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Pattern Sprint completes five puzzles and awards energy',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    String? completedGame;
    int reward = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PatternGameScreen(
          ageBand: AgeBand.adventurer9to11,
          alreadyCompleted: false,
          onCompleted: (gameId, earned) async {
            completedGame = gameId;
            reward = earned;
          },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Start Pattern Sprint'));
    await tester.pump();

    for (final answer in ['32', '25', '▲', '48', 'O']) {
      await tester.tap(find.text(answer));
      await tester.pump();
      final action = answer == 'O' ? 'Finish sprint' : 'Next puzzle';
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
    }

    expect(find.text('Sprint complete!'), findsOneWidget);
    expect(find.text('You cracked 5 of 5 patterns.'), findsOneWidget);
    expect(completedGame, 'game_pattern_sprint');
    expect(reward, 20);
  });
}
