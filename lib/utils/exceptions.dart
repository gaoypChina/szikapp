class BaseException implements Exception {
  String message;

  BaseException(this.message);

  @override
  String toString() => 'Exception: $message\n';
}

class AuthException extends BaseException {
  AuthException(message) : super(message);
}

class IOException extends BaseException {
  IOException(message) : super(message);
}

class IOServerException extends IOException {
  IOServerException(message) : super(message);
}

class IOClientException extends IOException {
  IOClientException(message) : super(message);
}

class IONotModifiedException extends IOException {
  IONotModifiedException(message) : super(message);
}

class IOUnknownException extends IOException {
  IOUnknownException(message) : super(message);
}

class ValidationException extends BaseException {
  ValidationException(message) : super(message);
}

class NonHungarianPhoneException extends ValidationException {
  NonHungarianPhoneException(message) : super(message);
}

class FunctionalityException extends BaseException {
  FunctionalityException(message) : super(message);
}

class NotSupportedCallFunctionalityException extends FunctionalityException {
  NotSupportedCallFunctionalityException(message) : super(message);
}

class NotSupportedEmailFunctionalityException extends FunctionalityException {
  NotSupportedEmailFunctionalityException(message) : super(message);
}
