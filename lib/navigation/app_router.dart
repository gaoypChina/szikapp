import 'package:flutter/material.dart';

import '../business/calendar_manager.dart';
import '../business/good_to_know_manager.dart';
import '../business/janitor_manager.dart';
import '../business/kitchen_cleaning_manager.dart';
import '../business/poll_manager.dart';
import '../business/reservation_manager.dart';
import '../screens/home_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/submenu_screen.dart';
import '../utils/auth_manager.dart';
import 'app_link.dart';
import 'app_state_manager.dart';

class SzikAppRouter extends RouterDelegate<SzikAppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final SzikAppStateManager appStateManager;
  final AuthManager authManager;
  final CalendarManager calendarManager;
  final GoodToKnowManager goodToKnowManager;
  final JanitorManager janitorManager;
  final KitchenCleaningManager kitchenCleaningManager;
  final PollManager pollManager;
  final ReservationManager reservationManager;

  SzikAppRouter({
    required this.appStateManager,
    required this.authManager,
    required this.calendarManager,
    required this.goodToKnowManager,
    required this.janitorManager,
    required this.kitchenCleaningManager,
    required this.pollManager,
    required this.reservationManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    authManager.addListener(notifyListeners);
    calendarManager.addListener(notifyListeners);
    goodToKnowManager.addListener(notifyListeners);
    janitorManager.addListener(notifyListeners);
    kitchenCleaningManager.addListener(notifyListeners);
    pollManager.addListener(notifyListeners);
    reservationManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (!authManager.isSignedIn) ...[
          SignInScreen.page(),
        ] else ...[
          HomeScreen.page(appStateManager.selectedTab),
          if (appStateManager.selectedSubMenu != SzikAppSubMenu.none)
            SubMenuScreen.page(
                selectedSubMenu: appStateManager.selectedSubMenu),
        ]
      ],
      onPopPage: _handlePopPage,
    );
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    authManager.removeListener(notifyListeners);
    calendarManager.removeListener(notifyListeners);
    goodToKnowManager.removeListener(notifyListeners);
    janitorManager.removeListener(notifyListeners);
    kitchenCleaningManager.removeListener(notifyListeners);
    pollManager.removeListener(notifyListeners);
    reservationManager.removeListener(notifyListeners);
    super.dispose();
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    if (route.settings.name == SzikAppLink.kHomePath) {
      authManager.signOut();
    }
    if (route.settings.name == SzikAppLink.kSubMenuPath) {
      appStateManager.unselectSubMenu();
    }

    return true;
  }

  SzikAppLink getCurrentPath() {
    if (!authManager.isSignedIn) {
      return SzikAppLink(location: SzikAppLink.kSignInPath);
    } else if (appStateManager.selectedSubMenu != SzikAppSubMenu.none) {
      return SzikAppLink(
        location: SzikAppLink.kSubMenuPath,
        currentSubMenu: appStateManager.selectedSubMenu,
      );
    } else {
      return SzikAppLink(
        location: SzikAppLink.kHomePath,
        currentTab: appStateManager.selectedTab,
      );
    }
  }

  @override
  SzikAppLink get currentConfiguration => getCurrentPath();

  @override
  Future<void> setNewRoutePath(SzikAppLink configuration) async {
    switch (configuration.location) {
      case SzikAppLink.kHomePath:
        appStateManager.selectTab(configuration.currentTab ?? SzikAppTab.feed);
        break;
      case SzikAppLink.kSubMenuPath:
        appStateManager
            .selectSubMenu(configuration.currentSubMenu ?? SzikAppSubMenu.data);
        break;
      default:
        break;
    }
  }
}
