class AppUrls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  // Auth Endpoints
  static const String registration = '$_baseUrl/Registration';
  static const String login = '$_baseUrl/Login';
  static const String profileDetails = '$_baseUrl/ProfileDetails';
  static const String profileUpdate = '$_baseUrl/ProfileUpdate';
  static String recoverVerifyEmail(email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverVerifyOtp(String email, String otp) => '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  static const String recoverResetPassword = '$_baseUrl/RecoverResetPass';

  // Task Endpoints
  static const String createTask = '$_baseUrl/createTask';
  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatus(String id, String status) => '$_baseUrl/updateTaskStatus/$id/$status';
  static String listTaskByStatus(String status) => '$_baseUrl/listTaskByStatus/$status';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
}