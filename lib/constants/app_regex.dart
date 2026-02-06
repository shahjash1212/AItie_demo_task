class AppRegex {
  static const String email = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String trimWhiteSpace = r'\s';
  static const String passwordRegex =
      r'^(?=.*\d)(?=.*[!@#$%.^&*])(?=.*[a-z])(?=.*[A-Z]).{6,}$';
}
