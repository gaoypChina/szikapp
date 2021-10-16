import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'exceptions.dart';

class ErrorInformation {
  late int errorCode;
  late String errorMessage;
  late String errorSolution;

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
  factory ErrorInformation.unknown() {
    return ErrorInformation.fromCode(informationlessExceptionCode);
  }
}

class ErrorHandler {
  static MaterialBanner buildBanner(BuildContext context,
      {int? errorCode, Exception? exception}) {
    ErrorInformation errorInformation;
    if (errorCode != null) {
      errorInformation = ErrorInformation.fromCode(errorCode);
    } else if (exception != null) {
      errorInformation = ErrorInformation.fromException(exception);
    } else {
      errorInformation = ErrorInformation.unknown();
    }
    return _buildBanner(context, errorInformation);
  }

  static SnackBar buildSnackbar(BuildContext context,
      {int? errorCode, Exception? exception}) {
    ErrorInformation errorInformation;
    if (errorCode != null) {
      errorInformation = ErrorInformation.fromCode(errorCode);
    } else if (exception != null) {
      errorInformation = ErrorInformation.fromException(exception);
    } else {
      errorInformation = ErrorInformation.unknown();
    }
    return _buildSnackBar(context, errorInformation);
  }

  static Widget buildInset(BuildContext context,
      {int? errorCode, Exception? exception}) {
    ErrorInformation errorInformation;
    if (errorCode != null) {
      errorInformation = ErrorInformation.fromCode(errorCode);
    } else if (exception != null) {
      errorInformation = ErrorInformation.fromException(exception);
    } else {
      errorInformation = ErrorInformation.unknown();
    }
    return _buildInset(context, errorInformation);
  }

  static Widget _buildInset(
      BuildContext context, ErrorInformation errorInformation) {
    var theme = Theme.of(context);
    return Container(
      key: const Key("ErrorBanner"),
      color: theme.colorScheme.background,
      child: SafeArea(
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
            ),
            child: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(top: 30),
                        child: Image.asset(
                          'assets/pictures/no_network_grey.png',
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 20),
                      child: Text(
                        errorInformation.errorMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText1!
                            .copyWith(color: theme.colorScheme.primary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 20),
                      child: Text(
                        errorInformation.errorSolution,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText1!
                            .copyWith(color: theme.colorScheme.primaryVariant),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static MaterialBanner _buildBanner(
      BuildContext context, ErrorInformation errorInformation) {
    return MaterialBanner(
      content: Text(errorInformation.errorMessage),
      actions: [
        TextButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          child: Text('BUTTON_DISMISS'.tr()),
        ),
      ],
    );
  }

  static SnackBar _buildSnackBar(
      BuildContext context, ErrorInformation errorInformation) {
    return SnackBar(
      content: Text(errorInformation.errorMessage),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: "BUTTON_DISMISS".tr(),
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
  }
}
