import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String errorMessage;


  ApiResponse ({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage = '',
});

}


class ApiService {
  /// common headers
  static Map<String, String> _headers(String? token) => {
    'Content-Type': 'application/json',
    'Accept':'application/json',
    if(token != null && token.isNotEmpty) 'token' : token,
  };


  /// Get Request
  static Future<ApiResponse> getRequest(String url, {String? token}) async {
    try {
      log("Get: $url");
      final response = await http.get(Uri.parse(url), headers:  _headers(token));
      return _handleResponse(response);
    } catch (e){
      log("Get error: $e");
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

      // Status Code 200 থেকে 299 এর মধ্যে হলে Success ধরা হবে
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        // সার্ভার থেকে আসা আসল এরর মেসেজটি বের করা
        String message = decodedData['data'] ?? decodedData['message'] ?? 'Something went wrong';
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





