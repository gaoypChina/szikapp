import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/models.dart';
import '../navigation/navigation.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';

class PollAddScreen extends StatefulWidget {
  static const String route = '/poll/createedit';

  static MaterialPage page({
    PollTask? originalItem,
    int index = -1,
    required Function(PollTask) onCreate,
    required Function(PollTask, int) onUpdate,
    required Function(PollTask, int) onDelete,
  }) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: PollAddScreen(
        originalItem: originalItem,
        index: index,
        onCreate: onCreate,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
    );
  }

  final bool isEdit;
  final PollTask? originalItem;
  final int index;
  final Function(PollTask) onCreate;
  final Function(PollTask, int) onDelete;
  final Function(PollTask, int) onUpdate;

  const PollAddScreen({
    Key? key,
    this.originalItem,
    this.index = -1,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
  })  : isEdit = (originalItem != null),
        super(key: key);

  @override
  PollAddScreenState createState() => PollAddScreenState();
}

class PollAddScreenState extends State<PollAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String question = '';
  List<String> answerOptions = [''];
  late DateTime startDateTime;
  late DateTime endDateTime;
  List<String> participantGroupIDs = [];
  bool isSecret = false;
  bool isMultipleChoice = false;
  int numberOfOptions = 2;
  String? feedbackMessage;
  bool isLive = false;

  @override
  void initState() {
    var now = DateTime.now();
    startDateTime = widget.isEdit
        ? widget.originalItem!.start
        : DateTime(
            now.year,
            now.month,
            now.day,
            now.hour,
            0,
          );
    endDateTime = widget.isEdit
        ? widget.originalItem!.end
        : DateTime(
            now.year,
            now.month,
            now.day + 7,
            23,
            59,
          );
    title = widget.isEdit ? widget.originalItem!.name : '';
    description = (widget.isEdit ? widget.originalItem!.description : '') ?? '';
    question = widget.isEdit ? widget.originalItem!.question : '';
    answerOptions = widget.isEdit ? widget.originalItem!.answerOptions : [''];
    participantGroupIDs =
        widget.isEdit ? widget.originalItem!.participantIDs : [];
    isSecret = widget.isEdit ? widget.originalItem!.isConfidential : true;
    isMultipleChoice =
        widget.isEdit ? widget.originalItem!.isMultipleChoice : false;
    isLive = widget.isEdit ? widget.originalItem!.isLive : true;
    numberOfOptions =
        widget.isEdit ? widget.originalItem!.maxSelectableOptions : 2;
    feedbackMessage =
        widget.isEdit ? widget.originalItem!.feedbackOnAnswer : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var groups =
        Provider.of<SzikAppStateManager>(context, listen: false).groups;
    final confirmDialog = CustomDialog.alert(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onStrongButtonClick: _onAcceptDelete,
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
    );
    return CustomScaffold(
      appBarTitle:
          widget.isEdit ? 'POLL_TITLE_EDIT'.tr() : 'POLL_TITLE_CREATE'.tr(),
      body: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(kBorderRadiusNormal),
          border: Border.all(
            color: theme.colorScheme.primary,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(4, 4), // changes position of shadow
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //fejléc
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kPaddingLarge),
                  child: TextFormField(
                    onChanged: _onTitleChanged,
                    initialValue: title,
                    validator: _validateTextField,
                    readOnly: widget.isEdit,
                    style: theme.textTheme.subtitle1?.copyWith(
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    decoration: InputDecoration(
                      hintText: 'POLL_HINT_TITLE'.tr(),
                    ),
                  ),
                ),
              ),

              //tartalom
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(kPaddingNormal),
                  child: ListView(
                    cacheExtent: 1000,
                    children: [
                      TextFormField(
                        onChanged: _onQuestionChanged,
                        initialValue: question,
                        validator: _validateTextField,
                        readOnly: widget.isEdit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusSmall),
                          ),
                          hintText: 'POLL_HINT_QUESTION'.tr(),
                        ),
                        maxLines: 5,
                        minLines: 1,
                      ),
                      const SizedBox(height: 10),
                      //szavazás leírása
                      TextFormField(
                        onChanged: _onDescriptionChanged,
                        initialValue: description,
                        validator: _validateTextField,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusSmall),
                          ),
                          hintText: 'POLL_HINT_DESCRIPTION'.tr(),
                        ),
                        maxLines: 5,
                        minLines: 1,
                      ),
                      //választási lehetőségek
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kPaddingNormal),
                        child: Text(
                          'POLL_OPTIONS'.tr(),
                          style: theme.textTheme.subtitle1?.copyWith(
                              color: theme.colorScheme.primaryContainer),
                        ),
                      ),
                      ...answerOptions.map<Widget>(
                        (String answerOption) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kPaddingNormal),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (newOption) =>
                                        _onAnswerOptionChanged(
                                            answerOption, newOption),
                                    readOnly: widget.isEdit,
                                    validator: _validateTextField,
                                    initialValue: answerOption,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            kBorderRadiusSmall),
                                      ),
                                      hintText: 'POLL_ANSWER_OPTION'.tr(),
                                    ),
                                  ),
                                ),
                                if (widget.isEdit == false)
                                  IconButton(
                                    onPressed: () =>
                                        _onAnswerOptionDeleted(answerOption),
                                    icon: const Icon(Icons.close),
                                  ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                      if (widget.isEdit == false)
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: FittedBox(
                            child: FloatingActionButton(
                              onPressed: _onAnswerOptionAdded,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints.expand(
                                  width: kIconSizeXLarge,
                                  height: kIconSizeXLarge,
                                ),
                                child: Image.asset(
                                    'assets/icons/plus_light_72.png'),
                              ),
                            ),
                          ),
                        ),

                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kPaddingNormal),
                        child: Text(
                          'POLL_DURATION'.tr(),
                          style: theme.textTheme.subtitle1?.copyWith(
                              color: theme.colorScheme.primaryContainer),
                        ),
                      ),

                      Row(
                        children: [
                          DatePicker(
                            onChanged: _onStartDateChanged,
                            initialDate: startDateTime,
                            startDate: DateTime.now(),
                          ),
                          const SizedBox(width: kPaddingNormal),
                          TimePicker(
                            time: TimeOfDay(
                              hour: startDateTime.hour,
                              minute: startDateTime.minute,
                            ),
                            onChanged: _onStartTimeChanged,
                          )
                        ],
                      ),
                      const SizedBox(height: kPaddingNormal),
                      Row(
                        children: [
                          DatePicker(
                            onChanged: _onEndDateChanged,
                            initialDate: endDateTime,
                            startDate: DateTime.now(),
                          ),
                          const SizedBox(width: kPaddingNormal),
                          TimePicker(
                            time: TimeOfDay(
                              hour: endDateTime.hour,
                              minute: endDateTime.minute,
                            ),
                            onChanged: _onEndTimeChanged,
                          )
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: kPaddingNormal),
                        child: Text(
                          'POLL_PARTICIPANTS'.tr(),
                          style: theme.textTheme.subtitle1?.copyWith(
                              color: theme.colorScheme.primaryContainer),
                        ),
                      ),
                      SearchableOptions<Group>.multiSelection(
                        items: groups,
                        selectedItems: widget.isEdit
                            ? groups
                                .where(
                                  (element) =>
                                      participantGroupIDs.contains(element.id),
                                )
                                .toList()
                            : [],
                        onItemsChanged: _onParticipantGroupIDsChanged,
                        readonly: widget.isEdit,
                        compare: (i, s) => i!.isEqual(s),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: kPaddingSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'POLL_SECRET'.tr(),
                              style: theme.textTheme.subtitle1?.copyWith(
                                  color: theme.colorScheme.primaryContainer),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Switch(
                                value: isSecret,
                                onChanged:
                                    widget.isEdit ? null : _onSecretPollChanged,
                                activeColor: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: kPaddingSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'POLL_MULTIPLE_CHOICE'.tr(),
                              style: theme.textTheme.subtitle1?.copyWith(
                                  color: theme.colorScheme.primaryContainer),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Switch(
                                value: isMultipleChoice,
                                onChanged: widget.isEdit
                                    ? null
                                    : _onMultipleChoiceChanged,
                                activeColor: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isMultipleChoice)
                        Container(
                          margin: const EdgeInsets.only(top: kPaddingSmall),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'POLL_MAX_OPTIONS'.tr(),
                                style: theme.textTheme.subtitle1?.copyWith(
                                    color: theme.colorScheme.primaryContainer),
                              ),
                              const SizedBox(width: kPaddingLarge),
                              Expanded(
                                child: TextFormField(
                                  readOnly: widget.isEdit,
                                  onChanged: _onNumberOfOptionsChanged,
                                  initialValue: numberOfOptions.toString(),
                                  validator: _validateTextField,
                                  keyboardType: TextInputType.number,
                                  //itt mi történik?
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kBorderRadiusSmall),
                                    ),
                                    hintText: '...',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kPaddingNormal),
                        child: Text(
                          'POLL_FEEDBACK'.tr(),
                          style: theme.textTheme.subtitle1?.copyWith(
                              color: theme.colorScheme.primaryContainer),
                        ),
                      ),
                      TextFormField(
                        onChanged: _onFeedbackMessageChanged,
                        initialValue: feedbackMessage,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusSmall),
                          ),
                          hintText: 'POLL_HINT_THANKS'.tr(),
                        ),
                      ),
                      if (widget.isEdit)
                        Container(
                          margin: const EdgeInsets.only(top: kPaddingSmall),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'POLL_LIVE'.tr(),
                                style: theme.textTheme.subtitle1?.copyWith(
                                    color: theme.colorScheme.primaryContainer),
                              ),
                              Switch(
                                value: isLive,
                                onChanged: _onLivePollChanged,
                                activeColor: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.isEdit
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
                          ElevatedButton(
                            style: theme.elevatedButtonTheme.style!.copyWith(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadiusSmall),
                                ),
                              ),
                            ),
                            onPressed: widget.isEdit ? _onEditSent : _onNewSent,
                            child: Text(
                              widget.isEdit
                                  ? 'BUTTON_SAVE'.tr()
                                  : 'BUTTON_SEND'.tr(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTitleChanged(String title) {
    setState(() => this.title = title);
  }

  void _onQuestionChanged(String question) {
    setState(() => this.question = question);
  }

  void _onDescriptionChanged(String description) {
    setState(() => this.description = description);
  }

  void _onAnswerOptionAdded() {
    setState(() => answerOptions.add(''));
  }

  void _onAnswerOptionChanged(String oldOption, String newOption) {
    var index = answerOptions.indexOf(oldOption);
    setState(() => answerOptions[index] = newOption);
  }

  void _onAnswerOptionDeleted(String answerOption) {
    setState(() => answerOptions.remove(answerOption));
  }

  void _onStartDateChanged(DateTime date) {
    setState(() {
      startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        startDateTime.hour,
        startDateTime.minute,
        startDateTime.second,
      );
    });
  }

  void _onStartTimeChanged(TimeOfDay time) {
    setState(() {
      startDateTime = DateTime(
        startDateTime.year,
        startDateTime.month,
        startDateTime.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _onEndDateChanged(DateTime date) {
    setState(() {
      endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        endDateTime.hour,
        endDateTime.minute,
        endDateTime.second,
      );
    });
  }

  void _onEndTimeChanged(TimeOfDay time) {
    setState(() {
      endDateTime = DateTime(
        endDateTime.year,
        endDateTime.month,
        endDateTime.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _onParticipantGroupIDsChanged(List<Group>? groups) {
    groups = groups ?? [];
    for (var group in groups) {
      if (participantGroupIDs.contains(group.id)) {
        setState(() => participantGroupIDs.remove(group.id));
      } else {
        setState(() => participantGroupIDs.add(group.id));
      }
    }
  }

  void _onSecretPollChanged(bool value) {
    setState(() => isSecret = value);
  }

  void _onMultipleChoiceChanged(bool value) {
    setState(() => isMultipleChoice = value);
  }

  void _onNumberOfOptionsChanged(String number) {
    var numberInt = int.parse(number);
    setState(() => numberOfOptions = numberInt);
  }

  void _onFeedbackMessageChanged(String message) {
    setState(() => feedbackMessage = message);
  }

  void _onLivePollChanged(bool value) {
    setState(() => isLive = value);
  }

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

  void _onNewSent() {
    if (_formKey.currentState!.validate()) {
      var uuid = const Uuid();
      var task = PollTask(
        id: uuid.v4().toUpperCase(),
        name: title,
        start: startDateTime,
        end: endDateTime,
        type: TaskType.poll,
        managerIDs: [
          Provider.of<AuthManager>(context, listen: false).user!.id,
          'g001',
        ],
        participantIDs: participantGroupIDs,
        description: description,
        lastUpdate: DateTime.now(),
        question: question,
        answerOptions: answerOptions,
        answers: [],
        feedbackOnAnswer: feedbackMessage,
        isLive: DateTime.now().isInInterval(startDateTime, endDateTime),
        isConfidential: isSecret,
        isMultipleChoice: isMultipleChoice,
        maxSelectableOptions: numberOfOptions,
      );

      SZIKAppState.analytics.logEvent(name: 'create_sent_poll_task');
      widget.onCreate(task);
    }
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate()) {
      var task = widget.originalItem;
      task!.name = title;
      task.start = startDateTime;
      task.end = endDateTime;
      task.description = description;
      task.feedbackOnAnswer = feedbackMessage;
      task.isLive = isLive;

      SZIKAppState.analytics.logEvent(name: 'edit_sent_poll_task');
      widget.onUpdate(task, widget.index);
    }
  }

  void _onAcceptDelete() {
    SZIKAppState.analytics.logEvent(name: 'delete_poll_task');
    widget.onDelete(widget.originalItem!, widget.index);
    Navigator.of(context, rootNavigator: true).pop();
  }
}
