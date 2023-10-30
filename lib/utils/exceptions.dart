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
const int notValidEnumValueExceptionCode = 924;
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
  IOException(super.code, super.message);
}

class InformationException extends BaseException {
  InformationException(super.code, super.message);
}

class IOServerException extends IOException {
  IOServerException(super.code, super.message);
}

class IOConflictException extends IOException {
  IOConflictException(message) : super(ioConflictExceptionCode, message);
}

class IOClientException extends IOException {
  IOClientException(super.code, super.message);
}

class IONotModifiedException extends IOException {
  IONotModifiedException(message) : super(ioNotModifiedExceptionCode, message);
}

class NoConnectionException extends IOException {
  NoConnectionException(message) : super(noConnectionExceptionCode, message);
}

class IOUnknownException extends IOException {
  IOUnknownException(super.code, super.message);
}

abstract class ValidationException extends BaseException {
  ValidationException(super.code, super.message);
}

class NotValidEnumValueException extends ValidationException {
  NotValidEnumValueException(message)
      : super(notValidEnumValueExceptionCode, message);
}

class NotValidPhoneException extends ValidationException {
  NotValidPhoneException(message) : super(notValidPhoneExceptionCode, message);
}

class NonHungarianPhoneException extends ValidationException {
  NonHungarianPhoneException(message)
      : super(nonHungarianPhoneExceptionCode, message);
}

abstract class FunctionalityException extends BaseException {
  FunctionalityException(super.code, super.message);
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
