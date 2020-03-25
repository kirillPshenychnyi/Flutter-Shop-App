class AuthExpception implements Exception {
  String _message;

  AuthExpception(String message) {
    _message = () {
      if (message.contains("EMAIL_EXISTS")) {
        return 'Provided email exists';
      }

      if (message.contains("INVALID_EMAIL")) {
        return 'Invalid email';
      }

      if (message.contains("EMAIL_NOT_FOUND")) {
        return 'Email was not found';
      }

      if (message.contains("INVALID_PASSWORD")) {
        return 'Invalid password provided';
      }

      return 'Authintification error';
    }();
  }

  @override
  String toString() {
    return _message;
  }
}
