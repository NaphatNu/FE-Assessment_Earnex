import 'package:flutter/material.dart';

/// A tag chip widget that can be selected or unselected.
class TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const TagChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: selected ? const Color(0xFF1E2329) : const Color(0xFFEAECEF),
            width: selected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.check,
                  size: 14,
                  color: Color(0xFF1E2329),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E2329),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
