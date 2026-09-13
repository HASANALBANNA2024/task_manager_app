import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_icon.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_button.dart';
import 'package:task_manager_app/core/widgets/app_text_field.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/auth/screen/login_screen.dart';

import '../../../app/theme/app_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      isGradient: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Back Button Icon Box
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

              const SizedBox(height: 24),

              // Title Header
              const AppText(
                "Create your account",
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),

              const SizedBox(height: 6),

              // Subtitle
              const AppText(
                "A few details and you're set to go",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black45,
              ),

              const SizedBox(height: 28),

              // First Name and Last Name Row
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _firstNameController,
                      labelText: "First name",
                      hintText: "Hasan",
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: AppTextField(
                      controller: _lastNameController,
                      labelText: "Last name",
                      hintText: "Rahman",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Email Field
              AppTextField(
                controller: _emailController,
                labelText: "Email",
                hintText: "hasan@gmail.com",
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // Mobile Number Field
              AppTextField(
                controller: _mobileController,
                labelText: "Mobile number",
                hintText: "01716 874981",
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              // Password Field
              AppTextField(
                controller: _passwordController,
                labelText: "Password",
                hintText: "••••••••",
                obscureText: true,
              ),

              const SizedBox(height: 28),

              // Primary Create Account Button with Loading State
              Visibility(
                visible: !_inProgress,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: AppButton(
                  text: "Create account",
                  width: double.infinity,
                  onTap: _onTapSignUp,
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Already Have Account Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppText(
                    "Already have an account? ",
                    fontSize: 12.5,
                    color: Colors.black45,
                  ),
                  AppTextButton(
                    text: "Log in",
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.moss,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTapSignUp() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _firstNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields!")),
      );
      return;
    }

    setState(() {
      _inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
      "password": _passwordController.text.trim()
    };

    final ApiResponse response = await ApiService.postRequest(
      AppUrls.registration,
      body: requestBody,
    );

    setState(() {
      _inProgress = false;
    });

    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful!")),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.errorMessage.isNotEmpty
                  ? response.errorMessage
                  : "Registration Failed!",
            ),
          ),
        );
      }
    }
  }
}
