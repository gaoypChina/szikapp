import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferences.dart';
import 'io.dart';

class Settings {
  //Privát változók
  SharedPreferences? _ownSharedPreferences;

  //Konstruktor
  Settings() {
    _intialize();
  }

  //Getterek
  DarkMode get darkMode {
    var value = _ownSharedPreferences!.getString('darkMode');
    return DarkMode.values
        .firstWhere((element) => element.toString() == 'DarkMode.$value');
  }

  Language get language {
    var value = _ownSharedPreferences!.getString('language');
    return Language.values
        .firstWhere((element) => element.toString() == 'Language.$value');
  }

  Theme get theme {
    var value = _ownSharedPreferences!.getString('theme');
    return Theme.values
        .firstWhere((element) => element.toString() == 'Theme.$value');
  }

  bool get dataLite => _ownSharedPreferences!.getBool('dataLite') ?? false;

  Map<String, bool>? get notifications {
    var enabled = _ownSharedPreferences!.getStringList('enabled');
    var disabled = _ownSharedPreferences!.getStringList('disabled');
    var result = <String, bool>{};

    enabled!.forEach((element) {
      result.putIfAbsent(element, () => true);
    });
    disabled!.forEach((element) {
      result.putIfAbsent(element, () => false);
    });

    return result;
  }

  String? get leftMenuOption =>
      _ownSharedPreferences!.getString('leftMenuOption');

  String? get rightMenuOption =>
      _ownSharedPreferences!.getString('rightMenuOption');

  //Setterek
  set darkMode(DarkMode mode) {
    _ownSharedPreferences!.setString('darkMode', mode.toString());
  }

  set language(Language ownLanguage) {
    _ownSharedPreferences!.setString('language', ownLanguage.toString());
  }

  set theme(Theme ownTheme) {
    _ownSharedPreferences!.setString('theme', ownTheme.toString());
  }

  set dataLite(bool ownLite) {
    _ownSharedPreferences!.setBool('dataLite', ownLite);
  }

  set notifications(Map<String, bool>? notif) {
    var enabled = <String>[];
    var disabled = <String>[];

    for (var key in notif!.keys) {
      notif[key] == true ? enabled.add(key) : disabled.add(key);
    }

    _ownSharedPreferences!.setStringList('disabled', disabled);
    _ownSharedPreferences!.setStringList('enabled', enabled);
  }

  set leftMenuOption(String? option) {
    option ??= '';
    _ownSharedPreferences!.setString('leftMenuOption', option);
  }

  set rightMenuOption(String? option) {
    option ??= '';
    _ownSharedPreferences!.setString('rightMenuOption', option);
  }

  //Publikus függvények (Interface)
  Future<bool> loadPreferences() async {
    var io = IO();
    var serverPreferences = await io.getUserPreferences(null);
    darkMode = serverPreferences.darkMode;
    theme = serverPreferences.theme;
    language = serverPreferences.language;
    dataLite = serverPreferences.dataLite;
    notifications = serverPreferences.notifications;
    leftMenuOption = serverPreferences.leftMenuOption;
    rightMenuOption = serverPreferences.rightMenuOption;
    return true;
  }

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
    await io.putUserPreferences(null, prefs);
    return true;
  }

  //Privát függvények
  Future<void> _intialize() async {
    _ownSharedPreferences ??= await SharedPreferences.getInstance();
  }
}
