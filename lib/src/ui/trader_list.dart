import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/providers.dart';
import 'package:fe_assessment_earnex/src/ui/trader_card.dart';

/// A list of traders with loading and error states.
class TraderList extends ConsumerWidget {
  const TraderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradersAsync = ref.watch(filteredTradersProvider);

    return tradersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (traders) {
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
