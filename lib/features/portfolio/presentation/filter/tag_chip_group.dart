import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/tag_chip.dart';

/// The 7 tag chips, laid out two per row exactly as in Figma.
class TagChipGroup extends ConsumerWidget {
  const TagChipGroup({super.key});

  // The exact 7 tag chip labels in the required order
  static const List<String> _tagLabels = [
    'Top Performer',
    'Money Maker',
    'Most Resilient',
    'Whale Manager',
    'Solid Growth',
    'Low Leverage',
    'Most Consistent',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(draftFilterProvider);

    return ChipGrid(
      chips: [
        for (final label in _tagLabels)
          TagChip(
            label: label,
            selected: draft.tags.contains(label),
            onTap: () =>
                ref.read(draftFilterProvider.notifier).toggleTag(label),
          ),
      ],
    );
  }
}
