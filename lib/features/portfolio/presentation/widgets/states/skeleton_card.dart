import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// A static grey placeholder shaped like a trader card, shown while
/// the trader list is loading.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border(
          bottom: BorderSide(color: AppColors.borderDefault, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, 17.5, 15, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _bar(44, 44, radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bar(120, 16),
                    const SizedBox(height: 6),
                    _bar(70, 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _bar(140, 12),
          const SizedBox(height: 8),
          _bar(100, 20),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _bar(double.infinity, 28)),
              const SizedBox(width: 8),
              Expanded(child: _bar(double.infinity, 28)),
              const SizedBox(width: 8),
              Expanded(child: _bar(double.infinity, 28)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(double width, double height, {double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.borderDefault,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
