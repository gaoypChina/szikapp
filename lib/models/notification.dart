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
  advertisements,
  birthdays,
  cleaningExchangeAvailable,
  cleaningExchangeUpdate,
  cleaningTasksAvailable,
  cleaningTaskAssigned,
  cleaningTaskDueDate,
  janitorStatusUpdate,
  pollAvailable,
  pollVotingEnded,
  pollVotingReminder,
  reservationEnd,
  reservationStart;

  @override
  String toString() => name;
}

typedef NotificationPath = ({
  SzikAppLink path,
  String iconPath,
});

Map<NotificationTopic, NotificationPath> notificationPaths = {
  NotificationTopic.advertisements: (
    iconPath: CustomIcons.bell,
    path: SzikAppLink(currentTab: SzikAppTab.feed)
  ),
  NotificationTopic.birthdays: (
    iconPath: CustomIcons.description,
    path: SzikAppLink(currentTab: SzikAppTab.feed)
  ),
  NotificationTopic.cleaningExchangeAvailable: (
    iconPath: CustomIcons.knife,
    path: SzikAppLink(currentFeature: SzikAppFeature.cleaning)
  ),
  NotificationTopic.cleaningExchangeUpdate: (
    iconPath: CustomIcons.knife,
    path: SzikAppLink(currentFeature: SzikAppFeature.cleaning)
  ),
  NotificationTopic.cleaningTaskAssigned: (
    iconPath: CustomIcons.knife,
    path: SzikAppLink(currentFeature: SzikAppFeature.cleaning)
  ),
  NotificationTopic.cleaningTasksAvailable: (
    iconPath: CustomIcons.knife,
    path: SzikAppLink(currentFeature: SzikAppFeature.cleaning)
  ),
  NotificationTopic.cleaningTaskDueDate: (
    iconPath: CustomIcons.knife,
    path: SzikAppLink(currentFeature: SzikAppFeature.cleaning)
  ),
  NotificationTopic.janitorStatusUpdate: (
    iconPath: CustomIcons.wrench,
    path: SzikAppLink(currentFeature: SzikAppFeature.janitor)
  ),
  NotificationTopic.pollAvailable: (
    iconPath: CustomIcons.handpalm,
    path: SzikAppLink(currentFeature: SzikAppFeature.poll)
  ),
  NotificationTopic.pollVotingEnded: (
    iconPath: CustomIcons.handpalm,
    path: SzikAppLink(currentFeature: SzikAppFeature.poll)
  ),
  NotificationTopic.pollVotingReminder: (
    iconPath: CustomIcons.handpalm,
    path: SzikAppLink(currentFeature: SzikAppFeature.poll)
  ),
  NotificationTopic.reservationEnd: (
    iconPath: CustomIcons.hourglass,
    path: SzikAppLink(currentFeature: SzikAppFeature.reservation)
  ),
  NotificationTopic.reservationStart: (
    iconPath: CustomIcons.hourglass,
    path: SzikAppLink(currentFeature: SzikAppFeature.reservation)
  ),
};

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
  NotificationTopic.cleaningTasksAvailable: NotificationSetting(
    topic: NotificationTopic.cleaningTasksAvailable,
    label: 'NF_CLEANING_TASKS_AVAILABLE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.cleaningTaskDueDate: NotificationSetting(
    topic: NotificationTopic.cleaningTaskDueDate,
    label: 'NF_CLEANING_TASK_DUE_DATE_LABEL'.tr(),
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
    topic: NotificationTopic.pollVotingReminder,
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
