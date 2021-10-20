import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/good_to_know.dart';
import '../main.dart';
import '../ui/screens/error_screen.dart';

class DocumentsPage extends StatefulWidget {
  static const String route = '/documents';

  const DocumentsPage({Key? key}) : super(key: key);

  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  late final Goodtoknow goodToKnow;

  @override
  void initState() {
    super.initState();
    goodToKnow = Goodtoknow();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: goodToKnow.refresh(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Shrimmer
            return const Scaffold();
          } else if (snapshot.hasError) {
            Object? message;
            if (SZIKAppState.connectionStatus == ConnectivityResult.none) {
              message = 'ERROR_NO_INTERNET'.tr();
            } else {
              message = snapshot.error;
            }
            return ErrorScreen(error: message ?? 'ERROR_UNKNOWN'.tr());
          } else {
            return const Scaffold(
                //TODO kód ide
                );
          }
        });
  }
}
