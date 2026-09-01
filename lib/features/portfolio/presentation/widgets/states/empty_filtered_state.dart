import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';

/// Shown when the traders list loaded successfully but the applied filter
/// excluded every trader.
class EmptyFilteredState extends ConsumerWidget {
  const EmptyFilteredState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.filter_alt_off_outlined,
            size: 48,
            color: Color(0xFF707A8A),
          ),
          const SizedBox(height: 12),
          const Text(
            'No traders match your filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E2329),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(appliedFilterProvider.notifier).clear(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0B90B),
              foregroundColor: const Color(0xFF1E2329),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Clear filter',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
