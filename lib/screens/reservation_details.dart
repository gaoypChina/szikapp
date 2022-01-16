import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/reservation_manager.dart';
import '../components/components.dart';

class ReservationDetailsScreen extends StatelessWidget {
  static const String route = '/reservation/details';

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationDetailsScreen(manager: manager),
    );
  }

  final ReservationManager manager;

  const ReservationDetailsScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: Provider.of<ReservationManager>(context, listen: false).refresh(),
      shimmer: const ListScreenShimmer(),
      child: const CustomScaffold(),
    );
  }
}
