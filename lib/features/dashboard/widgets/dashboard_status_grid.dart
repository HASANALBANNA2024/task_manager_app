import 'package:flutter/material.dart';
import 'package:task_manager_app/features/dashboard/widgets/status_card.dart';

class DashboardStatusGrid extends StatelessWidget {
  final String Function(String) getCount;

  const DashboardStatusGrid({super.key, required this.getCount});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.25,
      children: [
        StatusCard(
          count: getCount('New'),
          title: "New",
          icon: Icons.access_time_filled,
          backgroundColor: const Color(0xFFFAF0E6),
          iconColor: const Color(0xFFE28B00),
        ),
        StatusCard(
          count: getCount('Progress'),
          title: "In Progress",
          icon: Icons.refresh_rounded,
          backgroundColor: const Color(0xFFE8F4F8),
          iconColor: const Color(0xFF1E88E5),
        ),
        StatusCard(
          count: getCount('Completed'),
          title: "Complete",
          icon: Icons.check_circle_rounded,
          backgroundColor: const Color(0xFFEAF4EC),
          iconColor: const Color(0xFF2E7D32),
        ),
        StatusCard(
          count: getCount('Canceled'),
          title: "Cancelled",
          icon: Icons.cancel_rounded,
          backgroundColor: const Color(0xFFF5F5F5),
          iconColor: const Color(0xFF757575),
        ),
      ],
    );
  }
}