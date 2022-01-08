import 'package:accordion/accordion.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/tasks.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';
import 'error_screen.dart';

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
    return FutureBuilder<void>(
      future: manager.refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //Shrimmer
          return const Scaffold();
        } else if (snapshot.hasError) {
          if (SZIKAppState.connectionStatus == ConnectivityResult.none) {
            return ErrorScreen(
              errorInset: ErrorHandler.buildInset(
                context,
                errorCode: noConnectionExceptionCode,
              ),
            );
          }
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          return const JanitorListView();
        }
      },
    );
  }
}

class JanitorListView extends StatefulWidget {
  const JanitorListView({Key? key}) : super(key: key);

  @override
  State<JanitorListView> createState() => _JanitorListViewState();
}

class _JanitorListViewState extends State<JanitorListView> {
  List<JanitorTask> items = [];
  late final JanitorManager manager;

  @override
  void initState() {
    super.initState();
    manager = Provider.of<JanitorManager>(context, listen: false);
    items = manager.tasks;
  }

  void _onTabChanged(int? newValue) {
    List<JanitorTask> newItems;
    switch (newValue) {
      case 2:
        var ownID = Provider.of<AuthManager>(context, listen: false).user!.id;
        newItems = manager.filter(involvedID: ownID);
        break;
      case 1:
        newItems = manager.filter(statuses: [
          TaskStatus.sent,
          TaskStatus.in_progress,
          TaskStatus.awaiting_approval
        ]);
        break;
      default:
        newItems = manager.filter();
    }
    setState(() {
      items = newItems;
    });
  }

  void _onCreateTask() {
    SZIKAppState.analytics.logEvent(name: 'create_open_janitor_task');
    manager.createNewTask();
  }

  void _onEditPressed(JanitorTask task) {
    SZIKAppState.analytics.logEvent(name: 'edit_open_janitor_task');
    var index = manager.tasks.indexOf(task);
    manager.editTask(index);
  }

  void _onEditJanitorPressed(JanitorTask task) {
    SZIKAppState.analytics.logEvent(name: 'edit_admin_open_janitor_task');
    var index = manager.tasks.indexOf(task);
    manager.adminEditTask(index);
  }

  void _onFeedbackPressed(JanitorTask task) {
    if (task.status == TaskStatus.awaiting_approval ||
        task.status == TaskStatus.approved) {
      SZIKAppState.analytics.logEvent(name: 'feedback_open_janitor_task');
      var index = manager.tasks.indexOf(task);
      manager.feedbackTask(index);
    }
  }

  void _onApprovePressed(JanitorTask task) {
    if (task.status == TaskStatus.awaiting_approval) {
      SZIKAppState.analytics.logEvent(name: 'approve_janitor_task');
      manager.updateStatus(TaskStatus.approved, task);
    }
  }

  List<Widget> _buildActionButtons(JanitorTask task) {
    var buttons = <Widget>[];
    var userID = Provider.of<AuthManager>(context, listen: false).user!.id;
    if ((task.involvedIDs!.contains(userID) &&
            (task.status == TaskStatus.sent ||
                task.status == TaskStatus.in_progress)) ||
        userID == 'u904') {
      buttons.add(OutlinedButton(
        onPressed: () => userID == 'u904'
            ? _onEditJanitorPressed(task)
            : _onEditPressed(task),
        child: Text('BUTTON_EDIT'.tr()),
      ));
    }
    if (task.status == TaskStatus.approved ||
        task.status == TaskStatus.awaiting_approval) {
      buttons.add(OutlinedButton(
        onPressed: () => _onFeedbackPressed(task),
        child: Text('BUTTON_FEEDBACK'.tr()),
      ));
    }
    if (task.involvedIDs!.contains(userID) &&
        task.status == TaskStatus.awaiting_approval) {
      buttons.add(OutlinedButton(
        onPressed: () => _onApprovePressed(task),
        child: Text('BUTTON_APPROVE'.tr()),
      ));
    }

    return buttons;
  }

  Future<void> _onManualRefresh() async {
    await manager.refresh();
    setState(() {
      items = manager.tasks;
    });
  }

