import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferences.dart';
import '../utils/io.dart';

///Felhasználói beállításokat implementáló osztály. Specifikus interfészt
///biztosít a [SharedPreferences] lokális perzisztens adattárolóhoz.
class Settings extends ChangeNotifier {
  ///Adattár példány
  late SharedPreferences _preferences;

  ///Singleton osztálypéldány
  static final Settings _instance = Settings._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory Settings() => _instance;
  static Settings get instance => _instance;

  ///Rejtett konstruktor, ami inicializálja a [_preferences] adattár példányt.
  Settings._privateConstructor();

  ///Lekéri az első futtatást jelző flaget.
  bool get firstRun => _preferences.getBool('firstRun') ?? true;

  ///Lekéri a sötét mód beállítást.
  DarkMode get darkMode {
    var value = _preferences.getString('darkMode');
    return DarkMode.values
        .firstWhere((element) => element.toShortString() == value);
  }

  ///Lekéri a nyelvbeállításokat.
  Language get language {
    var value = _preferences.getString('language');
    return Language.values
        .firstWhere((element) => element.toShortString() == value);
  }

  ///Lekéri az alkalmazás színtémát.
  SzikAppTheme get theme {
    var value = _preferences.getString('theme');
    return SzikAppTheme.values
        .firstWhere((element) => element.toShortString() == value);
  }

  ///Lekéri az adattakarékos mód beállítását.
  bool get dataLite => _preferences.getBool('dataLite') ?? false;

  ///Lekéri a felhasználó értesítés beállításait.
  Map<String, bool>? get notificationSettings {
    var enabled = _preferences.getStringList('enabled') ?? [];
    var disabled = _preferences.getStringList('disabled') ?? [];
    var result = <String, bool>{};

    for (var element in enabled) {
      result.putIfAbsent(element, () => true);
    }
    for (var element in disabled) {
      result.putIfAbsent(element, () => false);
    }

    return result;
  }

  List<int>? get feedShortcuts {
    var shortcutsStrings = _preferences.getStringList('feedShortcuts') ?? [];
    var shortcuts = <int>[];
    for (var item in shortcutsStrings) {
      var parsedItem = int.tryParse(item);
      if (parsedItem != null) shortcuts.add(parsedItem);
    }
    return shortcuts;
  }

  ///Elmenti az első futtatást jelző flaget.
  set firstRun(bool isFirstRun) => _preferences.setBool('firstRun', false);

  ///Elmenti a sötét mód beállítást.
  set darkMode(DarkMode mode) {
    _preferences
        .setString('darkMode', mode.toShortString())
        .then((_) => notifyListeners());
  }

  ///Elmenti a nyelvbeállításokat.
  set language(Language language) {
    _preferences
        .setString('language', language.toShortString())
        .then((_) => notifyListeners());
  }

  ///Elmenti a témabeállításokat.
  set theme(SzikAppTheme theme) {
    _preferences
        .setString('theme', theme.toShortString())
        .then((_) => notifyListeners());
  }

  ///Elmenti az adattakarékos mód beállításait.
  set dataLite(bool enabled) {
    _preferences.setBool('dataLite', enabled).then((_) => notifyListeners());
  }

  ///Elmenti a felhasználó értesítés beállításait.
  set notificationSettings(Map<String, bool>? notifications) {
    var enabled = <String>[];
    var disabled = <String>[];

    for (var key in notifications!.keys) {
      notifications[key] == true ? enabled.add(key) : disabled.add(key);
    }

    Future.wait([
      _preferences.setStringList('disabled', disabled),
      _preferences.setStringList('enabled', enabled)
    ]).then((_) => notifyListeners());
  }

  set feedShortcuts(List<int>? shortcuts) {
    var shortcutsStrings = <String>[];
    for (var item in shortcuts ?? []) {
      shortcutsStrings.add('$item');
    }
    _preferences
        .setStringList('feedShortcuts', shortcutsStrings)
        .then((_) => notifyListeners());
  }

  ///Letölti és lokálisan tárolja a felhasználó szerveren elmentett
  ///preferenciáit. A fügvényt meghívva a lokális adatok felülíródnak.
  Future<bool> loadPreferences() async {
    var io = IO();
    var serverPreferences = await io.getUserPreferences();
    darkMode = serverPreferences.darkMode;
    theme = serverPreferences.theme;
    language = serverPreferences.language;
    dataLite = serverPreferences.dataLite;
    notificationSettings = serverPreferences.notifications;
    feedShortcuts = serverPreferences.feedShortcuts;
    return true;
  }

  ///Feltölti a felhasználó preferenciáit a szerverre.
  Future<bool> savePreferences() async {
    var prefs = Preferences(lastUpdate: DateTime.now())
      ..darkMode = darkMode
      ..language = language
      ..theme = theme
      ..dataLite = dataLite
      ..notifications = notificationSettings
      ..feedShortcuts = feedShortcuts;
    var io = IO();
    await io.putUserPreferences(prefs);
    return true;
  }

  ///Inicializálja a lokális adattárat menedzselő paramétert.
  ///Mivel disk olvasást tartalmaz nem szabad `await`tel hívni
  ///teljesítményérzékeny környezetben.
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }
}
