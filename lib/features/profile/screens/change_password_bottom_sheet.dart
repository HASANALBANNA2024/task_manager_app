import 'package:flutter/material.dart';
import 'package:task_manager_app/app/theme/app_theme.dart';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_field.dart';
import 'package:task_manager_app/features/auth/controllers/auth_controller.dart';

void showChangePasswordBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppTheme.paper,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const ChangePasswordBottomSheet(),
  );
}

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState
    extends State<ChangePasswordBottomSheet> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottom Sheet Top Bar / Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.line,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const AppText(
                "Change Password",
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.ink,
              ),
              const SizedBox(height: 20),

              // New Password Input
              AppTextField(
                controller: _newPasswordController,
                labelText: "New Password",
                hintText: "Enter new password",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password Input
              AppTextField(
                controller: _confirmPasswordController,
                labelText: "Confirm New Password",
                hintText: "Re-enter new password",
                obscureText: true,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return "Passwords do not match!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Action Button
              AppButton(
                text: "Update Password",
                color: AppTheme.moss,
                textColor: Colors.white,
                isLoading: _isLoading,
                onTap: _onChangePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Password Change API Handler
  Future<void> _onChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if(_newPasswordController.text != _confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: AppText("New password and Confirm password do not match!")));
      _confirmPasswordController.clear();
      _newPasswordController.clear();
      return;
    }

    setState(() => _isLoading = true);

    final Map<String, dynamic> requestBody = {
      "email": AuthController.userData?['email'],
      "firstName": AuthController.userData?['firstName'],
      "lastName": AuthController.userData?['lastName'],
      "mobile": AuthController.userData?['mobile'],
      "password": _newPasswordController.text.trim(),
    };

    final ApiResponse response = await ApiService.postRequest(
      AppUrls.profileUpdate,
      body: requestBody,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (response.isSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password changed successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.errorMessage.isNotEmpty
                  ? response.errorMessage
                  : "Password update failed! Try again.",
            ),
          ),
        );
      }
    }
  }
}