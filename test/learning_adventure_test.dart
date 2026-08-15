import 'package:curioverse/data/open_knowledge_service.dart';
import 'package:curioverse/data/progress_store.dart';
import 'package:curioverse/models/child_profile.dart';
import 'package:curioverse/screens/learning_adventure_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('learning reward is granted only once per topic', () {
    const progress = LearningProgress();
    final first = progress.complete('moon_phases', 30);
    final replay = first.complete('moon_phases', 30);

    expect(first.energy, 150);
    expect(replay.energy, 150);
    expect(replay.completed('moon_phases'), isTrue);
  });

  testWidgets('creator sees age-aware catalog and completes Moon quiz',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    String? completedTopic;
    int reward = 0;

    await tester.pumpWidget(
      TestApp(
        child: LearningAdventureScreen(
          ageBand: AgeBand.creator12to14,
          knowledgeSource: const MemoryOpenKnowledgeSource(),
          completedTopicIds: const {},
          onTopicCompleted: (topicId, earned) async {
            completedTopic = topicId;
            reward = earned;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AI Pattern Lab'), findsOneWidget);
    expect(find.text('Ocean Networks'), findsOneWidget);
    expect(find.text('Dinosaur Detective'), findsNothing);

    await tester.tap(find.text('Moon Shapes'));
    await tester.pumpAndSettle();
    expect(find.text('The Moon’s light-and-shadow dance'), findsOneWidget);

    await tester.tap(find.text('Next discovery'));
    await tester.pump();
    await tester.tap(find.text('Next discovery'));
    await tester.pump();
    await tester.tap(find.text('Take the 3-question challenge'));
    await tester.pump();

    await tester.tap(find.text('The Sun'));
    await tester.pump();
    expect(find.textContaining('reflects sunlight'), findsOneWidget);
    await tester.tap(find.text('Next question'));
    await tester.pump();

    await tester.tap(
      find.text('We see different parts of its sunlit half'),
    );
    await tester.pump();
    await tester.tap(find.text('Next question'));
    await tester.pump();

    await tester.tap(find.text('Round like a ball'));
    await tester.pump();
    await tester.tap(find.text('See my result'));
    await tester.pumpAndSettle();

    expect(find.text('Mission complete!'), findsOneWidget);
    expect(find.text('You solved 3 of 3 questions.'), findsOneWidget);
    expect(completedTopic, 'moon_phases');
    expect(reward, 30);
  });
}

class TestApp extends StatelessWidget {
  const TestApp({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(body: SafeArea(child: child)),
      );
}
