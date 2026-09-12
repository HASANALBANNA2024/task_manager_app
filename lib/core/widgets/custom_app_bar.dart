import 'package:flutter/material.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';

import '../../app/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.ink),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: AppText(
        title,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppTheme.ink,
      ),
      centerTitle: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}