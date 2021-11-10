import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/reservation_manager.dart';
import '../models/tasks.dart';
import 'error_screen.dart';

class ReservationDetailsScreen extends StatefulWidget {
  static const String route = '/reservation/details';

  static MaterialPage page({
    required String title,
    required TimetableTask task,
  }) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationDetailsScreen(
        title: title,
        task: task,
      ),
    );
  }

  final String title;
  final TimetableTask task;

  const ReservationDetailsScreen({
    Key? key,
    required this.title,
    required this.task,
  }) : super(key: key);

  @override
  _ReservationDetailsScreenState createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  late final ReservationManager reservation;

  @override
  void initState() {
    super.initState();
    reservation = ReservationManager();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: reservation.refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //Shrimmer
          return const Scaffold();
        } else if (snapshot.hasError) {
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          return const Scaffold(
              //Ide
              );
        }
      },
    );
  }
}
