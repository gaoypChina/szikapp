import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  static const String route = '/error';
  ErrorScreen({Key key = const Key('ErrorScreen')}) : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(),
    );
  }
}
