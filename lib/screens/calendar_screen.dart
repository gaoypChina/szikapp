import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/calendar_manager.dart';
import '../main.dart';
import 'error_screen.dart';

class CalendarScreen extends StatefulWidget {
  static const String route = '/calendar';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: CalendarScreen(),
    );
  }

  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
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
      },
    );
  }
}
