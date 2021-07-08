import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';

void main() {
  group('Material 3 window width classes', () {
    testWidgets('uses compact below 600 dp', (tester) async {
      await _expectWidthClass(tester, 599, WindowWidthClass.compact);
    });

    testWidgets('uses medium from 600 to 839 dp', (tester) async {
      await _expectWidthClass(tester, 600, WindowWidthClass.medium);
      await _expectWidthClass(tester, 839, WindowWidthClass.medium);
    });

    testWidgets('uses expanded from 840 dp', (tester) async {
      await _expectWidthClass(tester, 840, WindowWidthClass.expanded);
    });
  });
}

Future<void> _expectWidthClass(
  WidgetTester tester,
  double width,
  WindowWidthClass expected,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 800)),
        child: Builder(
          builder: (context) {
            expect(AppBreakpoints.widthClassOf(context), expected);
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
}
