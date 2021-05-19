import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const String route = '/profile';

  const ProfilePage({Key key = const Key('ProfilePage')}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Profile'),
      ),
    );
  }
}
