import 'package:flutter/material.dart';

/// A simple metric display cell with a label and value.
class MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const MetricCell({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400, // Regular
            fontSize: 12,
            height: 16 / 12,
            color: Color(0xFF707A8A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500, // Medium
            fontSize: 12,
            height: 16 / 12,
            color: valueColor ?? const Color(0xFF1E2329),
          ),
        ),
      ],
    );
  }
}
