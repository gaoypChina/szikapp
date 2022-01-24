import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/reservation_manager.dart';
import '../components/components.dart';

class ReservationGamesListScreen extends StatelessWidget {
  final ReservationManager manager;

  static const String route = '/reservation/games';

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationGamesListScreen(manager: manager),
    );
  }

  const ReservationGamesListScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refreshGames(),
      shimmer: const ListScreenShimmer(type: ShimmerListType.square),
      child: ReservationGamesList(manager: manager),
    );
  }
}

class ReservationGamesList extends StatelessWidget {
  final ReservationManager manager;

  const ReservationGamesList({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'RESERVATION_TITLE_BOARDGAME_LIST'.tr(),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 4
                      : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: manager.games
                  .map(
                    (item) => Card(
                      elevation: 5,
                      color: Theme.of(context).colorScheme.background,
                      child: GestureDetector(
                        onTap: () => Provider.of<ReservationManager>(context,
                                listen: false)
                            .createNewReservation(
                          gameIndex: manager.games.indexOf(item),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/pictures/${item.iconLink}',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
