import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_list/toggle_list.dart';

import '../business/poll_manager.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/models.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';

class PollScreen extends StatelessWidget {
  static const String route = '/poll';

  static MaterialPage page({required PollManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: PollScreen(manager: manager),
    );
  }

  final PollManager manager;
  const PollScreen({Key key = const Key('PollScreen'), required this.manager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refresh(),
      shimmer: const TileShimmer(),
      child: PollTileView(manager: manager),
    );
  }
}

class PollTileView extends StatefulWidget {
  final PollManager manager;

  const PollTileView({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  _PollTileViewState createState() => _PollTileViewState();
}

class _PollTileViewState extends State<PollTileView> {
  DateTime d1 = DateTime.utc(2020, 2, 17);
  DateTime d2 = DateTime.utc(2020, 2, 18);
  DateTime d3 = DateTime.utc(2020, 2, 20);
  DateTime d4 = DateTime.utc(2020, 2, 23);
  //PollTask(uid: '0', name: 'Szav1', start: , end: end, type: type, lastUpdate: lastUpdate, question: question, answerOptions: answerOptions, answers: answers, issuerIDs: issuerIDs)

  List<PollTask> _polls = [];
/*
    PollTask(uid : '0', name : 'Szav1', start : DateTime.utc(2020, 2, 17) , end : DateTime.utc(2020, 2, 18), type : TaskType.poll, lastUpdate : DateTime.utc(2020, 2, 17), question : 'Szavazás 1', answerOptions : ['1. opció','2. opció'], answers: [], issuerIDs : ['u999']),
    PollTask(uid : '1', name : 'Szav2', start : DateTime.utc(2020, 2, 20) , end : DateTime.utc(2020, 2, 23), type : TaskType.poll, lastUpdate : DateTime.utc(2020, 2, 17), question : 'Szavazás 1', answerOptions : ['1. opció','2. opció'], answers: [], issuerIDs : ['u999']),
*/

  bool _isActivePolls = true;

  @override
  void initState() {
    _polls = widget.manager.polls;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return CustomScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreatePoll,
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(width: 36, height: 36),
          child: Image.asset('assets/icons/plus_light_72.png'),
        ),
      ),
      body: Column(
        children: [
          TabChoice(
            labels: ['POLL_TAB_ACTIVE'.tr(), 'POLL_TAB_EXPIRED'.tr()],
            onChanged: _onTabChanged,
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(
                  kPaddingNormal, kPaddingLarge, kPaddingNormal, 0),
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 4
                      : 2,
              crossAxisSpacing: kPaddingNormal,
              mainAxisSpacing: kPaddingNormal,
              children: _polls.map<Container>((poll) {
                var difference = poll.end.difference(DateTime.now()).inDays;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                    color: poll.isLive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondaryContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kBorderRadiusNormal),
                    child: Column(
                      children: [
                        Expanded(
                            child: Text(
                          poll.question,
                          style: theme.textTheme.subtitle1?.copyWith(
                            color: theme.colorScheme.surface,
                          ),
                        )),
                        Text(
                          'POLL_DAYS_LEFT'.tr(
                            args: [
                              (poll.end.difference(DateTime.now()).inDays)
                                  .toString()
                            ],
                          ),
                          style: theme.textTheme.subtitle1?.copyWith(
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  void _onTabChanged(int? tab) {
    setState(() {
      (tab == 0) ? _isActivePolls = true : _isActivePolls = false;
    });
  }

  void _onCreatePoll() {}
}
