import 'package:flutter/material.dart';

/// A simple tab bar section with static labels.
class TabBarSection extends StatelessWidget {
  const TabBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Center(
            child: Text('Recommended'),
          ),
        ),
        Expanded(
          child: Center(
            child: Text('All Portfolios'),
          ),
        ),
        Expanded(
          child: Center(
            child: Text('My Favorites'),
          ),
        ),
      ],
    );
  }
}
