class AuthUserNotFound implements Exception {
  final String message;

  AuthUserNotFound(this.message);
}

class AuthWrongPassword implements Exception {}

class AuthWeakPassword implements Exception {}

class AuthInvalidEmail implements Exception {}