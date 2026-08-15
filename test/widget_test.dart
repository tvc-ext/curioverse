import 'package:curioverse/data/profile_store.dart';
import 'package:curioverse/main.dart';
import 'package:curioverse/models/child_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  void useTallPhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('new explorer completes safe onboarding', (tester) async {
    useTallPhoneSurface(tester);
    final store = MemoryProfileStore();

    await tester.pumpWidget(CurioVerseApp(profileStore: store));

    expect(find.text('Welcome to CurioVerse!'), findsOneWidget);
    expect(
      find.textContaining('We never need your real name or exact age.'),
      findsOneWidget,
    );

    await tester.tap(find.text('6–8'));
    await tester.ensureVisible(find.text('Nova Fox'));
    await tester.tap(find.text('Nova Fox'));
    await tester.ensureVisible(find.text('Enter CurioVerse'));
    final continueButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Enter CurioVerse'),
    );
    expect(continueButton.onPressed, isNotNull);
    await tester.tap(find.widgetWithText(FilledButton, 'Enter CurioVerse'));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Nova Fox!'), findsOneWidget);
    expect(store.profile?.ageBand, AgeBand.explorer6to8);
    expect(store.profile?.avatarId, 'nova_fox');
  });

  testWidgets('returning explorer skips onboarding', (tester) async {
    useTallPhoneSurface(tester);
    const profile = ChildProfile(
      ageBand: AgeBand.creator12to14,
      avatarId: 'astro_owl',
    );

    await tester.pumpWidget(
      CurioVerseApp(
        profileStore: MemoryProfileStore(profile),
        initialProfile: profile,
      ),
    );

    expect(find.text('Hello, Astro Owl!'), findsOneWidget);
    expect(find.text('Welcome to CurioVerse!'), findsNothing);
    expect(find.text('Friends'), findsOneWidget);
  });

  testWidgets('continue is disabled until both choices are selected',
      (tester) async {
    useTallPhoneSurface(tester);
    await tester.pumpWidget(
      CurioVerseApp(profileStore: MemoryProfileStore()),
    );

    FilledButton button =
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Enter CurioVerse'));
    expect(button.onPressed, isNull);

    await tester.tap(find.text('9–11'));
    await tester.pump();
    button =
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Enter CurioVerse'));
    expect(button.onPressed, isNull);

    await tester.ensureVisible(find.text('Nova Fox'));
    await tester.tap(find.text('Nova Fox'));
    await tester.pump();
    button =
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Enter CurioVerse'));
    expect(button.onPressed, isNotNull);
  });
}
