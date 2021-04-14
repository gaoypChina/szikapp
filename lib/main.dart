///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'pages/home_page.dart';
import 'pages/menu_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/signin_page.dart';
import 'utils/auth.dart';
import 'utils/user.dart';

void main() async {
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
  late Auth authManager;
  User? user;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_firebaseInitialized` state to true
      await Firebase.initializeApp();
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
    authManager = Auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SzikApp',
      initialRoute: HomePage.route,
      onGenerateRoute: _onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
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
