import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/reservation.dart';
import 'error_screen.dart';

class ReservationDetailsArguments {
  String title;

  ReservationDetailsArguments({required this.title});
}

class ReservationDetailsScreen extends StatefulWidget {
  static const String route = '/reservation/details';
  final String title;
  const ReservationDetailsScreen({Key? key, required this.title})
      : super(key: key);

  @override
  _ReservationDetailsScreenState createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  late final Reservation reservation;

  @override
  void initState() {
    super.initState();
    reservation = Reservation();
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
        });
  }
}
