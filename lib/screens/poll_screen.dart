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

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: PollScreen(),
    );
  }

  const PollScreen({Key key = const Key('PollScreen')}) : super(key: key);

  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  late PollManager manager;

  @override
  void initState() {
    super.initState();
    manager = PollManager();
  }

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

  const PollTileView({Key? key, required this.manager}) : super(key: key);

  @override
  _PollTileViewState createState() => _PollTileViewState();
}

class _PollTileViewState extends State<PollTileView> {
//  DateTime d1,d2,d3,d4 = new DateTime(2020,2,18), new new DateTime(2020,2,17), new DateTime(2020,2,20), new DateTime(2020,2,23);
//PollTask(uid: '0', name: 'Szav1', start: , end: end, type: type, lastUpdate: lastUpdate, question: question, answerOptions: answerOptions, answers: answers, issuerIDs: issuerIDs)
  List<PollTask> _polls = [];
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
      body: Column(
        children: [
          TabChoice(
            labels: [
              'POLL_TAB_ACTIVE'.tr(), //fordítás fájlba betenni
              'POLL_TAB_EXPIRED'.tr()
            ],
            onChanged: (tab) => setState(() {
              (tab == 0) ? _isActivePolls = true : _isActivePolls = false;
            }),
          ),

          //labels string lista
          //setstate: megváltoztat a stateben valamit

          GridView.count(
            crossAxisCount: 2,
            children: _polls.map<Container>((poll) {
              return Container(
                child: Column(
                  children: [
                    Expanded(child: Text(poll.question)),
                    Text((poll.end.day - DateTime.now().day).toString() +
                        'DAYS_LEFT'.tr())
                  ],
                ),
              );
            }).toList()
            //map-es tolistes valami
            ,
          )
        ],
      ),
    );
  }
}
