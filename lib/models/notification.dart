import '../navigation/navigation.dart';

class SzikAppNotification {
  String title;
  String? description;
  SzikAppLink route;
  String iconPath;

  SzikAppNotification({
    required this.title,
    this.description,
    required this.route,
    this.iconPath = 'assets/icons/bell_light_72.png',
  });
}
