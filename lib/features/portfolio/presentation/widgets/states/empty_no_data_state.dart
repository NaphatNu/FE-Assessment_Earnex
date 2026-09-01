import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// Shown when the traders list loaded successfully but is empty with no
/// filter applied -- there is simply no data.
class EmptyNoDataState extends StatelessWidget {
  const EmptyNoDataState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppColors.iconSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            'No traders available',
            style: AppText.semiBold16.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
