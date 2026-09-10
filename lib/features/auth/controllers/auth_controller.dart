import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
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

    if (response.isSuccess) {
      final responseData = response.responseData;

      if (responseData != null) {
        /// memory saved
        userToken = responseData['token'];
        userData = responseData['data'];

        // SharedPreferences
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

        /// token saved
        if (userToken != null) {
          await sharedPreferences.setString('token', userToken!);
        }

        /// user data saved
        if (userData != null) {
          await sharedPreferences.setString('firstName', userData?['firstName'] ?? '');
          await sharedPreferences.setString('lastName', userData?['lastName'] ?? '');
          await sharedPreferences.setString('email', userData?['email'] ?? '');
        }
      }
      return true;
    } else {
      return false;
    }
  }
  /// auto login check
  static Future<bool> checkAutoLogin()async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   String? token = sharedPreferences.getString('user_token');

   if(token != null && token.isNotEmpty){
     userToken = token;
     String firstName = sharedPreferences.getString('first_name')??'';
     String lastName = sharedPreferences.getString('first_name')??'';
     userData = {
       'firstName':firstName,
       'lastName':lastName,
     };
     return true;
   }
   return false;
  }
  ///logout
  static Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    userToken= null;
    userData = null;
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