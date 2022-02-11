import '../navigation/navigation.dart';

class CustomNotification {
  String title;
  String? description;
  SzikAppLink route;
  String iconPath;

  CustomNotification({
    required this.title,
    this.description,
    required this.route,
    this.iconPath = 'assets/icons/bell_light_72.png',
  });
}
