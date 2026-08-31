import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/providers.dart';
import 'package:fe_assessment_earnex/src/ui/filter/tag_chip.dart';

/// A group of tag chips that displays the 7 required tags and manages selection.
class TagChipGroup extends ConsumerWidget {
  const TagChipGroup({super.key});

  // The exact 7 tag chip labels in the required order
  static const List<String> _tagLabels = [
    "Top Performer",
    "Money Maker",
    "Most Resilient",
    "Whale Manager",
    "Solid Growth",
    "Low Leverage",
    "Most Consistent",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(draftFilterProvider);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _tagLabels.map((label) {
        return TagChip(
          label: label,
          selected: draft.tags.contains(label),
          onTap: () {
            ref.read(draftFilterProvider.notifier).toggleTag(label);
          },
        );
      }).toList(),
    );
  }
}
