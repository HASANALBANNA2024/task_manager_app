import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../features/auth/controllers/auth_controller.dart';


class ApiResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage = '',
  });
}

class ApiService {
  /// Common Headers:  AuthController
  static Map<String, String> _headers(String? token) {
    final String userToken = token ?? AuthController.userToken ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (userToken.isNotEmpty) 'token': userToken,
    };
  }

  /// Get Request
  static Future<ApiResponse> getRequest(String url, {String? token}) async {
    try {
      log("GET: $url");
      final response = await http.get(Uri.parse(url), headers: _headers(token));
      return _handleResponse(response);
    } catch (e) {
      log("GET Error: $e");
      return ApiResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// Post Request
  static Future<ApiResponse> postRequest(
      String url, {
        Map<String, dynamic>? body,
        String? token,
      }) async {
    try {
      log("POST: $url");
      final response = await http.post(
        Uri.parse(url),
        headers: _headers(token),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      log("POST Error: $e");
      return ApiResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// Common Response Handler
  static ApiResponse _handleResponse(http.Response response) {
    log("Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");

    try {
      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        String message = 'Something went wrong';
        if (decodedData is Map) {
          if (decodedData['data'] is String) {
            message = decodedData['data'];
          } else if (decodedData['message'] is String) {
            message = decodedData['message'];
          } else if (decodedData['status'] != null) {
            message = decodedData['status'].toString();
          }
        }

        return ApiResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedData,
          errorMessage: message,
        );
      }
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Failed to parse response: ${response.body}',
      );
    }
  }
}