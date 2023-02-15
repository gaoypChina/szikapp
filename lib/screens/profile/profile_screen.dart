import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business/auth_manager.dart';
import '../../components/components.dart';
import '../../navigation/navigation.dart';
import '../progress_screen.dart';
import 'profile_profile_view.dart';
import 'profile_signin_view.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/me';

  final AuthManager manager;

  static MaterialPage page({required AuthManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ProfileScreen(
        manager: manager,
      ),
    );
  }

  const ProfileScreen({
    super.key = const Key('ProfileScreen'),
    required this.manager,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var authManager = Provider.of<AuthManager>(context);
    return CustomFutureBuilder(
      future: Future.wait([
        authManager.signInSilently(),
        if (authManager.isSignedIn && !authManager.isUserGuest) ...[
          Provider.of<SzikAppStateManager>(context, listen: false)
              .loadEarlyData()
        ]
      ]),
      shimmer: const ProgressScreen(),
      child: authManager.isSignedIn
          ? ProfileScreenView(manager: widget.manager)
          : const SignInScreenView(),
    );
  }
}
