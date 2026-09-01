import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

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
            color: AppColors.iconSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            'No traders match your filter',
            style: AppText.semiBold16.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(appliedFilterProvider.notifier).clear(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bgBrand,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Clear filter',
              style: AppText.semiBold14,
            ),
          ),
        ],
      ),
    );
  }
}
