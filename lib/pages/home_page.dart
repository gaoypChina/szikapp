import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'menu_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';
  HomePage({Key key = const Key('HomePage')}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 1);
  }

  List<Widget> _buildScreens() {
    return [
      ProfilePage(),
      MenuPage(),
      SettingsPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: 'Profile',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Color(0xffeeeeee),
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.menu),
        title: 'Menu',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Color(0xffeeeeee),
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: 'Settings',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Color(0xffeeeeee),
        inactiveColorSecondary: Colors.purple,
      ),
    ];
  }

  Future<bool> _onPop(BuildContext? context) async {
    if (Navigator.of(context!).canPop()) {
      Navigator.of(context).pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color(0xff59a3b0),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.all(0.0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        onWillPop: _onPop,
        decoration: NavBarDecoration(
          colorBehindNavBar: Color(0xff59a3b0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}
