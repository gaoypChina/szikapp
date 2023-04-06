const int ioNotModifiedExceptionCode = 304;
const int ioConflictExceptionCode = 409;
const int authExceptionCode = 610;
const int routeExceptionCode = 710;
const int dynamicLinkExceptionCode = 720;
const int notImplementedExceptionCode = 730;
const int socketExceptionCode = 810;
const int noConnectionExceptionCode = 820;
const int notValidPhoneExceptionCode = 921;
const int nonHungarianPhoneExceptionCode = 922;
const int notValidBirthdayExceptionCode = 923;
const int notValidPermissionExceptionCode = 924;
const int notSupportedCallFunctionalityExceptionCode = 931;
const int notSupportedEmailFunctionalityExceptionCode = 932;
const int notSupportedBrowserFunctionalityExceptionCode = 933;
const int unknownExceptionCode = 1000;

const int cleaningAssignPeriodShrink = 2010;
const int cleaningAssignPeriodExtended = 2020;
const int cleaningAssignPeriodExtendedWithEmptyEnd = 2025;
const int cleaningAssigned = 2000;
const int cleaningAssignedWithEmptyEnd = 2005;

const int signInRequiredExceptionCode = 6010;

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

class NotImplementedException extends BaseException {
  NotImplementedException(message)
      : super(notImplementedExceptionCode, message);
}

class AuthException extends BaseException {
  AuthException(message) : super(authExceptionCode, message);
}

abstract class IOException extends BaseException {
  IOException(code, message) : super(code, message);
}

class InformationException extends BaseException {
  InformationException(code, message) : super(code, message);
}

class IOServerException extends IOException {
  IOServerException(code, message) : super(code, message);
}

class IOConflictException extends IOException {
  IOConflictException(message) : super(ioConflictExceptionCode, message);
}

class IOClientException extends IOException {
  IOClientException(code, message) : super(code, message);
}

class IONotModifiedException extends IOException {
  IONotModifiedException(message) : super(ioNotModifiedExceptionCode, message);
}

class NoConnectionException extends IOException {
  NoConnectionException(message) : super(noConnectionExceptionCode, message);
}

class IOUnknownException extends IOException {
  IOUnknownException(code, message) : super(code, message);
}

abstract class ValidationException extends BaseException {
  ValidationException(code, message) : super(code, message);
}

class NotValidPermissionException extends ValidationException {
  NotValidPermissionException(message)
      : super(notValidPermissionExceptionCode, message);
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

abstract class FunctionalityException extends BaseException {
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

class NotSupportedBrowserFunctionalityException extends FunctionalityException {
  NotSupportedBrowserFunctionalityException(message)
      : super(notSupportedBrowserFunctionalityExceptionCode, message);
}
