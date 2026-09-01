import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fe_assessment_earnex/data/traders_repository.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/filter_state.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/trader.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/states/skeleton_card.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/trader_list.dart';

class _FakeTradersRepository implements TradersRepository {
  _FakeTradersRepository(this._future);

  final Future<List<Trader>> Function() _future;

  @override
  Future<List<Trader>> fetchTraders() => _future();
}

Trader _trader(String id, List<String> tags) => Trader(
      id: id,
      name: 'Trader $id',
      avatarUrl: 'https://example.com/$id.jpg',
      copierCount: 0,
      copierLimit: 100,
      isAPI: false,
      tags: tags,
      pnl30d: 100.0,
      roi30d: 5.0,
      aum: 1000.0,
      mdd30d: 1.0,
      sharpeRatio: 1.0,
    );

Widget _appWith(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: Scaffold(body: TraderList())),
  );
}

void main() {
  testWidgets('loading state shows skeleton cards', (tester) async {
    final container = ProviderContainer(
      overrides: [
        tradersRepositoryProvider.overrideWithValue(
          _FakeTradersRepository(() => Completer<List<Trader>>().future),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(_appWith(container));
    await tester.pump();

    expect(find.byType(SkeletonCard), findsWidgets);
  });

  testWidgets('error state shows message and Retry', (tester) async {
    final container = ProviderContainer(
      overrides: [
        tradersRepositoryProvider.overrideWithValue(
          _FakeTradersRepository(() => Future.error(Exception('boom'))),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(_appWith(container));
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    expect(find.textContaining('Something went wrong'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    // Retrying re-invokes the repository and re-lands in the same error
    // state without crashing (the fake always throws).
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('empty state (no data) shown when list is empty and no filter',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        tradersRepositoryProvider.overrideWithValue(
          _FakeTradersRepository(() async => <Trader>[]),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(_appWith(container));
    await tester.pumpAndSettle();

    expect(find.text('No traders available'), findsOneWidget);
  });

  testWidgets(
      'empty state (filtered) shown when a filter excludes every trader, '
      'and Clear filter restores the list', (tester) async {
    final container = ProviderContainer(
      overrides: [
        tradersRepositoryProvider.overrideWithValue(
          _FakeTradersRepository(
            () async => [
              _trader('1', ['Top Performer'])
            ],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(appliedFilterProvider.notifier).apply(
          const FilterState(tags: {'Whale Manager'}),
        );

    await tester.pumpWidget(_appWith(container));
    await tester.pumpAndSettle();

    expect(find.text('No traders match your filter'), findsOneWidget);
    expect(find.text('Clear filter'), findsOneWidget);

    await tester.tap(find.text('Clear filter'));
    await tester.pumpAndSettle();

    expect(find.text('No traders match your filter'), findsNothing);
  });
}
