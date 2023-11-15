import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_list/toggle_list.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/tasks.dart';
import '../../navigation/app_state_manager.dart';
import '../../ui/themes.dart';

class JanitorScreen extends StatelessWidget {
  static const String route = '/janitor';

  static MaterialPage page({required JanitorManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: JanitorScreen(manager: manager),
    );
  }

  final JanitorManager manager;

  const JanitorScreen({super.key, required this.manager});

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refresh(),
      shimmer: const ListScreenShimmer(),
      child: JanitorListView(manager: manager),
    );
  }
}

class JanitorListView extends StatefulWidget {
  final JanitorManager manager;

  const JanitorListView({super.key, required this.manager});

  @override
  JanitorListViewState createState() => JanitorListViewState();
}

class JanitorListViewState extends State<JanitorListView> {
  List<JanitorTask> items = [];

  @override
  void initState() {
    super.initState();
    items = widget.manager.tasks;
  }

  void _onTabChanged(int? newValue) {
    List<JanitorTask> newItems;
    switch (newValue) {
      case 2:
        var ownID = Provider.of<AuthManager>(context, listen: false).user!.id;
        newItems = widget.manager.filter(participantID: ownID);
        break;
      case 1:
        newItems = widget.manager.filter(statuses: [
          TaskStatus.sent,
          TaskStatus.inProgress,
          TaskStatus.awaitingApproval
        ]);
        break;
      default:
        newItems = widget.manager.filter();
    }
    setState(() {
      items = newItems;
    });
  }

  void _onCreateTask() {
    SzikAppState.analytics.logEvent(name: 'janitor_task_open_create');
    widget.manager.createNewTask();
  }

  void _onEditPressed(JanitorTask task) {
    SzikAppState.analytics.logEvent(name: 'janitor_task_open_edit');
    var index = widget.manager.indexOf(task);
    widget.manager.editTask(index);
  }

  void _onEditJanitorPressed(JanitorTask task) {
    SzikAppState.analytics.logEvent(name: 'janitor_task_open_admin_edit');
    var index = widget.manager.indexOf(task);
    widget.manager.adminEditTask(index);
  }

  void _onFeedbackPressed(JanitorTask task) {
    if (task.status == TaskStatus.awaitingApproval ||
        task.status == TaskStatus.approved) {
      SzikAppState.analytics.logEvent(name: 'janitor_task_open_feedback');
      var index = widget.manager.indexOf(task);
      widget.manager.feedbackTask(index);
    }
  }

  void _onApprovePressed(JanitorTask task) {
    if (task.status == TaskStatus.awaitingApproval) {
      SzikAppState.analytics.logEvent(name: 'janitor_task_approve');
      task.status = TaskStatus.approved;
      widget.manager.updateTask(task);
    }
  }

