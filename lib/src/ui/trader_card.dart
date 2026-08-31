import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/src/domain/trader.dart';
import 'package:fe_assessment_earnex/src/ui/format.dart';
import 'package:fe_assessment_earnex/src/ui/trader_avatar.dart';
import 'package:fe_assessment_earnex/src/ui/api_badge.dart';
import 'package:fe_assessment_earnex/src/ui/metric_cell.dart';

/// A card displaying trader information.
class TraderCard extends StatelessWidget {
  final Trader trader;

  const TraderCard({
    super.key,
    required this.trader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEAECEF),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, 17.5, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              TraderAvatar(url: trader.avatarUrl, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trader.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600, // Semi Bold
                        fontSize: 16,
                        height: 22 / 16,
                        color: Color(0xFF1E2329),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.group,
                                size: 12,
                                color: Color(0xFF707A8A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${trader.copierCount} / ${trader.copierLimit}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400, // Regular
                                  fontSize: 12,
                                  height: 16 / 12,
                                  color: Color(0xFF1E2329),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (trader.isAPI) ...[
                          const SizedBox(width: 4),
                          const ApiBadge(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // PNL block
          const SizedBox(height: 12),
          Text(
            '30 Days PNL (USD)',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400, // Regular
              fontSize: 12,
              height: 16 / 12,
              color: Color(0xFF707A8A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Format.money(trader.pnl30d),
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700, // Bold
              fontSize: 20,
              height: 28 / 20,
              color: trader.pnl30d >= 0
                  ? const Color(0xFF0ECB81)
                  : const Color(0xFFF6465D),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'ROI',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400, // Regular
                  fontSize: 12,
                  height: 16 / 12,
                  color: Color(0xFF707A8A),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                Format.percent(trader.roi30d),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500, // Medium
                  fontSize: 12,
                  height: 16 / 12,
                  color: trader.roi30d >= 0
                      ? const Color(0xFF0ECB81)
                      : const Color(0xFFF6465D),
                ),
              ),
            ],
          ),

          // Stats row
          const SizedBox(height: 12),
          Row(
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
                  value: trader.sharpeRatio.toStringAsFixed(2),
                ),
              ),
            ],
          ),

          // Actions row
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 85,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: const Center(
                  child: Text(
                    'Mock',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600, // Semi Bold
                      fontSize: 14,
                      height: 20 / 14,
                      color: Color(0xFF1E2329),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0B90B),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Center(
                    child: Text(
                      'Copy',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600, // Semi Bold
                        fontSize: 14,
                        height: 20 / 14,
                        color: Color(0xFF1E2329),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
