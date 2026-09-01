import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// A selectable chip inside the filter sheet.
///
/// Mirrors the Figma `Button` component set (node 21:5542): the
/// `state=default, type=outline` and `state=active, type=outline` variants
/// differ only in border colour — there is no checkmark and no weight change.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  /// Every chip in the sheet is this tall (12pt padding over a 16pt line).
  static const double height = 38;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x24),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.borderStrong : AppColors.borderDefault,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppText.semiBold12.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// Lays chips out two-per-row with 8pt gaps, the way every chip group in the
/// sheet is built in Figma (`Frame 10`, node 22:7068).
class ChipGrid extends StatelessWidget {
  const ChipGrid({super.key, required this.chips});

  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < chips.length; i += 2) {
      final hasSecond = i + 1 < chips.length;
      rows.add(
        Row(
          children: [
            Expanded(child: chips[i]),
            const SizedBox(width: AppSpacing.x8),
            // A lone trailing chip still occupies only half the row.
            Expanded(child: hasSecond ? chips[i + 1] : const SizedBox()),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.x8),
          rows[i],
        ],
      ],
    );
  }
}
