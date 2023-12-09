import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_list/toggle_list.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
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
  int activeTab = 0;

  @override
  void initState() {
    super.initState();
    items = widget.manager.tasks;
    _setShowingItems();
  }

  Future<void> _onManualRefresh() async {
    await widget.manager.refresh();
    _setShowingItems();
  }

  void _onTabChanged(int? newValue) {
    activeTab = newValue ?? 0;
    _setShowingItems();
  }

  void _setShowingItems() {
    var ownID = Provider.of<AuthManager>(context, listen: false).user!.id;
    var activeStatuses = [
      TaskStatus.created,
      TaskStatus.sent,
      TaskStatus.inProgress,
      TaskStatus.awaitingApproval,
    ];
    List<JanitorTask> newItems;
    switch (activeTab) {
      case 0:
        newItems = widget.manager.filter((task) {
          var place = Provider.of<SzikAppStateManager>(context, listen: false)
              .places
              .firstWhere((place) => place.id == task.placeID);
          return (task.participantIDs.contains(ownID) ||
                  place.type != PlaceType.room) &&
              activeStatuses.contains(task.status);
        });
        break;
      case 1:
        newItems = widget.manager.filter((task) {
          return activeStatuses.contains(task.status);
        });
        break;
      default:
        newItems = widget.manager.filter((task) {
          return !activeStatuses.contains(task.status);
        });
    }
    setState(() {
      items = newItems;
    });
  }

  void _onCreateTask() {
    SzikAppState.analytics.logEvent(name: 'janitor_task_open_create');
    widget.manager.createNewTask();
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TabChoice(
                labels: [
                  'JANITOR_TAB_OWN'.tr(),
                  'JANITOR_TAB_ACTIVE'.tr(),
                  'JANITOR_TAB_ARCHIVE'.tr(),
                ],
                wrapColor: Colors.transparent,
                onChanged: _onTabChanged,
              ),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr(),
                    ),
                  )
                : _buildTaskList(),
          )
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _onCreateTask,
        typeToCreate: JanitorTask,
      ),
    );
  }

  Widget _buildTaskList() {
    var theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _onManualRefresh,
      child: ToggleList(
        divider: const SizedBox(height: kPaddingNormal),
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
            itemDecoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              border: Border.all(color: theme.colorScheme.primaryContainer),
            ),
            title: _buildTitle(task: item, isOpen: false),
            expandedTitle: _buildTitle(task: item, isOpen: true),
            divider: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.primaryContainer,
            ),
            content: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: kBorderRadiusNormal,
                    decoration: BoxDecoration(
                      color: taskStatusColors[item.status]!,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: kBorderRadiusNormal),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kPaddingNormal),
                    child: Column(
                      children: [
                        Column(
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
                        _buildFeedbackList(item),
                        Container(
                          margin: const EdgeInsets.only(bottom: kPaddingNormal),
                          child: Wrap(
                            children: _buildActionButtons(item),
                          ),
                        ),
                      ],
                    ),
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
    var buttons = <Widget>[];
    var user = Provider.of<AuthManager>(context, listen: false).user!;
    var janitorIDs = widget.manager.getJanitorIDs(context);
    var userIsParticipant = user.hasPermissionToModify(task: task);
    var userIsJanitor = janitorIDs.contains(user.id);
    var taskCanGetFeedback = [
      TaskStatus.inProgress,
      TaskStatus.awaitingApproval,
      TaskStatus.refused,
      TaskStatus.approved,
      TaskStatus.irresolvable
    ].contains(task.status);

    if (userIsParticipant && task.status == TaskStatus.sent) {
      buttons.add(generateEditButton(task));
    }
    if ((userIsParticipant || userIsJanitor) && (taskCanGetFeedback)) {
      buttons.add(generateFeedbackButton(task));
    }
    if (userIsJanitor && task.status == TaskStatus.created) {
      buttons.add(generateToInProgressButton(task));
    }
    if (userIsJanitor && task.status == TaskStatus.inProgress) {
      buttons.add(generateToAwaitingApprovalButton(task));
      buttons.add(generateToIrresolvable(task));
    }
    if (userIsParticipant && task.status == TaskStatus.awaitingApproval) {
      buttons.add(generateToApprovedButton(task));
      buttons.add(generateToRefusedButton(task));
    }
    if (userIsJanitor && task.status == TaskStatus.refused) {
      buttons.add(generateToInProgressButton(task));
    }
    return buttons;
  }

  Widget generateEditButton(JanitorTask task) {
    void callback(JanitorTask task) {
      SzikAppState.analytics.logEvent(name: 'janitor_task_open_edit');
      var index = widget.manager.indexOf(task);
      widget.manager.editTask(index);
    }

    return generateButton('BUTTON_EDIT'.tr(), () => callback(task));
  }

  Widget generateFeedbackButton(JanitorTask task) {
    void callback(JanitorTask task) {
      SzikAppState.analytics.logEvent(name: 'janitor_task_open_feedback');
      var index = widget.manager.indexOf(task);
      widget.manager.feedbackTask(index);
    }

    return generateButton('BUTTON_FEEDBACK'.tr(), () => callback(task));
  }

  Widget generateToInProgressButton(JanitorTask task) {
    void callback(JanitorTask task) {
      SzikAppState.analytics.logEvent(name: 'janitor_task_marked_in_progress');
      task.status = TaskStatus.inProgress;
      widget.manager.updateTask(task);
    }

    return generateButton(
        'JANITOR_BUTTON_START_TASK'.tr(), () => callback(task));
  }

  Widget generateToAwaitingApprovalButton(JanitorTask task) {
    void callback(JanitorTask task) {
      SzikAppState.analytics
          .logEvent(name: 'janitor_task_marked_awaiting_approval');
      task.status = TaskStatus.awaitingApproval;
      widget.manager.updateTask(task);
    }

    return generateButton(
        'JANITOR_BUTTON_FINISH_TASK'.tr(), () => callback(task));
  }

  Widget generateToIrresolvable(JanitorTask task) {
    void callback(JanitorTask task) {
      SzikAppState.analytics.logEvent(name: 'janitor_task_marked_irresolvable');
      task.status = TaskStatus.irresolvable;
      widget.manager.updateTask(task);
    }

    return generateButton(
        'JANITOR_BUTTON_IRRESOLVABLE_TASK'.tr(), () => callback(task));
  }

  Widget generateToApprovedButton(JanitorTask task) {
    void callback(JanitorTask task) {
      SzikAppState.analytics.logEvent(name: 'janitor_task_approve');
      task.status = TaskStatus.approved;
      widget.manager.updateTask(task);
    }

    return generateButton(
        'JANITOR_BUTTON_APPROVE_TASK'.tr(), () => callback(task));
  }

  Widget generateToRefusedButton(JanitorTask task) {
    void callback(JanitorTask task) {
      SzikAppState.analytics.logEvent(name: 'janitor_task_marked_refused');
      task.status = TaskStatus.refused;
      widget.manager.updateTask(task);
    }

    return generateButton(
        'JANITOR_BUTTON_REFUSE_TASK'.tr(), () => callback(task));
  }

  Widget generateButton(String text, VoidCallback onPressed) {
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
      padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
        (states) => const EdgeInsets.symmetric(
          horizontal: kPaddingNormal,
          vertical: kPaddingSmall,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(kPaddingSmall),
      child: OutlinedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          text,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackList(JanitorTask task) {
    var theme = Theme.of(context);
    var leftColumnWidth = MediaQuery.of(context).size.width * 0.25;
    var user = Provider.of<AuthManager>(context, listen: false).user!;
    var userIsParticipant = user.hasPermissionToModify(task: task);
    var userIsJanitor = widget.manager.getJanitorIDs(context).contains(user.id);
    var place = Provider.of<SzikAppStateManager>(context)
        .places
        .firstWhere((place) => place.id == task.placeID);
    var userCanSee = place.type == PlaceType.room
        ? userIsParticipant || userIsJanitor
        : true;

    return userCanSee && task.feedback.isNotEmpty
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
                      color: theme.colorScheme.primaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(kPaddingNormal),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border:
                          Border.all(color: theme.colorScheme.primaryContainer),
                      borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: task.feedback.map(
                        (item) {
                          var feedbackWriter =
                              Provider.of<SzikAppStateManager>(context)
                                  .users
                                  .firstWhere((user) => user.id == item.userID)
                                  .name;
                          var time = item.lastUpdate;
                          return Text(
                            '$feedbackWriter - ${time.month}. ${time.day}. ${time.hour}:${time.minute}\n${item.message}\n',
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primaryContainer,
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
