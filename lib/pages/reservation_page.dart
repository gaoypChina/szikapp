import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../business/reservation.dart';
import '../ui/screens/error_screen.dart';

class ReservationPage extends StatefulWidget {
  final String title;
  static const String route = '/reservation';

  const ReservationPage(
      {Key key = const Key('ReservationPage'), required this.title})
      : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
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
