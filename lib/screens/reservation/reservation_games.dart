import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../ui/themes.dart';

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
    super.key,
    required this.manager,
  });

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
    super.key,
    required this.manager,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'RESERVATION_TITLE_BOARDGAME_LIST'.tr(),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(
                kPaddingLarge,
                kPaddingLarge,
                kPaddingLarge,
                0,
              ),
              crossAxisCount: 2,
              crossAxisSpacing: kPaddingNormal,
              mainAxisSpacing: kPaddingNormal,
              children: manager.games
                  .map(
                    (game) => Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusNormal),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      color: Theme.of(context).colorScheme.background,
                      child: GestureDetector(
                        onTap: () => Provider.of<ReservationManager>(context,
                                listen: false)
                            .selectGame(
                          index: manager.games.indexOf(game),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(kPaddingNormal),
                          child: Image.asset(
                            'assets/pictures/${game.iconLink}',
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
