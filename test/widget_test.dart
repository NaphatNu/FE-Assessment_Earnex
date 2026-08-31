import 'package:flutter_test/flutter_test.dart';
import 'package:fe_assessment_earnex/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds without throwing.
    expect(find.text('Trader Portfolio List with Filter'), findsOneWidget);
  });
}
