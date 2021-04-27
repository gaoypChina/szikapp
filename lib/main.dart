///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/menu_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/signin_page.dart';
import 'pages/submenu_page.dart';
import 'ui/screens/error_screen.dart';
import 'utils/auth.dart';
import 'utils/io.dart';
import 'utils/user.dart';

void main() async {
  HttpOverrides.global = IOHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
  bool _firebaseInitialized = false;
  bool _firebaseError = false;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static late Auth authManager;
  static User? user;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and
      // set `_firebaseInitialized` state to true
      await Firebase.initializeApp();
      authManager = Auth();
      setState(() {
        _firebaseInitialized = true;
      });
    } on Exception catch (e) {
      // Set `_firebaseError` state to true if Firebase initialization fails
      setState(() {
        _firebaseError = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SzikApp',
      initialRoute: HomePage.route,
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    late Widget page;
    if (settings.name == HomePage.route) {
      page = HomePage();
    } else if (settings.name == MenuPage.route) {
      page = MenuPage();
    } else if (settings.name == ProfilePage.route) {
      page = ProfilePage();
    } else if (settings.name == SettingsPage.route) {
      page = SettingsPage();
    } else if (settings.name == SignInPage.route) {
      page = SignInPage();
    } else if (settings.name == SubMenuPage.route) {
      final args = settings.arguments as SubMenuArguments;
      page = SubMenuPage(
        listItems: args.items,
        title: args.title,
      );
    } else if (settings.name == ErrorScreen.route) {
      final args = settings.arguments as ErrorScreenArguments;
      page = ErrorScreen(
        error: args.error,
      );
    } else {
      throw Exception(
          'NAVIGATOR_MESSAGE_ERROR'.tr(args: [settings.name ?? '']));
    }
    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}
