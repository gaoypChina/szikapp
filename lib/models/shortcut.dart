import 'package:easy_localization/easy_localization.dart';

import '../components/custom_icon.dart';
import '../navigation/navigation.dart';

class Shortcut {
  final String assetPath;
  final int feature;
  final String name;

  const Shortcut({
    required this.assetPath,
    required this.feature,
    required this.name,
  });
}

Map<int, Shortcut> shortcutData = <int, Shortcut>{
  SzikAppFeature.bookrental: Shortcut(
    assetPath: CustomIcons.library,
    feature: SzikAppFeature.bookrental,
    name: 'BOOKRENTAL_TITLE'.tr(),
  ),
  SzikAppFeature.calendar: Shortcut(
    assetPath: CustomIcons.calendar,
    feature: SzikAppFeature.calendar,
    name: 'CALENDAR_TITLE'.tr(),
  ),
  SzikAppFeature.cleaning: Shortcut(
    assetPath: CustomIcons.knife,
    feature: SzikAppFeature.cleaning,
    name: 'CLEANING_TITLE'.tr(),
  ),
  SzikAppFeature.contacts: Shortcut(
    assetPath: CustomIcons.users,
    feature: SzikAppFeature.contacts,
    name: 'CONTACTS_TITLE'.tr(),
  ),
  SzikAppFeature.documents: Shortcut(
    assetPath: CustomIcons.bookClosed,
    feature: SzikAppFeature.documents,
    name: 'DOCUMENTS_TITLE'.tr(),
  ),
  SzikAppFeature.janitor: Shortcut(
    assetPath: CustomIcons.wrench,
    feature: SzikAppFeature.janitor,
    name: 'JANITOR_TITLE'.tr(),
  ),
  SzikAppFeature.poll: Shortcut(
    assetPath: CustomIcons.handpalm,
    feature: SzikAppFeature.poll,
    name: 'POLL_TITLE'.tr(),
  ),
  SzikAppFeature.profile: Shortcut(
    assetPath: CustomIcons.user,
    feature: SzikAppFeature.profile,
    name: 'PROFILE_TITLE'.tr(),
  ),
  SzikAppFeature.reservation: Shortcut(
    assetPath: CustomIcons.hourglass,
    feature: SzikAppFeature.reservation,
    name: 'RESERVATION_TITLE'.tr(),
  ),
  SzikAppFeature.settings: Shortcut(
    assetPath: CustomIcons.settings,
    feature: SzikAppFeature.settings,
    name: 'SETTINGS_TITLE'.tr(),
  ),
};
