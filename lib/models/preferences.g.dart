// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      darkMode: $enumDecodeNullable(_$DarkModeEnumMap, json['dark_mode']) ??
          DarkMode.system,
      language: json['language'] == null
          ? Language.hu
          : Language.languageFromJson(json['language']),
      theme: $enumDecodeNullable(_$SzikAppThemeEnumMap, json['theme']) ??
          SzikAppTheme.defaultTheme,
      notifications: json['notifications'] == null
          ? const []
          : NotificationTopic.topicsFromJson(json['notifications'] as List),
      feedShortcuts: (json['feed_shortcuts'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [0, 1, 2],
      dataLite: json['data_lite'] as bool? ?? false,
      leftMenuOption: json['left_menu_option'] as String? ?? 'feed',
      rightMenuOption: json['right_menu_option'] as String? ?? 'settings',
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

const _$SzikAppThemeEnumMap = {
  SzikAppTheme.defaultTheme: 'default',
};

const _$LanguageEnumMap = {
  Language.hu: 'hu',
  Language.en: 'en',
};

const _$NotificationTopicEnumMap = {
  NotificationTopic.advertisements: 'advertisements',
  NotificationTopic.birthdays: 'birthdays',
  NotificationTopic.cleaningExchangeAvailable: 'cleaningExchangeAvailable',
  NotificationTopic.cleaningExchangeUpdate: 'cleaningExchangeUpdate',
  NotificationTopic.cleaningTasksAvailable: 'cleaningTasksAvailable',
  NotificationTopic.cleaningTaskAssigned: 'cleaningTaskAssigned',
  NotificationTopic.cleaningTaskDueDate: 'cleaningTaskDueDate',
  NotificationTopic.janitorStatusUpdate: 'janitorStatusUpdate',
  NotificationTopic.pollAvailable: 'pollAvailable',
  NotificationTopic.pollVotingEnded: 'pollVotingEnded',
  NotificationTopic.pollVotingReminder: 'pollVotingReminder',
  NotificationTopic.reservationEnd: 'reservationEnd',
  NotificationTopic.reservationStart: 'reservationStart',
};
