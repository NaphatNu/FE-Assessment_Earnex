import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/header_section.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/tab_bar_section.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/filter_icon_with_badge.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/trader_list.dart';

/// The main portfolio list page.
///
/// Mirrors Figma `UI 7` (node 6:609): app bar, headings, promo banner, tab
/// strip with the filter button, sort row, then the scrolling trader list.
class PortfolioListPage extends ConsumerWidget {
  const PortfolioListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            HeaderSection(),
            SizedBox(height: AppSpacing.x12),
            TabBarSection(trailing: FilterIconWithBadge()),
            SortBarSection(),
            Expanded(child: TraderList()),
          ],
        ),
      ),
    );
  }
}
