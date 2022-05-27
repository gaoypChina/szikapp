import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_list/toggle_list.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/tasks.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';

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

  const JanitorScreen({Key? key, required this.manager}) : super(key: key);

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

  const JanitorListView({
    Key? key,
    required this.manager,
  }) : super(key: key);

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
    SZIKAppState.analytics.logEvent(name: 'create_open_janitor_task');
    widget.manager.createNewTask();
  }

  void _onEditPressed(JanitorTask task) {
    SZIKAppState.analytics.logEvent(name: 'edit_open_janitor_task');
    var index = widget.manager.indexOf(task);
    widget.manager.editTask(index);
  }

  void _onEditJanitorPressed(JanitorTask task) {
    SZIKAppState.analytics.logEvent(name: 'edit_admin_open_janitor_task');
    var index = widget.manager.indexOf(task);
    widget.manager.adminEditTask(index);
  }

  void _onFeedbackPressed(JanitorTask task) {
    if (task.status == TaskStatus.awaitingApproval ||
        task.status == TaskStatus.approved) {
      SZIKAppState.analytics.logEvent(name: 'feedback_open_janitor_task');
      var index = widget.manager.indexOf(task);
      widget.manager.feedbackTask(index);
    }
  }

  void _onApprovePressed(JanitorTask task) {
    if (task.status == TaskStatus.awaitingApproval) {
      SZIKAppState.analytics.logEvent(name: 'approve_janitor_task');
      widget.manager.updateStatus(TaskStatus.approved, task);
    }
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
        (Set<MaterialState> states) => RoundedRectangleBorder(
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
            style: theme.textTheme.bodyText1!.copyWith(
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
            style: theme.textTheme.bodyText1!.copyWith(
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
            style: theme.textTheme.bodyText1!.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  Future<void> _onManualRefresh() async {
    await widget.manager.refresh();
    setState(() {
      items = widget.manager.tasks;
    });
  }

  Widget _buildFeedbackList(BuildContext context, JanitorTask task) {
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
                    style: theme.textTheme.bodyText1!.copyWith(
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
                      border: Border.all(
                          color: theme.colorScheme.background, width: 1),
                      borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: task.feedback.map(
                        (item) {
                          return Text(
                            '${item.lastUpdate.month}. ${item.lastUpdate.day}: ${item.message}',
                            style: theme.textTheme.subtitle1!.copyWith(
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'JANITOR_TITLE'.tr(),
      body: Container(
        padding: const EdgeInsets.fromLTRB(
          kPaddingNormal,
          kPaddingLarge,
          kPaddingNormal,
          0,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pictures/background_1.jpg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Column(
          children: [
            TabChoice(
              labels: [
                'JANITOR_TAB_ALL'.tr(),
                'JANITOR_TAB_ACTIVE'.tr(),
                'JANITOR_TAB_OWN'.tr(),
              ],
              onChanged: _onTabChanged,
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr(),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _onManualRefresh,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kPaddingNormal),
                        child: ToggleList(
                          divider: const SizedBox(
                            height: 10,
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kPaddingLarge),
                            child: CustomIcon(
                              CustomIcons.doubleArrowDown,
                              size: theme.textTheme.headline3!.fontSize ?? 14,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          children: items.map<ToggleListItem>((item) {
                            var leftColumnWidth =
                                MediaQuery.of(context).size.width * 0.25;
                            return ToggleListItem(
                              headerDecoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(kBorderRadiusNormal),
                                ),
                              ),
                              expandedHeaderDecoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(kBorderRadiusNormal),
                                ),
                              ),
                              title: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: kBorderRadiusNormal,
                                        decoration: BoxDecoration(
                                          color: taskStatusColors[item.status]!,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                            left: Radius.circular(
                                                kBorderRadiusNormal),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            Provider.of<SzikAppStateManager>(
                                                    context,
                                                    listen: false)
                                                .places
                                                .firstWhere((element) =>
                                                    element.id == item.placeID)
                                                .name,
                                            style: theme.textTheme.bodyText1!
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: theme
                                                  .colorScheme.primaryContainer,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${item.start.month}. ${item.start.day}.',
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: theme
                                                .colorScheme.primaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              expandedTitle: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: kBorderRadiusNormal,
                                        decoration: BoxDecoration(
                                          color: taskStatusColors[item.status]!,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(
                                                kBorderRadiusNormal),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            Provider.of<SzikAppStateManager>(
                                                    context,
                                                    listen: false)
                                                .places
                                                .firstWhere((element) =>
                                                    element.id == item.placeID)
                                                .name,
                                            style: theme.textTheme.bodyText1!
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: theme
                                                  .colorScheme.primaryContainer,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${item.start.month}. ${item.start.day}.',
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: theme
                                                .colorScheme.primaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              content: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: kBorderRadiusNormal,
                                        decoration: BoxDecoration(
                                          color: taskStatusColors[item.status]!,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                                kBorderRadiusNormal),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: kBorderRadiusNormal,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(
                                            kBorderRadiusNormal),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          indent: kPaddingNormal,
                                          endIndent: kPaddingNormal,
                                          color: theme
                                              .colorScheme.primaryContainer,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              kPaddingNormal),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical:
                                                            kPaddingNormal),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: leftColumnWidth,
                                                      child: Text(
                                                        'JANITOR_LABEL_TITLE'
                                                            .tr(),
                                                        style: theme.textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                          fontSize: 14,
                                                          color: theme
                                                              .colorScheme
                                                              .primaryContainer,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(
                                                                kPaddingNormal),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          border: Border.all(
                                                            color: theme
                                                                .colorScheme
                                                                .primaryContainer,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            kBorderRadiusNormal,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          item.name,
                                                          style: theme.textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: theme
                                                                .colorScheme
                                                                .primaryContainer,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: kPaddingNormal),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: leftColumnWidth,
                                                      child: Text(
                                                        'JANITOR_LABEL_DESCRIPTION'
                                                            .tr(),
                                                        style: theme.textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                          fontSize: 14,
                                                          color: theme
                                                              .colorScheme
                                                              .primaryContainer,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(
                                                          kPaddingNormal,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          border: Border.all(
                                                            color: theme
                                                                .colorScheme
                                                                .primaryContainer,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            kBorderRadiusNormal,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          item.description ??
                                                              '',
                                                          style: theme.textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: theme
                                                                .colorScheme
                                                                .primaryContainer,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: kPaddingNormal),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: leftColumnWidth,
                                                      child: Text(
                                                        'JANITOR_LABEL_START'
                                                            .tr(),
                                                        style: theme.textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                          fontSize: 14,
                                                          color: theme
                                                              .colorScheme
                                                              .primaryContainer,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(
                                                                kPaddingNormal),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            border: Border.all(
                                                                color: theme
                                                                    .colorScheme
                                                                    .primaryContainer,
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        kBorderRadiusNormal)),
                                                        child: Text(
                                                          '${item.start.year}. ${item.start.month}. ${item.start.day}.  ${item.start.hour}:${item.start.minute}',
                                                          style: theme.textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: theme
                                                                .colorScheme
                                                                .primaryContainer,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: kPaddingNormal),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: leftColumnWidth,
                                                      child: Text(
                                                        'JANITOR_LABEL_STATUS'
                                                            .tr(),
                                                        style: theme.textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                          fontSize: 14,
                                                          color: theme
                                                              .colorScheme
                                                              .primaryContainer,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(
                                                                kPaddingNormal),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            border: Border.all(
                                                                color: theme
                                                                    .colorScheme
                                                                    .primaryContainer,
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        kBorderRadiusNormal)),
                                                        child: Text(
                                                          item.status
                                                              .toString(),
                                                          style: theme.textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: theme
                                                                .colorScheme
                                                                .primaryContainer,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        item.answer == null
                                            ? Container()
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: kPaddingNormal),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: leftColumnWidth,
                                                      child: Text(
                                                        'JANITOR_LABEL_ANSWER'
                                                            .tr(),
                                                        style: theme.textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                          fontSize: 14,
                                                          color: theme
                                                              .colorScheme
                                                              .background,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(
                                                                kPaddingNormal),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            border: Border.all(
                                                                color: theme
                                                                    .colorScheme
                                                                    .background,
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Text(
                                                          item.answer!,
                                                          style: theme.textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: theme
                                                                .colorScheme
                                                                .background,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        _buildFeedbackList(context, item),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: kPaddingNormal),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
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
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _onCreateTask,
        typeToCreate: JanitorTask,
      ),
    );
  }
}
