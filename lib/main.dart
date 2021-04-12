///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'utils/auth.dart';
import 'utils/user.dart';

void main() {
  runApp(SZIKApp());
}

class SZIKApp extends StatefulWidget {
  @override
  SZIKAppState createState() => SZIKAppState();
}

class SZIKAppState extends State<SZIKApp> {
  bool _firebaseInitialized = false;
  bool _firebaseError = false;
  late Auth authManager;
  User? user;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_firebaseInitialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _firebaseInitialized = true;
      });
    } on Exception catch (e) {
      // Set `_firebaseError` state to true if Firebase initialization fails
      setState(() {
        _firebaseError = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    authManager = Auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Hello world!');
  }
}
