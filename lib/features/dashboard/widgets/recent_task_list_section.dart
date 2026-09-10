import 'package:flutter/material.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_button.dart';
import 'package:task_manager_app/features/dashboard/widgets/task_item_card.dart';

class RecentTaskListSection extends StatelessWidget {
  final List<dynamic> taskList;

  const RecentTaskListSection({super.key, required this.taskList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              "Recent tasks",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            AppTextButton(
              text: "See all",
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            var task = taskList[index];
            return TaskItemCard(
              title: task['title'] ?? '',
              description: task['description'] ?? '',
              status: task['status'] ?? 'New',
              date: task['createdDate'] ?? '',
            );
          },
        ),
      ],
    );
  }
}