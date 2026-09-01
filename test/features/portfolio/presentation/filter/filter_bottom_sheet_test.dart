import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/filter_bottom_sheet.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';

void main() {
  group('FilterBottomSheet', () {
    testWidgets('builds without error and shows title', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FilterBottomSheet(),
            ),
          ),
        ),
      );

      expect(find.text('Advanced Filters'), findsOneWidget);
    });

    testWidgets(
        'tapping a tag chip updates draftFilterProvider but not appliedFilterProvider',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FilterBottomSheet(),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
          tester.element(find.byType(FilterBottomSheet)));

      // Initial state - both should be empty
      expect(container.read(draftFilterProvider).tags, isEmpty);
      expect(container.read(appliedFilterProvider).tags, isEmpty);

      // Tap the first tag chip ("Top Performer")
      await tester.tap(find.text('Top Performer'));
      await tester.pump();

      // Draft should be updated, but applied should remain unchanged
      expect(
          container.read(draftFilterProvider).tags, contains('Top Performer'));
      expect(container.read(appliedFilterProvider).tags, isEmpty);
    });

    testWidgets('tapping Reset clears draft only', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FilterBottomSheet(),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
          tester.element(find.byType(FilterBottomSheet)));

      // First select a tag
      await tester.tap(find.text('Top Performer'));
      await tester.pump();

      expect(container.read(draftFilterProvider).tags, isNotEmpty);
      expect(container.read(appliedFilterProvider).tags, isEmpty);

      // Then tap Reset
      await tester.tap(find.text('Reset'));
      await tester.pump();

      // Draft should be cleared, applied should still be empty
      expect(container.read(draftFilterProvider).tags, isEmpty);
      expect(container.read(appliedFilterProvider).tags, isEmpty);
    });

    testWidgets('tapping Confirm copies draft to appliedFilterProvider',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FilterBottomSheet(),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
          tester.element(find.byType(FilterBottomSheet)));

      // Select a tag
      await tester.tap(find.text('Top Performer'));
      await tester.pump();

      expect(
          container.read(draftFilterProvider).tags, contains('Top Performer'));
      expect(container.read(appliedFilterProvider).tags, isEmpty);

      // Tap Confirm
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Both should now contain the selected tag
      expect(
          container.read(draftFilterProvider).tags, contains('Top Performer'));
      expect(container.read(appliedFilterProvider).tags,
          contains('Top Performer'));
    });

    testWidgets(
        'closing the sheet after editing without Confirm discards the draft '
        '(autoDispose re-seeds from applied on reopen)', (tester) async {
      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            navigatorKey: key,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => const FilterBottomSheet(),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      final container =
          ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));

      // Open the sheet and select a tag without confirming.
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Top Performer'));
      await tester.pump();
      expect(
          container.read(draftFilterProvider).tags, contains('Top Performer'));
      expect(container.read(appliedFilterProvider).tags, isEmpty);

      // Close the sheet without tapping Confirm (drag-to-dismiss equivalent:
      // pop the route directly).
      key.currentState!.pop();
      await tester.pumpAndSettle();

      // Reopen the sheet: the fresh draft must re-seed from the (still empty)
      // applied filter, discarding the earlier unconfirmed edit.
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(container.read(draftFilterProvider).tags, isEmpty);
      expect(find.text('Top Performer'), findsOneWidget);
    });
  });
}
