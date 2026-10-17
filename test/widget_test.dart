import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gesture_lab/main.dart';

void main() {
  testWidgets('Tapping the button raises the counter', (WidgetTester tester) async {
    await tester.pumpWidget(const GestureLabApp());

    expect(find.text('You tapped the button 0 times.'), findsOneWidget);

    await tester.tap(find.text('Tap me'));
    await tester.pump();

    expect(find.text('You tapped the button 1 times.'), findsOneWidget);
  });

  testWidgets('Swiping a task deletes it and Undo brings it back',
      (WidgetTester tester) async {
    // A tall screen so every task is visible without scrolling.
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const GestureLabApp());
    expect(find.text('Buy groceries'), findsOneWidget);

    await tester.drag(find.text('Buy groceries'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsNothing);
    expect(find.text('Undo'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsOneWidget);
  });
}
