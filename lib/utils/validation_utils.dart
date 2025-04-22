class ValidationUtils {
  static bool isValidUsername({required String username}) {
    RegExp regExp = RegExp(r'^[a-zA-Z]{3,20}$');
    return regExp.hasMatch(username);
  }
}
