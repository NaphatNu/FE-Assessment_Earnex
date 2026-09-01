import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/filter_state.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';

void main() {
  group('appliedFilterProvider', () {
    test('apply updates the filter state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Create a draft filter state
      const draftFilter = FilterState(tags: {'Top Performer', 'Money Maker'});

      // Apply the draft to the applied filter
      container.read(appliedFilterProvider.notifier).apply(draftFilter);

      // Verify the applied filter now matches the draft
      final appliedFilter = container.read(appliedFilterProvider);
      expect(appliedFilter.tags, equals({'Top Performer', 'Money Maker'}));
    });

    test('clear resets the filter state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set initial filter
      const initialFilter = FilterState(tags: {'Top Performer', 'Money Maker'});
      container.read(appliedFilterProvider.notifier).apply(initialFilter);

      // Clear the filter
      container.read(appliedFilterProvider.notifier).clear();

      // Verify the applied filter is now empty
      final appliedFilter = container.read(appliedFilterProvider);
      expect(appliedFilter.tags, isEmpty);
    });
  });
}
