import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/calendar_manager.dart';
import '../main.dart';
import '../ui/screens/error_screen.dart';

class CalendarPage extends StatefulWidget {
  static const String route = '/calendar';

  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final CalendarManager calendar;

  @override
  void initState() {
    super.initState();
    calendar = CalendarManager();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: calendar.refresh(),
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
            return const Scaffold();
          }
        });
  }
}
