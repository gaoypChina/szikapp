import 'package:flutter/material.dart';

import '../../business/reservation_manager.dart';
import '../../components/components.dart';

class ReservationAccountsListScreen extends StatelessWidget {
  final ReservationManager manager;

  static const String route = '/reservation/accounts';

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationAccountsListScreen(manager: manager),
    );
  }

  const ReservationAccountsListScreen({
    super.key,
    required this.manager,
  });

  @override
  Widget build(BuildContext context) {
    return AccountList.reservation(manager: manager);
  }
}
