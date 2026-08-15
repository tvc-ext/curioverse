import 'package:curioverse/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the CurioVerse home experience', (tester) async {
    await tester.pumpWidget(const CurioVerseApp());

    expect(find.text('CurioVerse'), findsOneWidget);
    expect(find.text('Hello, Nova Fox!'), findsOneWidget);
    expect(find.text('TODAY’S MISSION'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
  });
}
