import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorInformation {
  int errorCode;
  late String errorMessage;
  late String errorSolution;
  bool isSolvableByRefresh = true;
  bool isSolvableByReturn = true;

  ErrorInformation(this.errorCode) {
    if (errorCode > 100 && errorCode < 600) {
      errorMessage = 'ERROR_HTTP_MESSAGE'.tr();
      errorSolution = 'ERROR_HTTP_SOLUTION'.tr();
    } else if (errorCode >= 900 && errorCode < 1000) {
      errorMessage = 'ERROR_SZIKAPP_MESSAGE'.tr();
      errorSolution = 'ERROR_SZIKAPP_SOLUTION'.tr();
    } else {
      errorMessage = 'ERROR_UNKNOWN_MESSAGE'.tr();
      errorSolution = 'ERROR_UNKNOWN_SOLUTION'.tr();
    }
  }
}

class ErrorHandler {
  static Widget buildBanner(int errorCode) {
    var errorInformation = ErrorInformation(errorCode);
    return Container(
        //Ide jön a dizájn
        );
  }

  static Widget buildInset(int errorCode) {
    var errorInformation = ErrorInformation(errorCode);
    return Container(
        //Ide jön a dizájn
        );
  }
}
