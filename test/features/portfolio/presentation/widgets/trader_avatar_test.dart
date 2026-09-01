import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/trader_avatar.dart';

void main() {
  Future<void> pump(WidgetTester tester, String name) => tester.pumpWidget(
        MaterialApp(
          home: AvatarFallback(name: name, size: 44),
        ),
      );

  testWidgets('shows the uppercased first letter for an ASCII name',
      (tester) async {
    await pump(tester, 'CRYPTO 加密');

    expect(find.text('C'), findsOneWidget);
  });

  testWidgets('shows the first multi-byte character for a CJK name',
      (tester) async {
    await pump(tester, '師429');

    expect(find.text('師'), findsOneWidget);
  });

  testWidgets('shows ? for a blank name', (tester) async {
    await pump(tester, '   ');

    expect(find.text('?'), findsOneWidget);
  });
}
