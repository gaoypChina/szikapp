import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'signin_page.dart';

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
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_DATA_PINNED'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_DATA_DOCUMENTS'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
];

final List<SubMenuButton> subMenuCommunityListItems = [
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_HELPME'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_BEERWITHME'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_SPIRITUAL'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
];

final List<SubMenuButton> subMenuEverydayListItems = [
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_CLEANING'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_RESERVATION'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_JANITOR'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_FORMS'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_POLL'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_BOOKLOAN'.tr(),
    picture: 'assets/pictures/default.png',
    route: SignInPage.route,
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
      backgroundColor: Colors.grey[600],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pictures/background_1.jpg'),
              fit: BoxFit.cover),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    color: Color(0xff990e35),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
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
                                  color: Colors.white.withOpacity(.7),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(item.picture),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 32,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xff59a3b0)),
                                          ),
                                        ],
                                      ),
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
