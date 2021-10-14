import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../main.dart';
import '../ui/screens/error_screen.dart';
import '../ui/screens/progress_screen.dart';
import 'feed_page.dart';
import 'menu_page.dart';
import 'settings_page.dart';
import 'signin_page.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';
  const HomePage({Key key = const Key('HomePage')}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();

    _controller = PersistentTabController(initialIndex: 1);
  }

  List<Widget> _buildScreens() {
    return [
      const FeedPage(),
      const MenuPage(),
      const SettingsPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: ColorFiltered(
          child: Image.asset('assets/icons/feed_light_72.png'),
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        title: 'MENU_FEED'.tr(),
        textStyle: Theme.of(context).textTheme.overline,
        activeColorPrimary: Theme.of(context).colorScheme.background,
        inactiveColorPrimary:
            Theme.of(context).colorScheme.background.withOpacity(0.9),
        inactiveColorSecondary: Colors.purple,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: FeedPage.route,
          onGenerateRoute: SZIKAppState.onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: ColorFiltered(
          child: Image.asset('assets/icons/cedar_light_72.png'),
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        title: 'MENU_HOME'.tr(),
        textStyle: Theme.of(context).textTheme.overline,
        activeColorPrimary: Theme.of(context).colorScheme.background,
        inactiveColorPrimary:
            Theme.of(context).colorScheme.background.withOpacity(0.9),
        inactiveColorSecondary: Colors.purple,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: MenuPage.route,
          onGenerateRoute: SZIKAppState.onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: ColorFiltered(
          child: Image.asset('assets/icons/gear_light_72.png'),
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        title: 'MENU_SETTINGS'.tr(),
        textStyle: Theme.of(context).textTheme.overline,
        activeColorPrimary: Theme.of(context).colorScheme.background,
        inactiveColorPrimary:
            Theme.of(context).colorScheme.background.withOpacity(0.9),
        inactiveColorSecondary: Colors.purple,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
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

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (deepLink.path == '/me') {
          pushNewScreen(context,
              screen: SZIKAppState.getDestination(
                  const RouteSettings(name: '/profile')));
        }
        pushNewScreen(
          context,
          screen:
              SZIKAppState.getDestination(RouteSettings(name: deepLink.path)),
          withNavBar: true,
        );
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (deepLink.path == '/me') {
        pushNewScreen(context,
            screen: SZIKAppState.getDestination(
                const RouteSettings(name: '/profile')));
      }
      pushNewScreen(
        context,
        screen: SZIKAppState.getDestination(RouteSettings(name: deepLink.path)),
        withNavBar: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SZIKAppState.initializeFlutterFire(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProgressScreen();
        } else if (snapshot.hasData) {
          if (SZIKAppState.authManager.isSignedIn) SZIKAppState.loadEarlyData();
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
                    margin: const EdgeInsets.all(0.0),
                    popActionScreens: PopActionScreensType.all,
                    bottomScreenMargin: 0.0,
                    onWillPop: _onPop,
                    decoration: NavBarDecoration(
                      colorBehindNavBar: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    popAllScreensOnTapOfSelectedTab: true,
                    itemAnimationProperties: const ItemAnimationProperties(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.ease,
                    ),
                    screenTransitionAnimation: const ScreenTransitionAnimation(
                      animateTabTransition: true,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 200),
                    ),
                    navBarStyle: NavBarStyle.style1,
                  ),
                )
              : const SignInPage();
        } else if (snapshot.hasError) {
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          return ErrorScreen(error: 'ERROR_UNKNOWN'.tr());
        }
      },
    );
  }
}
