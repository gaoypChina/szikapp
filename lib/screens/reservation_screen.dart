import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/reservation_manager.dart';

import '../components/components.dart';
import '../ui/themes.dart';

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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SzikAppScaffold(
      withAppBar: false,
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
            GestureDetector(
              onTap: () =>
                  Provider.of<ReservationManager>(context, listen: false)
                      .selectMode(ReservationMode.place),
              child: Container(
                margin: EdgeInsets.fromLTRB(width * 0.08, 0, width * 0.08, 0),
                height: height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(width * 0.08),
                      child: Image.asset(
                        'assets/icons/armchair_light_72.png',
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0, width * 0.08, width * 0.08, width * 0.08),
                      child: Center(
                        child: Text(
                          'RESERVATION_MODE_PLACE'.tr(),
                          style: szikTextTheme.headline2!.copyWith(
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Provider.of<ReservationManager>(context, listen: false)
                      .selectMode(ReservationMode.zoom),
              child: Container(
                margin: EdgeInsets.fromLTRB(width * 0.08, 0, width * 0.08, 0),
                height: height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(width * 0.08),
                      child: Image.asset(
                        'assets/icons/chalkboard_teacher_light_72.png',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0, width * 0.08, width * 0.08, width * 0.08),
                      child: Center(
                        child: Text(
                          'RESERVATION_MODE_ZOOM'.tr(),
                          style: szikTextTheme.headline2!.copyWith(
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Provider.of<ReservationManager>(context, listen: false)
                      .selectMode(ReservationMode.boardgame),
              child: Container(
                margin: EdgeInsets.fromLTRB(width * 0.08, 0, width * 0.08, 0),
                height: height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(width * 0.08),
                      child: Image.asset(
                        'assets/icons/dicefive_light_72.png',
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0, width * 0.08, width * 0.08, width * 0.08),
                      child: Text(
                        'RESERVATION_MODE_BOARDGAME'.tr(),
                        style: szikTextTheme.headline2!.copyWith(
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.none,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
