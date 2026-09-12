import 'package:flutter/material.dart';
import 'package:task_manager_app/features/dashboard/widgets/task_item_card.dart';

import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_button.dart';

class RecentTaskListSection extends StatelessWidget {
  final List<dynamic> taskList;
  final Function(Map<String, dynamic>)? onTaskTap;

  const RecentTaskListSection({
    super.key,
    required this.taskList,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText("Recent tasks", fontSize: 16, fontWeight: FontWeight.w700),
            AppTextButton(text: "See all", onTap: () {}),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            var task = taskList[index];
            return GestureDetector(
              onTap: () {
                if (onTaskTap != null) {
                  onTaskTap!(task);
                }
              },
              child: TaskItemCard(
                title: task['title'] ?? '',
                description: task['description'] ?? '',
                status: task['status'] ?? 'New',
                date: task['createdDate'] ?? '',
              ),
            );
          },
        ),
      ],
    );
  }
}