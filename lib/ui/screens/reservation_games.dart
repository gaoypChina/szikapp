import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/resource.dart';
import '../../pages/reservation_page.dart';
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
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              margin: EdgeInsets.fromLTRB(0, 25, 0, kBottomNavigationBarHeight),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  Expanded(
                    child: GridView.count(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 4
                          : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: boardgames!
                          .map((item) => Card(
                                elevation: 5,
                                color: Theme.of(context).colorScheme.background,
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(ReservationPage.route),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Image.asset(
                                      'assets/pictures/${item.iconLink}',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        var message;
        if (SZIKAppState.connectionStatus == ConnectivityResult.none)
          message = 'ERROR_NO_INTERNET'.tr();
        else
          message = snapshot.error;
        return ErrorScreen(error: message ?? 'ERROR_UNKNOWN'.tr());
      },
    );
  }
}
