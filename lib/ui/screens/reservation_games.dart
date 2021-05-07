import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/pictures/background_1.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
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
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(ReservationPage.route),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              spreadRadius: 0,
                                              blurRadius: 17,
                                              offset: Offset(5, 5),
                                            ),
                                          ],
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/pictures/${item.iconLink}')),
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
              ),
            );
          }
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        });
  }
}
