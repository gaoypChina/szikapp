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
  @JsonValue('left_menu_option')
  String? leftMenuOption;
  @JsonValue('right_menu_option')
  String? rightMenuOption;
  @JsonValue('data_lite')
  bool dataLite;
  @JsonValue('last_update')
  DateTime lastUpdate;

  Preferences(
      {this.darkMode = DarkMode.system,
      this.language = Language.hu,
      this.theme = Theme.defaultTheme,
      this.notifications,
      this.dataLite = false,
      this.leftMenuOption,
      this.rightMenuOption,
      required this.lastUpdate}) {
    notifications ??= <String, bool>{};
  }

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
}
