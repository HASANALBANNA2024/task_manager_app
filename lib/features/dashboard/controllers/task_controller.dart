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
  /// create news task
  static Future<bool> createTask({required String title,required String description,required String status,required String token,}) async {
    final response = await ApiService.postRequest(AppUrls.createTask, token: token, body: {
      "title":title.trim(),
      "description": description.trim(),
      "status": status
    });
    if(response.isSuccess && response.responseData['status'] == 'success'){
      return true;
    }
    return false;
  }
  /// updateTaskStatus
  static Future<bool> updateTaskStatus({required String taskId, required String newStatus, required String token}) async {
    final response = await ApiService.getRequest(AppUrls.updateTaskStatus(taskId, newStatus), token: token);
    if(response.isSuccess && response.responseData['status']=='success'){
      return true;
    }
    return false;
  }
  ///deleted task
  static Future<bool> deleteTask({required String taskId,required String token,}) async {
    final response = await ApiService.getRequest(
      AppUrls.deleteTask(taskId),
      token: token,
    );

    if (response.isSuccess && response.responseData['status'] == 'success') {
      return true;
    }
    return false;
  }

}