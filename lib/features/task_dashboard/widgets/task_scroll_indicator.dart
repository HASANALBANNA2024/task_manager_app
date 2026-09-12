import 'package:flutter/material.dart';

class TaskScrollIndicator extends StatelessWidget {
  const TaskScrollIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_left, size: 16, color: Color(0xFF94A3B8)),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.35,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF64748B),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(Icons.arrow_right, size: 16, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}