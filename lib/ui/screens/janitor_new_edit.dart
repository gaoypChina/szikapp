import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../business/janitor.dart';
import 'error_screen.dart';

class JanitorNewEditScreen extends StatefulWidget {
  static const String route = '/janitor/newedit';
  JanitorNewEditScreen({Key? key}) : super(key: key);

  @override
  _JanitorNewEditScreenState createState() => _JanitorNewEditScreenState();
}

class _JanitorNewEditScreenState extends State<JanitorNewEditScreen> {
  late final Janitor janitor;

  @override
  void initState() {
    super.initState();
    janitor = Janitor();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: janitor.refresh(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Shrimmer
            return Scaffold();
          } else if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
          } else {
            return Scaffold(
                //Ide
                );
          }
        });
  }
}
