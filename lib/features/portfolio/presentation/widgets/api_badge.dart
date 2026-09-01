import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// The small "API" label shown next to the copier count.
///
/// Mirrors Figma node 21:5007.
class ApiBadge extends StatelessWidget {
  const ApiBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Text(
        'API',
        style: AppText.regular12.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
