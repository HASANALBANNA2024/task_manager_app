import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/app_text.dart';
import '../../features/auth/controllers/auth_controller.dart';

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const AppText(
        "Log Out",
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppTheme.ink,
      ),
      content: const AppText(
        "Are you sure you want to log out of your account?",
        fontSize: 14,
        color: AppTheme.inkFaint,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const AppText(
            "Cancel",
            color: AppTheme.inkSoft,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await AuthController.logout();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            }
          },
          child: const AppText(
            "Log out",
            color: AppTheme.brick,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}