  Future<void> _onManualRefresh() async {
    await widget.manager.refresh();
    setState(() => items = widget.manager.tasks);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'JANITOR_TITLE'.tr(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              kPaddingNormal,
              kPaddingLarge,
              kPaddingNormal,
              kPaddingNormal,
            ),
            child: TabChoice(
              labels: [
                'JANITOR_TAB_ALL'.tr(),
                'JANITOR_TAB_ACTIVE'.tr(),
                'JANITOR_TAB_OWN'.tr(),
              ],
              onChanged: _onTabChanged,
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr(),
                    ),
                  )
                : _buildTasks(),
          )
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _onCreateTask,
        typeToCreate: JanitorTask,
      ),
    );
  }

  Widget _buildTasks() {
    var theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _onManualRefresh,
      child: ToggleList(
        divider: const SizedBox(height: 10),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
          child: CustomIcon(
            CustomIcons.doubleArrowDown,
            size: theme.textTheme.displaySmall!.fontSize ?? 14,
            color: theme.colorScheme.primary,
          ),
        ),
        children: items.map<ToggleListItem>((item) {
          return ToggleListItem(
            headerDecoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.all(
                Radius.circular(kBorderRadiusNormal),
              ),
              border: Border.all(color: theme.colorScheme.primaryContainer),
            ),
            expandedHeaderDecoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(kBorderRadiusNormal),
              ),
              border: Border.all(color: theme.colorScheme.primaryContainer),
            ),
            title: _buildTitle(task: item, isOpen: false),
            expandedTitle: _buildTitle(task: item, isOpen: true),
            content: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: kBorderRadiusNormal,
                    decoration: BoxDecoration(
                      color: taskStatusColors[item.status]!,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(kBorderRadiusNormal),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: kBorderRadiusNormal),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(kBorderRadiusNormal),
                    ),
                    border:
                        Border.all(color: theme.colorScheme.primaryContainer),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(kPaddingNormal),
                        child: Column(
                          children: [
                            _buildRow(
                              label: 'JANITOR_LABEL_TITLE'.tr(),
                              value: item.name,
                            ),
                            _buildRow(
                              label: 'JANITOR_LABEL_DESCRIPTION'.tr(),
                              value: item.description ?? '',
                            ),
                            _buildRow(
                              label: 'JANITOR_LABEL_START'.tr(),
                              value: DateFormat('yyyy. MM. dd. HH:mm')
                                  .format(item.start),
                            ),
                            _buildRow(
                              label: 'JANITOR_LABEL_STATUS'.tr(),
                              value: item.status.name.tr(),
                            ),
                            if (item.answer != null)
                              _buildRow(
                                label: 'JANITOR_LABEL_ANSWER'.tr(),
                                value: item.answer!,
                              ),
                          ],
                        ),
                      ),
                      _buildFeedbackList(item),
                      Container(
                        margin: const EdgeInsets.only(bottom: kPaddingNormal),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _buildActionButtons(item),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTitle({required JanitorTask task, required bool isOpen}) {
    var theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Container(
              width: kBorderRadiusNormal,
              decoration: BoxDecoration(
                color: taskStatusColors[task.status]!,
                borderRadius: isOpen
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(kBorderRadiusNormal),
                      )
                    : const BorderRadius.horizontal(
                        left: Radius.circular(kBorderRadiusNormal),
                      ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            kPaddingLarge + kBorderRadiusNormal,
            kPaddingLarge,
            kPaddingLarge,
            kPaddingLarge,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  Provider.of<SzikAppStateManager>(context, listen: false)
                      .places
                      .firstWhere((item) => item.id == task.placeID)
                      .name,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ),
              Text(
                DateFormat('MM. dd.').format(task.start),
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow({required String label, required String value}) {
    var theme = Theme.of(context);
    var leftColumnWidth = MediaQuery.of(context).size.width * 0.25;
    return Container(
      margin: const EdgeInsets.only(bottom: kPaddingNormal),
      child: Row(
        children: [
          SizedBox(
            width: leftColumnWidth,
            child: Text(
              label,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(
                kPaddingNormal,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primaryContainer),
                borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              ),
              child: Text(
                value,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(JanitorTask task) {
    var theme = Theme.of(context);
    var buttonStyle = theme.outlinedButtonTheme.style!.copyWith(
      foregroundColor: MaterialStateColor.resolveWith(
          (states) => theme.colorScheme.primaryContainer),
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(color: theme.colorScheme.primaryContainer),
      ),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
        (states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusNormal),
        ),
      ),
    );
    var buttons = <Widget>[];
    var userID = Provider.of<AuthManager>(context, listen: false).user!.id;
    if ((task.participantIDs.contains(userID) &&
            (task.status == TaskStatus.sent ||
                task.status == TaskStatus.inProgress)) ||
        userID == 'u904') {
      buttons.add(
        OutlinedButton(
          onPressed: () => userID == 'u904'
              ? _onEditJanitorPressed(task)
              : _onEditPressed(task),
          style: buttonStyle,
          child: Text(
            'BUTTON_EDIT'.tr(),
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
        ),
      );
    }
    if (task.status == TaskStatus.approved ||
        task.status == TaskStatus.awaitingApproval) {
      buttons.add(
        OutlinedButton(
          onPressed: () => _onFeedbackPressed(task),
          style: buttonStyle,
          child: Text(
            'BUTTON_FEEDBACK'.tr(),
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
        ),
      );
    }
    if (task.participantIDs.contains(userID) &&
        task.status == TaskStatus.awaitingApproval) {
      buttons.add(
        OutlinedButton(
          onPressed: () => _onApprovePressed(task),
          style: buttonStyle,
          child: Text(
            'BUTTON_APPROVE'.tr(),
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
        ),
      );
    }
    return buttons;
  }

  Widget _buildFeedbackList(JanitorTask task) {
    var theme = Theme.of(context);
    var leftColumnWidth = MediaQuery.of(context).size.width * 0.25;
    return Provider.of<AuthManager>(context, listen: false).user!.id ==
                'u904' &&
            task.feedback.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(bottom: kPaddingNormal),
            child: Row(
              children: [
                SizedBox(
                  width: leftColumnWidth,
                  child: Text(
                    'JANITOR_LABEL_FEEDBACK'.tr(),
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 14,
                      color: theme.colorScheme.background,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(kPaddingNormal),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: theme.colorScheme.background),
                      borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: task.feedback.map(
                        (item) {
                          return Text(
                            '${item.lastUpdate.month}. ${item.lastUpdate.day}: ${item.message}',
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.background,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
