import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

enum DarkMode {
  @JsonValue('system')
  system,
  @JsonValue('dark')
  dark,
  @JsonValue('light')
  light,
}

enum Language {
  @JsonValue('hu')
  hu,
  @JsonValue('en')
  en,
}

enum Theme {
  @JsonValue('default')
  defaultTheme,
}

@JsonSerializable()
class Preferences {
  @JsonValue('dark_mode')
  DarkMode darkMode;
  Language language;
  Theme theme;
  Map<String, bool>? notifications;
  @JsonValue('data_lite')
  bool dataLite;
  @JsonValue('menu_options')
  List? menuOptions;
  @JsonValue('last_update')
  DateTime lastUpdate;

  Preferences(
      {this.darkMode = DarkMode.system,
      this.language = Language.hu,
      this.theme = Theme.defaultTheme,
      this.notifications,
      this.dataLite = false,
      this.menuOptions,
      required this.lastUpdate}) {
    notifications ??= <String, bool>{};
    menuOptions ??= [];
  }

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
}
