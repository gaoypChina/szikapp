class SzikAppLink {
  static const String kCalendarPath = '/calendar';
  static const String kContactsPath = '/contacts';
  static const String kDocumentsPath = '/documents';
  static const String kErrorPath = '/error';
  static const String kFeedPath = '/feed';
  static const String kHomePath = '/';
  static const String kJanitorEditAdminPath = '/janitor/adminedit';
  static const String kJanitorNewEditPath = '/janitor/newedit';
  static const String kJanitorPath = '/janitor';
  static const String kMenuPath = '/menu';
  static const String kProfilePath = '/profile';
  static const String kShortProfilePath = '/me';
  static const String kReservationDetailsPath = '/reservation/details';
  static const String kReservationGamesListPath = '/reservation/games';
  static const String kReservationNewEditPath = '/reservation/newedit';
  static const String kReservationPath = '/reservation';
  static const String kSettingsPath = '/settings';
  static const String kSignInPath = '/signin';
  static const String kSubMenuPath = '/submenu';

  static const String kTabParam = 'tab';
  static const String kSubMenuParam = 'submenu';
  static const String kFeatureParam = 'feature';
  static const String kIdParam = 'id';

  String? location;
  int? currentTab;
  int? currentSubMenu;
  int? currentFeature;
  String? itemId;

  SzikAppLink({
    this.location,
    this.currentTab,
    this.currentSubMenu,
    this.currentFeature,
    this.itemId,
  });

  static SzikAppLink fromLocation(String? location) {
    location = Uri.decodeFull(location ?? '');

    final uri = Uri.parse(location);
    final params = uri.queryParameters;

    final currentTab = int.tryParse(params[kTabParam] ?? '');
    final currentSubMenu = int.tryParse(params[kSubMenuParam] ?? '');
    final currentFeature = int.tryParse(params[kFeatureParam] ?? '');

    final itemId = params[kIdParam];

    final link = SzikAppLink(
      location: uri.path,
      currentTab: currentTab,
      currentSubMenu: currentSubMenu,
      currentFeature: currentFeature,
      itemId: itemId,
    );

    return link;
  }

  String toLocation() {
    String addKeyValPair({
      required String key,
      String? value,
    }) =>
        value == null ? '' : '$key=$value&';

    switch (location) {
      case kCalendarPath:
        return kCalendarPath;
      case kContactsPath:
        return kContactsPath;
      case kDocumentsPath:
        return kDocumentsPath;
      case kErrorPath:
        return kErrorPath;
      case kFeedPath:
        return kFeedPath;
      case kJanitorEditAdminPath:
        var loc = '$kJanitorEditAdminPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      case kJanitorNewEditPath:
        var loc = '$kJanitorNewEditPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      case kJanitorPath:
        return kJanitorPath;
      case kMenuPath:
        return kMenuPath;
      case kProfilePath:
        return kProfilePath;
      case kReservationDetailsPath:
        var loc = '$kReservationDetailsPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      case kReservationGamesListPath:
        return kReservationGamesListPath;
      case kReservationNewEditPath:
        var loc = '$kReservationNewEditPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      case kReservationPath:
        return kReservationPath;
      case kSettingsPath:
        return kSettingsPath;
      case kShortProfilePath:
        return kShortProfilePath;
      case kSignInPath:
        return kSignInPath;
      case kSubMenuPath:
        var loc = '$kSubMenuPath?';
        loc += addKeyValPair(
          key: kSubMenuParam,
          value: currentSubMenu.toString(),
        );
        return Uri.encodeFull(loc);
      default:
        var loc = '$kHomePath?';
        loc += addKeyValPair(
          key: kTabParam,
          value: currentTab.toString(),
        );
        return Uri.encodeFull(loc);
    }
  }
}
