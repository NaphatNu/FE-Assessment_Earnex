import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/providers.dart';
import 'package:fe_assessment_earnex/src/ui/theme/tokens.dart';

/// Reset / Confirm, using the three Figma `Button` variants:
/// `disabled, outline` (grey) when there is nothing to reset,
/// `default, outline` (white + hairline) once there is, and
/// `enabled, filled` (brand) for Confirm.
///
/// Mirrors Figma node 22:7287.
class SheetActions extends ConsumerWidget {
  const SheetActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(draftFilterProvider);
    final canReset = !draft.isEmpty;

    return Row(
      children: [
        Expanded(
          child: _SheetButton(
            label: 'Reset',
            background:
                canReset ? AppColors.bgPrimary : AppColors.bgDisabled,
            borderColor: canReset ? AppColors.borderDefault : null,
            onTap: canReset
                ? () => ref.read(draftFilterProvider.notifier).reset()
                : null,
          ),
        ),
        const SizedBox(width: AppSpacing.x8),
        Expanded(
          child: _SheetButton(
            label: 'Confirm',
            background: AppColors.bgBrand,
            onTap: () {
              ref
                  .read(appliedFilterProvider.notifier)
                  .apply(ref.read(draftFilterProvider));
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.background,
    this.borderColor,
    this.onTap,
  });

  final String label;
  final Color background;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: borderColor == null ? null : Border.all(color: borderColor!),
        ),
        child: Text(
          label,
          style: AppText.semiBold12.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
