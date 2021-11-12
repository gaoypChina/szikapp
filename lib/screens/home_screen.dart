import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../navigation/app_state_manager.dart';
import 'feed_screen.dart';
import 'menu_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/';

  final int currentTab;

  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: HomeScreen(
        currentTab: currentTab,
      ),
    );
  }

  const HomeScreen({
    Key key = const Key('HomeScreen'),
    required this.currentTab,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<Widget> pages = [
    const FeedScreen(),
    const MenuScreen(),
    const SettingsScreen(),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Consumer<SzikAppStateManager>(
      builder: (context, appStateManager, child) {
        var theme = Theme.of(context);
        return SafeArea(
          child: Scaffold(
            //appBar: ,
            body: IndexedStack(
              index: widget.currentTab,
              children: pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: theme.colorScheme.onPrimary,
              currentIndex: widget.currentTab,
              onTap: (index) {
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .selectTab(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: ColorFiltered(
                    child: Image.asset('assets/icons/feed_light_72.png'),
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  label: 'MENU_FEED'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: ColorFiltered(
                    child: Image.asset('assets/icons/cedar_light_72.png'),
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  label: 'MENU_HOME'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: ColorFiltered(
                    child: Image.asset('assets/icons/gear_light_72.png'),
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  label: 'MENU_SETTINGS'.tr(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
