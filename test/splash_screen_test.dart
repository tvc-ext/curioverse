import 'package:curioverse/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash introduces CurioVerse and continues automatically',
      (tester) async {
    var finished = false;
    await tester.pumpWidget(
      MaterialApp(
        home: CurioVerseSplashScreen(onFinished: () => finished = true),
      ),
    );

    expect(find.text('CurioVerse'), findsOneWidget);
    expect(find.text('Big curiosity. Brilliant adventures.'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    expect(finished, isTrue);
  });
}
