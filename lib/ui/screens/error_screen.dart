import 'package:flutter/material.dart';
import '../../main.dart';

class ErrorScreenArguments {
  Object error;

  ErrorScreenArguments({required this.error});
}

class ErrorScreen extends StatefulWidget {
  static const String route = '/error';
  final Object error;
  const ErrorScreen({Key key = const Key('ErrorScreen'), required this.error})
      : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            widget.error.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
