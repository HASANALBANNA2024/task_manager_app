import 'package:flutter/material.dart';
import 'package:task_manager_app/features/auth/controllers/auth_controller.dart';
import '../../../../../app/theme/app_theme.dart';
import '../../dashboard/screen/dashboard_screen.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginAndNavigate();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [AppTheme.moss, AppTheme.mossDeep]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  'assets/images/app_icon.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 18),

            /// Title
            const Text(
              "Task Manager",
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.surface,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Plan it. Write it. Do it',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.surface.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if(!mounted) return;

    bool isLoggedIn = await AuthController.checkAutoLogin();

    if(!mounted) return;

    if(isLoggedIn){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
    else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}