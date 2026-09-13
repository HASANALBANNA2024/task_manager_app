import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_helper.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final String? userName;
  final String? taskCountText;
  final String? userInitials;
  final VoidCallback? onProfileTap;

  const ProfileHeader({
    super.key,
    this.title = "Task Manager",
    this.userName,
    this.taskCountText,
    this.userInitials,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {

    final nameParts = (userName ?? '').trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts[1] : '';


    final String displayInitials = UserInitials.getInitials(firstName, lastName);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D5A42),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              userName ?? "Loading...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (taskCountText != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8ECE9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  taskCountText!,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ),
            ]
          ],
        ),

        // Profile Initials Box
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8ECE9),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              displayInitials,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A2B)),
            ),
          ),
        ),
      ],
    );
  }
}