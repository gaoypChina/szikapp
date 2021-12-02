import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/reservation_manager.dart';

import 'error_screen.dart';

class ReservationDetailsScreen extends StatelessWidget {
  static const String route = '/reservation/details';

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationDetailsScreen(
        manager: manager,
      ),
    );
  }

  final ReservationManager manager;

  const ReservationDetailsScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Provider.of<ReservationManager>(context, listen: false).refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //Shrimmer
          return const Scaffold();
        } else if (snapshot.hasError) {
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          return const Scaffold(
              //Ide
              );
        }
      },
    );
  }
}
