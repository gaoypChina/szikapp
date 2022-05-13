import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../main.dart';
import '../ui/themes.dart';

class ErrorScreen extends StatefulWidget {
  static const String route = '/error';

  static MaterialPage page({
    Object? error,
    Widget? errorInset,
  }) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ErrorScreen(
        error: error,
        errorInset: errorInset,
      ),
    );
  }

  final Object? error;
  final Widget? errorInset;

  const ErrorScreen({
    Key key = const Key('ErrorScreen'),
    this.error,
    this.errorInset,
  }) : super(key: key);

  @override
  ErrorScreenState createState() => ErrorScreenState();
}

class ErrorScreenState extends State<ErrorScreen> {
  @override
  void initState() {
    super.initState();
    SZIKAppState.analytics.logEvent(
      name: 'error_screen_show',
      parameters: <String, dynamic>{
        'message': widget.error.toString(),
      },
    );
  }

  Widget _buildErrorContent() {
    return widget.errorInset ??
        Text(
          widget.error.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'ERROR_TITLE'.tr(),
      body: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Center(
          child: _buildErrorContent(),
        ),
      ),
    );
  }
}
