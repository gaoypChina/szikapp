import 'dart:io';
import 'package:flutter/material.dart';

import '../business/business.dart';
import '../navigation/navigation.dart';
import '../screens/screens.dart';
import '../utils/utils.dart';

class SzikAppRouter extends RouterDelegate<SzikAppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final SzikAppStateManager appStateManager;
  final AuthManager authManager;
  final GoodToKnowManager goodToKnowManager;
  final KitchenCleaningManager kitchenCleaningManager;
  final PollManager pollManager;
  final ReservationManager reservationManager;

  SzikAppRouter({
    required this.appStateManager,
    required this.authManager,
    required this.goodToKnowManager,
    required this.kitchenCleaningManager,
    required this.pollManager,
    required this.reservationManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    authManager.addListener(notifyListeners);
    goodToKnowManager.addListener(notifyListeners);
    kitchenCleaningManager.addListener(notifyListeners);
    pollManager.addListener(notifyListeners);
    reservationManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appStateManager.hasError) ...[
          ErrorScreen.page(
            errorInset: ErrorHandler.buildInset(
              context,
              errorCode: appStateManager.error?.code,
            ),
          )
        ] else if (appStateManager.isStarting) ...[
          StartScreen.page(),
        ] else if (authManager.isUserGuest) ...[
          HomeScreen.page(appStateManager.selectedTab),
          if (appStateManager.selectedFeature == SzikAppFeature.article)
            ArticleScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.invitation)
            InvitationScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.settings)
            SettingsScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.profile)
            ProfileScreen.page(manager: authManager),
        ] else ...[
          HomeScreen.page(appStateManager.selectedTab),
          if (appStateManager.selectedSubMenu != SzikAppSubMenu.none)
            SubMenuScreen.page(
                selectedSubMenu: appStateManager.selectedSubMenu),
          if (appStateManager.selectedFeature == SzikAppFeature.bookrental)
            BookRentalScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.calendar)
            CalendarScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.contacts)
            ContactsScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.documents)
            DocumentsScreen.page(manager: goodToKnowManager),
          if (appStateManager.selectedFeature == SzikAppFeature.poll)
            PollScreen.page(manager: pollManager),
          if (appStateManager.selectedFeature == SzikAppFeature.cleaning)
            CleaningScreen.page(manager: kitchenCleaningManager),
          if (appStateManager.selectedFeature == SzikAppFeature.error)
            ErrorScreen.page(
              error: appStateManager.error ??
                  NotImplementedException('Not implemented.'),
            ),
          if (appStateManager.selectedFeature == SzikAppFeature.janitor)
            JanitorScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.passwords)
            PasswordsScreen.page(manager: reservationManager),
          if (appStateManager.selectedFeature == SzikAppFeature.profile)
            ProfileScreen.page(manager: authManager),
          if (appStateManager.selectedFeature == SzikAppFeature.reservation)
            ReservationScreen.page(),
          if (appStateManager.selectedFeature == SzikAppFeature.settings)
            SettingsScreen.page(),
          if (pollManager.isCreatingNewPoll)
            PollCreateEditScreen.page(
              onCreate: (poll) {
                performFunctionSecurely(
                    context, () => pollManager.addPoll(poll));
              },
              onUpdate: (_, __) {},
              onDelete: (_, __) {},
            ),
          if (pollManager.isEditingPoll)
            PollCreateEditScreen.page(
              originalItem: pollManager.selectedPoll,
              onCreate: (_) {},
              onUpdate: (poll, index) {
                performFunctionSecurely(
                    context, () => pollManager.updatePoll(poll));
              },
              onDelete: (poll, index) {
                performFunctionSecurely(
                    context, () => pollManager.deletePoll(poll));
              },
            ),
          if (reservationManager.selectedMode == ReservationMode.place)
            ReservationPlacesScreen.page(manager: reservationManager),
          if (reservationManager.selectedMode == ReservationMode.boardgame)
            ReservationGamesListScreen.page(manager: reservationManager),
          if (reservationManager.selectedMode == ReservationMode.account)
            ReservationAccountsListScreen.page(manager: reservationManager),
          if (reservationManager.selectedPlaceIndex != -1 ||
              reservationManager.selectedGameIndex != -1 ||
              reservationManager.selectedAccountIndex != -1)
            ReservationDetailsScreen.page(manager: reservationManager),
          if (reservationManager.isCreatingNewReservation)
            ReservationCreateEditScreen.page(
              manager: reservationManager,
              onCreate: (task) {
                performFunctionSecurely(
                    context, () => reservationManager.addReservation(task));
              },
              onUpdate: (_, __) {},
              onDelete: (_, __) {},
            ),
          if (reservationManager.isEditingReservation)
            ReservationCreateEditScreen.page(
              manager: reservationManager,
              originalItem: reservationManager.selectedTask,
              onCreate: (_) {},
              onUpdate: (task, index) {
                performFunctionSecurely(
                    context, () => reservationManager.updateReservation(task));
              },
              onDelete: (task, index) {
                performFunctionSecurely(
                    context, () => reservationManager.deleteReservation(task));
              },
            ),
          if (kitchenCleaningManager.isAdminEditing)
            CleaningAdminScreen.page(manager: kitchenCleaningManager),
        ],
      ],
      onPopPage: _handlePopPage,
    );
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    authManager.removeListener(notifyListeners);
    goodToKnowManager.removeListener(notifyListeners);
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
    if (route.settings.name == SzikAppLink.kArticlePath ||
        route.settings.name == SzikAppLink.kBookRentalPath ||
        route.settings.name == SzikAppLink.kInvitationPath ||
        route.settings.name == SzikAppLink.kCalendarPath ||
        route.settings.name == SzikAppLink.kContactsPath ||
        route.settings.name == SzikAppLink.kDocumentsPath ||
        route.settings.name == SzikAppLink.kErrorPath ||
        route.settings.name == SzikAppLink.kJanitorPath ||
        route.settings.name == SzikAppLink.kKitchenCleaningPath ||
        route.settings.name == SzikAppLink.kPasswordsPath ||
        route.settings.name == SzikAppLink.kPollPath ||
        route.settings.name == SzikAppLink.kProfilePath ||
        route.settings.name == SzikAppLink.kReservationPath ||
        route.settings.name == SzikAppLink.kSettingsPath) {
      appStateManager.unselectFeature();
    }
    if (route.settings.name == SzikAppLink.kPollCreateEditPath) {
      pollManager.performBackButtonPressed();
    }
    if (route.settings.name == SzikAppLink.kReservationCreateEditPath) {
      reservationManager.cancelCreatingOrEditing();
    }
    if (route.settings.name == SzikAppLink.kReservationGamesListPath ||
        route.settings.name == SzikAppLink.kReservationPlacesMapPath ||
        route.settings.name == SzikAppLink.kReservationAccountsListPath) {
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
    if (route.settings.name == SzikAppLink.kReservationDetailsPath &&
        reservationManager.selectedMode == ReservationMode.account) {
      reservationManager.selectAccount(-1);
    }
    if (route.settings.name == SzikAppLink.kKitchenCleaningAdminPath) {
      kitchenCleaningManager.performBackButtonPressed();
    }
    return true;
  }

  SzikAppLink getCurrentPath() {
    if (appStateManager.isStarting) {
      return SzikAppLink(location: SzikAppLink.kStartPath);
    }
    if (appStateManager.selectedSubMenu != SzikAppSubMenu.none) {
      return SzikAppLink(
        location: SzikAppLink.kSubMenuPath,
        currentSubMenu: appStateManager.selectedSubMenu,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.article) {
      return SzikAppLink(
        location: SzikAppLink.kArticlePath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.bookrental) {
      return SzikAppLink(
        location: SzikAppLink.kBookRentalPath,
        currentFeature: appStateManager.selectedFeature,
        currentTab: appStateManager.selectedTab,
      );
    } else if (appStateManager.selectedFeature == SzikAppFeature.invitation) {
      return SzikAppLink(
        location: SzikAppLink.kInvitationPath,
        currentFeature: appStateManager.selectedFeature,
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
    } else if (appStateManager.selectedFeature == SzikAppFeature.passwords) {
      return SzikAppLink(
        location: SzikAppLink.kPasswordsPath,
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
      case SzikAppLink.kStartPath:
        appStateManager.initStarting();
        break;
      case SzikAppLink.kHomePath:
        appStateManager.selectTab(configuration.currentTab ?? SzikAppTab.feed);
        break;
      case SzikAppLink.kSubMenuPath:
        appStateManager
            .selectSubMenu(configuration.currentSubMenu ?? SzikAppSubMenu.data);
        break;
      case SzikAppLink.kArticlePath:
        appStateManager.selectFeature(SzikAppFeature.article);
        break;
      case SzikAppLink.kBookRentalPath:
        appStateManager.selectFeature(SzikAppFeature.bookrental);
        break;
      case SzikAppLink.kInvitationPath:
        appStateManager.selectFeature(SzikAppFeature.invitation);
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
      case SzikAppLink.kPasswordsPath:
        appStateManager.selectFeature(SzikAppFeature.passwords);
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

  Future<void> performFunctionSecurely(
    BuildContext context,
    Future<dynamic> Function() callback,
  ) async {
    try {
      await callback();
    } on IOException catch (exception) {
      var snackbar = ErrorHandler.buildSnackbar(context, exception: exception);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } on SocketException {
      var snackbar =
          ErrorHandler.buildSnackbar(context, errorCode: socketExceptionCode);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
