import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/providers.dart';
import 'package:fe_assessment_earnex/src/ui/trader_card.dart';
import 'package:fe_assessment_earnex/src/ui/states/skeleton_card.dart';
import 'package:fe_assessment_earnex/src/ui/states/empty_no_data_state.dart';
import 'package:fe_assessment_earnex/src/ui/states/empty_filtered_state.dart';
import 'package:fe_assessment_earnex/src/ui/states/error_state.dart';

/// A list of traders with loading, error, and empty states.
class TraderList extends ConsumerWidget {
  const TraderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradersAsync = ref.watch(filteredTradersProvider);
    final isFilterEmpty = ref.watch(appliedFilterProvider).isEmpty;

    return tradersAsync.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: 4,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: SkeletonCard(),
        ),
      ),
      error: (error, stack) => ErrorState(error: error),
      data: (traders) {
        if (traders.isEmpty) {
          return isFilterEmpty
              ? const EmptyNoDataState()
              : const EmptyFilteredState();
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: traders.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TraderCard(trader: traders[index]),
            );
          },
        );
      },
    );
  }
}
