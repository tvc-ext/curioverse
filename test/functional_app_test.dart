import 'package:curioverse/data/profile_store.dart';
import 'package:curioverse/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('functional explorer journey: onboard, navigate, and reset',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final store = MemoryProfileStore();
    await tester.pumpWidget(CurioVerseApp(
        showSplash: false,profileStore: store));

    expect(find.text('Welcome to CurioVerse!'), findsOneWidget);

    await tester.tap(find.text('9–11'));
    await tester.pump();
    await tester.tap(find.text('Nova Fox'));
    await tester.pump();

    final continueFinder =
        find.widgetWithText(FilledButton, 'Enter CurioVerse');
    expect(tester.widget<FilledButton>(continueFinder).onPressed, isNotNull);
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    expect(find.text('Hello, Nova Fox!'), findsOneWidget);
    expect(store.profile, isNotNull);

    await tester.tap(find.text('Games'));
    await tester.pumpAndSettle();
    expect(find.text('Pattern Sprint'), findsOneWidget);

    await tester.tap(find.text('🦊'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nova Fox · 9–11'), findsOneWidget);

    await tester.tap(find.text('Change explorer'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to CurioVerse!'), findsOneWidget);
    expect(store.profile, isNull);
  });
}
