import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../utils/utils.dart';

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
  bool get gdprAccepted => _preferences.getBool('gdprAccepted') ?? false;
  DateTime? get gdprAcceptanceDate =>
      _preferences.getString('gdprAcceptanceDate') != null
          ? DateTime.parse(_preferences.getString('gdprAcceptanceDate')!)
          : null;

  ///Lekéri a sötét mód beállítást.
  DarkMode get darkMode {
    var value =
        _preferences.getString('darkMode') ?? DarkMode.system.toString();
    return DarkMode.values
        .firstWhere((enumValue) => enumValue.toString() == value);
  }

  ///Lekéri a nyelvbeállításokat.
  Language get language {
    var value = _preferences.getString('language') ?? Language.hu.toString();
    return Language.values
        .firstWhere((enumValue) => enumValue.toString() == value);
  }

  ///Lekéri az alkalmazás színtémát.
  SzikAppTheme get theme {
    var value =
        _preferences.getString('theme') ?? SzikAppTheme.defaultTheme.toString();
    return SzikAppTheme.values
        .firstWhere((enumValue) => enumValue.toString() == value);
  }

  ///Lekéri az adattakarékos mód beállítását.
  bool get dataLite => _preferences.getBool('dataLite') ?? false;

  ///Lekéri a felhasználó értesítés beállításait.
  List<NotificationTopic> get notificationSettings {
    var enabled = _preferences.getStringList('notificationsEnabled') ?? [];
    var result = <NotificationTopic>[];
    for (var item in enabled) {
      result.add(NotificationTopic.values
          .firstWhere((enumValue) => enumValue.toString() == item));
    }
    return result;
  }

  List<int> get feedShortcuts {
    var shortcutsStrings =
        _preferences.getStringList('feedShortcuts') ?? ['0', '1', '2'];
    var shortcuts = <int>[];
    for (var item in shortcutsStrings) {
      var parsedItem = int.tryParse(item);
      if (parsedItem != null) shortcuts.add(parsedItem);
    }
    return shortcuts;
  }

  ///Elmenti az első futtatást jelző flaget.
  set gdprAccepted(bool gdprAccepted) =>
      _preferences.setBool('gdprAccepted', false);

  set gdprAcceptanceDate(DateTime? gdprAcceptanceDate) {
    if (gdprAcceptanceDate != null) {
      _preferences.setString(
          'gdprAcceptanceDate', gdprAcceptanceDate.toIso8601String());
    }
  }

  ///Elmenti a sötét mód beállítást.
  set darkMode(DarkMode mode) {
    _preferences
        .setString('darkMode', mode.toString())
        .then((_) => notifyListeners());
  }

  ///Elmenti a nyelvbeállításokat.
  set language(Language language) {
    _preferences
        .setString('language', language.toString())
        .then((_) => notifyListeners());
  }

  ///Elmenti a témabeállításokat.
  set theme(SzikAppTheme theme) {
    _preferences
        .setString('theme', theme.toString())
        .then((_) => notifyListeners());
  }

  ///Elmenti az adattakarékos mód beállításait.
  set dataLite(bool enabled) {
    _preferences.setBool('dataLite', enabled).then((_) => notifyListeners());
  }

  ///Elmenti a felhasználó értesítés beállításait.
  set notificationSettings(List<NotificationTopic> notifications) {
    var enabled = <String>[];

    for (var item in notifications) {
      enabled.add(item.toString());
    }

    _preferences
        .setStringList('notificationsEnabled', enabled)
        .then((_) => notifyListeners());
  }

  set feedShortcuts(List<int> shortcuts) {
    var shortcutsStrings = <String>[];
    for (var item in shortcuts) {
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
    gdprAccepted = serverPreferences.gdprAccepted;
    gdprAcceptanceDate = serverPreferences.gdprAcceptanceDate;
    return true;
  }

  ///Feltölti a felhasználó preferenciáit a szerverre.
  Future<bool> savePreferences() async {
    var preferences = Preferences(lastUpdate: DateTime.now())
      ..darkMode = darkMode
      ..language = language
      ..theme = theme
      ..dataLite = dataLite
      ..notifications = notificationSettings
      ..feedShortcuts = feedShortcuts
      ..gdprAccepted = gdprAccepted
      ..gdprAcceptanceDate = gdprAcceptanceDate;
    var io = IO();
    await io.postUserPreferences(data: preferences);
    return true;
  }

  ///Inicializálja a lokális adattárat menedzselő paramétert.
  ///Mivel disk olvasást tartalmaz nem szabad `await`tel hívni
  ///teljesítményérzékeny környezetben.
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }
}
