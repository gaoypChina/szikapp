import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/resource.dart';
import '../../utils/io.dart';
import 'error_screen.dart';

class ReservationGamesListArguments {
  String title;

  ReservationGamesListArguments({required this.title});
}

class ReservationGamesListScreen extends StatefulWidget {
  static const String route = '/reservation/games';
  final String title;
  const ReservationGamesListScreen({Key? key, required this.title})
      : super(key: key);

  @override
  _ReservationGamesListScreenState createState() =>
      _ReservationGamesListScreenState();
}

class _ReservationGamesListScreenState
    extends State<ReservationGamesListScreen> {
  late final IO io;

  @override
  void initState() {
    super.initState();
    io = IO();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Boardgame>>(
        future: io.getBoardgame(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Shrimmer
            return Scaffold();
          } else if (snapshot.hasData) {
            var boardgames = snapshot.data;
            return Scaffold(
                //Ide
                );
          }
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        });
  }
}
