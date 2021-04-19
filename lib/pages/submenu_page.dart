import 'package:flutter/material.dart';
import 'signin_page.dart';

class SubMenuPage extends StatefulWidget {
  static const String route = '/submenu';
  @override
  _SubMenuPageState createState() => _SubMenuPageState();
}

class SubMenuButton {
  final String picture;
  final String name;
  final String ontap;

  /// Konstruktor
  SubMenuButton(
      {required this.picture, required this.name, required this.ontap});
}

class _SubMenuPageState extends State<SubMenuPage> {
  final List<SubMenuButton> _listItem = [
    SubMenuButton(
        name: 'Sign in with Google',
        picture: 'assets/pictures/kristof.jpg',
        ontap: SignInPage.route),
    SubMenuButton(
        name: 'második',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'harmadik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'negyedik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'ötödik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'hatodik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'hetedik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'nyolcadik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'kilencedik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'tizedik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
    SubMenuButton(
        name: 'tizenegyedik',
        picture: 'assets/pictures/kristof.jpg',
        ontap: 'HomePage'),
  ];

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
                  children: _listItem
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
                                                'assets/pictures/kristof.jpg'),
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
