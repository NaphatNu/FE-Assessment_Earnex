import 'package:flutter/material.dart';

/// A small "API" text badge.
class ApiBadge extends StatelessWidget {
  const ApiBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'API',
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500, // Medium
        fontSize: 14,
        height: 20 / 14,
        color: Color(0xFF1E2329),
      ),
    );
  }
}
