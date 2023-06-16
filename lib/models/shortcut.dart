import 'package:easy_localization/easy_localization.dart';

import '../components/components.dart';
import '../navigation/navigation.dart';

typedef Shortcut = ({
  String assetPath,
  int feature,
  String name,
});

/// List of shortcuts. Keep in sync with SzikappFeatures. Order matters.
Map<int, Shortcut> shortcutData = <int, Shortcut>{
  SzikAppFeature.calendar: (
    assetPath: CustomIcons.calendar,
    feature: SzikAppFeature.calendar,
    name: 'CALENDAR_TITLE'.tr(),
  ),
  SzikAppFeature.cleaning: (
    assetPath: CustomIcons.knife,
    feature: SzikAppFeature.cleaning,
    name: 'CLEANING_TITLE'.tr(),
  ),
  SzikAppFeature.contacts: (
    assetPath: CustomIcons.users,
    feature: SzikAppFeature.contacts,
    name: 'CONTACTS_TITLE'.tr(),
  ),
  SzikAppFeature.documents: (
    assetPath: CustomIcons.bookClosed,
    feature: SzikAppFeature.documents,
    name: 'DOCUMENTS_TITLE'.tr(),
  ),
  SzikAppFeature.janitor: (
    assetPath: CustomIcons.wrench,
    feature: SzikAppFeature.janitor,
    name: 'JANITOR_TITLE'.tr(),
  ),
  SzikAppFeature.poll: (
    assetPath: CustomIcons.handpalm,
    feature: SzikAppFeature.poll,
    name: 'POLL_TITLE'.tr(),
  ),
  SzikAppFeature.profile: (
    assetPath: CustomIcons.user,
    feature: SzikAppFeature.profile,
    name: 'PROFILE_TITLE'.tr(),
  ),
  SzikAppFeature.reservation: (
    assetPath: CustomIcons.hourglass,
    feature: SzikAppFeature.reservation,
    name: 'RESERVATION_TITLE'.tr(),
  ),
  SzikAppFeature.settings: (
    assetPath: CustomIcons.settings,
    feature: SzikAppFeature.settings,
    name: 'SETTINGS_TITLE'.tr(),
  ),
  SzikAppFeature.bookrental: (
    assetPath: CustomIcons.library,
    feature: SzikAppFeature.bookrental,
    name: 'BOOKRENTAL_TITLE'.tr(),
  ),
  SzikAppFeature.passwords: (
    assetPath: CustomIcons.password,
    feature: SzikAppFeature.passwords,
    name: 'PASSWORDS_TITLE'.tr(),
  )
};
