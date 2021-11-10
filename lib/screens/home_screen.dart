import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../main.dart';
import '../utils/error_handler.dart';
import '../utils/exceptions.dart';
import 'error_screen.dart';
import 'feed_screen.dart';
import 'menu_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: HomeScreen(),
    );
  }

  const HomeScreen({Key key = const Key('HomeScreen')}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PersistentTabController _controller;
  bool hasDynamicLinkError = false;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();

    _controller = PersistentTabController(initialIndex: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      const FeedScreen(),
      const MenuScreen(),
      const SettingsScreen(),
    ];
  }

  void setNotificationBarTheme() {
    MediaQuery.of(context).platformBrightness == Brightness.light
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.primary,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
              //systemStatusBarContrastEnforced: , //Not sure if needed
            ),
          )
        : SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.primary,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark,
              //systemStatusBarContrastEnforced: ,  //Not sure if needed
            ),
          );
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
          initialRoute: FeedScreen.route,
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
          initialRoute: MenuScreen.route,
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
          initialRoute: SettingsScreen.route,
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
      final deepLink = dynamicLink?.link;

      if (deepLink != null) {
        pushNewScreen(
          context,
          screen:
              SZIKAppState.getDestination(RouteSettings(name: deepLink.path)),
          withNavBar: true,
        );
      }
    }, onError: (OnLinkErrorException e) async {
      hasDynamicLinkError = true;
    });

    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
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
          setNotificationBarTheme();
          if (hasDynamicLinkError) {
            ScaffoldMessenger.of(context).showSnackBar(
              ErrorHandler.buildSnackbar(
                context,
                errorCode: dynamicLinkExceptionCode,
              ),
            );
          }
          return snapshot.data!
              ? SafeArea(
                  child: Scaffold(
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
                        colorBehindNavBar:
                            Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                      ),
                      popAllScreensOnTapOfSelectedTab: true,
                      itemAnimationProperties: const ItemAnimationProperties(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.ease,
                      ),
                      screenTransitionAnimation:
                          const ScreenTransitionAnimation(
                        animateTabTransition: true,
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 200),
                      ),
                      navBarStyle: NavBarStyle.style1,
                    ),
                  ),
                )
              : const SignInScreen();
        } else if (snapshot.hasError) {
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          return ErrorScreen(error: 'ERROR_UNKNOWN'.tr());
        }
      },
    );
  }
}
