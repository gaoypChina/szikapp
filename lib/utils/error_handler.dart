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
          key: noInternet,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Align(
              alignment: AlignmentDirectional(0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                            child: Image.asset(
                              'assets/pictures/no_network_grey.png',
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.2,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            'Error 12029 \nNincs internet',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Roboto',
                              color: Color(0xFFE6E6E6),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            'Próbálj meg csatlakozni egy másik \ninternet-forráshoz!',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Roboto',
                              color: Color(0xFFAFAFAF),
                              fontWeight: FontWeight.bold,
                            ),
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

  static Widget _buildInset(ErrorInformation errorInformation) {
    return Container(
          key: commonError,
          backgroundColor: Color(0xFFF5F5F5),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, 0.8),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 5,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1, -1),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 5, 0, 0),
                                      child: Text(
                                        'Hoppá! ',
                                        style: FlutterFlowTheme.bodyText1.override(
                                          fontFamily: 'Roboto',
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1, -1),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 10, 5, 5),
                                      child: Text(
                                        'A hiba megoldásához szükséged lesz egy olyan eszközre, ami javít...',
                                        style: FlutterFlowTheme.bodyText1.override(
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                              child: FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: 'OK',
                                options: FFButtonOptions(
                                  width: 50,
                                  height: 40,
                                  color: Color(0xFF1D1F25),
                                  textStyle: FlutterFlowTheme.subtitle2.override(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                  borderRadius: 0,
                                ),
                                loading: _loadingButton,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
  }
}
