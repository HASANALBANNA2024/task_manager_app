import 'dart:developer';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';

class ProfileController {
  /// Get Profile Details API
  static Future<ApiResponse> getProfileDetails({required String token}) async {
    log("Fetching Profile Details..........");
    return await ApiService.getRequest(
      AppUrls.profileDetails,
      token: token,
    );
  }

  /// Update Profile API
  static Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String token,
    String? password,
  }) async {
    final Map<String, dynamic> requestBody = {
      "email": email.trim(),
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "mobile": mobile.trim(),
    };

    if (password != null && password.isNotEmpty) {
      requestBody["password"] = password;
    }

    final response = await ApiService.postRequest(
      AppUrls.profileUpdate,
      token: token,
      body: requestBody,
    );

    return response.isSuccess && response.responseData['status'] == 'success';
  }
}