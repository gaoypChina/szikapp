import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../business/reservation.dart';
import '../ui/themes.dart';

class ReservationPage extends StatefulWidget {
  static const String route = '/reservation';

  const ReservationPage({Key key = const Key('ReservationPage')})
      : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late final Reservation reservation;

  @override
  void initState() {
    super.initState();
    reservation = Reservation();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pictures/background_1.jpg'),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          // Teremfoglalás
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.08, 0, width * 0.08, 0),
            height: height * 0.15,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25)),
            child: ListView(
              scrollDirection: Axis.horizontal,
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
                      child: Text('RESERVATION_MODE_PLACE'.tr(),
                          style: szikTextTheme.headline2!.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.none,
                              color: Theme.of(context).colorScheme.secondary))),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          // Zoom foglalás
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.08, 0, width * 0.08, 0),
            height: height * 0.15,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25)),
            child: ListView(
              scrollDirection: Axis.horizontal,
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
                      child: Text('RESERVATION_MODE_ZOOM'.tr(),
                          style: szikTextTheme.headline2!.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.none,
                              color: Theme.of(context).colorScheme.primary))),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          // Társas foglalás
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.08, 0, width * 0.08, 0),
            height: height * 0.15,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25)),
            child: ListView(
              scrollDirection: Axis.horizontal,
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
                  child: Center(
                      child: Text('RESERVATION_MODE_BOARDGAME'.tr(),
                          style: szikTextTheme.headline2!.copyWith(
                              fontSize: 20,
                              decoration: TextDecoration.none,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryVariant))),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            height: kBottomNavigationBarHeight,
          )
        ],
      ),
    );
  }
}
