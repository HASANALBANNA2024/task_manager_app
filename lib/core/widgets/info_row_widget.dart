import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';
import 'app_text.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final double labelFontSize;
  final double valueFontSize;
  final Color labelColor;
  final Color valueColor;

  const InfoRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.labelFontSize = 13.5,
    this.valueFontSize = 13.5,
    this.labelColor = AppTheme.inkFaint,
    this.valueColor = AppTheme.ink,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          fontSize: labelFontSize,
          fontWeight: FontWeight.w500,
          color: labelColor,
        ),
        AppText(
          value,
          fontSize: valueFontSize,
          fontWeight: FontWeight.w700,
          color: valueColor,
        ),
      ],
    );
  }
}