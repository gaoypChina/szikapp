import 'package:flutter/material.dart';

import '../business/business.dart';
import '../components/components.dart';

class PasswordsScreen extends StatelessWidget {
  final ReservationManager manager;

  static const String route = '/passwords';

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: PasswordsScreen(manager: manager),
    );
  }

  const PasswordsScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AccountList.passwords(manager: manager);
  }
}
