///[SZIKApp] is an awesome application made in Flutter for the lovely people
///in da SZIK.
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'pages/home_page.dart';
import 'pages/menu_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/signin_page.dart';

const routeHome = '/';
const routeSettings = '/settings';
const routeProfile = '/profile';
const routeMenu = '/menu';
const routeSignIn = '/signin';

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
  _SZIKAppState createState() => _SZIKAppState();
}

class _SZIKAppState extends State<SZIKApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SzikApp',
      initialRoute: routeHome,
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
