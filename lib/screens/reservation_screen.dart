import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/reservation_manager.dart';

import '../components/components.dart';

class ReservationScreen extends StatelessWidget {
  static const String route = '/reservation';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: ReservationScreen(),
    );
  }

  const ReservationScreen({Key key = const Key('ReservationScreen')})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'RESERVATION_TITLE'.tr(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pictures/background_1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ModeMenuItem(
              onTap: () =>
                  Provider.of<ReservationManager>(context, listen: false)
                      .selectMode(ReservationMode.place),
              leadingAssetPath: 'assets/icons/armchair_light_72.png',
              title: 'RESERVATION_MODE_PLACE'.tr(),
            ),
            ModeMenuItem(
              onTap: () =>
                  Provider.of<ReservationManager>(context, listen: false)
                      .selectMode(ReservationMode.zoom),
              leadingAssetPath: 'assets/icons/chalkboard_teacher_light_72.png',
              title: 'RESERVATION_MODE_ZOOM'.tr(),
              color: Theme.of(context).colorScheme.primary,
            ),
            ModeMenuItem(
              onTap: () =>
                  Provider.of<ReservationManager>(context, listen: false)
                      .selectMode(ReservationMode.boardgame),
              leadingAssetPath: 'assets/icons/dicefive_light_72.png',
              title: 'RESERVATION_MODE_BOARDGAME'.tr(),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
