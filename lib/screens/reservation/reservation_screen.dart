import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/business.dart';

import '../../components/components.dart';

class ReservationScreen extends StatelessWidget {
  static const String route = '/reservation';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: ReservationScreen(),
    );
  }

  const ReservationScreen({super.key = const Key('ReservationScreen')});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var manager = Provider.of<ReservationManager>(context, listen: false);
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
              onTap: () => manager.selectMode(mode: ReservationMode.place),
              leadingAssetPath: CustomIcons.armchair,
              title: 'RESERVATION_MODE_PLACE'.tr(),
            ),
            ModeMenuItem(
              onTap: () => manager.selectMode(mode: ReservationMode.account),
              leadingAssetPath: CustomIcons.chalkboard,
              title: 'RESERVATION_MODE_ACCOUNT'.tr(),
              color: theme.colorScheme.primary,
            ),
            ModeMenuItem(
              onTap: () => manager.selectMode(mode: ReservationMode.boardgame),
              leadingAssetPath: CustomIcons.dice,
              title: 'RESERVATION_MODE_BOARDGAME'.tr(),
              color: theme.colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
