///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // firebase "el van-e kezdve"
  await Firebase.initializeApp(); // firebase --> FlutterFire initialisation
  runApp(SZIKApp());
}

class SZIKApp extends StatefulWidget {
  @override
  _SZIKAppState createState() => _SZIKAppState();
}

class _SZIKAppState extends State<SZIKApp> {
  @override
  Widget build(BuildContext context) {
    return Text('Hello world!');
  }
}
