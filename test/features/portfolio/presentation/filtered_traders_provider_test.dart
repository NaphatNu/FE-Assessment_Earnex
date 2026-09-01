import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/trader.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/filter_state.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';

void main() {
  group('filteredTradersProvider', () {
    test('filters traders based on applied filter', () async {
      // Create test traders
      final traders = [
        Trader(
          id: '1',
          name: 'Trader 1',
          avatarUrl: 'https://example.com/avatar1.jpg',
          copierCount: 0,
          copierLimit: 100,
          isAPI: true,
          tags: ['Top Performer'],
          pnl30d: 1000.0,
          roi30d: 5.0,
          aum: 10000.0,
          mdd30d: 1.0,
          sharpeRatio: 1.5,
        ),
        Trader(
          id: '2',
          name: 'Trader 2',
          avatarUrl: 'https://example.com/avatar2.jpg',
          copierCount: 0,
          copierLimit: 100,
          isAPI: true,
          tags: ['Money Maker'],
          pnl30d: 2000.0,
          roi30d: 6.0,
          aum: 20000.0,
          mdd30d: 2.0,
          sharpeRatio: 1.6,
        ),
        Trader(
          id: '3',
          name: 'Trader 3',
          avatarUrl: 'https://example.com/avatar3.jpg',
          copierCount: 0,
          copierLimit: 100,
          isAPI: true,
          tags: ['High Risk'],
          pnl30d: 3000.0,
          roi30d: 7.0,
          aum: 30000.0,
          mdd30d: 3.0,
          sharpeRatio: 1.7,
        ),
      ];

      // Create container with overridden providers
      final container = ProviderContainer(
        overrides: [
          tradersProvider.overrideWith((ref) async => traders),
        ],
      );
      addTearDown(container.dispose);

      // Initially, no filter applied, should show all traders
      await container.read(tradersProvider.future);
      var filteredTraders = container.read(filteredTradersProvider);
      expect(filteredTraders.value, hasLength(3));

      // Apply a filter for "Top Performer" and "Money Maker"
      container.read(appliedFilterProvider.notifier).apply(
            const FilterState(tags: {'Top Performer', 'Money Maker'}),
          );

      // Now should only show 2 traders
      filteredTraders = container.read(filteredTradersProvider);
      expect(filteredTraders.value, hasLength(2));
      expect(filteredTraders.value?.map((t) => t.id), containsAll(['1', '2']));
    });
  });

  group('filteredCountProvider', () {
    test('returns the correct count of filtered traders', () async {
      // Create test traders
      final traders = [
        Trader(
          id: '1',
          name: 'Trader 1',
          avatarUrl: 'https://example.com/avatar1.jpg',
          copierCount: 0,
          copierLimit: 100,
          isAPI: true,
          tags: ['Top Performer'],
          pnl30d: 1000.0,
          roi30d: 5.0,
          aum: 10000.0,
          mdd30d: 1.0,
          sharpeRatio: 1.5,
        ),
        Trader(
          id: '2',
          name: 'Trader 2',
          avatarUrl: 'https://example.com/avatar2.jpg',
          copierCount: 0,
          copierLimit: 100,
          isAPI: true,
          tags: ['Money Maker'],
          pnl30d: 2000.0,
          roi30d: 6.0,
          aum: 20000.0,
          mdd30d: 2.0,
          sharpeRatio: 1.6,
        ),
      ];

      // Create container with overridden providers
      final container = ProviderContainer(
        overrides: [
          tradersProvider.overrideWith((ref) async => traders),
        ],
      );
      addTearDown(container.dispose);

      // Initially, no filter applied, should show count of 2
      await container.read(tradersProvider.future);
      var count = container.read(filteredCountProvider);
      expect(count, equals(2));

      // Apply a filter that matches only one trader
      container.read(appliedFilterProvider.notifier).apply(
            const FilterState(tags: {'Top Performer'}),
          );

      // Now should show count of 1
      count = container.read(filteredCountProvider);
      expect(count, equals(1));
    });
  });
}
