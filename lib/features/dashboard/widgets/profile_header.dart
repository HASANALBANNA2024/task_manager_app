import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final String? userName; // Nullable করা হলো যেন API লোড না হওয়া পর্যন্ত ক্র্যাশ না করে
  final String? taskCountText;
  final String? userInitials; // Nullable করা হলো
  final VoidCallback? onProfileTap;

  const ProfileHeader({
    super.key,
    this.title = "Task Manager",
    this.userName,
    this.taskCountText,
    this.userInitials,
    this.onProfileTap,
  });


  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return "U";
    List<String> nameParts = name.trim().split(" ");
    if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
      return "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
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
              userInitials ?? _getInitials(userName),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A2B)),
            ),
          ),
        ),
      ],
    );
  }
}