import 'package:flutter/material.dart';

/// A simple header section with title.
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Spot Copy Trading',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700, // Bold
          fontSize: 18,
        ),
      ),
    );
  }
}
