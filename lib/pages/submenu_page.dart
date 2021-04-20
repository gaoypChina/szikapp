import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'signin_page.dart';

class SubMenuButton {
  final String picture;
  final String name;
  final String ontap;

  /// Konstruktor
  SubMenuButton(
      {required this.picture, required this.name, required this.ontap});
}

final List<SubMenuButton> subMenuDataListItems = [
  SubMenuButton(
      name: 'Telefonkönyv, kontaktok',
      picture: 'assets/pictures/default.png',
      ontap: SignInPage.route),
  SubMenuButton(
      name: 'Pinned post',
      picture: 'assets/pictures/default.png',
      ontap: SignInPage.route),
  SubMenuButton(
      name: 'Hivatalos dokumentumok',
      picture: 'assets/pictures/default.png',
      ontap: SignInPage.route),
];

final List<SubMenuButton> subMenuCommunityListItems = [
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Help me! fül',
      ontap: SignInPage.route),
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Beer with me',
      ontap: SignInPage.route),
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Spiri részleg',
      ontap: SignInPage.route),
];

final List<SubMenuButton> subMenuEverydayListItems = [
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Konyhataka és csere',
      ontap: SignInPage.route),
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Foglalások',
      ontap: SignInPage.route),
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Gondnoki kérések',
      ontap: SignInPage.route),
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Form kitöltés fül',
      ontap: SignInPage.route),
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Szavazás közgyűlésen',
      ontap: SignInPage.route),
  SubMenuButton(
      picture: 'assets/pictures/default.png',
      name: 'Könyvtári kölcsönzés',
      ontap: SignInPage.route),
];

class SubMenuPage extends StatefulWidget {
  final List<SubMenuButton> listItems;
  static const String route = '/submenu';

  const SubMenuPage(
      {Key key = const Key('SubMenuPage'), required this.listItems})
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
                'BELÜGY',
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
                                _onPressed(item.ontap);
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
                                            image: AssetImage(
                                                'assets/pictures/default.png'),
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
    Navigator.of(context).pushReplacementNamed(route);
  }
}
