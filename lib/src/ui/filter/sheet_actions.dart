import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_assessment_earnex/src/providers.dart';

/// Action buttons for the filter bottom sheet: Reset and Confirm.
class SheetActions extends ConsumerWidget {
  const SheetActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(draftFilterProvider);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: draft.isEmpty
                  ? null
                  : () {
                      ref.read(draftFilterProvider.notifier).reset();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: draft.isEmpty
                    ? const Color(0xFFF0F0F0)
                    : const Color(0xFFF0B90B),
                foregroundColor: draft.isEmpty
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF1E2329),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                ref.read(appliedFilterProvider.notifier).apply(
                      ref.read(draftFilterProvider),
                    );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0B90B),
                foregroundColor: const Color(0xFF1E2329),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
