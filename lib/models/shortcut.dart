import '../navigation/navigation.dart';

class Shortcut {
  final String assetPath;
  final int feature;

  const Shortcut({required this.assetPath, required this.feature});
}

const shortcutData = <int, Shortcut>{
  SzikAppFeature.calendar: Shortcut(
    assetPath: 'assets/icons/calendar_light_72.png',
    feature: SzikAppFeature.calendar,
  ),
  SzikAppFeature.cleaning: Shortcut(
    assetPath: 'assets/icons/knife_light_72.png',
    feature: SzikAppFeature.cleaning,
  ),
  SzikAppFeature.contacts: Shortcut(
    assetPath: 'assets/icons/users_light_72.png',
    feature: SzikAppFeature.contacts,
  ),
  SzikAppFeature.documents: Shortcut(
    assetPath: 'assets/icons/book_light_72.png',
    feature: SzikAppFeature.documents,
  ),
  SzikAppFeature.janitor: Shortcut(
    assetPath: 'assets/icons/wrench_light_72.png',
    feature: SzikAppFeature.janitor,
  ),
  SzikAppFeature.poll: Shortcut(
    assetPath: 'assets/icons/handpalm_light_72.png',
    feature: SzikAppFeature.poll,
  ),
  SzikAppFeature.profile: Shortcut(
    assetPath: 'assets/icons/user_light_72.png',
    feature: SzikAppFeature.profile,
  ),
  SzikAppFeature.reservation: Shortcut(
    assetPath: 'assets/icons/hourglass_light_72.png',
    feature: SzikAppFeature.reservation,
  ),
  SzikAppFeature.settings: Shortcut(
    assetPath: 'assets/icons/gear_light_72.png',
    feature: SzikAppFeature.settings,
  ),
};
