import 'package:flutter/material.dart';

import '../business/business.dart';

class CleaningScreen extends StatefulWidget {
  static const String route = '/cleaning';

  static MaterialPage page({required KitchenCleaningManager manager}) {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: CleaningScreen(),
    );
  }

  const CleaningScreen({Key? key}) : super(key: key);

  @override
  State<CleaningScreen> createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
