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

  bool? get dataLite => _ownSharedPreferences!.getBool('dataLite');

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

  set dataLite(bool? ownLite) {
    ownLite ??= false;
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

  //Publikus függvények (Interface)
  bool loadPreferences() {
    var io = IO();
    var serverPreferences = io.getUserPreferences();
    darkMode = serverPreferences.darkMode;
    theme = serverPreferences.theme;
    language = serverPreferences.language;
    dataLite = serverPreferences.dataLite;
    notifications = serverPreferences.notifications;
    return true;
  }

  bool savePreferences() {
    var prefs = Preferences()
      ..darkMode = darkMode
      ..language = language
      ..theme = theme;

    var io = IO();
    io.putUserPreferences(data: prefs);
    return true;
  }

  //Privát függvények
  void _intialize() async {
    _ownSharedPreferences ??= await SharedPreferences.getInstance();
  }
}
