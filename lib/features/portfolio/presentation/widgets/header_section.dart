import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// The top of the portfolio screen: the "Spot" app bar, the two headings and
/// the Elite Trader promo banner.
///
/// Mirrors Figma `UI 7 / Body / Container` (node 6:628).
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      // The Figma container insets its 360pt content inside the 390pt frame.
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopBar(),
          SizedBox(height: AppSpacing.x12),
          _Headings(),
          SizedBox(height: AppSpacing.x16),
          _PromoBanner(),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Spot',
                  style: AppText.medium14.copyWith(
                    color: AppColors.textPrimary,
                  )),
              const _Icon(AppIcons.chevronDown20, size: 20),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const _Icon(AppIcons.playCircle, size: 16),
              ),
              const SizedBox(width: 10),
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgBrand,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _Icon(AppIcons.leadTrader, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      'Be a Lead Trader',
                      style: AppText.medium14.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Headings extends StatelessWidget {
  const _Headings();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spot Copy Trading',
          style: AppText.bold20.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.x20),
        Text(
          "Follow the world's top crypto traders and copy their trades with "
          'one click',
          style: AppText.bold20.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x12,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgTertiary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The Figma text node hugs at 169pt, which lands the break between
          // "Program" and "Up". The break is written out here so it survives
          // a font-metric difference instead of spilling to a third line.
          Text(
            'Join Elite Trader Program\nUp To 30% Profit Share!',
            style: AppText.medium14.copyWith(color: AppColors.textPrimary),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Join Now',
                style: AppText.medium12.copyWith(color: AppColors.textPrimary),
              ),
              Text(
                '2/2',
                style:
                    AppText.regular12.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// An icon exported from Figma, sized to an explicit square box.
class _Icon extends StatelessWidget {
  const _Icon(this.asset, {required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(asset, width: size, height: size);
  }
}
