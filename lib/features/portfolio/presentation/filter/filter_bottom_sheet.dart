import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/sheet_actions.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/tag_chip.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/tag_chip_group.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/portfolio_providers.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// The "Advanced Filters" sheet.
///
/// Mirrors Figma `UI 1 / Frame 23` (node 22:7051). Every control writes to
/// `draftFilterProvider`, so Reset clears all of them. Only `tags` is read by
/// `FilterState.matches`, so the PnL range, the ROI threshold and the API
/// toggle reach `appliedFilterProvider` on Confirm without narrowing the list.
/// The sheet takes zero filter data through its constructor — hence `const`.
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
            const _SheetFooter(),
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

/// The two editable amount fields and the draggable range slider beneath
/// them, backed by `draftFilterProvider` so Reset clears them too.
class _PnlRange extends ConsumerStatefulWidget {
  const _PnlRange();

  @override
  ConsumerState<_PnlRange> createState() => _PnlRangeState();
}

class _PnlRangeState extends ConsumerState<_PnlRange> {
  static const double _min = 0;
  static const double _max = 500000;
  static const double _handleSize = 16;

  late final _lowerCtrl = TextEditingController();
  late final _upperCtrl = TextEditingController();

  static String _format(double v) => v.round().toString();

  @override
  void dispose() {
    _lowerCtrl.dispose();
    _upperCtrl.dispose();
    super.dispose();
  }

  void _commitLower(String text, double upper) {
    final parsed = double.tryParse(text);
    final lower = parsed == null
        ? ref.read(draftFilterProvider).pnlMin
        : parsed.clamp(_min, upper);
    ref.read(draftFilterProvider.notifier).setPnlRange(lower, upper);
  }

  void _commitUpper(String text, double lower) {
    final parsed = double.tryParse(text);
    final upper = parsed == null
        ? ref.read(draftFilterProvider).pnlMax
        : parsed.clamp(lower, _max);
    ref.read(draftFilterProvider.notifier).setPnlRange(lower, upper);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(draftFilterProvider);
    final lower = draft.pnlMin;
    final upper = draft.pnlMax;

    final lowerText = _format(lower);
    final upperText = _format(upper);
    if (_lowerCtrl.text != lowerText) _lowerCtrl.text = lowerText;
    if (_upperCtrl.text != upperText) _upperCtrl.text = upperText;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _AmountField(
                controller: _lowerCtrl,
                onSubmitted: (text) => _commitLower(text, upper),
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            const Text('-'),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _AmountField(
                controller: _upperCtrl,
                onSubmitted: (text) => _commitUpper(text, lower),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x12),
        SizedBox(
          height: 16,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth - _handleSize;
              final lowerX = (lower / _max) * trackWidth;
              final upperX = (upper / _max) * trackWidth;

              void dragLower(double dx) {
                final frac = ((lowerX + dx) / trackWidth).clamp(0.0, 1.0);
                final newLower = (frac * _max).clamp(_min, upper);
                ref
                    .read(draftFilterProvider.notifier)
                    .setPnlRange(newLower, upper);
              }

              void dragUpper(double dx) {
                final frac = ((upperX + dx) / trackWidth).clamp(0.0, 1.0);
                final newUpper = (frac * _max).clamp(lower, _max);
                ref
                    .read(draftFilterProvider.notifier)
                    .setPnlRange(lower, newUpper);
              }

              return Stack(
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
                  Positioned(
                    left: lowerX + 8,
                    right: constraints.maxWidth - upperX - 8,
                    top: 7,
                    child: Container(
                      height: 2,
                      color: AppColors.bgBrand,
                    ),
                  ),
                  Positioned(
                    left: lowerX,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (d) => dragLower(d.delta.dx),
                      child: const _SliderHandle(),
                    ),
                  ),
                  Positioned(
                    left: upperX,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (d) => dragUpper(d.delta.dx),
                      child: const _SliderHandle(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AmountField extends StatefulWidget {
  const _AmountField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) widget.onSubmitted(widget.controller.text);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppText.semiBold14.copyWith(color: AppColors.textPrimary),
        decoration: const InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
        ),
        onSubmitted: widget.onSubmitted,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
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

/// Four ROI threshold chips, single-select (tap again to clear), backed by
/// `draftFilterProvider` so Reset clears the selection too.
class _RoiChips extends ConsumerWidget {
  const _RoiChips();

  static const _thresholds = [0.0, 25.0, 50.0, 100.0];
  static const _labels = ['≥0%', '≥25%', '≥50%', '≥100%'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(draftFilterProvider).roiThreshold;

    return ChipGrid(
      chips: [
        for (var i = 0; i < _labels.length; i++)
          TagChip(
            label: _labels[i],
            selected: selected == _thresholds[i],
            onTap: () => ref.read(draftFilterProvider.notifier).setRoiThreshold(
                  selected == _thresholds[i] ? null : _thresholds[i],
                ),
          ),
      ],
    );
  }
}

/// The API row with an iOS-style switch, grey when off and green when on,
/// backed by `draftFilterProvider` so Reset turns it off too.
class _ApiToggleRow extends ConsumerWidget {
  const _ApiToggleRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(draftFilterProvider).apiOnly;

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'API',
            style: AppText.medium14.copyWith(color: AppColors.textPrimary),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                ref.read(draftFilterProvider.notifier).setApiOnly(!enabled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              width: 64,
              height: 28,
              padding: const EdgeInsets.all(2),
              alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: enabled ? AppColors.green500 : const Color(0x4D3C3C43),
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
          ),
        ],
      ),
    );
  }
}

class _SheetFooter extends StatelessWidget {
  const _SheetFooter();

  @override
  Widget build(BuildContext context) {
    // Figma reserves 60pt below the buttons for the home indicator; the
    // sheet's own `SafeArea(top: false)` already pads that, so what is left
    // here is a plain 16pt inset.
    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        AppSpacing.x16,
        AppSpacing.x16,
        AppSpacing.x16,
      ),
      child: const SheetActions(),
    );
  }
}
