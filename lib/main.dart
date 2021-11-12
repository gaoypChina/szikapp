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
import 'package:provider/provider.dart';

import 'business/calendar_manager.dart';
import 'business/good_to_know_manager.dart';
import 'business/janitor_manager.dart';
import 'business/kitchen_cleaning_manager.dart';
import 'business/poll_manager.dart';
import 'business/reservation_manager.dart';
import 'navigation/app_route_parser.dart';
import 'navigation/app_router.dart';
import 'navigation/app_state_manager.dart';
import 'ui/themes.dart';
import 'utils/auth_manager.dart';
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
  final _appStateManager = SzikAppStateManager();
  final _authManager = AuthManager();
  final _calendarManager = CalendarManager();
  final _goodToKnowManager = GoodToKnowManager();
  final _janitorManager = JanitorManager();
  final _kitchenCleaningManager = KitchenCleaningManager();
  final _pollManager = PollManager();
  final _reservationManager = ReservationManager();

  late SzikAppRouter _appRouter;
  final appRouteParser = SzikAppRouteParser();

  static final analytics = FirebaseAnalytics();
  static final observer = FirebaseAnalyticsObserver(analytics: analytics);

  static ConnectivityResult connectionStatus = ConnectivityResult.none;
  final _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ///Kezdeti Firebase setup. Beállítja a [firebaseInitialized] és a [firebaseError]
  ///flageket, ha szükséges.
  Future<void> _initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and
      // set `firebaseInitialized` state to true
      await Firebase.initializeApp();
      Provider.of<SzikAppStateManager>(context, listen: false)
          .initializeFirebase();
    } on Exception catch (e) {
      // Set `firebaseError` state to true if Firebase initialization fails
      Provider.of<SzikAppStateManager>(context, listen: false).setError(e);
    }
  }

  ///Kezdeti internetkapcsolat-figyelő bővítmény setup.
  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      await SZIKAppState.analytics
          .logEvent(name: 'PACKAGE_ERROR', parameters: {'error': e.toString()});
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
    _initConnectivity();
    _initializeFlutterFire();

    ///Kapcsolati státusz figyelő feliratkozás. Amint a státusz megváltozik
    ///frissíti a [connectionStatus] paraméter értékét.
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _appRouter = SzikAppRouter(
        appStateManager: _appStateManager,
        authManager: _authManager,
        calendarManager: _calendarManager,
        goodToKnowManager: _goodToKnowManager,
        janitorManager: _janitorManager,
        kitchenCleaningManager: _kitchenCleaningManager,
        pollManager: _pollManager,
        reservationManager: _reservationManager);

    _appStateManager.loadEarlyData();

    super.initState();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _appStateManager),
        ChangeNotifierProvider(create: (context) => _authManager),
        ChangeNotifierProvider(create: (context) => _calendarManager),
        ChangeNotifierProvider(create: (context) => _goodToKnowManager),
        ChangeNotifierProvider(create: (context) => _janitorManager),
        ChangeNotifierProvider(create: (context) => _kitchenCleaningManager),
        ChangeNotifierProvider(create: (context) => _pollManager),
        ChangeNotifierProvider(create: (context) => _reservationManager),
      ],
      child: MaterialApp.router(
        title: 'APP_NAME'.tr(),
        routerDelegate: _appRouter,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: szikLightThemeData,
        darkTheme: szikDarkThemeData,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routeInformationParser: appRouteParser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
