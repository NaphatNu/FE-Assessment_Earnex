import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// A label-over-value cell used by the three-column stats row on the card.
///
/// Mirrors Figma node 21:4663.
class MetricCell extends StatelessWidget {
  const MetricCell({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.alignment = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final Color? valueColor;

  /// The right-most column is right-aligned in the design.
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final textAlign =
        alignment == CrossAxisAlignment.end ? TextAlign.right : TextAlign.left;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.visible,
          softWrap: false,
          style: AppText.regular12.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          textAlign: textAlign,
          style: AppText.medium12.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
