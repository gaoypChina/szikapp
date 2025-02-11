import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'business/business.dart';
import 'firebase_options.dart';
import 'models/models.dart';
import 'navigation/navigation.dart';
import 'ui/themes.dart';
import 'utils/utils.dart';

///Program belépési pont. Futtatja az applikációt a megfelelő kontextus,
///lokalizáció és kezdeti beállítások elvégzése után.
void main() async {
  HttpOverrides.global = IOHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Settings.instance.initialize();
  await NotificationManager.instance.initialize();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/Nunito/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('hu'), Locale('en')],
      useFallbackTranslations: true,
      fallbackLocale: const Locale('en'),
      saveLocale: false,
      useOnlyLangCode: true,
      child: const SzikApp(),
    ),
  );
}

///Az applikáció
class SzikApp extends StatefulWidget {
  const SzikApp({super.key = const Key('SzikApp')});

  @override
  SzikAppState createState() => SzikAppState();
}

///Az applikáció állapota. A [runApp] függvény meghívásakor jön létre és a
///program futása során megmarad. Így statikus változóként tartalmazza azokat
///az adatokat, amelyekre bármikor és funkciótól függetlenül szükség lehet
///a futás során.
class SzikAppState extends State<SzikApp> {
  final _appStateManager = SzikAppStateManager();
  final _authManager = AuthManager();
  final _goodToKnowManager = GoodToKnowManager();
  final _janitorManager = JanitorManager();
  final _kitchenCleaningManager = KitchenCleaningManager();
  final _pollManager = PollManager();
  final _reservationManager = ReservationManager();
  final _notificationManager = NotificationManager();
  final _settings = Settings();

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  late SzikAppRouter _appRouter;
  final appRouteParser = SzikAppRouteParser();

  static ConnectivityResult connectionStatus = ConnectivityResult.none;
  final _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ///Kezdeti internetkapcsolat-figyelő bővítmény setup.
  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      await SzikAppState.analytics.logEvent(name: 'error_connectivity_package');
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
    IO(manager: _authManager);

    ///Kapcsolati státusz figyelő feliratkozás. Amint a státusz megváltozik
    ///frissíti a [connectionStatus] paraméter értékét.
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _appRouter = SzikAppRouter(
      appStateManager: _appStateManager,
      authManager: _authManager,
      goodToKnowManager: _goodToKnowManager,
      janitorManager: _janitorManager,
      kitchenCleaningManager: _kitchenCleaningManager,
      pollManager: _pollManager,
      reservationManager: _reservationManager,
    );

    _notificationManager.setupInteractedMessage();

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
        ChangeNotifierProvider(create: (context) => _goodToKnowManager),
        ChangeNotifierProvider(create: (context) => _janitorManager),
        ChangeNotifierProvider(create: (context) => _kitchenCleaningManager),
        ChangeNotifierProvider(create: (context) => _pollManager),
        ChangeNotifierProvider(create: (context) => _reservationManager),
        ChangeNotifierProvider(create: (context) => _settings),
        ChangeNotifierProvider(create: (context) => _notificationManager),
      ],
      child: Consumer<Settings>(
        builder: (context, settings, child) {
          ThemeMode themeMode;
          if (settings.darkMode == DarkMode.dark) {
            themeMode = ThemeMode.dark;
          } else if (settings.darkMode == DarkMode.light) {
            themeMode = ThemeMode.light;
          } else {
            themeMode = ThemeMode.system;
          }
          if (settings.language == Language.hu) {
            context.setLocale(const Locale('hu'));
          } else {
            context.setLocale(const Locale('en'));
          }
          return MaterialApp.router(
            title: 'SzikApp',
            routerDelegate: _appRouter,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: szikLightThemeData,
            darkTheme: szikDarkThemeData,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            routeInformationParser: appRouteParser,
            backButtonDispatcher: RootBackButtonDispatcher(),
          );
        },
      ),
    );
  }
}
