import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';
import 'poll_details_view.dart';

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
  const PollScreen({
    super.key = const Key('PollScreen'),
    required this.manager,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refresh(
        userID: Provider.of<AuthManager>(context).user!.id,
      ),
      shimmer: const ListScreenShimmer(type: ShimmerListType.square),
      child: PollTileView(manager: manager),
    );
  }
}

class PollTileView extends StatefulWidget {
  final PollManager manager;

  const PollTileView({
    super.key,
    required this.manager,
  });

  @override
  PollTileViewState createState() => PollTileViewState();
}

class PollTileViewState extends State<PollTileView> {
  List<PollTask> _polls = [];

  @override
  void initState() {
    _polls = widget.manager.polls;
    _onTabChanged(0);
    super.initState();
  }

  void _onTabChanged(int? tab) {
    setState(() {
      _polls = widget.manager.filter(isLive: tab == 0);
    });
  }

  void _onCreatePoll() {
    SzikAppState.analytics.logEvent(name: 'poll_open_create');
    widget.manager.createNewPoll();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'POLL_TITLE'.tr(),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _onCreatePoll,
        typeToCreate: PollTask,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              kPaddingNormal,
              kPaddingLarge,
              kPaddingNormal,
              kPaddingSmall,
            ),
            child: TabChoice(
              labels: ['POLL_TAB_ACTIVE'.tr(), 'POLL_TAB_EXPIRED'.tr()],
              wrapColor: Colors.transparent,
              onChanged: _onTabChanged,
              wrapColor: Colors.transparent,
            ),
          ),
          Expanded(
            child: _polls.isEmpty
                ? Center(
                    child: Text('PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr()),
                  )
                : RefreshIndicator(
                    onRefresh: () => widget.manager.refresh(
                        userID: Provider.of<AuthManager>(context).user!.id),
                    child: GridView.count(
                      padding: const EdgeInsets.fromLTRB(
                        kPaddingNormal,
                        kPaddingNormal,
                        kPaddingNormal,
                        0,
                      ),
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 4
                          : 2,
                      crossAxisSpacing: kPaddingNormal,
                      mainAxisSpacing: kPaddingNormal,
                      children: _buildPolls(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPolls() {
    var theme = Theme.of(context);
    return _polls.map<GestureDetector>((poll) {
      String timeInformation;
      if (poll.isLive) {
        if (poll.start.isAfter(DateTime.now())) {
          timeInformation =
              poll.start.readableRemainingTime(until: 'UNTIL_START'.tr());
        } else {
          timeInformation =
              poll.end.readableRemainingTime(until: 'UNTIL_END'.tr());
        }
      } else {
        timeInformation = 'POLL_CLOSED'.tr();
      }
      return GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => PollDetailsView(
            poll: poll,
            manager: widget.manager,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusNormal),
            color:
                poll.isLive && DateTime.now().isInInterval(poll.start, poll.end)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondaryContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.all(kBorderRadiusNormal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    poll.question,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.surface,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                const SizedBox(
                  height: kPaddingNormal,
                ),
                Text(
                  timeInformation,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
