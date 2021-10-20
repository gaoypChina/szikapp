import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/screens/error_screen.dart';
import 'contacts_page.dart';
import 'documents_page.dart';
import 'janitor_page.dart';
import 'reservation_page.dart';

class SubMenuArguments {
  List<SubMenuButton> items;
  String title;

  SubMenuArguments({required this.items, required this.title});
}

class SubMenuButton {
  final String picture;
  final String name;
  final String route;

  /// Konstruktor
  SubMenuButton(
      {required this.picture, required this.name, required this.route});
}

final List<SubMenuButton> subMenuDataListItems = [
  SubMenuButton(
    name: 'SUBMENU_DATA_CONTACTS'.tr(),
    picture: 'assets/icons/users_light_72.png',
    route: ContactsPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_DATA_DOCUMENTS'.tr(),
    picture: 'assets/icons/book_light_72.png',
    route: DocumentsPage.route,
  ),
];

final List<SubMenuButton> subMenuCommunityListItems = [
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_HELPME'.tr(),
    picture: 'assets/icons/helpme_light_72.png',
    route: ErrorScreen.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_BEERWITHME'.tr(),
    picture: 'assets/icons/beer_light_72.png',
    route: ErrorScreen.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_SPIRITUAL'.tr(),
    picture: 'assets/icons/fire_light_72.png',
    route: ErrorScreen.route,
  ),
];

final List<SubMenuButton> subMenuEverydayListItems = [
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_CLEANING'.tr(),
    picture: 'assets/icons/knife_light_72.png',
    route: ErrorScreen.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_RESERVATION'.tr(),
    picture: 'assets/icons/hourglass_light_72.png',
    route: ReservationPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_JANITOR'.tr(),
    picture: 'assets/icons/wrench_light_72.png',
    route: JanitorPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_FORMS'.tr(),
    picture: 'assets/icons/pencil_light_72.png',
    route: ErrorScreen.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_POLL'.tr(),
    picture: 'assets/icons/handpalm_light_72.png',
    route: ErrorScreen.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_BOOKLOAN'.tr(),
    picture: 'assets/icons/bank_light_72.png',
    route: ErrorScreen.route,
  ),
];

class SubMenuPage extends StatefulWidget {
  final List<SubMenuButton> listItems;
  final String title;
  static const String route = '/submenu';

  const SubMenuPage(
      {Key key = const Key('SubMenuPage'),
      required this.listItems,
      required this.title})
      : super(key: key);
  @override
  _SubMenuPageState createState() => _SubMenuPageState();
}

class _SubMenuPageState extends State<SubMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pictures/background_1.jpg'),
              fit: BoxFit.cover),
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.title.toUpperCase(),
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 25,
                      ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 4
                      : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: widget.listItems
                      .map((item) => Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: GestureDetector(
                              onTap: () {
                                _onPressed(item.route);
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .withOpacity(0.7),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    SizedBox(
                                      height: 55,
                                      width: 55,
                                      child: ColorFiltered(
                                        child: Image.asset(item.picture),
                                        colorFilter: ColorFilter.mode(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.name,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 16,
                                              ),
                                        ),
                                      ],
                                    )
                                  ],
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

  void _onPressed(String route) {
    Navigator.of(context).pushNamed(route);
  }
}
