import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tower_of_hanoi/tower_of_hanoi.dart';

void main() {
  testWidgets('Tower of Hanoi widget test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: TowerOfHanoi()));

    // Verify the app title is displayed.
    expect(find.text('Tower of Hanoi'), findsOneWidget);

    // Verify the presence of three towers.
    expect(find.byType(GestureDetector), findsNWidgets(3));

    // Simulate tapping a tower and verify state changes.
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Verify the tower is selected (state change).
    // This assumes the selected tower has a visual indicator.
    expect(find.byType(AnimatedContainer), findsWidgets);
  });
}
