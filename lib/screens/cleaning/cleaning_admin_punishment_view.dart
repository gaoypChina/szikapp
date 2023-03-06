import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/business.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

class CleaningAdminPunishmentView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningAdminPunishmentView({super.key, required this.manager});

  @override
  State<CleaningAdminPunishmentView> createState() =>
      _CleaningAdminPunishmentViewState();
}

class _CleaningAdminPunishmentViewState
    extends State<CleaningAdminPunishmentView> {
  List<CleaningTask> _pendingTasks = [];
  List<CleaningTask> _refusedTasks = [];

  @override
  void initState() {
    super.initState();
    _pendingTasks = widget.manager.tasks
        .where((task) => task.status == TaskStatus.awaitingApproval)
        .toList();
    _refusedTasks = widget.manager.tasks
        .where((task) => task.status == TaskStatus.refused)
        .toList();
  }

  Future<void> _onRefusedPressed(CleaningTask task) async {
    try {
      task.status = TaskStatus.approved;
      await widget.manager.editCleaningTask(task: task);
      await widget.manager.refreshTasks();
      SzikAppState.analytics.logEvent(name: 'cleaning_refuse_report');
      setState(() {
        _pendingTasks = widget.manager.tasks
            .where((task) => task.status == TaskStatus.awaitingApproval)
            .toList();
        _refusedTasks = widget.manager.tasks
            .where((task) => task.status == TaskStatus.refused)
            .toList();
      });
    } on IOException catch (exception) {
      var snackbar =
          ErrorHandler.buildSnackbar(context: context, exception: exception);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> _onAcceptedPressed(CleaningTask task) async {
    try {
      task.status = TaskStatus.refused;
      await widget.manager.editCleaningTask(task: task);
      await widget.manager.refreshTasks();
      SzikAppState.analytics
          .logEvent(name: 'cleaning_accept_report_or_payment');
      setState(() {
        _pendingTasks = widget.manager.tasks
            .where((task) => task.status == TaskStatus.awaitingApproval)
            .toList();
        _refusedTasks = widget.manager.tasks
            .where((task) => task.status == TaskStatus.refused)
            .toList();
      });
    } on IOException catch (exception) {
      var snackbar =
          ErrorHandler.buildSnackbar(context: context, exception: exception);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(kBorderRadiusNormal),
            ),
            border: Border.all(color: theme.colorScheme.primary),
          ),
          padding: const EdgeInsets.all(kPaddingNormal),
          child: Column(
            children: [
              Text(
                'CLEANING_ADMIN_AWAITING_APPROVAL'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall!
                    .copyWith(color: theme.colorScheme.primaryContainer),
              ),
              const SizedBox(height: kPaddingNormal),
              if (_pendingTasks.isEmpty)
                Text(
                  'PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr(),
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ..._pendingTasks.map(
                (task) => Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(kBorderRadiusSmall),
                    ),
                    border: Border.all(color: theme.colorScheme.secondary),
                  ),
                  padding: const EdgeInsets.all(kPaddingNormal),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('yyyy. MM. dd.').format(task.start),
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primaryContainer,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        userIDsToString(context, task.participantIDs),
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primaryContainer,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _onRefusedPressed(task),
                            child: Text(
                              'BUTTON_DISAGREE'.tr(),
                              style: theme.textTheme.labelSmall!.copyWith(
                                color: theme.colorScheme.surface,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _onAcceptedPressed(task),
                            child: Text(
                              'BUTTON_APPROVE'.tr(),
                              style: theme.textTheme.labelSmall!.copyWith(
                                color: theme.colorScheme.surface,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kPaddingNormal),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(kBorderRadiusNormal),
            ),
            border: Border.all(color: theme.colorScheme.primaryContainer),
          ),
          padding: const EdgeInsets.all(kPaddingNormal),
          child: Column(
            children: [
              Text(
                'CLEANING_ADMIN_FEE_PAYMENT'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall!
                    .copyWith(color: theme.colorScheme.primaryContainer),
              ),
              const SizedBox(height: kPaddingNormal),
              if (_refusedTasks.isEmpty)
                Text(
                  'PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr(),
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ..._refusedTasks.map(
                (task) => Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(kBorderRadiusSmall),
                    ),
                    border: Border.all(color: theme.colorScheme.secondary),
                  ),
                  padding: const EdgeInsets.all(kPaddingNormal),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('yyyy. MM. dd.').format(task.start),
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primaryContainer,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        userIDsToString(context, task.participantIDs),
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primaryContainer,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _onRefusedPressed(task),
                            child: Text(
                              'BUTTON_PAYMENT'.tr(),
                              style: theme.textTheme.labelSmall!.copyWith(
                                color: theme.colorScheme.surface,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
