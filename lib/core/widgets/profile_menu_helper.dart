import 'package:flutter/material.dart';
class ProfileMenuItem {
  final String title;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
  });
}

class ProfileMenuHelper {
  static void showMenu(
      BuildContext context, {
        required List<ProfileMenuItem> items,
      }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              return ListTile(
                leading: Icon(item.icon, color: item.color),
                title: Text(
                  item.title,
                  style: TextStyle(color: item.color),
                ),
                onTap: () {
                  Navigator.pop(context);
                  item.onTap();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}