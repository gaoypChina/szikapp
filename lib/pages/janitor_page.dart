import 'package:accordion/accordion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/janitor.dart';
import '../main.dart';
import '../models/tasks.dart';
import '../ui/screens/error_screen.dart';
import '../ui/screens/janitor_edit_admin.dart';
import '../ui/screens/janitor_new_edit.dart';
import '../ui/themes.dart';
import '../ui/widgets/tab_choice.dart';

class JanitorPage extends StatefulWidget {
  static const String route = '/janitor';
  JanitorPage({Key? key}) : super(key: key);

  @override
  _JanitorPageState createState() => _JanitorPageState();
}

class _JanitorPageState extends State<JanitorPage> {
  late final Janitor janitor;

  @override
  void initState() {
    super.initState();
    janitor = Janitor();
    if (SZIKAppState.places.isEmpty) SZIKAppState.loadEarlyData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: janitor.refresh(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Shrimmer
            return Scaffold();
          } else if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
          } else {
            return JanitorListView();
          }
        });
  }
}

class JanitorListView extends StatefulWidget {
  JanitorListView({Key? key}) : super(key: key);

  @override
  _JanitorListViewState createState() => _JanitorListViewState();
}

class _JanitorListViewState extends State<JanitorListView> {
  late Janitor janitor;
  late List<JanitorTask> items;

  @override
  void initState() {
    super.initState();
    janitor = Janitor();
    items = janitor.janitorTasks;
  }

  void _onTabChanged(int? newValue) {
    var newItems;
    switch (newValue) {
      case 2:
        var ownID = SZIKAppState.authManager.user!.id;
        newItems = janitor.filter(involvedID: ownID);
        break;
      case 1:
        newItems = janitor.filter(statuses: [
          TaskStatus.sent,
          TaskStatus.in_progress,
          TaskStatus.awaiting_approval
        ]);
        break;
      default:
        newItems = janitor.filter();
    }
    setState(() {
      items = newItems;
    });
  }

  void _onCreateTask() {
    Navigator.of(context).pushNamed(JanitorNewEditScreen.route,
        arguments: JanitorNewEditArguments(isEdit: false));
  }

  void _onEditPressed(JanitorTask task) {
    Navigator.of(context).pushNamed(JanitorNewEditScreen.route,
        arguments: JanitorNewEditArguments(isEdit: true, task: task));
  }

  void _onEditJanitorPressed(JanitorTask task) {
    Navigator.of(context).pushNamed(JanitorEditAdminScreen.route,
        arguments: JanitorEditAdminArguments(task: task));
  }

  void _onFeedbackPressed(JanitorTask task) {
    if (task.status == TaskStatus.awaiting_approval ||
        task.status == TaskStatus.approved) {
      Navigator.of(context).pushNamed(JanitorNewEditScreen.route,
          arguments: JanitorNewEditArguments(
              isEdit: true, isFeedback: true, task: task));
    }
  }

  void _onApprovePressed(JanitorTask task) {
    if (task.status == TaskStatus.awaiting_approval) {
      janitor.editStatus(TaskStatus.approved, task);
    }
  }

  List<Widget> _buildActionButtons(JanitorTask task) {
    var buttons = <Widget>[];
    if ((task.involvedIDs!.contains(SZIKAppState.authManager.user!.id) &&
            (task.status == TaskStatus.sent ||
                task.status == TaskStatus.in_progress)) ||
        SZIKAppState.authManager.user!.id == 'u904') {
      buttons.add(OutlinedButton(
        onPressed: () => SZIKAppState.authManager.user!.id == 'u904'
            ? _onEditJanitorPressed(task)
            : _onEditPressed(task),
        child: Text('JANITOR_BUTTON_EDIT'.tr()),
      ));
    }
    if (task.status == TaskStatus.approved ||
        task.status == TaskStatus.awaiting_approval) {
      buttons.add(OutlinedButton(
        onPressed: () => _onFeedbackPressed(task),
        child: Text('JANITOR_BUTTON_FEEDBACK'.tr()),
      ));
    }
    if (task.involvedIDs!.contains(SZIKAppState.authManager.user!.id) &&
        task.status == TaskStatus.awaiting_approval) {
      buttons.add(OutlinedButton(
        onPressed: () => _onApprovePressed(task),
        child: Text('JANITOR_BUTTON_APPROVE'.tr()),
      ));
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 30, 10, kBottomNavigationBarHeight),
      color: theme.colorScheme.background,
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'JANITOR_TITLE'.tr().toUpperCase(),
                  style: theme.textTheme.headline2!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
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
                  : Accordion(
                      headerPadding: EdgeInsets.all(20),
                      headerBorderRadius: 20,
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
                          headerText: '${item.start.month}. ${item.start.day}.',
                          headerTextStyle: theme.textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.colorScheme.background,
                          ),
                          headerBackgroundColor:
                              statusColors[item.status]!.withOpacity(0.65),
                          contentBackgroundColor:
                              statusColors[item.status]!.withOpacity(0.65),
                          leftIcon: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              SZIKAppState.places
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
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: leftColumnWidth,
                                      child: Text(
                                        'JANITOR_LABEL_TITLE'.tr(),
                                        style:
                                            theme.textTheme.bodyText1!.copyWith(
                                          fontSize: 14,
                                          color: theme.colorScheme.background,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: theme
                                                    .colorScheme.background,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          item.name,
                                          style: theme.textTheme.subtitle1!
                                              .copyWith(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: leftColumnWidth,
                                      child: Text(
                                        'JANITOR_LABEL_DESCRIPTION'.tr(),
                                        style:
                                            theme.textTheme.bodyText1!.copyWith(
                                          fontSize: 14,
                                          color: theme.colorScheme.background,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: theme
                                                    .colorScheme.background,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          item.description ?? '',
                                          style: theme.textTheme.subtitle1!
                                              .copyWith(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: leftColumnWidth,
                                      child: Text(
                                        'JANITOR_LABEL_START'.tr(),
                                        style:
                                            theme.textTheme.bodyText1!.copyWith(
                                          fontSize: 14,
                                          color: theme.colorScheme.background,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: theme
                                                    .colorScheme.background,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          '${item.start.year}. ${item.start.month}. ${item.start.day}.  ${item.start.hour}:${item.start.minute}',
                                          style: theme.textTheme.subtitle1!
                                              .copyWith(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: leftColumnWidth,
                                      child: Text(
                                        'JANITOR_LABEL_STATUS'.tr(),
                                        style:
                                            theme.textTheme.bodyText1!.copyWith(
                                          fontSize: 14,
                                          color: theme.colorScheme.background,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: theme
                                                    .colorScheme.background,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          item.status.toShortString(),
                                          style: theme.textTheme.subtitle1!
                                              .copyWith(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.background,
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
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: leftColumnWidth,
                                            child: Text(
                                              'JANITOR_LABEL_ANSWER'.tr(),
                                              style: theme.textTheme.bodyText1!
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
                                              padding: EdgeInsets.all(10),
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
                              Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: _buildActionButtons(item),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onCreateTask,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(width: 36, height: 36),
            child: Image.asset('assets/icons/plus_light_72.png'),
          ),
        ),
      ),
    );
  }
}
