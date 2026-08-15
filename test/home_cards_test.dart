import 'package:curioverse/data/profile_store.dart';
import 'package:curioverse/main.dart';
import 'package:curioverse/models/child_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const profile = ChildProfile(
    ageBand: AgeBand.adventurer9to11,
    avatarId: 'nova_fox',
  );

  final worldCases = <String, String>{
    'Space': 'Moon Shapes',
    'Dinosaurs': 'Dinosaur Detective',
    'AI Lab': 'AI Pattern Lab',
    'Oceans': 'Ocean Networks',
  };

  for (final entry in worldCases.entries) {
    testWidgets('${entry.key} home card opens its learning adventure',
        (tester) async {
      await _pumpHome(tester, profile);
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();

      expect(find.text(entry.value), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  }

  testWidgets("today's mission opens the Moon adventure", (tester) async {
    await _pumpHome(tester, profile);
    await tester.tap(find.text('Start mission'));
    await tester.pumpAndSettle();

    expect(find.text('Moon Shapes'), findsOneWidget);
  });

  testWidgets('quick challenge opens Pattern Sprint', (tester) async {
    await _pumpHome(tester, profile);
    await tester.tap(find.text('Can you crack the pattern?'));
    await tester.pumpAndSettle();

    expect(find.text('Pattern Sprint'), findsOneWidget);
  });
}

Future<void> _pumpHome(WidgetTester tester, ChildProfile profile) async {
  tester.view.physicalSize = const Size(430, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    CurioVerseApp(
      profileStore: MemoryProfileStore(profile),
      initialProfile: profile,
    ),
  );
  await tester.pumpAndSettle();
}
