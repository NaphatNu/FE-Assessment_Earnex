import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/providers.dart';
import 'package:fe_assessment_earnex/src/ui/theme/tokens.dart';
import 'package:fe_assessment_earnex/src/ui/trader_card.dart';
import 'package:fe_assessment_earnex/src/ui/states/skeleton_card.dart';
import 'package:fe_assessment_earnex/src/ui/states/empty_no_data_state.dart';
import 'package:fe_assessment_earnex/src/ui/states/empty_filtered_state.dart';
import 'package:fe_assessment_earnex/src/ui/states/error_state.dart';

/// A list of traders with loading, error, and empty states.
///
/// Cards are inset 20pt either side and separated by 16pt, matching the
/// 350pt card on the 390pt Figma frame.
class TraderList extends ConsumerWidget {
  const TraderList({super.key});

  static const EdgeInsets _padding = EdgeInsets.fromLTRB(20, 0, 20, 16);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradersAsync = ref.watch(filteredTradersProvider);
    final isFilterEmpty = ref.watch(appliedFilterProvider).isEmpty;

    return tradersAsync.when(
      loading: () => ListView.separated(
        padding: _padding,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.x16),
        itemBuilder: (_, __) => const SkeletonCard(),
      ),
      error: (error, stack) => ErrorState(error: error),
      data: (traders) {
        if (traders.isEmpty) {
          return isFilterEmpty
              ? const EmptyNoDataState()
              : const EmptyFilteredState();
        }
        return ListView.separated(
          padding: _padding,
          itemCount: traders.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.x16),
          itemBuilder: (context, index) => TraderCard(trader: traders[index]),
        );
      },
    );
  }
}
