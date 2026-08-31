import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/providers.dart';

import 'package:fe_assessment_earnex/src/ui/filter/filter_bottom_sheet.dart';

/// A filter icon with a badge showing the filtered count.
class FilterIconWithBadge extends ConsumerWidget {
  const FilterIconWithBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(filteredCountProvider);

    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFFEF6D8),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.filter_list,
              size: 24,
              color: Color(0xFF707A8A),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const FilterBottomSheet(),
              );
            },
          ),
        ),
        if (count != null)
          Positioned(
            right: -4,
            top: -7,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFFF0B90B),
                borderRadius: BorderRadius.all(Radius.circular(99)),
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF1E2329),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
