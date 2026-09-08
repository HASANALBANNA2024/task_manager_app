import 'package:flutter/material.dart';
import 'package:task_manager_app/app/theme/app_theme.dart';

/// Text , onTap, Color, Height/Width or Loading state Control use
class AppButton extends StatelessWidget {

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final double width;
  final double height;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = AppTheme.moss,
    this.textColor = AppTheme.surface,
    this.width = double.infinity,
    this.height = 50,
    this.isLoading = false,
});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
     width:  width,
     height: height,
     child: ElevatedButton(
       style: ElevatedButton.styleFrom(
         backgroundColor: color,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(13)
         ),
         elevation: 0,
       ),
         onPressed: isLoading ? null : onTap,
         child: isLoading ?
             const SizedBox(
               child: CircularProgressIndicator( color: AppTheme.surface, strokeWidth: 2,),
             ): Text(text, style: TextStyle(
           fontFamily: 'Manrope',
           fontSize: 13.5,
           fontWeight: FontWeight.w800,
           color: textColor
         ),)
     ),
   );
  }


}