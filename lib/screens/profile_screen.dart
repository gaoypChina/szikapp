import 'package:flutter/material.dart';
import '../utils/user.dart';

class ProfileScreen extends StatelessWidget {
  static const String route = '/profile';
  static const String shortRoute = '/me';

  final User user;

  static MaterialPage page({required User user}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ProfileScreen(
        user: user,
      ),
    );
  }

  const ProfileScreen({
    Key key = const Key('ProfileScreen'),
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: const Center(
        child: Text('Profile'),
      ),
    );
  }
}
