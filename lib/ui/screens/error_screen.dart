import 'package:flutter/material.dart';

class ErrorScreenArguments {
  Object error;

  ErrorScreenArguments({required this.error});
}

class ErrorScreen extends StatefulWidget {
  static const String route = '/error';
  final Object error;
  ErrorScreen({Key key = const Key('ErrorScreen'), required this.error})
      : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              widget.error.toString(),
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
