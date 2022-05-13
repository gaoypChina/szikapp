import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../business/auth_manager.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/models.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';

class JanitorCreateEditScreen extends StatefulWidget {
  static const String route = '/janitor/createedit';

  static MaterialPage page({
    JanitorTask? originalItem,
    bool isFeedback = false,
    int index = -1,
    required Function(JanitorTask) onCreate,
    required Function(JanitorTask, int) onUpdate,
    required Function(JanitorTask, int) onDelete,
  }) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: JanitorCreateEditScreen(
        originalItem: originalItem,
        isFeedback: isFeedback,
        index: index,
        onCreate: onCreate,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
    );
  }

  final bool isEdit;
  final bool isFeedback;
  final JanitorTask? originalItem;
  final int index;
  final Function(JanitorTask) onCreate;
  final Function(JanitorTask, int) onDelete;
  final Function(JanitorTask, int) onUpdate;

  const JanitorCreateEditScreen({
    Key? key,
    this.isFeedback = false,
    this.originalItem,
    this.index = -1,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
  })  : isEdit = (originalItem != null),
        super(key: key);

  @override
  JanitorCreateEditScreenState createState() => JanitorCreateEditScreenState();
}

class JanitorCreateEditScreenState extends State<JanitorCreateEditScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Place> places = [];
  String? placeID;
  String? title;
  String? description;
  String? feedback;

  @override
  void initState() {
    super.initState();
    places = Provider.of<SzikAppStateManager>(context, listen: false).places;
    placeID = places.first.id;
    if (widget.isFeedback || widget.isEdit) {
      title = widget.originalItem!.name;
      description = widget.originalItem!.description;
      placeID = widget.originalItem!.placeID;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var leftColumnWidth = width * 0.3;
    var theme = Theme.of(context);
    final confirmDialog = CustomDialog.alert(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: _onAcceptDelete,
    );
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: widget.isEdit
          ? 'JANITOR_TITLE_EDIT'.tr()
          : 'JANITOR_TITLE_CREATE'.tr(),
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: kPaddingNormal),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: kPaddingLarge,
                bottom: kPaddingNormal,
              ),
              width: width * 0.5,
              height: width * 0.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/pictures/gyuri_800.png'),
                    fit: BoxFit.contain),
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
                    margin: const EdgeInsets.only(top: kPaddingNormal),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: Text(
                            'JANITOR_LABEL_PLACE'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: SearchableOptions<Place>(
                            items: places,
                            selectedItem: widget.isEdit
                                ? places.firstWhere((element) =>
                                    element.id == widget.originalItem!.placeID)
                                : places.first,
                            onItemChanged: _onPlaceChanged,
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
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: Text(
                            'JANITOR_LABEL_TITLE'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: widget.isFeedback,
                            initialValue: widget.isEdit || widget.isFeedback
                                ? widget.originalItem!.name
                                : null,
                            validator: _validateTextField,
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primaryContainer,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              hintText: 'PLACEHOLDER_TITLE'.tr(),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadiusSmall),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.all(kPaddingSmall),
                            ),
                            onChanged: _onTitleChanged,
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
                            widget.isFeedback
                                ? 'JANITOR_LABEL_FEEDBACK'.tr()
                                : 'JANITOR_LABEL_DESCRIPTION'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: (widget.isEdit && !widget.isFeedback)
                                ? widget.originalItem!.description
                                : null,
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primaryContainer,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              hintText: 'PLACEHOLDER_DESCRIPTION'.tr(),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadiusSmall),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.all(kPaddingSmall),
                            ),
                            onChanged: _onDescriptionChanged,
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
                          child: widget.isEdit
                              ? IconButton(
                                  icon: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        theme.colorScheme.secondaryContainer,
                                        BlendMode.srcIn),
                                    child: Image.asset(
                                        'assets/icons/trash_light_72.png'),
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

  void _onTitleChanged(String title) {
    this.title = title;
  }

  void _onDescriptionChanged(String text) {
    widget.isFeedback ? feedback = text : description = text;
  }

  void _onNewSent() {
    if (_formKey.currentState!.validate()) {
      var uuid = const Uuid();
      var task = JanitorTask(
        id: uuid.v4().toUpperCase(),
        name: title!,
        description: description,
        start: DateTime.now(),
        end: DateTime.now(),
        type: TaskType.janitor,
        lastUpdate: DateTime.now(),
        placeID: placeID!,
        //Gondnok ID !!
        participantIDs: <String>[
          Provider.of<AuthManager>(context, listen: false).user!.id,
          'u904'
        ],
        status: TaskStatus.created,
      );
      task.status = TaskStatus.sent;

      SZIKAppState.analytics.logEvent(name: 'create_sent_janitor_task');
      widget.onCreate(task);
    }
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate()) {
      var task = widget.originalItem;
      task!.name = title!;
      widget.isFeedback
          ? task.feedback.add(
              Feedback(
                id: const Uuid().v4().toUpperCase(),
                userID:
                    Provider.of<AuthManager>(context, listen: false).user!.id,
                message: feedback ?? '',
                lastUpdate: DateTime.now(),
              ),
            )
          : task.description = description;

      task.placeID = placeID!;

      SZIKAppState.analytics.logEvent(name: 'edit_sent_janitor_task');
      widget.onUpdate(task, widget.index);
    }
  }

  void _onAcceptDelete() {
    SZIKAppState.analytics.logEvent(name: 'delete_janitor_task');
    widget.onDelete(widget.originalItem!, widget.index);
    Navigator.of(context, rootNavigator: true).pop();
  }
}
