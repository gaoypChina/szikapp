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
  DarkMode darkMode;
  Language language;
  Theme theme;
  Map<String, bool> notifications;
  bool dataLite;
  List menuOptions;

  Preferences(
      {this.darkMode,
      this.language,
      this.theme,
      this.notifications,
      this.dataLite,
      this.menuOptions}) {
    notifications ??= <String, bool>{};
    menuOptions ??= [];
  }

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
}
