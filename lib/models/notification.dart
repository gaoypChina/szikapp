import 'package:easy_localization/easy_localization.dart';
import '../components/components.dart';
import '../navigation/navigation.dart';
import '../utils/utils.dart';

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

  static NotificationTopic decodeTopic({required dynamic source}) {
    for (var topic in NotificationTopic.values) {
      if (topic.toString() == source.toString()) {
        return topic;
      }
    }
    throw NotValidEnumValueException(
      '`$source` is not one of the supported values.',
    );
  }

  static List<NotificationTopic> topicsFromJson(List<dynamic> rawTopics) {
    var topics = <NotificationTopic>[];
    for (var rawTopic in rawTopics) {
      try {
        topics.add(NotificationTopic.decodeTopic(source: rawTopic));
      } on NotValidEnumValueException catch (_) {
        continue;
      }
    }
    return topics;
  }
}

final obligatoryTopics = <NotificationTopic>[
  NotificationTopic.advertisements,
  NotificationTopic.cleaningExchangeUpdate,
  NotificationTopic.cleaningTaskAssigned,
  NotificationTopic.cleaningTaskDueDate,
  NotificationTopic.cleaningTasksAvailable,
  NotificationTopic.janitorStatusUpdate,
  NotificationTopic.pollAvailable,
  NotificationTopic.cleaningExchangeAvailable,
];

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

typedef NotificationSetting = ({
  NotificationTopic topic,
  String label,
  bool enabled,
});

Map<NotificationTopic, NotificationSetting> notificationSettings = {
  NotificationTopic.advertisements: (
    topic: NotificationTopic.advertisements,
    label: 'NF_ADVERTISEMENTS_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.birthdays: (
    topic: NotificationTopic.birthdays,
    label: 'NF_BIRTHDAYS_LABEL'.tr(),
    enabled: true,
  ),
  NotificationTopic.cleaningExchangeAvailable: (
    topic: NotificationTopic.cleaningExchangeAvailable,
    label: 'NF_CLEANING_EXCHANGE_AVAILABLE_LABEL'.tr(),
    enabled: true,
  ),
  NotificationTopic.cleaningExchangeUpdate: (
    topic: NotificationTopic.cleaningExchangeUpdate,
    label: 'NF_CLEANING_EXCHANGE_UPDATE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.cleaningTaskAssigned: (
    topic: NotificationTopic.cleaningTaskAssigned,
    label: 'NF_CLEANING_TASK_ASSIGNED_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.cleaningTasksAvailable: (
    topic: NotificationTopic.cleaningTasksAvailable,
    label: 'NF_CLEANING_TASKS_AVAILABLE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.cleaningTaskDueDate: (
    topic: NotificationTopic.cleaningTaskDueDate,
    label: 'NF_CLEANING_TASK_DUE_DATE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.janitorStatusUpdate: (
    topic: NotificationTopic.janitorStatusUpdate,
    label: 'NF_JANITOR_STATUS_UPDATE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.pollAvailable: (
    topic: NotificationTopic.pollAvailable,
    label: 'NF_POLL_AVAILABLE_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.pollVotingEnded: (
    topic: NotificationTopic.pollVotingEnded,
    label: 'NF_POLL_VOTING_ENDED_LABEL'.tr(),
    enabled: true,
  ),
  NotificationTopic.pollVotingReminder: (
    topic: NotificationTopic.pollVotingReminder,
    label: 'NF_POLL_VOTING_REMINDER_LABEL'.tr(),
    enabled: false,
  ),
  NotificationTopic.reservationEnd: (
    topic: NotificationTopic.reservationEnd,
    label: 'NF_RESERVATION_END_LABEL'.tr(),
    enabled: true,
  ),
  NotificationTopic.reservationStart: (
    topic: NotificationTopic.reservationStart,
    label: 'NF_RESERVATION_START_LABEL'.tr(),
    enabled: true,
  ),
};
