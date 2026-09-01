import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/src/ui/theme/tokens.dart';

/// The trader avatar: a 44pt round image inset by 2pt, wrapped in the
/// gold "achievement ring" decoration that overhangs the top of the frame.
///
/// Mirrors Figma node 21:4611.
class TraderAvatar extends StatelessWidget {
  const TraderAvatar({
    super.key,
    required this.url,
    this.size = 44,
  });

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    // The ring is 56x56 over a 48x48 box, offset 8pt upwards in Figma.
    final boxSize = size + 4;
    final ringSize = boxSize * 56 / 48;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x2),
            child: ClipOval(
              child: Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _fallback(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: -boxSize * 8 / 48,
            child: Image.asset(
              AppIcons.avatarRing,
              width: ringSize,
              height: ringSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback() => Container(
        width: size,
        height: size,
        color: AppColors.bgBrand,
      );
}
