import 'package:flutter/material.dart';
import '../../pages/reservation_page.dart';
import '../themes.dart';

class ReservationPlacesMapScreen extends StatelessWidget {
  static const String route = '/reservation/places';

  const ReservationPlacesMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            height: 120,
          ),
          // 5. emelet ------------------------------------------------
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                        child: MyText(
                      title: 'Terasz',
                    )),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: 'Szemináriumi\nszoba',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: 'Hencsergő',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          // 4. emelet ------------------------------------------------
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                        child: MyText(
                      title: 'Párbeszéd\nterme',
                    )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: 'Folyóirat\nolvasó',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: 'Kápolna',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: 'Akvárium',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: 'TV szoba',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          // 3. emelet ------------------------------------------------
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                        child: MyText(
                      title: 'Nagy terasz',
                    )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: 'Szalon',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Center(
                    child: MyText(
                      title: 'Konyha\nnem foglalható',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          // Földszint ----------------------------------------------
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                        child: MyText(
                      title: 'Könyvtár',
                    )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: 'Zeneszoba',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          // -1. emelet ------------------------------------------------
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Center(
                      child: MyText(
                    title: 'Kondi terem\nnem foglalható',
                  )),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Center(
                    child: Text(
                      'Horánszky\n18',
                      textAlign: TextAlign.center,
                      style: szikTextTheme.headline2!.copyWith(
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.none,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ReservationPage.route),
                  child: Container(
                    child: Center(
                      child: MyText(
                        title: '-1 Közösségi tér',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyText extends StatefulWidget {
  final String title;
  const MyText({Key key = const Key('MyText'), required this.title})
      : super(key: key);
  @override
  _MyTextState createState() => _MyTextState();
}

class _MyTextState extends State<MyText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      textAlign: TextAlign.center,
      style: szikTextTheme.bodyText1!.copyWith(
          fontSize: 15,
          fontStyle: FontStyle.normal,
          decoration: TextDecoration.none,
          color: Theme.of(context).colorScheme.secondary),
    );
  }
}
