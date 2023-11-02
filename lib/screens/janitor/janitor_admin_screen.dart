import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../main.dart';
import '../../models/tasks.dart';
import '../../navigation/app_state_manager.dart';
import '../../ui/themes.dart';

class JanitorAdminScreen extends StatefulWidget {
  static const String route = '/janitor/admin';

  static MaterialPage page({
    required JanitorTask item,
    int index = -1,
    required Function(JanitorTask, int) onDelete,
    required Function(JanitorTask, int) onUpdate,
  }) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: JanitorAdminScreen(
        originalItem: item,
        index: index,
        onDelete: onDelete,
        onUpdate: onUpdate,
      ),
    );
  }

  final Function(JanitorTask, int) onDelete;
  final Function(JanitorTask, int) onUpdate;
  final JanitorTask originalItem;
  final int index;

  const JanitorAdminScreen({
    super.key,
    required this.onDelete,
    required this.onUpdate,
    required this.originalItem,
    this.index = -1,
  });

  @override
  JanitorAdminScreenState createState() => JanitorAdminScreenState();
}

class JanitorAdminScreenState extends State<JanitorAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  TaskStatus? status;
  String answer = '';

  @override
  void initState() {
    super.initState();

    status = widget.originalItem.status;
  }

  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

  void _onAcceptDelete() {
    SzikAppState.analytics.logEvent(name: 'janitor_task_delete');
    widget.onDelete(widget.originalItem, widget.index);
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _onStatusChanged(TaskStatus? newStatus) {
    status = newStatus!;
  }

  void _onAnswerChanged(String? newAnswer) {
    answer = newAnswer!;
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate()) {
      var newItem = widget.originalItem;
      newItem.status = status!;
      newItem.answer = answer;
      SzikAppState.analytics.logEvent(name: 'janitor_task_admin_edit');
      widget.onUpdate(newItem, widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var leftColumnWidth = MediaQuery.of(context).size.width * 0.3;
    var theme = Theme.of(context);
    final confirmDialog = CustomDialog.alert(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: _onAcceptDelete,
    );
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'JANITOR_TITLE_EDIT'.tr(),
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.all(kPaddingLarge),
        child: ListView(
          children: [
            Flex(
              direction: Axis.vertical,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: kPaddingLarge),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: const EdgeInsets.only(right: kPaddingNormal),
                        child: Text(
                          'JANITOR_LABEL_START'.tr(),
                          style: theme.textTheme.displaySmall!.copyWith(
                              fontSize: 14, color: theme.colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.primary),
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
                          padding: const EdgeInsets.all(kPaddingNormal),
                          child: Text(
                            '${widget.originalItem.start.year}. ${widget.originalItem.start.month}. ${widget.originalItem.start.day}.  ${widget.originalItem.start.hour}:${widget.originalItem.start.minute}',
                            style: theme.textTheme.titleLarge!.copyWith(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: kPaddingNormal),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: const EdgeInsets.only(right: kPaddingNormal),
                        child: Text(
                          'JANITOR_LABEL_PLACE'.tr(),
                          style: theme.textTheme.displaySmall!.copyWith(
                              fontSize: 14, color: theme.colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.primary),
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
                          padding: const EdgeInsets.all(kPaddingNormal),
                          child: Text(
                            Provider.of<SzikAppStateManager>(context,
                                    listen: false)
                                .places
                                .firstWhere(
                                  (item) =>
                                      item.id == widget.originalItem.placeID,
                                )
                                .name,
                            style: theme.textTheme.titleLarge!.copyWith(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: kPaddingNormal),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: const EdgeInsets.only(right: kPaddingNormal),
                        child: Text(
                          'JANITOR_LABEL_TITLE'.tr(),
                          style: theme.textTheme.displaySmall!.copyWith(
                              fontSize: 14, color: theme.colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.primary),
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
                          padding: const EdgeInsets.all(kPaddingNormal),
                          child: Text(
                            widget.originalItem.name,
                            style: theme.textTheme.titleLarge!.copyWith(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: kPaddingNormal),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: const EdgeInsets.only(right: kPaddingNormal),
                        child: Text(
                          'JANITOR_LABEL_DESCRIPTION'.tr(),
                          style: theme.textTheme.displaySmall!.copyWith(
                              fontSize: 14, color: theme.colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.primary),
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                          ),
                          padding: const EdgeInsets.all(kPaddingNormal),
                          child: Text(
                            widget.originalItem.description ??
                                'PLACEHOLDER_NOT_PROVIDED'.tr(),
                            style: theme.textTheme.titleLarge!.copyWith(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: kPaddingLarge),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: kPaddingLarge),
                          child: Row(
                            children: [
                              Container(
                                width: leftColumnWidth,
                                margin: const EdgeInsets.only(
                                    right: kPaddingNormal),
                                child: Text(
                                  'JANITOR_LABEL_STATUS'.tr(),
                                  style: theme.textTheme.displaySmall!.copyWith(
                                      fontSize: 14,
                                      color: theme.colorScheme.secondary),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Expanded(
                                child: SearchableOptions<TaskStatus>(
                                  items: TaskStatus.values,
                                  selectedItem: widget.originalItem.status,
                                  onItemChanged: _onStatusChanged,
                                  compare: (i, s) => i!.isEqual(s),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: kPaddingNormal),
                          child: Row(
                            children: [
                              Container(
                                width: leftColumnWidth,
                                margin: const EdgeInsets.only(
                                    right: kPaddingNormal),
                                child: Text(
                                  'JANITOR_LABEL_ANSWER'.tr(),
                                  style: theme.textTheme.displaySmall!.copyWith(
                                    fontSize: 14,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: widget.originalItem.answer,
                                  validator: _validateTextField,
                                  style: theme.textTheme.displaySmall!.copyWith(
                                    fontSize: 14,
                                    color: theme.colorScheme.primaryContainer,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kBorderRadiusSmall),
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.secondary,
                                        width: 2,
                                      ),
                                    ),
                                    hintText: 'PLACEHOLDER_ANSWER'.tr(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kBorderRadiusSmall),
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.secondary,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.all(kPaddingSmall),
                                  ),
                                  onChanged: _onAnswerChanged,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: kPaddingNormal),
                          child: Row(
                            children: [
                              Container(
                                width: leftColumnWidth,
                                margin: const EdgeInsets.only(
                                    right: kPaddingNormal),
                                child: IconButton(
                                  icon: CustomIcon(
                                    CustomIcons.trash,
                                    size: kIconSizeLarge,
                                    color: theme.colorScheme.secondaryContainer,
                                  ),
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (context) => confirmDialog,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _onEditSent,
                                  child: Text(
                                    'BUTTON_SEND'.tr(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
