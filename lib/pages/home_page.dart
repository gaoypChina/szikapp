import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../main.dart';
import '../ui/screens/error_screen.dart';
import '../ui/screens/progress_screen.dart';
import 'menu_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'signin_page.dart';

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

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: ColorFiltered(
          child: Image.asset('assets/icons/profile_light_72.png'),
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        title: 'MENU_CONTACTS'.tr(),
        textStyle: Theme.of(context).textTheme.overline,
        activeColorPrimary: Theme.of(context).colorScheme.background,
        inactiveColorPrimary:
            Theme.of(context).colorScheme.background.withOpacity(0.9),
        inactiveColorSecondary: Colors.purple,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: ProfilePage.route,
          onGenerateRoute: SZIKAppState.onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: ColorFiltered(
          child: Image.asset('assets/icons/cedar_light_72.png'),
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        title: 'MENU_HOME'.tr(),
        textStyle: Theme.of(context).textTheme.overline,
        activeColorPrimary: Theme.of(context).colorScheme.background,
        inactiveColorPrimary:
            Theme.of(context).colorScheme.background.withOpacity(0.9),
        inactiveColorSecondary: Colors.purple,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: MenuPage.route,
          onGenerateRoute: SZIKAppState.onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: ColorFiltered(
          child: Image.asset('assets/icons/calendar_light_72.png'),
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        title: 'MENU_CALENDAR'.tr(),
        textStyle: Theme.of(context).textTheme.overline,
        activeColorPrimary: Theme.of(context).colorScheme.background,
        inactiveColorPrimary:
            Theme.of(context).colorScheme.background.withOpacity(0.9),
        inactiveColorSecondary: Colors.purple,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: SettingsPage.route,
          onGenerateRoute: SZIKAppState.onGenerateRoute,
        ),
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
    return FutureBuilder<bool>(
      future: SZIKAppState.initializeFlutterFire(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProgressScreen();
        } else if (snapshot.hasData) {
          SZIKAppState.loadEarlyData();
          return snapshot.data!
              ? Scaffold(
                  body: PersistentTabView(
                    context,
                    controller: _controller,
                    screens: _buildScreens(),
                    items: _navBarItems(),
                    confineInSafeArea: false,
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                      colorBehindNavBar: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
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
                )
              : SignInPage();
        } else if (snapshot.hasError) {
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else
          return ErrorScreen(error: 'ERROR_UNKNOWN'.tr());
      },
    );
  }
}
