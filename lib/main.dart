///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'models/group.dart';
import 'models/resource.dart';
import 'pages/calendar_page.dart';
import 'pages/contacts_page.dart';
import 'pages/feed_page.dart';
import 'pages/home_page.dart';
import 'pages/janitor_page.dart';
import 'pages/menu_page.dart';
import 'pages/profile_page.dart';
import 'pages/reservation_page.dart';
import 'pages/settings_page.dart';
import 'pages/signin_page.dart';
import 'pages/submenu_page.dart';
import 'ui/screens/error_screen.dart';
import 'ui/screens/janitor_edit_admin.dart';
import 'ui/screens/janitor_new_edit.dart';
import 'ui/screens/reservation_details.dart';
import 'ui/screens/reservation_games.dart';
import 'ui/screens/reservation_new_edit.dart';
import 'ui/screens/reservation_places_map.dart';
import 'ui/themes.dart';
import 'utils/auth.dart';
import 'utils/io.dart';

void main() async {
  HttpOverrides.global = IOHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/Nunito/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('hu')],
      path: 'assets/translations',
      fallbackLocale: Locale('hu'),
      child: SZIKApp(),
      useOnlyLangCode: true,
    ),
  );
}

class SZIKApp extends StatefulWidget {
  SZIKApp({Key key = const Key('SzikApp')}) : super(key: key);

  @override
  SZIKAppState createState() => SZIKAppState();
}

class SZIKAppState extends State<SZIKApp> {
  static bool firebaseInitialized = false;
  static bool firebaseError = false;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static late Auth authManager;
  static late List<Place> places;
  static late List<Group> groups;

  static Future<bool> initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and
      // set `firebaseInitialized` state to true
      await Firebase.initializeApp();
      authManager = Auth();
      firebaseInitialized = true;
      var result = await SZIKAppState.authManager.signInSilently();
      return result;
    } on Exception {
      // Set `firebaseError` state to true if Firebase initialization fails
      firebaseError = true;
      return false;
    }
  }

  static void loadEarlyData() async {
    try {
      var io = IO();
      places = await io.getPlace();
      groups = await io.getGroup();
    } on Exception {
      places = <Place>[];
      groups = <Group>[];
      print('Error loading early data');
    }
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'SzikApp',
      initialRoute: HomePage.route,
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ourThemeData,
    );
  }

  static Widget getDestination(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.route:
        return HomePage();
      case MenuPage.route:
        return MenuPage();
      case FeedPage.route:
        return FeedPage();
      case SubMenuPage.route:
        final args = settings.arguments as SubMenuArguments;
        return SubMenuPage(
          listItems: args.items,
          title: args.title,
        );
      case CalendarPage.route:
        return CalendarPage();
      case ContactsPage.route:
        return ContactsPage();
      case JanitorPage.route:
        return JanitorPage();
      case ProfilePage.route:
        return ProfilePage();
      case ReservationPage.route:
        return ReservationPage();
      case SettingsPage.route:
        return SettingsPage();
      case SignInPage.route:
        return SignInPage();
      case ReservationDetailsScreen.route:
        final args = settings.arguments as ReservationDetailsArguments;
        return ReservationDetailsScreen(
          title: args.title,
        );
      case ReservationGamesListScreen.route:
        final args = settings.arguments as ReservationGamesListArguments;
        return ReservationGamesListScreen(
          title: args.title,
        );
      case ReservationNewEditScreen.route:
        return ReservationNewEditScreen();
      case ReservationPlacesMapScreen.route:
        return ReservationPlacesMapScreen();
      case JanitorNewEditScreen.route:
        final args = settings.arguments as JanitorNewEditArguments;
        return JanitorNewEditScreen(
          isEdit: args.isEdit,
          isFeedback: args.isFeedback,
          task: args.task,
        );
      case JanitorEditAdminScreen.route:
        final args = settings.arguments as JanitorEditAdminArguments;
        return JanitorEditAdminScreen(task: args.task);
      case ErrorScreen.route:
        var args;
        if (settings.arguments == null)
          args = ErrorScreenArguments(error: 'ERROR_NOT_IMPLEMENTED'.tr());
        else
          args = settings.arguments as ErrorScreenArguments;
        return ErrorScreen(
          error: args.error,
        );
      default:
        throw Exception(
            'ERROR_NAVIGATOR_MESSAGE'.tr(args: [settings.name ?? '']));
    }
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    late Widget page;

    page = getDestination(settings);

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}
