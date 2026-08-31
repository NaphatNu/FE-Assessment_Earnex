import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/models/filter_state.dart';
import 'package:fe_assessment_earnex/providers/applied_filter_provider.dart';
import 'package:fe_assessment_earnex/providers/draft_filter_provider.dart';

void main() {
  group('draftFilterProvider', () {
    test('toggleTag adds and removes tags without affecting applied filter',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set initial applied filter
      container.read(appliedFilterProvider.notifier).applyFrom(
            const FilterState(tags: {'Top Performer'}),
          );

      // Get draft filter notifier
      final draftNotifier = container.read(draftFilterProvider.notifier);

      // Toggle a new tag
      draftNotifier.toggleTag('Money Maker');

      // Draft should have both tags
      expect(container.read(draftFilterProvider).tags,
          equals({'Top Performer', 'Money Maker'}));

      // Applied filter should be unchanged
      expect(container.read(appliedFilterProvider).tags,
          equals({'Top Performer'}));

      // Toggle the same tag again - should remove it
      draftNotifier.toggleTag('Money Maker');

      // Draft should only have the original tag
      expect(
          container.read(draftFilterProvider).tags, equals({'Top Performer'}));

      // Applied filter should still be unchanged
      expect(container.read(appliedFilterProvider).tags,
          equals({'Top Performer'}));
    });

    test('reset clears the draft filter', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set initial applied filter
      container.read(appliedFilterProvider.notifier).applyFrom(
            const FilterState(tags: {'Top Performer'}),
          );

      // Get draft filter notifier
      final draftNotifier = container.read(draftFilterProvider.notifier);

      // Add some tags to draft
      draftNotifier.toggleTag('Money Maker');
      draftNotifier.toggleTag('High Risk');

      // Verify draft has multiple tags
      expect(container.read(draftFilterProvider).tags,
          equals({'Top Performer', 'Money Maker', 'High Risk'}));

      // Reset the draft
      draftNotifier.reset();

      // Draft should be empty
      expect(container.read(draftFilterProvider).tags, isEmpty);

      // Applied filter should be unchanged
      expect(container.read(appliedFilterProvider).tags,
          equals({'Top Performer'}));
    });
  });
}
