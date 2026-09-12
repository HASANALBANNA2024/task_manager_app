import 'package:flutter/material.dart';

class TaskEmptyStateWidget extends StatelessWidget {
  final String filterName;

  const TaskEmptyStateWidget({super.key, required this.filterName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.check_box_outlined, size: 40, color: Color(0xFF2D6A4F)),
            ),
            const SizedBox(height: 20),
            Text(
              "Nothing ${filterName.toLowerCase()} yet",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 8),
            const Text(
              "Finish a task and it will show up here. Tap a checkbox on the Home tab to get started.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, height: 1.4, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}