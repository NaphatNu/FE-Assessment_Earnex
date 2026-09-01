import 'package:flutter_test/flutter_test.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/filter_state.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/trader.dart';

void main() {
  group('FilterState', () {
    test('matches returns true when tags are empty', () {
      const filter = FilterState();
      final trader = Trader(
        id: '1',
        name: 'Test Trader',
        avatarUrl: 'https://example.com/avatar.jpg',
        copierCount: 0,
        copierLimit: 100,
        isAPI: true,
        tags: ['Top Performer'],
        pnl30d: 1000.0,
        roi30d: 5.0,
        aum: 10000.0,
        mdd30d: 1.0,
        sharpeRatio: 1.5,
      );

      expect(filter.matches(trader), isTrue);
    });

    test('matches returns true when trader has any of the selected tags', () {
      const filter = FilterState(tags: {'Top Performer', 'Money Maker'});
      final trader = Trader(
        id: '1',
        name: 'Test Trader',
        avatarUrl: 'https://example.com/avatar.jpg',
        copierCount: 0,
        copierLimit: 100,
        isAPI: true,
        tags: ['Top Performer'],
        pnl30d: 1000.0,
        roi30d: 5.0,
        aum: 10000.0,
        mdd30d: 1.0,
        sharpeRatio: 1.5,
      );

      expect(filter.matches(trader), isTrue);
    });

    test('matches returns false when trader has none of the selected tags', () {
      const filter = FilterState(tags: {'Top Performer', 'Money Maker'});
      final trader = Trader(
        id: '1',
        name: 'Test Trader',
        avatarUrl: 'https://example.com/avatar.jpg',
        copierCount: 0,
        copierLimit: 100,
        isAPI: true,
        tags: ['High Risk'],
        pnl30d: 1000.0,
        roi30d: 5.0,
        aum: 10000.0,
        mdd30d: 1.0,
        sharpeRatio: 1.5,
      );

      expect(filter.matches(trader), isFalse);
    });

    test('copyWith creates a new FilterState with updated tags', () {
      const filter = FilterState(tags: {'Top Performer'});
      final newFilter = filter.copyWith(tags: {'Money Maker'});

      expect(newFilter.tags, equals({'Money Maker'}));
      expect(filter.tags, equals({'Top Performer'})); // Original unchanged
    });

    test('equality works correctly', () {
      const filter1 = FilterState(tags: {'Top Performer', 'Money Maker'});
      const filter2 = FilterState(
          tags: {'Money Maker', 'Top Performer'}); // Same tags, different order
      const filter3 = FilterState(tags: {'Top Performer'});

      expect(filter1 == filter2, isTrue); // Sets with same elements are equal
      expect(filter1 == filter3, isFalse);
    });
  });
}
