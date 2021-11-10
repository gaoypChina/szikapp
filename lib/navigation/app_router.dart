import 'package:flutter/material.dart';
import '../business/calendar_manager.dart';
import '../business/good_to_know_manager.dart';
import '../business/janitor_manager.dart';
import '../business/kitchen_cleaning_manager.dart';
import '../business/poll_manager.dart';
import '../business/reservation_manager.dart';
import 'app_link.dart';
import 'app_state_manager.dart';

class SzikAppRouter extends RouterDelegate<SzikAppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final SzikAppStateManager appStateManager;
  final CalendarManager calendarManager;
  final GoodToKnowManager goodToKnowManager;
  final JanitorManager janitorManager;
  final KitchenCleaningManager kitchenCleaningManager;
  final PollManager pollManager;
  final ReservationManager reservationManager;

  SzikAppRouter({
    required this.appStateManager,
    required this.calendarManager,
    required this.goodToKnowManager,
    required this.janitorManager,
    required this.kitchenCleaningManager,
    required this.pollManager,
    required this.reservationManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
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
      pages: const [],
      onPopPage: _handlePopPage,
    );
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
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

    return true;
  }

  @override
  Future<void> setNewRoutePath(SzikAppLink newLink) async {}
}
