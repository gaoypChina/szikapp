// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      darkMode: $enumDecodeNullable(_$DarkModeEnumMap, json['dark_mode']) ??
          DarkMode.system,
      language: $enumDecodeNullable(_$LanguageEnumMap, json['language']) ??
          Language.hu,
      theme: $enumDecodeNullable(_$SzikAppThemeEnumMap, json['theme']) ??
          SzikAppTheme.defaultTheme,
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$NotificationTopicEnumMap, e))
              .toList() ??
          const [],
      feedShortcuts: (json['feed_shortcuts'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [0, 1, 2],
      dataLite: json['data_lite'] as bool? ?? false,
      leftMenuOption: json['left_menu_option'] as String?,
      rightMenuOption: json['right_menu_option'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'dark_mode': _$DarkModeEnumMap[instance.darkMode]!,
      'language': _$LanguageEnumMap[instance.language]!,
      'theme': _$SzikAppThemeEnumMap[instance.theme]!,
      'notifications': instance.notifications
          .map((e) => _$NotificationTopicEnumMap[e]!)
          .toList(),
      'feed_shortcuts': instance.feedShortcuts,
      'left_menu_option': instance.leftMenuOption,
      'right_menu_option': instance.rightMenuOption,
      'data_lite': instance.dataLite,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

const _$DarkModeEnumMap = {
  DarkMode.system: 'system',
  DarkMode.dark: 'dark',
  DarkMode.light: 'light',
};

const _$LanguageEnumMap = {
  Language.hu: 'hu',
  Language.en: 'en',
};

const _$SzikAppThemeEnumMap = {
  SzikAppTheme.defaultTheme: 'default',
};

const _$NotificationTopicEnumMap = {
  NotificationTopic.birthdays: 'birthdays',
  NotificationTopic.advertisements: 'advertisements',
  NotificationTopic.reservationStart: 'reservationStart',
  NotificationTopic.reservationEnd: 'reservationEnd',
  NotificationTopic.janitorStatusUpdate: 'janitorStatusUpdate',
  NotificationTopic.pollAvailable: 'pollAvailable',
  NotificationTopic.pollVotingReminder: 'pollVotingReminder',
  NotificationTopic.pollVotingEnded: 'pollVotingEnded',
  NotificationTopic.cleaningTaskDueDate: 'cleaningTaskDueDate',
  NotificationTopic.cleaningTasksAvailable: 'cleaningTasksAvailable',
  NotificationTopic.cleaningTaskAssigned: 'cleaningTaskAssigned',
  NotificationTopic.cleaningExchangeAvailable: 'cleaningExchangeAvailable',
  NotificationTopic.cleaningExchangeUpdate: 'cleaningExchangeUpdate',
};
