import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../navigation/app_state_manager.dart';
import '../../ui/themes.dart';

class JanitorCreateEditScreen extends StatefulWidget {
  static const String route = '/janitor/createedit';

  static MaterialPage page({
    JanitorTask? originalItem,
    required JanitorManager manager,
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
        manager: manager,
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
  final JanitorManager manager;
  final Function(JanitorTask) onCreate;
  final Function(JanitorTask, int) onDelete;
  final Function(JanitorTask, int) onUpdate;

  const JanitorCreateEditScreen({
    super.key,
    this.isFeedback = false,
    this.originalItem,
    this.index = -1,
    required this.manager,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
  }) : isEdit = (originalItem != null) && !isFeedback;

  @override
  JanitorCreateEditScreenState createState() => JanitorCreateEditScreenState();
}

class JanitorCreateEditScreenState extends State<JanitorCreateEditScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Place> places = [];
  Place? place;
  String? title;
  String? description;
  List<User> possibleRoommates = [];
  List<User> roommates = [];
  String? feedback;

  @override
  void initState() {
    super.initState();
    var appStateManager =
        Provider.of<SzikAppStateManager>(context, listen: false);
    places = appStateManager.places;
    possibleRoommates = appStateManager.users
        .where((user) => user.groupIDs.contains('g029'))
        .toList();
    possibleRoommates.remove(
      Provider.of<AuthManager>(context, listen: false).user!,
    );
    if (widget.isFeedback || widget.isEdit) {
      title = widget.originalItem!.name;
      description = widget.originalItem!.description;
      place = places
          .firstWhere((place) => place.id == widget.originalItem!.placeID);
      roommates = possibleRoommates
          .where(
              (user) => widget.originalItem!.participantIDs.contains(user.id))
          .toList();
    } else {
      place = places.first;
    }
  }

  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

  void _onPlaceChanged(Place? place) {
    this.place = place!;
  }

  void _onRoommatesChanged(List<User> roommates) {
    this.roommates = roommates;
  }

  void _onTitleChanged(String title) {
    this.title = title;
  }

  void _onDescriptionChanged(String description) {
    this.description = description;
  }

  void _onFeedbackChanged(String feedback) {
    this.feedback = feedback;
  }

  void _onNewSent() {
    var user = Provider.of<AuthManager>(context, listen: false).user!;

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
        placeID: place!.id,
        participantIDs: <String>[
          user.id,
          ...roommates.map((roommate) => roommate.id),
        ],
        managerIDs: widget.manager.getJanitorIDs(context),
        status: TaskStatus.created,
      );
      task.status = TaskStatus.sent;

      SzikAppState.analytics.logEvent(name: 'janitor_task_create');
      widget.onCreate(task);
    }
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate()) {
      var task = widget.originalItem!;
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

      SzikAppState.analytics.logEvent(name: 'janitor_task_edit_feedback');
      widget.onUpdate(task, widget.index);
    }
  }

  void _onAcceptDelete() {
    SzikAppState.analytics.logEvent(name: 'janitor_task_delete');
    widget.onDelete(widget.originalItem!, widget.index);
    Navigator.of(context, rootNavigator: true).pop();
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
    var appBarTitle = '';
    if (widget.isEdit) {
      appBarTitle = 'JANITOR_TITLE_EDIT'.tr();
    } else if (widget.isFeedback) {
      appBarTitle = 'JANITOR_TITLE_FEEDBACK'.tr();
    } else {
      appBarTitle = 'JANITOR_TITLE_CREATE'.tr();
    }
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: appBarTitle,
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: kPaddingNormal),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingLarge),
              child: Center(
                child: Text(
                  'JANITOR_TITLE'.tr().toUpperCase(),
                  style: theme.textTheme.displayLarge!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ),
            Divider(
              color: theme.colorScheme.secondary,
            ),
            Form(
              key: _formKey,
              child: Flex(
                direction: Axis.vertical,
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
                            style: theme.textTheme.displaySmall!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: SearchableOptions<Place>(
                            items: places,
                            selectedItem: widget.isEdit || widget.isFeedback
                                ? places.firstWhere((item) =>
                                    item.id == widget.originalItem!.placeID)
                                : places.first,
                            onItemChanged: _onPlaceChanged,
                            compare: (i, s) => i!.isEqual(s),
                            readonly: widget.isEdit || widget.isFeedback,
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
                          child: TextFormField(
                            readOnly: widget.isEdit || widget.isFeedback,
                            initialValue: widget.isEdit || widget.isFeedback
                                ? widget.originalItem!.name
                                : null,
                            validator: _validateTextField,
                            style: theme.textTheme.displaySmall!.copyWith(
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
                            'JANITOR_LABEL_DESCRIPTION'.tr(),
                            style: theme.textTheme.displaySmall!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: widget.isFeedback,
                            initialValue: widget.isEdit || widget.isFeedback
                                ? widget.originalItem!.description
                                : null,
                            style: theme.textTheme.displaySmall!.copyWith(
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
                  if (place!.type == PlaceType.room)
                    Container(
                      margin: const EdgeInsets.only(top: kPaddingNormal),
                      child: Row(
                        children: [
                          Container(
                            width: leftColumnWidth,
                            margin:
                                const EdgeInsets.only(right: kPaddingNormal),
                            child: Text(
                              'JANITOR_LABEL_ROOMMATE'.tr(),
                              style: theme.textTheme.displaySmall!.copyWith(
                                  fontSize: 14,
                                  color: theme.colorScheme.primary),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            child: SearchableOptions<User>.multiSelection(
                              items: possibleRoommates,
                              selectedItems: widget.isEdit || widget.isFeedback
                                  ? possibleRoommates
                                      .where((item) => widget
                                          .originalItem!.participantIDs
                                          .contains(item.id))
                                      .toList()
                                  : [],
                              onItemsChanged: _onRoommatesChanged,
                              compare: (i, s) => i!.isEqual(s),
                              readonly: widget.isEdit || widget.isFeedback,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.isFeedback) ...[
                    Divider(
                      color: theme.colorScheme.primary,
                      height: kPaddingXLarge,
                      thickness: 2,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: kPaddingNormal),
                      child: Row(
                        children: [
                          Container(
                            width: leftColumnWidth,
                            margin:
                                const EdgeInsets.only(right: kPaddingNormal),
                            child: Text(
                              'JANITOR_LABEL_FEEDBACK'.tr(),
                              style: theme.textTheme.displaySmall!.copyWith(
                                  fontSize: 14,
                                  color: theme.colorScheme.primary),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              style: theme.textTheme.displaySmall!.copyWith(
                                fontSize: 14,
                                color: theme.colorScheme.primaryContainer,
                                fontStyle: FontStyle.italic,
                              ),
                              decoration: InputDecoration(
                                hintText: 'PLACEHOLDER_FEEDBACK'.tr(),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadiusSmall),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.all(kPaddingSmall),
                              ),
                              onChanged: _onFeedbackChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Container(
                    margin: const EdgeInsets.only(top: kPaddingNormal),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: widget.isEdit
                              ? IconButton(
                                  icon: CustomIcon(
                                    CustomIcons.trash,
                                    size: kIconSizeLarge,
                                    color: theme.colorScheme.secondaryContainer,
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
                            onPressed: widget.isEdit || widget.isFeedback
                                ? _onEditSent
                                : _onNewSent,
                            child: Text(widget.isEdit || widget.isFeedback
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
}
