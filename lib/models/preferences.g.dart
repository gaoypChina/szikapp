// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) {
  return Preferences(
    darkMode: _$enumDecode(_$DarkModeEnumMap, json['dark_mode']),
    language: _$enumDecode(_$LanguageEnumMap, json['language']),
    theme: _$enumDecode(_$ThemeEnumMap, json['theme']),
    notifications: (json['notifications'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as bool),
    ),
    dataLite: json['data_lite'] as bool,
    leftMenuOption: json['left_menu_option'] as String?,
    rightMenuOption: json['right_menu_option'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
  );
}

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'dark_mode': _$DarkModeEnumMap[instance.darkMode],
      'language': _$LanguageEnumMap[instance.language],
      'theme': _$ThemeEnumMap[instance.theme],
      'notifications': instance.notifications,
      'left_menu_option': instance.leftMenuOption,
      'right_menu_option': instance.rightMenuOption,
      'data_lite': instance.dataLite,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$DarkModeEnumMap = {
  DarkMode.system: 'system',
  DarkMode.dark: 'dark',
  DarkMode.light: 'light',
};

const _$LanguageEnumMap = {
  Language.hu: 'hu',
  Language.en: 'en',
};

const _$ThemeEnumMap = {
  Theme.defaultTheme: 'default',
};
