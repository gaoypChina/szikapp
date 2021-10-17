///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

///Program belépési pont. Futtatja az applikációt a megfelelő kontextus,
///lokalizáció és kezdeti beállítások elvégzése után.
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
      supportedLocales: const [Locale('en'), Locale('hu')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      child: const SZIKApp(),
      useOnlyLangCode: true,
    ),
  );
}

///Az applikáció
class SZIKApp extends StatefulWidget {
  const SZIKApp({Key key = const Key('SzikApp')}) : super(key: key);

  @override
  SZIKAppState createState() => SZIKAppState();
}

///Az applikáció állapota. A [runApp] függvény meghívásakor jön létre és a
///program futása során megmarad. Így statikus változóként tartalmazza azokat
///az adatokat, amelyekre bármikor és funkciótól függetlenül szükség lehet
///a futás során.
class SZIKAppState extends State<SZIKApp> {
  static bool firebaseInitialized = false;
  static bool firebaseError = false;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ///[Auth] singleton, ami menedzseli a bejelentkezett felhasználót
  static late Auth authManager;

  ///A kollégiumban megtalálható helyek [Place] listája
  static late List<Place> places;

  ///A felhasználói csoportok [Group] listája, melyek meghatározzák a tagjaik
  ///jogosultságait.
  static late List<Group> groups;

  ///Kezdeti Firebase setup és a felhasználó csendes bejelentkeztetésének
  ///megkísérlése. Beállítja a [firebaseInitialized] és a [firebaseError]
  ///flageket, ha szükséges. Sikeres csendes bejelenkeztetés esetén Igaz,
  ///sikertelen bejelentkeztetés vagy egyéb hiba esetén Hamis értékkel tér
  ///vissza.
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

  ///A háttérben letölti azokat az adatokat, melyekre bármelyik funkciónak
  ///szüksége lehet.
  static void loadEarlyData() async {
    try {
      var io = IO();
      places = await io.getPlace();
      groups = await io.getGroup();
    } on Exception {
      places = <Place>[];
      groups = <Group>[];
      //print('Error loading early data');
    }
  }

  ///Kezdeti internetkapcsolat-figyelő bővítmény setup.
  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      SZIKAppState.analytics.logEvent(name: 'PACKAGE_ERROR');
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

  ///Segédfüggvény, ami beállítja a tárolt adatkapcsolati státuszt.
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();

    ///Kapcsolati státusz figyelő feliratkozás. Amint a státusz megváltozik
    ///frissíti a [connectionStatus] paraméter értékét.
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
    //Teljes képernyős mód bekapcsolása
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
    return MaterialApp(
      title: 'APP_NAME'.tr(),
      initialRoute: HomePage.route,
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorObservers: <NavigatorObserver>[observer],
      theme: szikLightThemeData,
      darkTheme: szikDarkThemeData,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }

  ///Segédfüggvény. A megadott [RouteSettings] paraméter alapján létrehozza
  ///azt az oldalt, ahová az útvonal mutat. Kezeli a célpont megnyitásához
  ///szükséges paramétereket is.
  static Widget getDestination(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.route:
        return const HomePage();
      case MenuPage.route:
        return const MenuPage();
      case FeedPage.route:
        return const FeedPage();
      case SubMenuPage.route:
        final args = settings.arguments as SubMenuArguments;
        return SubMenuPage(
          listItems: args.items,
          title: args.title,
        );
      case CalendarPage.route:
        return const CalendarPage();
      case ContactsPage.route:
        return const ContactsPage();
      case JanitorPage.route:
        return const JanitorPage();
      case ProfilePage.route:
        return const ProfilePage();
      case ReservationPage.route:
        return const ReservationPage();
      case SettingsPage.route:
        return const SettingsPage();
      case SignInPage.route:
        return const SignInPage();
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
        final args = settings.arguments as ReservationNewEditArguments;
        return ReservationNewEditScreen(
          task: args.task,
          isEdit: args.isEdit,
          placeID: args.placeID,
        );
      case ReservationPlacesMapScreen.route:
        return const ReservationPlacesMapScreen();
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
        ErrorScreenArguments args;
        if (settings.arguments == null) {
          args = ErrorScreenArguments(error: 'ERROR_NOT_IMPLEMENTED'.tr());
        } else {
          args = settings.arguments as ErrorScreenArguments;
        }
        return ErrorScreen(
          error: args.error,
        );
      default:
        throw Exception(
            'ERROR_NAVIGATOR_MESSAGE'.tr(args: [settings.name ?? '']));
    }
  }

  ///Navigációs függvény, ami a megadott [RouteSettings] adatok alapján
  ///konstruál egy végrehajtandó navigációs lépést, utat.
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
