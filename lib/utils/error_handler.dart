import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'exceptions.dart';

class ErrorInformation {
  late int errorCode;
  late String errorMessage;
  late String errorSolution;
  bool isSolvableByRefresh = true;
  bool isSolvableByReturn = true;

  ErrorInformation.fromCode(this.errorCode) {
    if (errorCode > 100 && errorCode < 600) {
      errorMessage = 'ERROR_HTTP_MESSAGE'.tr();
      errorSolution = 'ERROR_HTTP_SOLUTION'.tr();
    } else if (errorCode >= 900 && errorCode < 1000) {
      errorMessage = 'ERROR_SZIKAPP_MESSAGE'.tr();
      errorSolution = 'ERROR_SZIKAPP_SOLUTION'.tr();
    } else {
      errorMessage = 'ERROR_UNKNOWN_CODE_MESSAGE'.tr();
      errorSolution = 'ERROR_UNKNOWN_CODE_SOLUTION'.tr();
    }
  }
  ErrorInformation.fromException(Exception exception) {
    switch (exception.runtimeType) {
      case SocketException:
        errorCode = socketExceptionCode;
        errorMessage = 'ERROR_SOCKET_MESSAGE'.tr();
        errorSolution = 'ERROR_SOCKET_SOLUTION'.tr();
        break;
      default:
        errorCode = unknownCatchedExceptionCode;
        errorMessage = 'ERROR_UNKNOWN_EXCEPTION_MESSAGE'.tr();
        errorSolution = 'ERROR_UNKNOWN_EXCEPTION_SOLUTION'.tr();
        break;
    }
  }
}

class ErrorHandler {
  static Widget buildBanner({int? errorCode, Exception? exception}) {
    ErrorInformation errorInformation;
    if (errorCode != null) {
      errorInformation = ErrorInformation.fromCode(errorCode);
    } else if (exception != null) {
      errorInformation = ErrorInformation.fromException(exception);
    } else {
      errorInformation =
          ErrorInformation.fromCode(informationlessExceptionCode);
    }
    return _buildBanner(errorInformation);
  }

  static Widget buildInset({int? errorCode, Exception? exception}) {
    ErrorInformation errorInformation;
    if (errorCode != null) {
      errorInformation = ErrorInformation.fromCode(errorCode);
    } else if (exception != null) {
      errorInformation = ErrorInformation.fromException(exception);
    } else {
      errorInformation =
          ErrorInformation.fromCode(informationlessExceptionCode);
    }
    return _buildInset(errorInformation);
  }

  static Widget _buildBanner(ErrorInformation errorInformation) {
    return Container(
        //Ide jön a dizájn
        );
  }

  static Widget _buildInset(ErrorInformation errorInformation) {
    return Container(
        //Ide jön a dizájn
        );
  }
}
