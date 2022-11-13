import 'package:easy_localization/easy_localization.dart';
import '../components/components.dart';
import '../navigation/navigation.dart';

class CustomNotification {
  String title;
  String? body;
  SzikAppLink? route;
  String iconPath;

  CustomNotification({
    required this.title,
    this.body,
    this.route,
    this.iconPath = CustomIcons.bell,
  });
}

enum NotificationTopic {
  birthdays,
  advertisements,
  reservationStart,
  reservationEnd,
  janitorStatusUpdate,
  pollAvailable,
  pollVotingReminder,
  pollVotingEnded,
  cleaningTaskDueDate,
  cleaningTasksAvailable,
  cleaningTaskAssigned,
  cleaningExchangeAvailable,
  cleaningExchangeUpdate;

  @override
  String toString() => name;
}

class NotificationSetting {
  final NotificationTopic topic;
  final String label;
  final bool enabled;

  const NotificationSetting({
    required this.topic,
    required this.label,
    this.enabled = true,
  });
}

Map<NotificationTopic, NotificationSetting> notificationSettings = {
  NotificationTopic.advertisements: NotificationSetting(
    topic: NotificationTopic.advertisements,
    label: 'NF_ADVERTISEMENTS_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.birthdays: NotificationSetting(
    topic: NotificationTopic.birthdays,
    label: 'NF_BIRTHDAYS_LABEL'.tr(),
  ),
  NotificationTopic.cleaningExchangeAvailable: NotificationSetting(
    topic: NotificationTopic.cleaningExchangeAvailable,
    label: 'NF_CLEANING_EXCHANGE_AVAILABLE_LABEL'.tr(),
  ),
  NotificationTopic.cleaningExchangeUpdate: NotificationSetting(
    topic: NotificationTopic.cleaningExchangeUpdate,
    label: 'NF_CLEANING_EXCHANGE_UPDATE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.cleaningTaskAssigned: NotificationSetting(
    topic: NotificationTopic.cleaningTaskAssigned,
    label: 'NF_CLEANING_TASK_ASSIGNED_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.cleaningTaskDueDate: NotificationSetting(
    topic: NotificationTopic.cleaningTaskDueDate,
    label: 'NF_CLEANING_TASK_DUE_DATE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.cleaningTasksAvailable: NotificationSetting(
    topic: NotificationTopic.cleaningTasksAvailable,
    label: 'NF_CLEANING_TASKS_AVAILABLE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.janitorStatusUpdate: NotificationSetting(
    topic: NotificationTopic.janitorStatusUpdate,
    label: 'NF_JANITOR_STATUS_UPDATE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.pollAvailable: NotificationSetting(
    topic: NotificationTopic.pollAvailable,
    label: 'NF_POLL_AVAILABLE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.pollVotingEnded: NotificationSetting(
    topic: NotificationTopic.pollVotingEnded,
    label: 'NF_POLL_VOTING_ENDED_LABEL'.tr(),
  ),
  NotificationTopic.pollVotingReminder: NotificationSetting(
    topic: NotificationTopic.cleaningExchangeAvailable,
    label: 'NF_POLL_VOTING_REMINDER_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.reservationEnd: NotificationSetting(
    topic: NotificationTopic.reservationEnd,
    label: 'NF_RESERVATION_END_LABEL'.tr(),
  ),
  NotificationTopic.reservationStart: NotificationSetting(
    topic: NotificationTopic.reservationStart,
    label: 'NF_RESERVATION_START_LABEL'.tr(),
  ),
};
