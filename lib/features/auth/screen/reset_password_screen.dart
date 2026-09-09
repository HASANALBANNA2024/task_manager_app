import 'package:flutter/material.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_icon.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_field.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otpcode;
  const ResetPasswordScreen({super.key, required this.email, required this.otpcode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _inProgress = false;
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      isGradient: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const AppIcon(
                icon: Icons.chevron_left_rounded,
                size: 40,
                iconSize: 24,
                iconColor: Colors.black87,
                backgroundColor: Color(0xFFF0F4F1),
                borderRadius: 12,
              ),
            ),

            const SizedBox(height: 30),

            // Top Header Lock Icon, Title & Description
            const Center(
              child: Column(
                children: [
                  AppIcon(
                    icon: Icons.lock_outline_rounded,
                    size: 64,
                    iconSize: 32,
                    iconColor: Color(0xFF2D5A42),
                  ),
                  SizedBox(height: 24),
                  AppText(
                    "Set a new password",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  SizedBox(height: 8),
                  AppText(
                    "Choose a strong password you haven't\nused before.",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                    textAlign: TextAlign.center,
                    height: 1.4,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // New Password Field
            AppTextField(
              controller: _newPasswordController,
              labelText: "New password",
              hintText: "••••••••",
              obscureText: true,
            ),

            const SizedBox(height: 16),

            // Confirm Password Field
            AppTextField(
              controller: _confirmPasswordController,
              labelText: "Confirm password",
              hintText: "••••••••",
              obscureText: true,
            ),

            const SizedBox(height: 28),

            // Reset Password Action Button
           _inProgress ? const Center(child:  CircularProgressIndicator(),) :
               AppButton(text: "Reset password", onTap: _onTapResetPassword, width: double.infinity,)
          ],
        ),
      ),
    );
  }
  /// onTap reset password function
  Future<void> _onTapResetPassword() async {
    final password = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validation
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a new password')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _inProgress = true);

    // AuthController Call
    bool isSuccess = await AuthController.resetPassword(email: widget.email, otp: widget.otpcode, newPassword: password);
    setState(() => _inProgress = false);

    if (!mounted) return;

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully! Please login.'),
          backgroundColor: Colors.green,
        ),
      );

      // Login Screen-navigate
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to reset password. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }










}