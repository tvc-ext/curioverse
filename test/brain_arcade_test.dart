import 'package:curioverse/models/child_profile.dart';
import 'package:curioverse/screens/brain_arcade_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Visual Mind Lab provides 100 age-aware challenges', () {
    expect(visualPuzzles(AgeBand.explorer6to8), hasLength(100));
    expect(visualPuzzles(AgeBand.adventurer9to11), hasLength(100));
    expect(visualPuzzles(AgeBand.creator12to14), hasLength(100));
    expect(
      visualPuzzles(AgeBand.creator12to14).first.prompt,
      isNot(visualPuzzles(AgeBand.explorer6to8).first.prompt),
    );
  });

  testWidgets('every Brain Arcade card opens a functional game',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final title in [
      'Pattern Sprint',
      'Missing Tile',
      'Odd One Out',
      'Code Breaker',
      'Visual Mind Lab',
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrainArcadeScreen(
              key: ValueKey(title),
              ageBand: AgeBand.adventurer9to11,
              completedGameIds: const {},
              onCompleted: (_, __) async {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(title).first, 300);
      await tester.tap(find.text(title).first);
      await tester.pumpAndSettle();
      expect(find.text('Brain Arcade'), findsOneWidget);
      expect(find.textContaining(title), findsWidgets);
    }
  });
}
