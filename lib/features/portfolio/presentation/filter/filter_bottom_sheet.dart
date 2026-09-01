import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/sheet_actions.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/tag_chip.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/tag_chip_group.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// The "Advanced Filters" sheet.
///
/// Mirrors Figma `UI 1 / Frame 23` (node 22:7051). Every control in the
/// design is drawn; only **Tags** is wired to state, per the brief. The sheet
/// takes zero filter data through its constructor — hence `const`.
class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  /// 685 of the 852pt design frame.
  static const double _heightFactor = 685 / 852;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = MediaQuery.of(context);

    return SizedBox(
      height: media.size.height * _heightFactor,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHeader(),
            Expanded(
              child: Container(
                color: AppColors.bgPrimary,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x16,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Section(label: 'Tags', child: TagChipGroup()),
                      SizedBox(height: AppSpacing.x16),
                      _Section(label: '30D PnL', child: _PnlRange()),
                      SizedBox(height: AppSpacing.x16),
                      _Section(label: '7D ROI', child: _RoiChips()),
                      SizedBox(height: AppSpacing.x16),
                      _ApiToggleRow(),
                    ],
                  ),
                ),
              ),
            ),
            _SheetFooter(bottomInset: media.viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        AppSpacing.x4,
        AppSpacing.x16,
        AppSpacing.x12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.sheetGrabber,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x20),
          Text(
            'Advanced Filters',
            style: AppText.semiBold16.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// A `12pt` gap between a secondary-grey section label and its controls.
class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.regular12.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.x12),
        child,
      ],
    );
  }
}

/// The two read-only amount fields and the range slider beneath them.
///
/// Drawn to match the design; not wired to state (see docs/03-ui-and-figma).
class _PnlRange extends StatelessWidget {
  const _PnlRange();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: _AmountField('0')),
            SizedBox(width: AppSpacing.x4),
            Text('-'),
            SizedBox(width: AppSpacing.x4),
            Expanded(child: _AmountField('500000')),
          ],
        ),
        const SizedBox(height: AppSpacing.x12),
        SizedBox(
          height: 16,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Positioned(
                  left: 8,
                  right: 8,
                  top: 7,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.borderStrong,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
                const Positioned(left: 0, child: _SliderHandle()),
                const Positioned(right: 0, child: _SliderHandle()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x24),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        value,
        style: AppText.semiBold14.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

class _SliderHandle extends StatelessWidget {
  const _SliderHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: AppColors.bgBrand,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Four ROI threshold chips. Drawn to match the design; not wired to state.
class _RoiChips extends StatelessWidget {
  const _RoiChips();

  @override
  Widget build(BuildContext context) {
    return const ChipGrid(
      chips: [
        TagChip(label: '≥0%', selected: false),
        TagChip(label: '≥25%', selected: false),
        TagChip(label: '≥50%', selected: false),
        TagChip(label: '≥100%', selected: false),
      ],
    );
  }
}

/// The API row with an iOS-style switch. Drawn to match the design; not wired.
class _ApiToggleRow extends StatelessWidget {
  const _ApiToggleRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'API',
            style: AppText.medium14.copyWith(color: AppColors.textPrimary),
          ),
          Container(
            width: 64,
            height: 28,
            padding: const EdgeInsets.all(2),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0x4D3C3C43),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              width: 39,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFooter extends StatelessWidget {
  const _SheetFooter({required this.bottomInset});

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    // Figma reserves 60pt below the buttons; on a device with a home
    // indicator part of that is already the system inset.
    // final bottom = math.max(60 - bottomInset, AppSpacing.x16);

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x16,
        AppSpacing.x16,
        AppSpacing.x16,
        AppSpacing.x16,
      ),
      child: const SheetActions(),
    );
  }
}
