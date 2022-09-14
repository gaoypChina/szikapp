import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/business.dart';
import '../../components/components.dart';

class CleaningAdminScreen extends StatefulWidget {
  static const String route = '/cleaning/admin';
  final KitchenCleaningManager manager;

  static MaterialPage page({required KitchenCleaningManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: CleaningAdminScreen(manager: manager),
    );
  }

  const CleaningAdminScreen({
    super.key,
    required this.manager,
  });

  @override
  State<CleaningAdminScreen> createState() => _CleaningAdminScreenState();
}

class _CleaningAdminScreenState extends State<CleaningAdminScreen> {
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
