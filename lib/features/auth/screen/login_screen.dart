import 'package:flutter/material.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_icon.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_button.dart';
import 'package:task_manager_app/core/widgets/app_text_field.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/auth/controllers/auth_controller.dart';
import 'package:task_manager_app/features/auth/screen/recover_verify_email_screen.dart';
import 'package:task_manager_app/features/auth/screen/sign_up_screen.dart';
import 'package:task_manager_app/features/dashboard/screen/dashboard_screen.dart';
import '../../../app/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      isGradient: false,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppIcon(
                icon: Icons.edit_note_rounded,
                size: 64,
                iconSize: 36,
                iconColor: Color(0xFF2D5A42),
              ),
              const SizedBox(height: 24),
              const AppText(
                "Welcome Back",
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
              const SizedBox(height: 8),
              const AppText(
                "All your tasks in one place. Log in to pick \n up where you left off.",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black45,
                textAlign: TextAlign.center,
                height: 1.4,
              ),
              const SizedBox(height: 32),
              AppTextField(
                controller: _emailController,
                hintText: "youremail@gmail.com",
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                hintText: "********",
                labelText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: AppTextButton(
                  text: "Forgot Password",
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.moss ,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecoverVerifyEmailScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),


              _isLoading
                  ? const CircularProgressIndicator()
                  : AppButton(
                text: "Log in",
                width: double.infinity,
                onTap: _onTapLogin,
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppText(
                    "Don't have an account?",
                    fontSize: 12.5,
                    color: Colors.black45,
                  ),
                  AppTextButton(
                    text: "Sign up",
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.moss,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// login function with loading indication
  void _onTapLogin() async {
    setState(() {
      _isLoading = true;
    });
    bool isSuccess = await AuthController.login(
      email: _emailController.text.toString(),
      password: _passwordController.text.toString(),
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (isSuccess) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const DashboardScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed! Check email or password.'),
        ),
      );
    }
  }
}