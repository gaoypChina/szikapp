import 'package:json_annotation/json_annotation.dart';
import '../utils/types.dart';

part 'preferences.g.dart';

///Sötét mód beállításokat tartalmazó típus.
enum DarkMode {
  @JsonValue('system')
  system,
  @JsonValue('dark')
  dark,
  @JsonValue('light')
  light,
}

extension DarkModeExtensions on DarkMode {
  String toShortString() {
    return toString().split('.').last;
  }

  bool isEqual(DarkMode? other) {
    if (other == null) return false;
    return index == other.index;
  }
}

///Nyelvi beállításokat tartalmazó típus.
enum Language {
  @JsonValue('hu')
  hu,
  @JsonValue('en')
  en,
}

extension LanguageExtensions on Language {
  String toShortString() {
    return toString().split('.').last;
  }

  bool isEqual(Language? other) {
    if (other == null) return false;
    return index == other.index;
  }
}

///Témabeállításokat tartalmazó típus.
enum SzikAppTheme {
  @JsonValue('default')
  defaultTheme,
}

extension ThemeExtensions on SzikAppTheme {
  String toShortString() {
    return toString().split('.').last;
  }

  bool isEqual(SzikAppTheme? other) {
    if (other == null) return false;
    return index == other.index;
  }
}

///A felhasználó beállításait tároló adatmodell osztály.
///Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable()
class Preferences {
  @JsonKey(name: 'dark_mode')
  DarkMode darkMode;
  Language language;
  SzikAppTheme theme;
  Map<String, bool>? notifications;
  @JsonKey(name: 'left_menu_option')
  String? leftMenuOption;
  @JsonKey(name: 'right_menu_option')
  String? rightMenuOption;
  @JsonKey(name: 'data_lite')
  bool dataLite;
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Preferences(
      {this.darkMode = DarkMode.system,
      this.language = Language.hu,
      this.theme = SzikAppTheme.defaultTheme,
      this.notifications,
      this.dataLite = false,
      this.leftMenuOption,
      this.rightMenuOption,
      required this.lastUpdate}) {
    notifications ??= <String, bool>{};
  }

  Json toJson() => _$PreferencesToJson(this);

  factory Preferences.fromJson(Json json) => _$PreferencesFromJson(json);
}
