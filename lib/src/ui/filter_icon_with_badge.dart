import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/providers.dart';
import 'package:fe_assessment_earnex/src/ui/filter/filter_bottom_sheet.dart';
import 'package:fe_assessment_earnex/src/ui/theme/tokens.dart';

/// The 40x40 filter button with a badge showing how many traders currently
/// pass the applied filter.
///
/// Mirrors Figma `Filter button` (node 22:5865).
class FilterIconWithBadge extends ConsumerWidget {
  const FilterIconWithBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(filteredCountProvider);

    return GestureDetector(
      onTap: () => _openSheet(context),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgBrandLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Image.asset(AppIcons.filterList, width: 24, height: 24),
          ),
          if (count != null)
            Positioned(
              right: -4,
              top: -6,
              child: Container(
                constraints: const BoxConstraints(minWidth: 20),
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.bgBrand,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$count',
                  style: AppText.semiBold12.copyWith(
                    fontSize: 10,
                    height: 1,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }
}
