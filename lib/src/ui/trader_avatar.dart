import 'package:flutter/material.dart';

/// A trader avatar widget with fallback color.
class TraderAvatar extends StatelessWidget {
  final String url;
  final double size;

  const TraderAvatar({
    super.key,
    required this.url,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 4, // 2px outer padding on each side
      height: size + 4,
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              color: const Color(0xFFF0B90B),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              color: const Color(0xFFF0B90B),
            );
          },
        ),
      ),
    );
  }
}
