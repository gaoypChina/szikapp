import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:szikapp/ui/screens/janitor_new_edit.dart';
import '../business/janitor.dart';
import '../ui/screens/error_screen.dart';

class JanitorPage extends StatefulWidget {
  static const String route = '/janitor';
  JanitorPage({Key? key}) : super(key: key);

  @override
  _JanitorPageState createState() => _JanitorPageState();
}

class _JanitorPageState extends State<JanitorPage> {
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
            return JanitorNewEditScreen(isEdit: false);
          }
        });
  }
}
