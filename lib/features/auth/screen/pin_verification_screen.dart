import 'package:flutter/material.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_icon.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_button.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/auth/controllers/auth_controller.dart';
import 'package:task_manager_app/features/auth/screen/reset_password_screen.dart';

import '../../../app/theme/app_theme.dart';

class PinVerificationScreen extends StatefulWidget {
  final String? email;

  const PinVerificationScreen({super.key, this.email});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  bool _inProgress = false;
  bool _isResending = false;

  // 6 Digit Controller & FocusNodes
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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

            // Header Icon & Title
            Center(
              child: Column(
                children: [
                  const AppIcon(
                    icon: Icons.lock_outline_rounded,
                    size: 64,
                    iconSize: 32,
                    iconColor: Color(0xFF2D5A42),
                  ),
                  const SizedBox(height: 24),
                  const AppText(
                    "Enter the code",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    "We sent a 6-digit verification code to\n${widget.email ?? 'your email'}",
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

            // 6-Digit OTP Custom Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _buildOtpBox(index)),
            ),

            const SizedBox(height: 28),

            // Verify Button with Loading Indicator
            _inProgress
                ? const Center(child: CircularProgressIndicator())
                : AppButton(
                    text: "Verify",
                    width: double.infinity,
                    onTap: _onTapVerifyOtp,
                  ),

            const SizedBox(height: 24),

            // Resend Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppText(
                  "Didn't get a code? ",
                  fontSize: 12.5,
                  color: Colors.black45,
                ),
                _isResending
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : AppTextButton(
                        text: "Resend",
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.moss,
                        onTap: _onTapResendCode)
              ],
            ),
          ],
        ),
      ),
    );
  }

  // OTP Verification logic
  Future<void> _onTapVerifyOtp() async {
    String otpCode = _controllers.map((c) => c.text.trim()).join();

    if (otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter 6-digit code")),
      );
      return;
    }

    if (widget.email == null || widget.email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email address is missing!")),
      );
      return;
    }

    setState(() => _inProgress = true);

    bool isSuccess = await AuthController.verifyotp(widget.email!, otpCode);

    setState(() => _inProgress = false);
    if (!mounted) return;

    if (isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: widget.email!,
            otpcode: otpCode,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP code! Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Resend method
  Future<void> _onTapResendCode() async {
    if (widget.email == null || widget.email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: AppText("Email address is missing")));
      return;
    }
    setState(() {
      _isResending = true;
    });
    bool isSuccess = await AuthController.verifyEmail(widget.email!);
    setState(() {
      _isResending = false;
    });
    if (!mounted) return;

    if (isSuccess) {
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: AppText("A new OTP code has been sent again! Check your email")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AppText(
            "Failed to resend code! Please try again.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Single OTP Box Widget
  Widget _buildOtpBox(int index) {
    return SizedBox(
      height: 52,
      width: 44,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          counterText: "",
          fillColor: _controllers[index].text.isNotEmpty
              ? (AppTheme.mossTint)
              : Colors.transparent,
          filled: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: _controllers[index].text.isNotEmpty
                  ? (AppTheme.moss)
                  : Colors.grey.shade300,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.moss,
              width: 1.5,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
