import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// Shown when [tradersProvider] failed to load, with a way to retry.
class ErrorState extends ConsumerWidget {
  const ErrorState({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.textError),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
            style: AppText.semiBold16.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x32),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppText.regular12.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(tradersProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bgBrand,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Retry',
              style: AppText.semiBold14,
            ),
          ),
        ],
      ),
    );
  }
}
