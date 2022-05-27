import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/models.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';
import '../utils/methods.dart';

class ReservationCreateEditScreen extends StatefulWidget {
  static const String route = '/reservation/createedit';

  static MaterialPage page({
    TimetableTask? originalItem,
    required ReservationManager manager,
    int index = -1,
    required Function(TimetableTask) onCreate,
    required Function(TimetableTask, int) onUpdate,
    required Function(TimetableTask, int) onDelete,
  }) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationCreateEditScreen(
        originalItem: originalItem,
        index: index,
        manager: manager,
        onCreate: onCreate,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
    );
  }

  final ReservationManager manager;
  final bool isEdit;
  final TimetableTask? originalItem;
  final int index;
  final Function(TimetableTask) onCreate;
  final Function(TimetableTask, int) onDelete;
  final Function(TimetableTask, int) onUpdate;

  const ReservationCreateEditScreen({
    Key? key,
    this.originalItem,
    this.index = -1,
    required this.manager,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
  })  : isEdit = (originalItem != null),
        super(key: key);

  @override
  ReservationCreateEditScreenState createState() =>
      ReservationCreateEditScreenState();
}

class ReservationCreateEditScreenState
    extends State<ReservationCreateEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String? description;
  String? name;
  List<String> resourceIDs = [];
  late DateTime start;
  late DateTime end;
  late Resource selectedResource;

  String timeFieldError = '';

  @override
  void initState() {
    super.initState();
    name = widget.isEdit ? widget.originalItem!.name : null;
    description = widget.isEdit ? widget.originalItem!.description : null;
    start = widget.isEdit
        ? widget.originalItem!.start
        : DateTime.now()
            .toUtc()
            .roundDown()
            .toLocal()
            .add(const Duration(hours: 1));
    end = widget.isEdit
        ? widget.originalItem!.end
        : DateTime.now()
            .toUtc()
            .roundDown()
            .toLocal()
            .add(const Duration(hours: 2));

    if (widget.manager.selectedMode == ReservationMode.place) {
      selectedResource =
          Provider.of<SzikAppStateManager>(context, listen: false)
              .places[widget.manager.selectedPlaceIndex];
    } else if (widget.manager.selectedMode == ReservationMode.boardgame) {
      selectedResource = widget.manager.games[widget.manager.selectedGameIndex];
    } else {
      selectedResource =
          widget.manager.accounts[widget.manager.selectedAccountIndex];
    }
    resourceIDs.add(selectedResource.id);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var leftColumnWidth = width * 0.3;
    final confirmDialog = CustomDialog.alert(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: _onAcceptDelete,
    );

    return CustomScaffold(
      appBarTitle: widget.isEdit
          ? 'RESERVATION_TITLE_EDIT'.tr()
          : 'RESERVATION_TITLE_CREATE'.tr(),
      resizeToAvoidBottomInset: true,
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.all(kPaddingLarge),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
              child: Center(
                child: Text(
                  selectedResource.name.toUpperCase(),
                  style: theme.textTheme.headline1!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ),
            Divider(thickness: 1, color: theme.colorScheme.secondary),
            Form(
              key: _formKey,
              child: Flex(
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
                            'RESERVATION_LABEL_TITLE'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: _validateTextField,
                            initialValue: widget.isEdit
                                ? widget.originalItem!.name
                                : null,
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primaryContainer,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              hintText: 'PLACEHOLDER_TITLE'.tr(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadiusSmall),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
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
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: Text(
                            'RESERVATION_LABEL_DATE'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: DatePicker(
                            initialDate: start,
                            startDate: DateTime.now(),
                            onChanged: _onDateChanged,
                            readonly:
                                widget.isEdit & start.isBefore(DateTime.now()),
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: Text(
                            'RESERVATION_LABEL_TIME_FROM'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TimePicker(
                            time: TimeOfDay.fromDateTime(start),
                            onChanged: _onStartingTimeChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: Text(
                            'RESERVATION_LABEL_TIME_TO'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TimePicker(
                            time: TimeOfDay.fromDateTime(end),
                            onChanged: _onFinishingTimeChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (timeFieldError.isNotEmpty)
                    Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(kPaddingSmall),
                            child: Text(
                              timeFieldError,
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: theme.errorColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: Text(
                            'RESERVATION_LABEL_DESCRIPTION'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: widget.isEdit
                                ? widget.originalItem!.description
                                : null,
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primaryContainer,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              hintText: 'PLACEHOLDER_DESCRIPTION'.tr(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadiusSmall),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
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
                  Container(
                    margin: const EdgeInsets.only(top: kPaddingLarge),
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

  bool _timeFieldHasErrors() {
    timeFieldError = '';
    if (end.isBefore(start)) {
      setState(() => timeFieldError = 'ERROR_NEGATIVE_DATE'.tr());
      return true;
    } else if (end.difference(start) < const Duration(minutes: 15)) {
      setState(() => timeFieldError = 'ERROR_DURATION_TOO_SHORT'.tr());
    }
    return false;
  }

  void _onDateChanged(DateTime? date) {
    setState(() {
      start =
          DateTime(date!.year, date.month, date.day, start.hour, start.minute);
      end = DateTime(date.year, date.month, date.day, end.hour, end.minute);
    });
  }

  void _onStartingTimeChanged(TimeOfDay? startingTime) {
    startingTime ??= TimeOfDay.fromDateTime(start);
    var newStart = DateTime(
      start.year,
      start.month,
      start.day,
      startingTime.hour,
      startingTime.minute,
    );
    var diff = DateTime(
      start.year,
      start.month,
      start.day,
      startingTime.hour,
      startingTime.minute,
    ).difference(start);

    var newEnd = end.add(diff);
    if (newEnd.day != end.day || newEnd.isBefore(newStart)) {
      newEnd = DateTime(start.year, start.month, start.day, 23, 59);
    }

    setState(() {
      start = newStart;
      end = newEnd;
    });
    _timeFieldHasErrors();
  }

  void _onFinishingTimeChanged(TimeOfDay? endingTime) {
    setState(() {
      end = DateTime(
          end.year, end.month, end.day, endingTime!.hour, endingTime.minute);
    });
    _timeFieldHasErrors();
  }

  void _onTitleChanged(String? name) {
    setState(() {
      this.name = name;
    });
  }

  void _onDescriptionChanged(String? description) {
    setState(() {
      this.description = description;
    });
  }

  void _onNewSent() {
    if (_formKey.currentState!.validate() && !_timeFieldHasErrors()) {
      var uuid = const Uuid();
      var task = TimetableTask(
        id: uuid.v4().toUpperCase(),
        name: name!,
        start: start,
        end: end,
        type: TaskType.timetable,
        participantIDs: <String>[
          Provider.of<AuthManager>(context, listen: false).user!.id
        ],
        lastUpdate: DateTime.now(),
        description: description,
        managerIDs: <String>[
          Provider.of<AuthManager>(context, listen: false).user!.id
        ],
        resourceIDs: resourceIDs,
      );
      SZIKAppState.analytics.logEvent(name: 'create_sent_reservation');
      widget.onCreate(task);
    }
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate() && !_timeFieldHasErrors()) {
      var task = widget.originalItem;
      task!.name = name!;
      task.description = description;
      task.start = start;
      task.end = end;

      SZIKAppState.analytics.logEvent(name: 'edit_sent_reservation');
      widget.onUpdate(task, widget.index);
    }
  }

  void _onAcceptDelete() {
    SZIKAppState.analytics.logEvent(name: 'delete_reservation_task');
    widget.onDelete(widget.originalItem!, widget.index);
    Navigator.of(context, rootNavigator: true).pop();
  }
}
