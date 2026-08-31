import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/models/filter_state.dart';
import 'package:fe_assessment_earnex/providers/applied_filter_provider.dart';

void main() {
  group('appliedFilterProvider', () {
    test('applyFrom updates the filter state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Create a draft filter state
      const draftFilter = FilterState(tags: {'Top Performer', 'Money Maker'});

      // Apply the draft to the applied filter
      container.read(appliedFilterProvider.notifier).applyFrom(draftFilter);

      // Verify the applied filter now matches the draft
      final appliedFilter = container.read(appliedFilterProvider);
      expect(appliedFilter.tags, equals({'Top Performer', 'Money Maker'}));
    });
  });
}
