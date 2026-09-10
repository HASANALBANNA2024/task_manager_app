import 'dart:developer';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';

class AuthController {
  static String? userToken;

  static Map<String, dynamic>? userData;
  /// login method
  static Future<bool> login({required String email, required String password}) async {
    final ApiResponse response = await ApiService.postRequest(
      AppUrls.login,
      body: {
        "email": email,
        "password": password,
      },
    );
    if(response.isSuccess){
      final responseData = response.responseData;
      /// token save in controller memory
      if(responseData != null && responseData['token']!= null ){
        userToken = responseData['token'];
        /// shared preference saved to token (for local storage)
      }
      return true;
    } else {
      return false;
    }
  }
  /// Verify Method
  static Future<bool> verifyEmail(String email) async {
    final response = await ApiService.getRequest( AppUrls.recoverVerifyEmail(email.trim()),);
    if(response.isSuccess && response.responseData ['status'] == 'success'){
      return true;
    }
    return false;
  }
  /// OTP Verify
  static Future<bool> verifyotp(String email, String otp) async {
    final response = await ApiService.getRequest(AppUrls.recoverVerifyOtp(email.trim(), otp.trim()));
    if(response.isSuccess && response.responseData ['status'] == 'success'){
      return true;
    }
    return false;
  }
  /// Reset password
  static Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final Map<String, dynamic> requestBody = {
      "email": email.trim(),
      "OTP": otp.trim(), // POSTMAN- "OTP"
      "password": newPassword.trim(),
    };

    final response = await ApiService.postRequest(
      AppUrls.recoverResetPassword,
      body: requestBody,
    );

    log("--- API Response Debug ---");
    log("Status Code: ${response.statusCode}");
    log("Response Data: ${response.responseData}");

    if (response.isSuccess && response.responseData['status'] == 'success') {
      return true;
    }
    return false;
  }
}