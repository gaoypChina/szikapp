import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/auth_manager.dart';
import '../business/poll_manager.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../ui/themes.dart';

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
  List<PollTask> _polls = [];

  @override
  void initState() {
    _onTabChanged(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return CustomScaffold(
      appBarTitle: 'POLL_TITLE'.tr(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreatePoll,
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(width: 36, height: 36),
          child: Image.asset('assets/icons/plus_light_72.png'),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: TabChoice(
              labels: ['POLL_TAB_ACTIVE'.tr(), 'POLL_TAB_EXPIRED'.tr()],
              onChanged: _onTabChanged,
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(
                kPaddingNormal,
                kPaddingLarge,
                kPaddingNormal,
                0,
              ),
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 4
                      : 2,
              crossAxisSpacing: kPaddingNormal,
              mainAxisSpacing: kPaddingNormal,
              children: _polls.map<GestureDetector>((poll) {
                return GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return const PollWidget();
                    },
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                      color: poll.isLive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(kBorderRadiusNormal),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              poll.question,
                              style: theme.textTheme.subtitle1?.copyWith(
                                color: theme.colorScheme.surface,
                              ),
                            ),
                          ),
                          Text(
                            _calculateTime(poll.end),
                            style: theme.textTheme.subtitle1?.copyWith(
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ],
                      ),
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
    List<PollTask> newPolls;
    if (tab == 0) {
      newPolls = widget.manager.filter(
          userID: Provider.of<AuthManager>(context, listen: false).user!.id,
          isLive: true);
    } else {
      newPolls = widget.manager.filter(
          userID: Provider.of<AuthManager>(context, listen: false).user!.id,
          isLive: false);
    }
    setState(() {
      _polls = newPolls;
    });
  }

  void _onCreatePoll() {}

  String _calculateTime(DateTime date) {
    var difference = date.difference(DateTime.now());
    var answer = '';
    if (difference.isNegative) {
      answer = 'POLL_NO_TIME_LEFT'.tr();
    } else if (difference.inDays > 0) {
      answer = 'POLL_DAYS_LEFT'.tr(args: [difference.inDays.toString()]);
    } else if (difference.inHours > 0) {
      answer = 'POLL_HOURS_LEFT'.tr(args: [difference.inHours.toString()]);
    } else if (difference.inMinutes > 0) {
      answer = 'POLL_MINUTES_LEFT'.tr(args: [difference.inMinutes.toString()]);
    }
    return answer;
  }
}

class PollWidget extends StatelessWidget {
  const PollWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
