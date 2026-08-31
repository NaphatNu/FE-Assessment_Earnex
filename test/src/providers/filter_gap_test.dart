import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/domain/filter_state.dart';
import 'package:fe_assessment_earnex/src/domain/trader.dart';
import 'package:fe_assessment_earnex/src/providers.dart';
import 'fake_traders_repository.dart';

void main() {
  group('Filter gap tests', () {
    test('filteredTradersProvider shows AsyncLoading initially', () {
      final container = ProviderContainer(
        overrides: [
          tradersRepositoryProvider.overrideWithValue(FakeTradersRepository()),
        ],
      );
      addTearDown(container.dispose);

      // Read filteredTradersProvider immediately after container creation
      final filteredTraders = container.read(filteredTradersProvider);

      // Should be AsyncLoading before awaiting tradersProvider.future
      expect(filteredTraders, isA<AsyncLoading>());
    });

    test('filteredTradersProvider shows AsyncData after loading completes',
        () async {
      final container = ProviderContainer(
        overrides: [
          tradersRepositoryProvider.overrideWithValue(FakeTradersRepository()),
        ],
      );
      addTearDown(container.dispose);

      // Await the traders loading
      await container.read(tradersProvider.future);

      // Now filteredTradersProvider should be AsyncData
      final filteredTraders = container.read(filteredTradersProvider);
      expect(filteredTraders, isA<AsyncData<List<Trader>>>());
      expect(filteredTraders.value,
          hasLength(3)); // All 3 traders (no filter applied)
    });

    test('filteredCountProvider is null while loading', () {
      final container = ProviderContainer(
        overrides: [
          tradersRepositoryProvider.overrideWithValue(FakeTradersRepository()),
        ],
      );
      addTearDown(container.dispose);

      // Read filteredCountProvider immediately after container creation
      final count = container.read(filteredCountProvider);

      // Should be null before awaiting tradersProvider.future
      expect(count, isNull);
    });

    test('filtered providers update when filter is applied', () async {
      final container = ProviderContainer(
        overrides: [
          tradersRepositoryProvider.overrideWithValue(FakeTradersRepository()),
        ],
      );
      addTearDown(container.dispose);

      // Await the traders loading
      await container.read(tradersProvider.future);

      // Apply a filter
      container.read(appliedFilterProvider.notifier).apply(
            const FilterState(tags: {'Top Performer'}),
          );

      // Check filteredTradersProvider updates
      final filteredTraders = container.read(filteredTradersProvider);
      expect(filteredTraders, isA<AsyncData<List<Trader>>>());
      expect(filteredTraders.value,
          hasLength(2)); // Traders with 'Top Performer' tag

      // Check filteredCountProvider updates
      final count = container.read(filteredCountProvider);
      expect(count, equals(2));
    });

    test('Draft/applied separation test', () async {
      // Create container with overrides from the start
      final container = ProviderContainer(
        overrides: [
          tradersRepositoryProvider.overrideWithValue(FakeTradersRepository()),
        ],
      );
      addTearDown(container.dispose);

      // Await the traders loading
      await container.read(tradersProvider.future);

      // Apply an initial filter to appliedFilterProvider
      container.read(appliedFilterProvider.notifier).apply(
            const FilterState(tags: {'Top Performer'}),
          );

      // Check initial state
      final initialFilteredTraders = container.read(filteredTradersProvider);
      expect(initialFilteredTraders.value, hasLength(2));
      final initialCount = container.read(filteredCountProvider);
      expect(initialCount, equals(2));

      // Mutate draftFilterProvider
      container.read(draftFilterProvider.notifier).toggleTag('Money Maker');

      // Applied filter should NOT change
      final appliedFilter = container.read(appliedFilterProvider);
      expect(appliedFilter.tags, equals({'Top Performer'}));

      // Filtered providers should NOT change yet
      final unchangedFilteredTraders = container.read(filteredTradersProvider);
      expect(unchangedFilteredTraders.value, hasLength(2));
      final unchangedCount = container.read(filteredCountProvider);
      expect(unchangedCount, equals(2));

      // Apply draft to applied filter
      container.read(appliedFilterProvider.notifier).apply(
            container.read(draftFilterProvider),
          );

      // Now filtered providers should update
      final updatedFilteredTraders = container.read(filteredTradersProvider);
      expect(updatedFilteredTraders.value,
          hasLength(3)); // All traders have at least one of the tags
      final updatedCount = container.read(filteredCountProvider);
      expect(updatedCount, equals(3));
    });

    test('Draft seeding test', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Apply a non-empty filter to appliedFilterProvider
      container.read(appliedFilterProvider.notifier).apply(
            const FilterState(tags: {'Top Performer', 'Money Maker'}),
          );

      // Read draftFilterProvider for the first time
      final draftFilter = container.read(draftFilterProvider);

      // Should equal the current applied FilterState value
      expect(draftFilter.tags, equals({'Top Performer', 'Money Maker'}));
    });

    test('autoDispose discard-on-relisten test', () async {
      // Create container with overrides from the start
      final container = ProviderContainer(
        overrides: [
          tradersRepositoryProvider.overrideWithValue(FakeTradersRepository()),
        ],
      );
      addTearDown(container.dispose);

      // Await the traders loading
      await container.read(tradersProvider.future);

      // Apply an initial filter to appliedFilterProvider
      container.read(appliedFilterProvider.notifier).apply(
            const FilterState(tags: {'Top Performer'}),
          );

      // Create a subscription to draftFilterProvider
      final sub = container.listen(draftFilterProvider, (prev, next) {});

      // Toggle a tag on the draft
      container.read(draftFilterProvider.notifier).toggleTag('Money Maker');

      // Check that draft has the edited value
      final editedDraft = container.read(draftFilterProvider);
      expect(editedDraft.tags, contains('Money Maker'));

      // Close the subscription
      sub.close();

      // Let disposal settle - using a small delay to ensure disposal happens
      await Future.delayed(Duration(milliseconds: 100));

      // Perform a fresh read of draftFilterProvider
      final freshDraft = container.read(draftFilterProvider);

      // Should equal the current appliedFilterProvider value, NOT the discarded edited value
      expect(freshDraft.tags, equals({'Top Performer'}));
      expect(freshDraft.tags, isNot(contains('Money Maker')));
    });
  });
}
