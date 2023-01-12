import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../screens/error_screen.dart';
import '../../utils/utils.dart';
import '../shimmers/list_screen_shimmer.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget shimmer;
  final Widget child;

  const CustomFutureBuilder({
    Key? key,
    required this.future,
    this.shimmer = const ListScreenShimmer(),
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return shimmer;
        } else if (snapshot.hasError) {
          if (SzikAppState.connectionStatus == ConnectivityResult.none) {
            return ErrorScreen(
              errorInset: ErrorHandler.buildInset(
                context,
                errorCode: noConnectionExceptionCode,
              ),
            );
          }
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          return child;
        }
      },
    );
  }
}
