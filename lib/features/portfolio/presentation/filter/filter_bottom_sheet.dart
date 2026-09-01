import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/sheet_actions.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/tag_chip.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/filter/tag_chip_group.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// The "Advanced Filters" sheet.
///
/// Mirrors Figma `UI 1 / Frame 23` (node 22:7051). **Tags** is wired to
/// `draftFilterProvider`, per the brief. The PnL range, ROI chips, and API
/// switch are interactive (draggable/typable/tappable) but keep their own
/// local widget state rather than feeding a provider. The sheet takes zero
/// filter data through its constructor — hence `const`.
class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  /// 685 of the 852pt design frame.
  static const double _heightFactor = 685 / 852;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = MediaQuery.of(context);

    return SizedBox(
      height: media.size.height * _heightFactor,
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
/// them. Interactive, but keeps its own local state — see the class doc on
/// [FilterBottomSheet] for why it isn't wired to a provider.
class _PnlRange extends StatefulWidget {
  const _PnlRange();

  @override
  State<_PnlRange> createState() => _PnlRangeState();
}

class _PnlRangeState extends State<_PnlRange> {
  static const double _min = 0;
  static const double _max = 500000;
  static const double _handleSize = 16;

  double _lower = _min;
  double _upper = _max;

  late final _lowerCtrl = TextEditingController(text: _format(_lower));
  late final _upperCtrl = TextEditingController(text: _format(_upper));

  static String _format(double v) => v.round().toString();

  @override
  void dispose() {
    _lowerCtrl.dispose();
    _upperCtrl.dispose();
    super.dispose();
  }

  void _commitLower(String text) {
    final parsed = double.tryParse(text);
    setState(() {
      _lower = parsed == null ? _lower : parsed.clamp(_min, _upper);
      _lowerCtrl.text = _format(_lower);
    });
  }

  void _commitUpper(String text) {
    final parsed = double.tryParse(text);
    setState(() {
      _upper = parsed == null ? _upper : parsed.clamp(_lower, _max);
      _upperCtrl.text = _format(_upper);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _AmountField(
                controller: _lowerCtrl,
                onSubmitted: _commitLower,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            const Text('-'),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _AmountField(
                controller: _upperCtrl,
                onSubmitted: _commitUpper,
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
              final lowerX = (_lower / _max) * trackWidth;
              final upperX = (_upper / _max) * trackWidth;

              void dragLower(double dx) {
                setState(() {
                  final frac = ((lowerX + dx) / trackWidth).clamp(0.0, 1.0);
                  _lower = (frac * _max).clamp(_min, _upper);
                  _lowerCtrl.text = _format(_lower);
                });
              }

              void dragUpper(double dx) {
                setState(() {
                  final frac = ((upperX + dx) / trackWidth).clamp(0.0, 1.0);
                  _upper = (frac * _max).clamp(_lower, _max);
                  _upperCtrl.text = _format(_upper);
                });
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

/// Four ROI threshold chips, single-select (tap again to clear). Keeps its
/// own local state — see the class doc on [FilterBottomSheet].
class _RoiChips extends StatefulWidget {
  const _RoiChips();

  @override
  State<_RoiChips> createState() => _RoiChipsState();
}

class _RoiChipsState extends State<_RoiChips> {
  static const _labels = ['≥0%', '≥25%', '≥50%', '≥100%'];

  int? _selected;

  @override
  Widget build(BuildContext context) {
    return ChipGrid(
      chips: [
        for (var i = 0; i < _labels.length; i++)
          TagChip(
            label: _labels[i],
            selected: _selected == i,
            onTap: () => setState(() {
              _selected = _selected == i ? null : i;
            }),
          ),
      ],
    );
  }
}

/// The API row with an iOS-style switch, grey when off and green when on.
/// Keeps its own local state — see the class doc on [FilterBottomSheet].
class _ApiToggleRow extends StatefulWidget {
  const _ApiToggleRow();

  @override
  State<_ApiToggleRow> createState() => _ApiToggleRowState();
}

class _ApiToggleRowState extends State<_ApiToggleRow> {
  bool _enabled = false;

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
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _enabled = !_enabled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              width: 64,
              height: 28,
              padding: const EdgeInsets.all(2),
              alignment:
                  _enabled ? Alignment.centerRight : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: _enabled ? AppColors.green500 : const Color(0x4D3C3C43),
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
  const _SheetFooter({required this.bottomInset});

  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    // Figma reserves 60pt below the buttons; on a device with a home
    // indicator part of that is already the system inset.
    final bottom = math.max(60 - bottomInset, AppSpacing.x16);

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x16,
        AppSpacing.x16,
        AppSpacing.x16,
        bottom,
      ),
      child: const SheetActions(),
    );
  }
}
