// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) {
  return Preferences(
    darkMode: _$enumDecode(_$DarkModeEnumMap, json['darkMode']),
    language: _$enumDecode(_$LanguageEnumMap, json['language']),
    theme: _$enumDecode(_$ThemeEnumMap, json['theme']),
    notifications: (json['notifications'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as bool),
    ),
    dataLite: json['dataLite'] as bool,
    menuOptions: json['menuOptions'] as List<dynamic>?,
  );
}

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'darkMode': _$DarkModeEnumMap[instance.darkMode],
      'language': _$LanguageEnumMap[instance.language],
      'theme': _$ThemeEnumMap[instance.theme],
      'notifications': instance.notifications,
      'dataLite': instance.dataLite,
      'menuOptions': instance.menuOptions,
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
