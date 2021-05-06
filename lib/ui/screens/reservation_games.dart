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
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/pictures/background_1.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 4
                              : 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: boardgames!
                              .map((item) => Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(0),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/pictures/${item.iconLink}')),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        });
  }
}
