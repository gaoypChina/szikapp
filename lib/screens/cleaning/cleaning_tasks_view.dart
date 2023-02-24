import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_list/toggle_list.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../models/models.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../../utils/methods.dart';

class CleaningTasksView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningTasksView({super.key, required this.manager});

  @override
  State<CleaningTasksView> createState() => _CleaningTasksViewState();
}

class _CleaningTasksViewState extends State<CleaningTasksView> {
  List<CleaningTask> _tasks = [];
  bool _isShowingPastTasks = false;

  @override
  void initState() {
    super.initState();
    _tasks = widget.manager.getCurrentTasks();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var yesterday = DateTime.now().subtract(const Duration(days: 1));
    var showingTasks = _isShowingPastTasks
        ? _tasks.where((task) => !task.start.isSameDate(yesterday)).toList()
        : _tasks.where((task) => task.start.isAfter(DateTime.now())).toList();
    return RefreshIndicator(
      onRefresh: () async {
        await widget.manager.refreshTasks();
        setState(() => _tasks = widget.manager.getCurrentTasks());
      },
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildReportTile(),
                ),
                _buildOpener(),
              ],
            ),
          ),
          Expanded(
            child: ToggleList(
              divider: const SizedBox(height: 10),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
                child: CustomIcon(
                  CustomIcons.doubleArrowDown,
                  size: theme.textTheme.displaySmall!.fontSize!,
                  color: theme.colorScheme.primary,
                ),
              ),
              children: showingTasks
                  .map<ToggleListItem>((task) => _buildTaskTile(task: task))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  ToggleListItem _buildTaskTile({required CleaningTask task}) {
    var isOwnItem = task.participantIDs
        .contains(Provider.of<AuthManager>(context).user!.id);
    var theme = Theme.of(context);
    var backgroundColor = isOwnItem
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface;
    var foregroundColor = isOwnItem
        ? theme.colorScheme.surface
        : theme.colorScheme.primaryContainer;
    var strongFont = theme.textTheme.displaySmall!.copyWith(
      color: foregroundColor,
    );
    var weakFont = theme.textTheme.titleMedium!.copyWith(
      color: foregroundColor,
      fontStyle: FontStyle.italic,
    );
    return ToggleListItem(
      headerDecoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(kBorderRadiusNormal),
        ),
      ),
      expandedHeaderDecoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(kBorderRadiusNormal),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: task.participantIDs.isNotEmpty
                    ? task.participantIDs
                        .map(
                          (participantID) => Text(
                            Provider.of<SzikAppStateManager>(context)
                                .users
                                .firstWhere((user) => user.id == participantID)
                                .showableName,
                            style: strongFont,
                          ),
                        )
                        .toList()
                    : [
                        Text('CLEANING_DIALOG_NO_MATE'.tr(), style: strongFont),
                      ],
              ),
            ),
            Text(
              DateFormat('MM. dd.').format(task.start),
              style: weakFont,
            ),
          ],
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(kBorderRadiusNormal),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 1,
              thickness: 1,
              indent: kPaddingNormal,
              endIndent: kPaddingNormal,
              color: foregroundColor,
            ),
            Padding(
              padding: const EdgeInsets.all(kPaddingLarge),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${'CLEANING_LABEL_EXTENSION'.tr()}: ',
                      style: weakFont.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: task.description,
                      style: weakFont,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTile() {
    var theme = Theme.of(context);
    var reportableItem = widget.manager.getYesterdayTask();
    var alreadyReported =
        reportableItem.status == TaskStatus.awaitingApproval ||
            reportableItem.status == TaskStatus.approved ||
            reportableItem.status == TaskStatus.refused;
    var weakFont = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.surface,
      fontStyle: FontStyle.italic,
    );
    var strongFont = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.surface,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPaddingSmall),
      child: GestureDetector(
        onTap: () {
          if (!alreadyReported) {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildReportDialog(reportableItem),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: kPaddingNormal,
            vertical: kPaddingSmall,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(kBorderRadiusNormal),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kPaddingNormal),
            child: Row(
              children: [
                const CustomIcon(CustomIcons.report),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kPaddingNormal),
                  child: Text(
                      alreadyReported
                          ? 'CLEANING_ALREADY_REPORTED'.tr()
                          : 'CLEANING_REPORT'.tr(),
                      style: strongFont),
                ),
                const Spacer(),
                Text(
                  DateFormat('MM. dd.').format(
                    DateTime.now().subtract(const Duration(days: 1)),
                  ),
                  style: weakFont,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOpener() {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: (() => setState(() => _isShowingPastTasks = !_isShowingPastTasks)),
      child: Container(
        margin: const EdgeInsets.all(kPaddingNormal),
        padding: const EdgeInsets.all(kPaddingNormal),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(kBorderRadiusNormal),
          ),
        ),
        child: _isShowingPastTasks
            ? CustomIcon(
                CustomIcons.doubleArrowDown,
                color: theme.colorScheme.primary,
                size: kIconSizeLarge,
              )
            : CustomIcon(
                CustomIcons.doubleArrowUp,
                color: theme.colorScheme.primary,
                size: kIconSizeLarge,
              ),
      ),
    );
  }

  Widget _buildReportDialog(CleaningTask reportableItem) {
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_REPORT_TITLE'.tr(),
      bodytext: 'CLEANING_DIALOG_REPORT_TEXT'.tr(args: [
        DateFormat('MM. dd. - EEEE', context.locale.toLanguageTag())
            .format(reportableItem.start),
      ]),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await widget.manager.reportInsufficiency(reportableItem);
        setState(() {});
      },
    );
  }
}
