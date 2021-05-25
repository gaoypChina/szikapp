import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferences.dart';
import 'io.dart';

///Felhasználói beállításokat implementáló osztály. Specifikus interfészt
///biztosít a [SharedPreferences] lokális perzisztens adattárolóhoz.
class Settings {
  ///Adattár példány
  late SharedPreferences _preferences;

  ///Singleton osztálypéldány
  static final Settings _instance = Settings._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory Settings() => _instance;

  ///Rejtett konstruktor, ami inicializálja a [_preferences] adattár példányt.
  Settings._privateConstructor() {
    _initialize();
  }

  ///Lekéri az első futtatást jelző flaget.
  bool get firstRun => _preferences.getBool('firstRun') ?? true;

  ///Lekéri a sötét mód beállítást.
  DarkMode get darkMode {
    var value = _preferences.getString('darkMode');
    return DarkMode.values
        .firstWhere((element) => element.toString() == 'DarkMode.$value');
  }

  ///Lekéri a nyelvbeállításokat.
  Language get language {
    var value = _preferences.getString('language');
    return Language.values
        .firstWhere((element) => element.toString() == 'Language.$value');
  }

  ///Lekéri az alkalmazás színtémát.
  Theme get theme {
    var value = _preferences.getString('theme');
    return Theme.values
        .firstWhere((element) => element.toString() == 'Theme.$value');
  }

  ///Lekéri az adattakarékos mód beállítását.
  bool get dataLite => _preferences.getBool('dataLite') ?? false;

  ///Lekéri a felhasználó értesítés beállításait.
  Map<String, bool>? get notifications {
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

  ///Lekéri a bal oldali navigációs gomb beállítását.
  String? get leftMenuOption => _preferences.getString('leftMenuOption');

  ///Lekéri a jobb oldali navigációs gomb beállítását.
  String? get rightMenuOption => _preferences.getString('rightMenuOption');

  ///Elmenti az első futtatást jelző flaget.
  set firstRun(bool isFirstRun) => _preferences.setBool('firstRun', false);

  ///Elmenti a sötét mód beállítást.
  set darkMode(DarkMode mode) {
    _preferences.setString('darkMode', mode.toString());
  }

  ///Elmenti a nyelvbeállításokat.
  set language(Language language) {
    _preferences.setString('language', language.toString());
  }

  ///Elmenti a témabeállításokat.
  set theme(Theme theme) {
    _preferences.setString('theme', theme.toString());
  }

  ///Elmenti az adattakarékos mód beállításait.
  set dataLite(bool enabled) {
    _preferences.setBool('dataLite', enabled);
  }

  ///Elmenti a felhasználó értesítés beállításait.
  set notifications(Map<String, bool>? notifications) {
    var enabled = <String>[];
    var disabled = <String>[];

    for (var key in notifications!.keys) {
      notifications[key] == true ? enabled.add(key) : disabled.add(key);
    }

    _preferences.setStringList('disabled', disabled);
    _preferences.setStringList('enabled', enabled);
  }

  ///Elmenti a bal oldali navigációs gomb beállításait.
  set leftMenuOption(String? option) {
    option ??= '';
    _preferences.setString('leftMenuOption', option);
  }

  ///Elmenti a bal oldali navigációs gomb beállításait.
  set rightMenuOption(String? option) {
    option ??= '';
    _preferences.setString('rightMenuOption', option);
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
    notifications = serverPreferences.notifications;
    leftMenuOption = serverPreferences.leftMenuOption;
    rightMenuOption = serverPreferences.rightMenuOption;
    return true;
  }

  ///Feltölti a felhasználó preferenciáit a szerverre.
  Future<bool> savePreferences() async {
    var prefs = Preferences(lastUpdate: DateTime.now())
      ..darkMode = darkMode
      ..language = language
      ..theme = theme
      ..dataLite = dataLite
      ..notifications = notifications
      ..leftMenuOption = leftMenuOption
      ..rightMenuOption = rightMenuOption;

    var io = IO();
    await io.putUserPreferences(prefs);
    return true;
  }

  ///Inicializálja a lokális adattárat menedzselő paramétert.
  Future<void> _initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }
}
