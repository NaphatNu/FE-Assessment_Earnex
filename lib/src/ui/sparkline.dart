import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/src/ui/theme/tokens.dart';

/// The 92x48 performance sparkline that sits to the right of the PNL block.
///
/// Mirrors Figma node 21:4641. The mock data set carries no time series, so
/// the curve is generated deterministically from [seed] (the trader id) and
/// drifts in the direction of [positive]. It is illustrative, not data — the
/// same trader always draws the same line, and no fabricated number is ever
/// shown as text.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.seed,
    required this.positive,
    this.width = 92,
    this.height = 48,
  });

  final String seed;
  final bool positive;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(
          points: _series(seed, positive),
          color: positive ? AppColors.textSuccess : AppColors.textError,
        ),
      ),
    );
  }

  /// A bounded random walk in 0..1, reproducible for a given seed.
  static List<double> _series(String seed, bool positive) {
    final random = math.Random(seed.hashCode);
    final drift = positive ? 0.035 : -0.035;
    var value = positive ? 0.25 : 0.75;

    return List<double>.generate(24, (_) {
      value = (value + drift + (random.nextDouble() - 0.5) * 0.28)
          .clamp(0.05, 0.95);
      return value;
    });
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.points, required this.color});

  final List<double> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = Path();
    final step = size.width / (points.length - 1);
    for (var i = 0; i < points.length; i++) {
      final offset = Offset(i * step, size.height * (1 - points[i]));
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.points != points;
}
