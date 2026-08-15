import 'package:curioverse/models/child_profile.dart';
import 'package:curioverse/screens/friends_clubhouse_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('clubhouse completes safe team mission and awards once',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var calls = 0;
    String? activity;
    int? reward;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FriendsClubhouseScreen(
            profile: const ChildProfile(
              ageBand: AgeBand.adventurer9to11,
              avatarId: 'nova_fox',
            ),
            alreadyCompleted: false,
            onCompleted: (id, points) async {
              calls++;
              activity = id;
              reward = points;
            },
          ),
        ),
      ),
    );

    expect(find.text('Explorer Clubhouse'), findsOneWidget);
    expect(find.textContaining('no public chat'), findsOneWidget);

    final correctAnswer =
        find.text('Compare trustworthy sources and evidence');
    await tester.ensureVisible(correctAnswer);
    await tester.tap(correctAnswer);
    await tester.pump();

    final completeButton = find.text('Complete as a team');
    await tester.ensureVisible(completeButton);
    await tester.tap(completeButton);
    await tester.pumpAndSettle();

    expect(find.text('Team mission complete!'), findsOneWidget);
    expect(calls, 1);
    expect(activity, 'clubhouse_team_mission');
    expect(reward, 25);
  });
}
