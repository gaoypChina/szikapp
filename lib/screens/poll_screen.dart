import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';
import 'poll_dialog.dart';

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
    Key key = const Key('PollScreen'),
    required this.manager,
  }) : super(key: key);

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
    Key? key,
    required this.manager,
  }) : super(key: key);

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
    widget.manager.createNewPoll();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      appBarTitle: 'POLL_TITLE'.tr(),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _onCreatePoll,
        typeToCreate: PollTask,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: kPaddingLarge,
              horizontal: kPaddingNormal,
            ),
            child: TabChoice(
              labels: ['POLL_TAB_ACTIVE'.tr(), 'POLL_TAB_EXPIRED'.tr()],
              onChanged: _onTabChanged,
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
                      children: _polls.map<GestureDetector>((poll) {
                        return GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => PollDialog(
                              poll: poll,
                              manager: widget.manager,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadiusNormal),
                              color: poll.isLive &&
                                      poll.end.isAfter(DateTime.now())
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondaryContainer,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(kBorderRadiusNormal),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      poll.question,
                                      style:
                                          theme.textTheme.subtitle1?.copyWith(
                                        color: theme.colorScheme.surface,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: kPaddingNormal,
                                  ),
                                  Text(
                                    poll.end.readableRemainingTime(),
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
                  ),
          ),
        ],
      ),
    );
  }
}
