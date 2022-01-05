import 'package:flutter/material.dart';

import '../business/business.dart';
import '../screens/calendar_screen.dart';
import '../screens/contacts_screen.dart';
import '../screens/documents_screen.dart';
import '../screens/error_screen.dart';
import '../screens/home_screen.dart';
import '../screens/janitor_edit_admin.dart';
import '../screens/janitor_new_edit.dart';
import '../screens/janitor_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/reservation_details.dart';
import '../screens/reservation_games.dart';
import '../screens/reservation_new_edit.dart';
import '../screens/reservation_places_map.dart';
import '../screens/reservation_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/submenu_screen.dart';
import '../utils/auth_manager.dart';
import '../utils/exceptions.dart';
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
          if (appStateManager.selectedFeature == SzikAppFeature.calendar)
            CalendarScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.contacts)
            ContactsScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.documents)
            DocumentsScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.error)
            ErrorScreen.page(
              error: appStateManager.error ??
                  NotImplementedException('Not implemented.'),
            ),
          if (appStateManager.selectedFeature == SzikAppFeature.janitor)
            JanitorScreen.page(manager: janitorManager),
          if (appStateManager.selectedFeature == SzikAppFeature.profile)
            ProfileScreen.page(manager: authManager),
          if (appStateManager.selectedFeature == SzikAppFeature.reservation)
            ReservationScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.settings)
            SettingsScreen.page(),
          if (janitorManager.isCreatingNewTask)
            JanitorNewEditScreen.page(
              onCreate: (item) {
                janitorManager.addTask(item);
              },
              onUpdate: (item, index) {},
              onDelete: (item, index) {},
            ),
          if (janitorManager.isEditingTask)
            JanitorNewEditScreen.page(
              originalItem: janitorManager.selectedTask,
              onCreate: (_) {},
              onUpdate: (item, index) {
                janitorManager.updateTask(item);
              },
              onDelete: (item, index) {
                janitorManager.deleteTask(item);
              },
            ),
          if (janitorManager.isGivingFeedback)
            JanitorNewEditScreen.page(
              originalItem: janitorManager.selectedTask,
              isFeedback: true,
              onCreate: (_) {},
              onUpdate: (item, index) {
                janitorManager.updateStatus(item.status, item);
              },
              onDelete: (item, index) {
                janitorManager.deleteTask(item);
              },
            ),
          if (janitorManager.isAdminEditingTask)
            JanitorEditAdminScreen.page(
              item: janitorManager.selectedTask!,
              onDelete: (item, index) {
                janitorManager.deleteTask(item);
              },
              onUpdate: (item, index) {
                janitorManager.updateTask(item);
              },
            ),
          if (reservationManager.selectedMode == ReservationMode.place)
            ReservationPlacesMapScreen.page(),
          if (reservationManager.selectedMode == ReservationMode.boardgame)
            ReservationGamesListScreen.page(),
          if (reservationManager.selectedPlaceIndex != -1 ||
              reservationManager.selectedGameIndex != -1 ||
              reservationManager.selectedMode == ReservationMode.zoom)
            ReservationDetailsScreen.page(manager: reservationManager),
          if (reservationManager.isCreatingNewReservation)
            ReservationNewEditScreen.page(
              placeIndex: reservationManager.selectedPlaceIndex,
              onCreate: (item) {
                reservationManager.addReservation(item);
              },
              onUpdate: (item, index) {},
              onDelete: (item, index) {},
            ),
          if (reservationManager.isEditingReservation)
            ReservationNewEditScreen.page(
              placeIndex: reservationManager.selectedPlaceIndex,
              originalItem: reservationManager.selectedTask,
              onCreate: (_) {},
              onUpdate: (item, index) {
                reservationManager.updateReservation(item);
              },
              onDelete: (item, index) {
                reservationManager.deleteReservation(item);
              },
            ),
        ],
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
    if (route.settings.name == SzikAppLink.kCalendarPath ||
        route.settings.name == SzikAppLink.kContactsPath ||
        route.settings.name == SzikAppLink.kDocumentsPath ||
        route.settings.name == SzikAppLink.kErrorPath ||
        route.settings.name == SzikAppLink.kJanitorPath ||
        route.settings.name == SzikAppLink.kProfilePath ||
        route.settings.name == SzikAppLink.kReservationPath ||
        route.settings.name == SzikAppLink.kSettingsPath) {
      appStateManager.unselectFeature();
    }
    if (route.settings.name == SzikAppLink.kJanitorNewEditPath ||
        route.settings.name == SzikAppLink.kJanitorEditAdminPath) {
      janitorManager.performBackButtonPressed();
    }
    if (route.settings.name == SzikAppLink.kReservationNewEditPath) {
      reservationManager.performBackButtonPressed();
    }
    if (route.settings.name == SzikAppLink.kReservationGamesListPath ||
        route.settings.name == SzikAppLink.kReservationPlacesMapPath ||
        (route.settings.name == SzikAppLink.kReservationDetailsPath &&
            reservationManager.selectedMode == ReservationMode.zoom)) {
      reservationManager.unselectMode();
    }
    if (route.settings.name == SzikAppLink.kReservationDetailsPath &&
        reservationManager.selectedMode == ReservationMode.boardgame) {
      reservationManager.selectGame(-1);
    }
    if (route.settings.name == SzikAppLink.kReservationDetailsPath &&
        reservationManager.selectedMode == ReservationMode.place) {
      reservationManager.selectPlace(-1);
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
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.calendar) {
      return SzikAppLink(
        location: SzikAppLink.kCalendarPath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.contacts) {
      return SzikAppLink(
        location: SzikAppLink.kContactsPath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.documents) {
      return SzikAppLink(
        location: SzikAppLink.kDocumentsPath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.error) {
      return SzikAppLink(
        location: SzikAppLink.kErrorPath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.janitor) {
      return SzikAppLink(
        location: SzikAppLink.kJanitorPath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.profile) {
      return SzikAppLink(
        location: SzikAppLink.kProfilePath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.reservation) {
      return SzikAppLink(
        location: SzikAppLink.kReservationPath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.settings) {
      return SzikAppLink(
        location: SzikAppLink.kSettingsPath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
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
      case SzikAppLink.kCalendarPath:
        appStateManager.selectFeature(SzikAppFeature.calendar);
        break;
      case SzikAppLink.kContactsPath:
        appStateManager.selectFeature(SzikAppFeature.contacts);
        break;
      case SzikAppLink.kDocumentsPath:
        appStateManager.selectFeature(SzikAppFeature.documents);
        break;
      case SzikAppLink.kErrorPath:
        appStateManager.selectFeature(SzikAppFeature.error);
        break;
      case SzikAppLink.kJanitorPath:
        appStateManager.selectFeature(SzikAppFeature.janitor);
        break;
      case SzikAppLink.kProfilePath:
        appStateManager.selectFeature(SzikAppFeature.profile);
        break;
      case SzikAppLink.kReservationPath:
        appStateManager.selectFeature(SzikAppFeature.reservation);
        break;
      case SzikAppLink.kSettingsPath:
        appStateManager.selectFeature(SzikAppFeature.settings);
        break;
      default:
        break;
    }
  }
}
