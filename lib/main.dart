import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/menu_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/signin_page.dart';
import 'utils/auth.dart';
import 'utils/io.dart';
import 'utils/user.dart';

const routeHome = '/';
const routeSettings = '/settings';
const routeProfile = '/profile';
const routeMenu = '/menu';
const routeSignIn = '/signin';

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
  static late Auth authManager;
  static User? user;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_firebaseInitialized` state to true
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
    //TODO: Auth() meghívása később
    //authManager = Auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SzikApp',
      initialRoute: routeSignIn,
      onGenerateRoute: _onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    if (settings.name == routeHome) {
      page = HomePage();
    } else if (settings.name == routeMenu) {
      page = MenuPage();
    } else if (settings.name == routeProfile) {
      page = ProfilePage();
    } else if (settings.name == routeSettings) {
      page = SettingsPage();
    } else if (settings.name == routeSignIn) {
      page = SignInPage();
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
