import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/business.dart';
import '../../components/components.dart';

class CleaningScreen extends StatefulWidget {
  static const String route = '/cleaning';

  final KitchenCleaningManager manager;

  static MaterialPage page({required KitchenCleaningManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: CleaningScreen(manager: manager),
    );
  }

  const CleaningScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<CleaningScreen> createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'CLEANING_TITLE'.tr(),
      body: Center(
        child: Text(
          'ERROR_NOT_IMPLEMENTED'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
