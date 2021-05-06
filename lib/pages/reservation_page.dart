import 'package:flutter/material.dart';
import '../business/reservation.dart';

class ReservationPage extends StatefulWidget {
  static const String route = '/reservation';

  const ReservationPage({Key key = const Key('ReservationPage')})
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
    return Container();
  }
}
