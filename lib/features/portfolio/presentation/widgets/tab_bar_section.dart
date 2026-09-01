import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// The tab strip ("Recommended / All Portfolios / My Favorites") plus the
/// trailing filter button, which in Figma lives inside this same row.
///
/// Mirrors Figma node 6:730.
class TabBarSection extends StatelessWidget {
  const TabBarSection({super.key, required this.trailing});

  /// The filter button. Passed in so this widget stays free of Riverpod.
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderDefault),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _Tab('Recommended', selected: true),
          const _Tab('All Portfolios'),
          const _Tab('My Favorites'),
          trailing,
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab(this.label, {this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: AppSpacing.x8, bottom: 5),
      decoration: selected
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderBrand, width: 3),
              ),
            )
          : null,
      child: Text(
        label,
        style: AppText.medium14.copyWith(
          color: selected ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// The "High PNL ⌄ … More ›" row that sits between the tabs and the list.
///
/// Mirrors Figma node 6:775.
class SortBarSection extends StatelessWidget {
  const SortBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        AppSpacing.x12,
        AppSpacing.x16,
        AppSpacing.x8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'High PNL',
                style:
                    AppText.medium12.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.x2),
              Image.asset(AppIcons.chevronDown16, width: 16, height: 16),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'More',
                style:
                    AppText.medium12.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.x2),
              Image.asset(AppIcons.chevronRight16, width: 16, height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
