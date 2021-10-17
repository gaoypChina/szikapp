import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:uuid/uuid.dart';

import '../../business/janitor.dart';
import '../../main.dart';
import '../../models/resource.dart';
import '../../models/tasks.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/searchable_options.dart';

class JanitorNewEditArguments {
  bool isEdit;
  bool isFeedback;
  JanitorTask? task;

  JanitorNewEditArguments({
    this.isEdit = false,
    this.isFeedback = false,
    this.task,
  });
}

class JanitorNewEditScreen extends StatefulWidget {
  static const String route = '/janitor/newedit';

  final bool isEdit;
  final bool isFeedback;
  final JanitorTask? task;

  const JanitorNewEditScreen({
    Key? key,
    this.isEdit = false,
    this.isFeedback = false,
    this.task,
  }) : super(key: key);

  @override
  _JanitorNewEditScreenState createState() => _JanitorNewEditScreenState();
}

class _JanitorNewEditScreenState extends State<JanitorNewEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Janitor janitor;
  String? placeID;
  String? title;
  String? description;
  String? feedback;

  @override
  void initState() {
    super.initState();
    janitor = Janitor();
    if (SZIKAppState.places.isNotEmpty) placeID = SZIKAppState.places.first.id;
    if (widget.isFeedback) {
      title = widget.task!.name;
      description = widget.task!.description;
      placeID = widget.task!.placeID;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var leftColumnWidth = width * 0.3;
    var theme = Theme.of(context);
    final confirmDialog = CustomAlertDialog(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onAcceptText: 'BUTTON_YES'.tr().toLowerCase(),
      onAccept: _onAcceptDelete,
      onCancelText: 'BUTTON_NO'.tr().toLowerCase(),
      onCancel: () => Navigator.of(context, rootNavigator: true).pop(),
    );
    if (SZIKAppState.places.isEmpty) SZIKAppState.loadEarlyData();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.all(10),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Picture
            Container(
              width: width * 0.7,
              height: width * 0.7,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/pictures/gyuri_800.png'),
                    fit: BoxFit.contain),
              ),
            ),
            //Title
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                widget.isEdit
                    ? 'JANITOR_TITLE_EDIT'.tr().toUpperCase()
                    : 'JANITOR_TITLE_CREATE'.tr().toUpperCase(),
                style: theme.textTheme.headline1!.copyWith(
                  color: theme.colorScheme.secondary,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 2,
              indent: 25,
              endIndent: 25,
              color: theme.colorScheme.secondary,
            ),
            //Details, text fields and buttons
            Form(
              key: _formKey,
              child: Flex(
                direction: Axis.vertical,
                /*child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,*/
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            'JANITOR_LABEL_PLACE'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: SearchableOptions<Place>(
                            items: SZIKAppState.places,
                            selectedItem: widget.isEdit
                                ? SZIKAppState.places.firstWhere((element) =>
                                    element.id == widget.task!.placeID)
                                : SZIKAppState.places.first,
                            onItemChanged: _onPlaceChanged,
                            compare: (i, s) => i.isEqual(s),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            'JANITOR_LABEL_TITLE'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            readOnly: widget.isFeedback,
                            initialValue:
                                widget.isEdit ? widget.task!.name : null,
                            validator: _validateTextField,
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primaryVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              hintText: 'PLACEHOLDER_TITLE'.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(5),
                            ),
                            onChanged: _onTitleChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            widget.isFeedback
                                ? 'JANITOR_LABEL_FEEDBACK'.tr()
                                : 'JANITOR_LABEL_DESCRIPTION'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: (widget.isEdit && !widget.isFeedback)
                                ? widget.task!.description
                                : null,
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primaryVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              hintText: 'PLACEHOLDER_DESCRIPTION'.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(5),
                            ),
                            onChanged: _onDescriptionChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: widget.isEdit
                              ? IconButton(
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
                                )
                              : Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: widget.isEdit ? _onEditSent : _onNewSent,
                            child: Text(widget.isEdit
                                ? 'BUTTON_SAVE'.tr()
                                : 'BUTTON_SEND'.tr()),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: kBottomNavigationBarHeight,
            )
          ],
        ),
      ),
    );
  }

  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

  void _onPlaceChanged(Place? item) {
    placeID = item!.id;
  }

  void _onTitleChanged(String? title) {
    this.title = title ?? '';
  }

  void _onDescriptionChanged(String? text) {
    widget.isFeedback ? feedback = text ?? '' : description = text ?? '';
  }

  void _onNewSent() {
    if (_formKey.currentState!.validate()) {
      var uuid = const Uuid();
      var task = JanitorTask(
          uid: uuid.v4(),
          name: title!,
          description: description,
          start: DateTime.now(),
          end: DateTime.now(),
          type: TaskType.janitor,
          lastUpdate: DateTime.now(),
          placeID: placeID!,
          //Gondnok ID !!
          involved: <String>[SZIKAppState.authManager.user!.id, 'u904'],
          status: TaskStatus.created);
      task.status = TaskStatus.sent;
      janitor.addTask(task);
      SZIKAppState.analytics.logEvent(name: 'create_sent_janitor_task');
      Navigator.of(context).pop(true);
    }
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate()) {
      var task = widget.task;
      task!.name = title!;
      widget.isFeedback
          ? task.feedback!.add(Feedback(
              user: SZIKAppState.authManager.user!.id,
              message: feedback ?? '',
              timestamp: DateTime.now(),
            ))
          : task.description = description;
      task.placeID = placeID!;
      janitor.editTask(task);
      SZIKAppState.analytics.logEvent(name: 'edit_sent_janitor_task');
      Navigator.of(context).pop(true);
    }
  }

  void _onAcceptDelete() {
    janitor.deleteTask(widget.task!);
    SZIKAppState.analytics.logEvent(name: 'delete_janitor_task');
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop(true);
  }
}
