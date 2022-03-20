import 'package:easy_localization/easy_localization.dart';

import '../navigation/navigation.dart';

class Shortcut {
  final String assetPath;
  final int feature;
  final String name;

  const Shortcut(
      {required this.assetPath, required this.feature, required this.name});
}

Map<int, Shortcut> shortcutData = <int, Shortcut>{
  SzikAppFeature.calendar: Shortcut(
    assetPath: 'assets/icons/calendar_light_72.png',
    feature: SzikAppFeature.calendar,
    name: 'CALENDAR_TITLE'.tr(),
  ),
  SzikAppFeature.cleaning: Shortcut(
    assetPath: 'assets/icons/knife_light_72.png',
    feature: SzikAppFeature.cleaning,
    name: 'CLEANING_TITLE'.tr(),
  ),
  SzikAppFeature.contacts: Shortcut(
    assetPath: 'assets/icons/users_light_72.png',
    feature: SzikAppFeature.contacts,
    name: 'CONTACTS_TITLE'.tr(),
  ),
  SzikAppFeature.documents: Shortcut(
    assetPath: 'assets/icons/book_light_72.png',
    feature: SzikAppFeature.documents,
    name: 'DOCUMENTS_TITLE'.tr(),
  ),
  SzikAppFeature.janitor: Shortcut(
    assetPath: 'assets/icons/wrench_light_72.png',
    feature: SzikAppFeature.janitor,
    name: 'JANITOR_TITLE'.tr(),
  ),
  SzikAppFeature.poll: Shortcut(
    assetPath: 'assets/icons/handpalm_light_72.png',
    feature: SzikAppFeature.poll,
    name: 'POLL_TITLE'.tr(),
  ),
  SzikAppFeature.profile: Shortcut(
    assetPath: 'assets/icons/user_light_72.png',
    feature: SzikAppFeature.profile,
    name: 'PROFILE_TITLE'.tr(),
  ),
  SzikAppFeature.reservation: Shortcut(
    assetPath: 'assets/icons/hourglass_light_72.png',
    feature: SzikAppFeature.reservation,
    name: 'RESERVATION_TITLE'.tr(),
  ),
  SzikAppFeature.settings: Shortcut(
    assetPath: 'assets/icons/gear_light_72.png',
    feature: SzikAppFeature.settings,
    name: 'SETTINGS_TITLE'.tr(),
  ),
};
