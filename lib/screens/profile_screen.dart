import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String route = '/profile';
  static const String shortRoute = '/me';

  const ProfileScreen({Key key = const Key('ProfileScreen')}) : super(key: key);

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
