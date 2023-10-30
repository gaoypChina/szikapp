import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

class PollDetailsView extends StatefulWidget {
  final PollTask poll;
  final PollManager manager;
  const PollDetailsView({
    super.key,
    required this.poll,
    required this.manager,
  });

  @override
  State<PollDetailsView> createState() => _PollDetailsViewState();
}

class _PollDetailsViewState extends State<PollDetailsView> {
  List<String> _selected = [];

  @override
  void initState() {
    var userID = Provider.of<AuthManager>(context, listen: false).user!.id;
    _selected = widget.poll.answers.any((answer) => answer.voterID == userID)
        ? widget.poll.answers
            .firstWhere((answer) => answer.voterID == userID)
            .votes
        : [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusNormal),
      ),
      child: _buildPoll(
          isOpen: widget.poll.isLive &&
              DateTime.now().isInInterval(widget.poll.start, widget.poll.end)),
    );
  }

  Widget _buildPoll({required bool isOpen}) {
    var theme = Theme.of(context);
    var user = Provider.of<AuthManager>(context, listen: false).user!;

    var results = widget.manager.getResults(
      poll: widget.poll,
      groups: Provider.of<SzikAppStateManager>(context)
          .groups
          .where((group) => widget.poll.participantIDs.contains(group.id))
          .toList(),
    );
    results.remove('allVoteCount');
    int allVoterCount = results.remove('allVoterCount');
    Set<String> nonVoterIDs = results.remove('nonVoterIDs');
    var nonVoterCount = nonVoterIDs.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(isOpen: isOpen),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(kPaddingLarge),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  widget.poll.question,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: kPaddingNormal),
                Text(
                  widget.poll.description ?? '',
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: theme.colorScheme.secondary,
                ),
                Column(
                  children: isOpen
                      ? _buildOpenAnswerItems()
                      : _buildClosedAnswerItems(),
                ),
                const SizedBox(height: kPaddingNormal),
                if (isOpen)
                  widget.manager.hasVoted(userID: user.id, poll: widget.poll)
                      ? Column(
                          children: [
                            if (widget.poll.managerIDs.contains(user.id))
                              Divider(
                                thickness: 2,
                                color: theme.colorScheme.secondary,
                              ),
                            ..._buildClosedAnswerItems(),
                            Center(
                              child: Text(
                                '${widget.poll.feedbackOnAnswer ?? ''}\n${'POLL_ALREADY_VOTED'.tr()}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadiusNormal),
                            ),
                          ),
                          onPressed: () {
                            SzikAppState.analytics.logEvent(name: 'poll_vote');
                            widget.manager.addVote(
                              poll: widget.poll,
                              vote: Vote(
                                voterID: user.id,
                                votes: _selected,
                                lastUpdate: DateTime.now(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              kPaddingNormal,
                              kBorderRadiusSmall,
                              kPaddingNormal,
                              kBorderRadiusSmall,
                            ),
                            child: Text('BUTTON_SEND'.tr()),
                          ),
                        ),
                if (!widget.poll.isConfidential)
                  Divider(
                    thickness: 2,
                    color: theme.colorScheme.secondary,
                  ),
                if (!widget.poll.isConfidential)
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(0),
                      title: Text(
                        '${'POLL_VOTED'.tr()} - ${'POLL_MEMBERS'.tr(args: [
                              allVoterCount.toString()
                            ])}',
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.outline,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      expandedAlignment: Alignment.topLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: results.entries.map((entry) {
                        var key = entry.key;
                        List<String> value = entry.value['voterIDs'];
                        int voteCount = entry.value['voteCount'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kPaddingSmall,
                                vertical: kPaddingNormal,
                              ),
                              child: Text(
                                '$key ($voteCount)',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: theme.colorScheme.outline,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...value.map(
                              (voterID) => Padding(
                                padding: const EdgeInsets.only(
                                  left: kPaddingNormal,
                                  top: kPaddingSmall,
                                ),
                                child: Text(
                                  Provider.of<SzikAppStateManager>(context,
                                          listen: false)
                                      .users
                                      .firstWhere((user) => user.id == voterID)
                                      .name,
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: theme.colorScheme.outline,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                if (!widget.poll.isConfidential)
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(0),
                      title: Text(
                        '${'POLL_NOT_VOTED'.tr()} - ${'POLL_MEMBERS'.tr(args: [
                              nonVoterCount.toString()
                            ])}',
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.outline,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      expandedAlignment: Alignment.topLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: nonVoterIDs
                          .map(
                            (id) => Padding(
                              padding: const EdgeInsets.only(
                                left: kPaddingNormal,
                                top: kPaddingSmall,
                              ),
                              child: Text(
                                Provider.of<SzikAppStateManager>(context,
                                        listen: false)
                                    .users
                                    .firstWhere((user) => user.id == id)
                                    .name,
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: theme.colorScheme.outline,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({required bool isOpen}) {
    var theme = Theme.of(context);
    var user = Provider.of<AuthManager>(context).user!;
    return Container(
      color: isOpen
          ? theme.colorScheme.primary
          : theme.colorScheme.secondaryContainer,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(kBorderRadiusNormal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.poll.name,
                style: theme.textTheme.displayMedium!
                    .copyWith(color: theme.colorScheme.surface),
              ),
            ),
            if (user.hasPermissionToModify(task: widget.poll) &&
                (isOpen || widget.poll.start.isAfter(DateTime.now())))
              Padding(
                padding: const EdgeInsets.only(left: kPaddingLarge),
                child: GestureDetector(
                  onTap: () {
                    SzikAppState.analytics.logEvent(name: 'poll_open_edit');
                    widget.manager
                        .editPoll(index: widget.manager.indexOf(widget.poll));
                  },
                  child: const CustomIcon(CustomIcons.pencil),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOpenAnswerItems() {
    var theme = Theme.of(context);
    var userID = Provider.of<AuthManager>(context, listen: false).user!.id;
    var hasVoted = widget.manager.hasVoted(userID: userID, poll: widget.poll);
    return widget.poll.answerOptions.map<ListTile>(
      (answerOption) {
        var disabled = hasVoted;
        if (widget.poll.isMultipleChoice) {
          disabled = hasVoted ||
              (_selected.length >= widget.poll.maxSelectableOptions &&
                  !_selected.contains(answerOption));
        }
        return ListTile(
          title: Text(
            answerOption,
            style: theme.textTheme.titleMedium!.copyWith(
              color: disabled
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.primaryContainer,
              fontStyle: FontStyle.italic,
            ),
          ),
          leading: widget.poll.isMultipleChoice
              ? Checkbox(
                  value: _selected.isEmpty
                      ? false
                      : _selected.contains(answerOption),
                  activeColor: disabled
                      ? theme.colorScheme.secondaryContainer
                      : theme.colorScheme.primaryContainer,
                  fillColor: MaterialStateProperty.all(
                    disabled
                        ? theme.colorScheme.secondaryContainer
                        : theme.colorScheme.primaryContainer,
                  ),
                  onChanged: disabled
                      ? null
                      : (bool? value) => setState(
                            () {
                              var index = _selected.indexOf(answerOption);
                              (index == -1)
                                  ? _selected.add(answerOption)
                                  : _selected.removeAt(index);
                            },
                          ),
                )
              : Radio<String>(
                  value: answerOption,
                  groupValue: _selected.isEmpty ? null : _selected.first,
                  activeColor: hasVoted
                      ? theme.colorScheme.secondaryContainer
                      : theme.colorScheme.primaryContainer,
                  fillColor: MaterialStateProperty.all(
                    hasVoted
                        ? theme.colorScheme.secondaryContainer
                        : theme.colorScheme.primaryContainer,
                  ),
                  onChanged: hasVoted
                      ? null
                      : (String? value) => setState(
                            () {
                              _selected = [];
                              if (value != null) _selected.add(value);
                            },
                          ),
                ),
        );
      },
    ).toList();
  }

  List<Widget> _buildClosedAnswerItems() {
    var theme = Theme.of(context);
    var results = widget.manager.getResults(
      poll: widget.poll,
      groups: Provider.of<SzikAppStateManager>(context).groups,
    );

    return widget.poll.answerOptions.map<Padding>(
      (answerOption) {
        var votesPercent = results['allVoteCount'] == 0
            ? 0
            : (results[answerOption]['voteCount'] /
                    results['allVoteCount'] *
                    100)
                .round();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  answerOption,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primaryContainer,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${votesPercent.toString()}%',
                    style: theme.textTheme.displayMedium!.copyWith(
                      color: theme.colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'POLL_VOTE'.tr(
                      args: [results[answerOption]['voteCount'].toString()],
                    ),
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).toList();
  }
}
