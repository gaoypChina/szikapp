import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../business/calendar.dart';
import '../ui/screens/error_screen.dart';

class CalendarPage extends StatefulWidget {
  static const String route = '/calendar';

  CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final Calendar calendar;

  @override
  void initState() {
    super.initState();
    calendar = Calendar();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: calendar.refresh(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Shrimmer
            return Scaffold();
          } else if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
          } else {
            return Scaffold();
          }
        });
  }
}
