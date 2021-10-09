import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
        errorCode = 801;
        errorMessage = 'ERROR_SOCKET_MESSAGE'.tr();
        errorSolution = 'ERROR_SOCKET_SOLUTION'.tr();
        break;
      default:
        errorCode = 899;
        errorMessage = 'ERROR_UNKNOWN_EXCEPTION_MESSAGE'.tr();
        errorSolution = 'ERROR_UNKNOWN_EXCEPTION_SOLUTION'.tr();
        break;
    }
  }
}

class ErrorHandler {
  static Widget buildBanner(int errorCode) {
    var errorInformation = ErrorInformation.fromCode(errorCode);
    return Container(
        //Ide jön a dizájn
        );
  }

  static Widget buildInset(int errorCode) {
    var errorInformation = ErrorInformation.fromCode(errorCode);
    return Container(
        //Ide jön a dizájn
        );
  }
}
