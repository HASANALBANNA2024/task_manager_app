extension UserInitials on String {
  /// First Name  Last Name
  static String getInitials(String? firstName, String? lastName) {
    final String fName = firstName?.trim() ?? '';
    final String lName = lastName?.trim() ?? '';

    if (fName.isNotEmpty && lName.isNotEmpty) {
      return "${fName[0]}${lName[0]}".toUpperCase();
    } else if (fName.isNotEmpty) {
      return fName.substring(0, fName.length >= 2 ? 2 : 1).toUpperCase();
    } else if (lName.isNotEmpty) {
      return lName.substring(0, lName.length >= 2 ? 2 : 1).toUpperCase();
    }
    return "U"; 
  }
}