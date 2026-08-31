import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/ui/filter/tag_chip_group.dart';
import 'package:fe_assessment_earnex/src/ui/filter/sheet_actions.dart';

/// A filter bottom sheet that can be instantiated as const FilterBottomSheet().
class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 20),
            child: Column(
              children: [
                SizedBox(height: 4),
                Center(
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xFFCCCCCC),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Advanced Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E2329),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Scrollable body
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags section
                    const Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF707A8A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const TagChipGroup(),
                    const SizedBox(height: 32),
                    // 30D PnL section (visual only)
                    const Text(
                      '30D PnL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF707A8A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Text('0'),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('-'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Text('500000'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // 7D ROI section (visual only)
                    const Text(
                      '7D ROI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF707A8A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ROIChip(label: '≥0%'),
                        _ROIChip(label: '≥25%'),
                        _ROIChip(label: '≥50%'),
                        _ROIChip(label: '≥100%'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // API row (visual only)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'API',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E2329),
                          ),
                        ),
                        Switch(
                          value: false,
                          onChanged: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer
          const SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsets.only(top: 16, bottom: 24),
              child: SheetActions(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A non-interactive chip for displaying ROI values.
class _ROIChip extends StatelessWidget {
  final String label;

  const _ROIChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: const Color(0xFFEAECEF),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E2329),
            ),
          ),
        ),
      ),
    );
  }
}
