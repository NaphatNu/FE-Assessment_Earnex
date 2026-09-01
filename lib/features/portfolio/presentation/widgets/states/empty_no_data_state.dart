import 'package:flutter/material.dart';

/// Shown when the traders list loaded successfully but is empty with no
/// filter applied -- there is simply no data.
class EmptyNoDataState extends StatelessWidget {
  const EmptyNoDataState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Color(0xFF707A8A)),
          SizedBox(height: 12),
          Text(
            'No traders available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E2329),
            ),
          ),
        ],
      ),
    );
  }
}