  Widget _buildFeedbackList(BuildContext context, JanitorTask task) {
    var theme = Theme.of(context);
    var leftColumnWidth = MediaQuery.of(context).size.width * 0.25;
    return Provider.of<AuthManager>(context, listen: false).user!.id ==
                'u904' &&
            task.feedback!.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(bottom: 8),
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: theme.colorScheme.background, width: 1),
                      borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: task.feedback!.map(
                        (item) {
                          return Text(
                            '${item.timestamp.month}. ${item.timestamp.day}: ${item.message}',
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
    return SzikAppScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'JANITOR_TITLE'.tr(),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        color: theme.colorScheme.background,
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
                      child: Accordion(
                        headerPadding: const EdgeInsets.all(20),
                        headerBackgroundColor: theme.colorScheme.background,
                        contentBackgroundColor: theme.colorScheme.background,
                        headerBorderRadius: kBorderRadiusNormal,
                        rightIcon: ColorFiltered(
                          child: Image.asset('assets/icons/down_light_72.png',
                              height: theme.textTheme.headline3!.fontSize),
                          colorFilter: ColorFilter.mode(
                              theme.colorScheme.background, BlendMode.srcIn),
                        ),
                        children: items.map<AccordionSection>((item) {
                          var leftColumnWidth =
                              MediaQuery.of(context).size.width * 0.25;
                          return AccordionSection(
                            headerText:
                                '${item.start.month}. ${item.start.day}.',
                            headerTextStyle:
                                theme.textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: theme.colorScheme.background,
                            ),
                            headerBackgroundColor:
                                taskStatusColors[item.status]!,
                            contentBackgroundColor:
                                taskStatusColors[item.status]!,
                            leftIcon: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                Provider.of<SzikAppStateManager>(context,
                                        listen: false)
                                    .places
                                    .firstWhere(
                                        (element) => element.id == item.placeID)
                                    .name,
                                style: theme.textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: theme.colorScheme.background,
                                ),
                              ),
                            ),
                            content: Flex(
                              direction: Axis.vertical,
                              children: [
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: theme.colorScheme.background,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 8),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: leftColumnWidth,
                                        child: Text(
                                          'JANITOR_LABEL_TITLE'.tr(),
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                            fontSize: 14,
                                            color: theme.colorScheme.background,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: theme
                                                      .colorScheme.background,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kBorderRadiusNormal)),
                                          child: Text(
                                            item.name,
                                            style: theme.textTheme.subtitle1!
                                                .copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: leftColumnWidth,
                                        child: Text(
                                          'JANITOR_LABEL_DESCRIPTION'.tr(),
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                            fontSize: 14,
                                            color: theme.colorScheme.background,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: theme
                                                      .colorScheme.background,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kBorderRadiusNormal)),
                                          child: Text(
                                            item.description ?? '',
                                            style: theme.textTheme.subtitle1!
                                                .copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: leftColumnWidth,
                                        child: Text(
                                          'JANITOR_LABEL_START'.tr(),
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                            fontSize: 14,
                                            color: theme.colorScheme.background,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: theme
                                                      .colorScheme.background,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kBorderRadiusNormal)),
                                          child: Text(
                                            '${item.start.year}. ${item.start.month}. ${item.start.day}.  ${item.start.hour}:${item.start.minute}',
                                            style: theme.textTheme.subtitle1!
                                                .copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: leftColumnWidth,
                                        child: Text(
                                          'JANITOR_LABEL_STATUS'.tr(),
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                            fontSize: 14,
                                            color: theme.colorScheme.background,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: theme
                                                      .colorScheme.background,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kBorderRadiusNormal)),
                                          child: Text(
                                            item.status.toShortString(),
                                            style: theme.textTheme.subtitle1!
                                                .copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                item.answer == null
                                    ? Container()
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: leftColumnWidth,
                                              child: Text(
                                                'JANITOR_LABEL_ANSWER'.tr(),
                                                style: theme
                                                    .textTheme.bodyText1!
                                                    .copyWith(
                                                  fontSize: 14,
                                                  color: theme
                                                      .colorScheme.background,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                        color: theme.colorScheme
                                                            .background,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Text(
                                                  item.answer!,
                                                  style: theme
                                                      .textTheme.subtitle1!
                                                      .copyWith(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme
                                                        .colorScheme.background,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                _buildFeedbackList(context, item),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: _buildActionButtons(item),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateTask,
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(width: 36, height: 36),
          child: Image.asset('assets/icons/plus_light_72.png'),
        ),
      ),
    );
  }
}
