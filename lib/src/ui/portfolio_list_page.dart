import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/ui/header_section.dart';
import 'package:fe_assessment_earnex/src/ui/tab_bar_section.dart';
import 'package:fe_assessment_earnex/src/ui/filter_icon_with_badge.dart';
import 'package:fe_assessment_earnex/src/ui/trader_list.dart';

/// The main portfolio list page.
class PortfolioListPage extends ConsumerWidget {
  const PortfolioListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Column(
        children: [
          HeaderSection(),
          TabBarSection(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text('High PNL'),
                ),
                FilterIconWithBadge(),
              ],
            ),
          ),
          Expanded(
            child: TraderList(),
          ),
        ],
      ),
    );
  }
}
