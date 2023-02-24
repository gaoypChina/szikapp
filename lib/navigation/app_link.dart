class SzikAppLink {
  static const String kArticlePath = '/article';
  static const String kBookRentalPath = '/bookrental';
  static const String kCalendarPath = '/calendar';
  static const String kContactsPath = '/contacts';
  static const String kDocumentsPath = '/documents';
  static const String kErrorPath = '/error';
  static const String kFeedPath = '/feed';
  static const String kHomePath = '/';
  static const String kJanitorPath = '/janitor';
  static const String kKitchenCleaningPath = '/cleaning';
  static const String kKitchenCleaningAdminPath = '/cleaning/admin';
  static const String kInvitationPath = '/invitation';
  static const String kMenuPath = '/menu';
  static const String kPasswordsPath = '/passwords';
  static const String kPollPath = '/poll';
  static const String kPollCreateEditPath = '/poll/createedit';
  static const String kProfilePath = '/me';
  static const String kReservationDetailsPath = '/reservation/details';
  static const String kReservationPlacesMapPath = '/reservation/places';
  static const String kReservationAccountsListPath = '/reservation/accounts';
  static const String kReservationGamesListPath = '/reservation/games';
  static const String kReservationCreateEditPath = '/reservation/createedit';
  static const String kReservationPath = '/reservation';
  static const String kSettingsPath = '/settings';
  static const String kStartPath = '/start';
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
    var locationUri = Uri.decodeFull(location ?? '');

    final uri = Uri.parse(locationUri);
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
      case kArticlePath:
        var loc = '$kArticlePath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kBookRentalPath:
        var loc = '$kBookRentalPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kCalendarPath:
        var loc = '$kCalendarPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kContactsPath:
        var loc = '$kContactsPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kDocumentsPath:
        var loc = '$kDocumentsPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kKitchenCleaningPath:
        var loc = '$kKitchenCleaningPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kKitchenCleaningAdminPath:
        var loc = '$kKitchenCleaningAdminPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kPollPath:
        var loc = '$kPollPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kPollCreateEditPath:
        var loc = '$kPollCreateEditPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      case kErrorPath:
        var loc = '$kErrorPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kFeedPath:
        var loc = '$kFeedPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kJanitorPath:
        var loc = '$kJanitorPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kInvitationPath:
        var loc = '$kInvitationPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kMenuPath:
        return kMenuPath;
      case kPasswordsPath:
        return kPasswordsPath;
      case kProfilePath:
        var loc = '$kProfilePath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kReservationDetailsPath:
        var loc = '$kReservationDetailsPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      case kReservationGamesListPath:
        return kReservationGamesListPath;
      case kReservationAccountsListPath:
        return kReservationAccountsListPath;
      case kReservationCreateEditPath:
        var loc = '$kReservationCreateEditPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      case kReservationPath:
        var loc = '$kReservationPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kSettingsPath:
        var loc = '$kSettingsPath?';
        loc += addKeyValPair(
          key: kFeatureParam,
          value: currentFeature.toString(),
        );
        return loc;
      case kStartPath:
        return kStartPath;
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
