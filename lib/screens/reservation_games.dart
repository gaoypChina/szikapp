import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/reservation_manager.dart';
import '../components/components.dart';
import '../main.dart';
import '../navigation/navigation.dart';
import 'error_screen.dart';

class ReservationGamesListScreen extends StatelessWidget {
  static const String route = '/reservation/games';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: ReservationGamesListScreen(),
    );
  }

  const ReservationGamesListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Provider.of<ReservationManager>(context, listen: false)
          .refreshGames(),
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
          var boardgames =
              Provider.of<ReservationManager>(context, listen: false).games;
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: buildAppBar(
              context: context,
              appBarTitle: 'RESERVATION_TITLE_BOARDGAME_LIST'.tr(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 4
                        : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: boardgames
                        .map((item) => Card(
                              elevation: 5,
                              color: Theme.of(context).colorScheme.background,
                              child: GestureDetector(
                                onTap: () => Provider.of<ReservationManager>(
                                        context,
                                        listen: false)
                                    .createNewReservation(
                                        gameIndex: boardgames.indexOf(item)),
                                child: Container(
                                  margin: const EdgeInsets.all(10),
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
            bottomNavigationBar: SzikBottomNavigationBar(
              selectedTab:
                  Provider.of<SzikAppStateManager>(context, listen: false)
                      .selectedTab,
            ),
          );
        }
      },
    );
  }
}
