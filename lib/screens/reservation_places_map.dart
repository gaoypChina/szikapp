import 'package:flutter/material.dart';
import '../components/components.dart';

import '../ui/themes.dart';
import 'reservation_screen.dart';

class ReservationPlacesMapScreen extends StatelessWidget {
  static const String route = '/reservation/places';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: ReservationPlacesMapScreen(),
    );
  }

  const ReservationPlacesMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            // 5. emelet ------------------------------------------------
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                        child: MyText(
                      title: 'Terasz',
                    )),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: 'Szemináriumi\nszoba',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: 'Hencsergő',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // 4. emelet ------------------------------------------------
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                        child: MyText(
                      title: 'Párbeszéd\nterme',
                    )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: 'Folyóirat\nolvasó',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: 'Kápolna',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: 'Akvárium',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: 'TV szoba',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // 3. emelet ------------------------------------------------
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                        child: MyText(
                      title: 'Nagy terasz',
                    )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: 'Szalon',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Center(
                    child: MyText(
                      title: 'Konyha\nnem foglalható',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // Földszint ----------------------------------------------
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                        child: MyText(
                      title: 'Könyvtár',
                    )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: 'Zeneszoba',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // -1. emelet ------------------------------------------------
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Center(
                      child: MyText(
                    title: 'Kondi terem\nnem foglalható',
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Center(
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
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationScreen())),
                    child: const Center(
                      child: MyText(
                        title: '-1 Közösségi tér',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
