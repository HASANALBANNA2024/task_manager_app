import 'dart:developer';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';
class TaskController {
  /// Task count api
  static Future<ApiResponse> getTaskStatusCount({required String token}) async {
    log("Fetching Task Status Count..........");
    return await ApiService.getRequest(AppUrls.taskStatusCount,token: token);
  }
  /// Get List Task By Status API (new, completed, cancelled, progress
  static Future<ApiResponse> getTasksByStatus({ required String status, required String token }) async {
    log("Fetching tasks for status: $status");
    return await ApiService.getRequest(AppUrls.listTaskByStatus(status), token: token);
  }
}