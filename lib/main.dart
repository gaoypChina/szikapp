///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(SZIKApp());
}

class SZIKApp extends StatefulWidget {
  @override
  _SZIKAppState createState() => _SZIKAppState();
}

class _SZIKAppState extends State<SZIKApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Text('Hello World!'),
    );
  }
}
