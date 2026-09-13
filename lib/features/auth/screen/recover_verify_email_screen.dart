import 'package:flutter/material.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_icon.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_field.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/auth/controllers/auth_controller.dart';
import 'package:task_manager_app/features/auth/screen/pin_verification_screen.dart';

class RecoverVerifyEmailScreen extends StatefulWidget {
  const RecoverVerifyEmailScreen({super.key});

  @override
  State<RecoverVerifyEmailScreen> createState() =>
      _RecoverVerifyEmailScreenState();
}

class _RecoverVerifyEmailScreenState extends State<RecoverVerifyEmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _inProgress = false;

  @override
  void dispose() {
    _emailController.dispose();
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

            /// Back Button Icon Box
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

            /// Center Top Mail Icon, Title & Subtitle
            const Center(
              child: Column(
                children: [
                  AppIcon(
                    icon: Icons.mail_outline_rounded,
                    size: 64,
                    iconSize: 32,
                    iconColor: Color(0xFF2D5A42),
                  ),
                  SizedBox(height: 24),
                  AppText(
                    "Forgot your password?",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  SizedBox(height: 8),
                  AppText(
                    "Enter your email and we'll send a\n verification code.",
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

            /// Email Field
            AppTextField(
              controller: _emailController,
              labelText: "Email",
              hintText: "hasan@gmail.com",
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 24),

            _inProgress
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : AppButton(
                    text: "Send code",
                    onTap: _onTapVerifyEmail,
                    width: double.infinity,
                  )
          ],
        ),
      ),
    );
  }

  /// Email Verification Method
  Future<void> _onTapVerifyEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: AppText("Please enter a valid email")));
      return;
    }
    setState(() => _inProgress = true);

    bool isSuccess = await AuthController.verifyEmail(email);

    setState(() => _inProgress = false);
    if (!mounted) return;

    if (isSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PinVerificationScreen(email: email)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: AppText("User not found or email verification failed"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
