// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_with_nicky/main.dart';

void main() {
  testWidgets('Fitness app landing page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FitnessWithNickyApp());

    // Verify that our landing page shows the correct title.
    expect(find.text('Fitness with Nicky'), findsOneWidget);
    expect(find.text('Your Feline Fitness Coach'), findsOneWidget);

    // Verify that the Start Training button is present.
    expect(find.text('Start Training'), findsOneWidget);

    // Tap the 'Start Training' button and trigger a frame.
    await tester.tap(find.text('Start Training'));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Verify that we navigated to the main menu.
    expect(find.text('Nicky\'s Gym'), findsOneWidget);
    expect(find.text('Welcome back!'), findsOneWidget);
  });
}
