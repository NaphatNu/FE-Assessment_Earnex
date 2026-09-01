import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/features/portfolio/domain/trader.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/api_badge.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/format.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/metric_cell.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/sparkline.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';
import 'package:fe_assessment_earnex/features/portfolio/presentation/widgets/trader_avatar.dart';

/// One trader card.
///
/// Mirrors Figma `Link` (node 21:4608): a 350x250 rounded card carrying the
/// gold "spot" background wash, a soft drop shadow, and four stacked blocks
/// separated by 12pt.
class TraderCard extends StatelessWidget {
  const TraderCard({super.key, required this.trader});

  final Trader trader;

  /// Fixed in the design — every card is exactly this tall.
  static const double height = 250;

  @override
  Widget build(BuildContext context) {
    final positive = trader.pnl30d >= 0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Stack(
          children: [
            const Positioned.fill(child: _CardWash()),
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderDefault),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(trader: trader),
                      const SizedBox(height: AppSpacing.x12),
                      _PnlBlock(trader: trader, positive: positive),
                      const SizedBox(height: AppSpacing.x12),
                      _StatsRow(trader: trader),
                      const SizedBox(height: AppSpacing.x12),
                      const _Actions(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The gold gradient plus the blurred gold ellipse behind the card content.
///
/// Figma layers a 50%-opacity "BG" instance holding a vertical
/// `#FFF7E0 -> #FFFFFF` gradient and a 200px-blurred `#D89F00` ellipse whose
/// centre sits just off the top-right corner of the card. The ellipse is
/// rendered here as an equivalent radial fade rather than a real 200px blur,
/// which would cost a full-card blur pass on every card in the list.
class _CardWash extends StatelessWidget {
  const _CardWash();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.cardWashStart, AppColors.cardWashEnd],
                  stops: [0.43, 0.70],
                ),
              ),
            ),
          ),
          Positioned(
            left: 202,
            top: -73,
            width: 334,
            height: 334,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.cardGlow.withValues(alpha: 0.28),
                    AppColors.cardGlow.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.trader});

  final Trader trader;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TraderAvatar(url: trader.avatarUrl),
        const SizedBox(width: AppSpacing.x12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trader.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    AppText.semiBold16.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.x2),
              Row(
                children: [
                  Container(
                    height: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppIcons.users12, width: 12, height: 12),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          '${trader.copiers} / ${trader.copiersMax}',
                          style: AppText.regular12.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trader.isApi) ...[
                    const SizedBox(width: AppSpacing.x4),
                    const ApiBadge(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PnlBlock extends StatelessWidget {
  const _PnlBlock({required this.trader, required this.positive});

  final Trader trader;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final accent = positive ? AppColors.textSuccess : AppColors.textError;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '30 Days PNL (USD)',
                style:
                    AppText.regular12.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                Format.money(trader.pnl30d),
                style: AppText.bold20.copyWith(color: accent),
              ),
              const SizedBox(height: AppSpacing.x2),
              Row(
                children: [
                  Text(
                    'ROI',
                    style: AppText.regular12
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  Text(
                    Format.percent(trader.roi),
                    style: AppText.medium12.copyWith(color: accent),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Sparkline(seed: trader.id, positive: positive),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.trader});

  final Trader trader;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MetricCell(
            label: 'AUM',
            value: Format.money(trader.aum),
          ),
        ),
        Expanded(
          child: MetricCell(
            label: '30 Days MDD',
            value: Format.percent(trader.mdd30d),
          ),
        ),
        Expanded(
          child: MetricCell(
            label: 'Sharpe Ratio',
            value: trader.sharpe.toStringAsFixed(2),
            alignment: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 85,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Text(
            'Mock',
            style: AppText.semiBold14.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: AppSpacing.x8),
        Expanded(
          child: Container(
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgBrand,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              'Copy',
              style: AppText.semiBold14.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
