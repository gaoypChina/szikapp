const int authExceptionCode = 910;
const int ioNotModifiedExceptionCode = 304;
const int notValidPhoneExceptionCode = 921;
const int nonHungarianPhoneExceptionCode = 922;
const int notValidBirthdayExceptionCode = 923;
const int notSupportedCallFunctionalityExceptionCode = 931;
const int notSupportedEmailFunctionalityExceptionCode = 932;

///Sablon kivétel, ami a specifikus típusok őse.
class BaseException implements Exception {
  ///Hibakód
  int code;

  ///Hibaüzenet
  String message;

  BaseException(this.code, this.message);

  @override
  String toString() => 'Exception: $message\n';
}

class AuthException extends BaseException {
  AuthException(message) : super(authExceptionCode, message);
}

class IOException extends BaseException {
  IOException(code, message) : super(code, message);
}

class IOServerException extends IOException {
  IOServerException(code, message) : super(code, message);
}

class IOClientException extends IOException {
  IOClientException(code, message) : super(code, message);
}

class IONotModifiedException extends IOException {
  IONotModifiedException(message) : super(ioNotModifiedExceptionCode, message);
}

class IOUnknownException extends IOException {
  IOUnknownException(code, message) : super(code, message);
}

class ValidationException extends BaseException {
  ValidationException(code, message) : super(code, message);
}

class NotValidPhoneException extends ValidationException {
  NotValidPhoneException(message) : super(notValidPhoneExceptionCode, message);
}

class NonHungarianPhoneException extends ValidationException {
  NonHungarianPhoneException(message)
      : super(nonHungarianPhoneExceptionCode, message);
}

class NotValidBirthdayException extends ValidationException {
  NotValidBirthdayException(message)
      : super(notValidBirthdayExceptionCode, message);
}

class FunctionalityException extends BaseException {
  FunctionalityException(code, message) : super(code, message);
}

class NotSupportedCallFunctionalityException extends FunctionalityException {
  NotSupportedCallFunctionalityException(message)
      : super(notSupportedCallFunctionalityExceptionCode, message);
}

class NotSupportedEmailFunctionalityException extends FunctionalityException {
  NotSupportedEmailFunctionalityException(message)
      : super(notSupportedEmailFunctionalityExceptionCode, message);
}
