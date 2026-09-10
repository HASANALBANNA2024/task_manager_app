import 'package:flutter/material.dart';

class TaskItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;

  const TaskItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    this.statusColor = const Color(0xFFE28B00),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECE9)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 12, color: Colors.black45)),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(date, style: const TextStyle(fontSize: 11, color: Colors.black38)),
              ],
            )
          ],
        ),
      ),
    );
  }
}