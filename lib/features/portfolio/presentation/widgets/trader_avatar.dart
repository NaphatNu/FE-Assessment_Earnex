import 'package:flutter/material.dart';
import 'package:fe_assessment_earnex/theme/tokens.dart';

/// The trader avatar: a 44pt round image inset by 2pt, wrapped in the
/// gold "achievement ring" decoration that overhangs the top of the frame.
///
/// Mirrors Figma node 21:4611.
class TraderAvatar extends StatelessWidget {
  const TraderAvatar({
    super.key,
    required this.url,
    required this.name,
    this.size = 44,
  });

  final String url;
  final String name;
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
                errorBuilder: (_, __, ___) =>
                    AvatarFallback(name: name, size: size),
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : AvatarFallback(name: name, size: size),
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
}

/// Shown in place of the avatar image while it loads and when it fails —
/// the trader's first character on the brand circle.
class AvatarFallback extends StatelessWidget {
  const AvatarFallback({super.key, required this.name, required this.size});

  final String name;
  final double size;

  String get _initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.bgBrand,
          shape: BoxShape.circle,
        ),
        child: Text(
          _initial,
          style: AppText.semiBold16.copyWith(color: AppColors.textPrimary),
        ),
      );
}
