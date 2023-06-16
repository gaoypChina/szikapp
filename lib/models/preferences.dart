import 'package:json_annotation/json_annotation.dart';
import '../utils/utils.dart';
import 'models.dart';

part 'preferences.g.dart';

///Sötét mód beállításokat tartalmazó típus.
enum DarkMode {
  system,
  dark,
  light;

  @override
  String toString() => name;

  bool isEqual(DarkMode? other) {
    if (other == null) return false;
    return index == other.index;
  }
}

///Nyelvi beállításokat tartalmazó típus.
enum Language {
  hu,
  en;

  @override
  String toString() => name;

  String toCapitalizedString() => name.toUpperCase();

  bool isEqual(Language? other) {
    if (other == null) return false;
    return index == other.index;
  }

  static Language languageFromJson(dynamic rawLanguage) {
    for (var language in Language.values) {
      if (language.toString() == rawLanguage.toString()) {
        return language;
      }
    }
    return Language.hu;
  }
}

///Témabeállításokat tartalmazó típus.
enum SzikAppTheme {
  @JsonValue('default')
  defaultTheme;

  @override
  String toString() => name;

  bool isEqual(SzikAppTheme? other) {
    if (other == null) return false;
    return index == other.index;
  }
}

///A felhasználó beállításait tároló adatmodell osztály.
///Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable()
class Preferences implements Cachable {
  @JsonKey(name: 'dark_mode')
  DarkMode darkMode;
  @JsonKey(fromJson: Language.languageFromJson)
  Language language;
  SzikAppTheme theme;
  @JsonKey(fromJson: NotificationTopic.topicsFromJson)
  List<NotificationTopic> notifications;
  @JsonKey(name: 'feed_shortcuts')
  List<int> feedShortcuts;
  @JsonKey(name: 'left_menu_option')
  String leftMenuOption;
  @JsonKey(name: 'right_menu_option')
  String rightMenuOption;
  @JsonKey(name: 'data_lite')
  bool dataLite;
  @override
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Preferences({
    this.darkMode = DarkMode.system,
    this.language = Language.hu,
    this.theme = SzikAppTheme.defaultTheme,
    this.notifications = const [],
    this.feedShortcuts = const [0, 1, 2],
    this.dataLite = false,
    this.leftMenuOption = 'feed',
    this.rightMenuOption = 'settings',
    required this.lastUpdate,
  });

  Json toJson() => _$PreferencesToJson(this);

  factory Preferences.fromJson(Json json) => _$PreferencesFromJson(json);
}
