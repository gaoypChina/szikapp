import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../business/janitor.dart';
import '../../models/resource.dart';
import '../../models/tasks.dart';
import '../widgets/searchable_options.dart';

class JanitorNewEditArguments {
  bool isEdit;
  JanitorTask? task;

  JanitorNewEditArguments({required this.isEdit, this.task});
}

class JanitorNewEditScreen extends StatefulWidget {
  static const String route = '/janitor/newedit';

  final bool isEdit;
  final JanitorTask? task;

  JanitorNewEditScreen({
    Key? key,
    this.isEdit = false,
    this.task,
  }) : super(key: key);

  @override
  _JanitorNewEditScreenState createState() => _JanitorNewEditScreenState();
}

class _JanitorNewEditScreenState extends State<JanitorNewEditScreen> {
  late final Janitor janitor;
  late JanitorTask task;

  @override
  void initState() {
    super.initState();
    janitor = Janitor();
    var uuid = Uuid();
    task = widget.task ??
        JanitorTask(
            uid: uuid.v4(),
            name: '',
            start: DateTime.now(),
            end: DateTime.now(),
            type: TaskType.janitor,
            lastUpdate: DateTime.now(),
            placeID: '',
            status: TaskStatus.created);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var leftColumnWidth = width * 0.3;
    var height =
        MediaQuery.of(context).size.height - kBottomNavigationBarHeight;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.all(10),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Picture
            Container(
              width: width * 0.7,
              height: width * 0.7,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/pictures/gyuri_800.png'),
                    fit: BoxFit.contain),
              ),
            ),
            //Title
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                widget.isEdit
                    ? 'JANITOR_TITLE_EDIT'.tr().toUpperCase()
                    : 'JANITOR_TITLE_CREATE'.tr().toUpperCase(),
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24,
                    ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 2,
              indent: 25,
              endIndent: 25,
              color: Theme.of(context).colorScheme.secondary,
            ),
            //Details, text fields and buttons
            Flex(
              direction: Axis.vertical,
              /*child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,*/
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Container(
                        width: leftColumnWidth,
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          'JANITOR_LABEL_PLACE'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        child: SearchableOptions(
                            //TODO Places
                            items: ['alpha', 'beta', 'gamma'],
                            selectedItem: 'alpha',
                            onItemChanged: _onPlaceChanged),
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
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          initialValue: widget.isEdit ? task.name : null,
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                          decoration: InputDecoration(
                            hintText: 'PLACEHOLDER_TITLE'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(5),
                          ),
                          onFieldSubmitted: _onTitleSubmitted,
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
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          initialValue: widget.isEdit ? task.description : null,
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                          decoration: InputDecoration(
                            hintText: 'PLACEHOLDER_DESCRIPTION'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(5),
                          ),
                          onFieldSubmitted: _onDescriptionSubmitted,
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
                        child: widget.isEdit
                            ? IconButton(
                                icon: ColorFiltered(
                                  child: Image.asset(
                                      'assets/icons/trash_light_72.png'),
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant
                                          .withOpacity(0.7),
                                      BlendMode.srcIn),
                                ),
                                onPressed: () => {})
                            : Container(),
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: widget.isEdit ? _onEditSent : _onNewSent,
                          child: Text(
                            'JANITOR_ACTION_CREATE'.tr(),
                            style: Theme.of(context).textTheme.button!.copyWith(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
              /*),
              ),*/
            ),
            SizedBox(
              height: kBottomNavigationBarHeight,
            )
          ],
        ),
      ),
    );
  }

  void _onPlaceChanged(dynamic item) {
    var place = item as Place;
    task.placeID = place.id;
  }

  void _onTitleSubmitted(String? title) {
    task.name = title ?? '';
  }

  void _onDescriptionSubmitted(String? description) {
    task.description = description ?? '';
  }

  void _onNewSent() {
    task.status = TaskStatus.sent;
    janitor.addTask(task);
  }

  void _onEditSent() {
    janitor.editTask(task);
  }
}
