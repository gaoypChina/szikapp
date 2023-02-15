import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../navigation/app_state_manager.dart';
import 'progress_screen.dart';

class StartScreen extends StatelessWidget {
  static const String route = '/start';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: StartScreen(),
    );
  }

  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AuthManager>(context, listen: false).signInSilently(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProgressScreen();
        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
            (() => Provider.of<SzikAppStateManager>(context, listen: false)
                .finishStarting()),
          );
          return const ProgressScreen();
        }
      }),
    );
  }
}
