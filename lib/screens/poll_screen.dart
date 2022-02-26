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

class PollScreen extends StatefulWidget {
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
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  //late PollManager manager;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: widget.manager.refresh(),
      shimmer: const TileShimmer(),
      child: PollTileView(),
    );
  }
}

class PollTileView extends StatefulWidget {
  //final PollManager manager;

  const PollTileView({
    Key? key,
    /*required this.manager*/
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
  bool _isActivePolls = true;

  @override
  void initState() {
    // _polls = widget.manager.polls;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return CustomScaffold(
      body: Column(
        children: [
          TabChoice(
            labels: ['POLL_TAB_ACTIVE'.tr(), 'POLL_TAB_EXPIRED'.tr()],
            onChanged: (tab) => setState(() {
              (tab == 0) ? _isActivePolls = true : _isActivePolls = false;
            }),
          ),
          GridView.count(
            crossAxisCount: 2,
            children: _polls.map<Expanded>((poll) {
              return Expanded(
                child: Column(
                  children: [
                    Expanded(child: Text(poll.question)),
                    Text('POLL_DAYS_LEFT'.tr(
                        args: [(poll.end.day - DateTime.now().day).toString()]))
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
