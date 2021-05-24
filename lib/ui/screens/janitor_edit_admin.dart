import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/janitor.dart';
import '../../main.dart';
import '../../models/tasks.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/searchable_options.dart';

class JanitorEditAdminArguments {
  JanitorTask task;

  JanitorEditAdminArguments({required this.task});
}

class JanitorEditAdminScreen extends StatefulWidget {
  static const String route = '/janitor/adminedit';

  final JanitorTask task;

  JanitorEditAdminScreen({Key? key, required this.task}) : super(key: key);

  @override
  _JanitorEditAdminScreenState createState() => _JanitorEditAdminScreenState();
}

class _JanitorEditAdminScreenState extends State<JanitorEditAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Janitor janitor;
  TaskStatus? status;
  String? answer;

  @override
  void initState() {
    super.initState();
    janitor = Janitor();
    status = widget.task.status;
  }

  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

  void _onAcceptDelete() {
    janitor.deleteTask(widget.task);
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop(true);
  }

  void _onStatusChanged(TaskStatus? newStatus) {
    status = newStatus!;
  }

  void _onAnswerChanged(String? newAnswer) {
    answer = newAnswer!;
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate()) {
      var task = widget.task;
      task.status = status!;
      task.answer = answer;
      janitor.editTask(task);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var leftColumnWidth = width * 0.3;
    var theme = Theme.of(context);
    final confirmDialog = CustomAlertDialog(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onAcceptText: 'BUTTON_YES'.tr(),
      onAccept: _onAcceptDelete,
      onCancelText: 'BUTTON_NO'.tr(),
      onCancel: () => Navigator.of(context, rootNavigator: true).pop(),
    );
    if (SZIKAppState.places.isEmpty) SZIKAppState.loadEarlyData();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: theme.colorScheme.background,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            //Title
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                'JANITOR_TITLE_EDIT_ADMIN'.tr(),
                style: theme.textTheme.headline2!.copyWith(
                  color: theme.colorScheme.primaryVariant,
                  fontSize: 24,
                ),
              ),
            ),
            //Fields
            Flex(
              direction: Axis.vertical,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          'JANITOR_LABEL_START'.tr(),
                          style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14, color: theme.colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${widget.task.start.year}. ${widget.task.start.month}. ${widget.task.start.day}.  ${widget.task.start.hour}:${widget.task.start.minute}',
                          style: theme.textTheme.headline6!.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          'JANITOR_LABEL_PLACE'.tr(),
                          style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14, color: theme.colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          SZIKAppState.places
                              .firstWhere((element) =>
                                  element.id == widget.task.placeID)
                              .name,
                          style: theme.textTheme.headline6!.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          'JANITOR_LABEL_TITLE'.tr(),
                          style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14, color: theme.colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.task.name,
                          style: theme.textTheme.headline6!.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          'JANITOR_LABEL_DESCRIPTION'.tr(),
                          style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14, color: theme.colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.task.description ??
                              'PLACEHOLDER_NOT_PROVIDED'.tr(),
                          style: theme.textTheme.headline6!.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Container(
                              width: leftColumnWidth,
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                'JANITOR_LABEL_STATUS'.tr(),
                                style: theme.textTheme.headline3!.copyWith(
                                    fontSize: 14,
                                    color: theme.colorScheme.primary),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Expanded(
                              child: SearchableOptions<TaskStatus>(
                                items: TaskStatus.values,
                                selectedItem: widget.task.status,
                                onItemChanged: _onStatusChanged,
                                compare: (i, s) => i.isEqual(s),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Container(
                              width: leftColumnWidth,
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                'JANITOR_LABEL_ANSWER'.tr(),
                                style: theme.textTheme.headline3!.copyWith(
                                    fontSize: 14,
                                    color: theme.colorScheme.secondary),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                initialValue: widget.task.answer,
                                validator: _validateTextField,
                                style: theme.textTheme.headline3!.copyWith(
                                  fontSize: 14,
                                  color: theme.colorScheme.primaryVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'PLACEHOLDER_ANSWER'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.secondary,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                                onChanged: _onAnswerChanged,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Container(
                                width: leftColumnWidth,
                                margin: EdgeInsets.only(right: 10),
                                child: IconButton(
                                  icon: ColorFiltered(
                                    child: Image.asset(
                                        'assets/icons/trash_light_72.png'),
                                    colorFilter: ColorFilter.mode(
                                        theme.colorScheme.secondaryVariant
                                            .withOpacity(0.7),
                                        BlendMode.srcIn),
                                  ),
                                  onPressed: () {
                                    showDialog<void>(
                                        context: context,
                                        builder: (context) => confirmDialog);
                                  },
                                )),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: _onEditSent,
                                child: Text('JANITOR_BUTTON_SEND'.tr()),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
