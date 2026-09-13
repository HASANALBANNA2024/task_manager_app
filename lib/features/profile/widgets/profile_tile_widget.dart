import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/app_text.dart';

class ProfileTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;

  const ProfileTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBg = isLogout
        ? AppTheme.brick.withValues(alpha:0.12)
        : AppTheme.moss.withValues(alpha:0.08);

    final Color iconColor = isLogout ? AppTheme.brick : AppTheme.ink;
    final Color textColor = isLogout ? AppTheme.brick : AppTheme.ink;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.line, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppText(
                  title,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              if (!isLogout)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.inkFaint,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}