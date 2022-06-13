import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';

class PollDialog extends StatefulWidget {
  final PollTask poll;
  final PollManager manager;
  const PollDialog({
    Key? key,
    required this.poll,
    required this.manager,
  }) : super(key: key);

  @override
  State<PollDialog> createState() => _PollDialogState();
}

class _PollDialogState extends State<PollDialog> {
  List<String> _selected = [];

  @override
  void initState() {
    _selected = widget.poll.answers.any((element) =>
            element.voterID ==
            Provider.of<AuthManager>(context, listen: false).user!.id)
        ? widget.poll.answers
            .firstWhere((element) =>
                element.voterID ==
                Provider.of<AuthManager>(context, listen: false).user!.id)
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
      child: (() {
        if (widget.poll.end.isBefore(DateTime.now()) ||
            widget.poll.isLive == false) {
          return _buildClosedPoll();
        } else if (true) {
          return _buildOpenPoll();
        }
      }()),
    );
  }

  Widget _buildOpenPoll() {
    var theme = Theme.of(context);
    var user = Provider.of<AuthManager>(context, listen: false).user;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: theme.colorScheme.primary,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(kBorderRadiusNormal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.poll.name,
                    style: theme.textTheme.headline2!
                        .copyWith(color: theme.colorScheme.surface),
                  ),
                ),
                const SizedBox(width: kPaddingLarge),
                if (user!.hasPermissionToModify(widget.poll))
                  GestureDetector(
                    onTap: () => widget.manager
                        .editPoll(widget.manager.indexOf(widget.poll)),
                    child: const CustomIcon(CustomIcons.pencil),
                  ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(kPaddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.poll.question,
                  style: theme.textTheme.subtitle1!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: kPaddingNormal),
                Text(
                  widget.poll.description ?? '',
                  style: theme.textTheme.subtitle1!.copyWith(
                    color: theme.colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: theme.colorScheme.secondary,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: _buildAnswerItems(),
                  ),
                ),
                const SizedBox(height: kPaddingNormal),
                widget.manager.hasVoted(userID: user.id, poll: widget.poll)
                    ? Center(
                        child: Text(
                        '${widget.poll.feedbackOnAnswer ?? ''}\n${'POLL_ALREADY_VOTED'.tr()}',
                        textAlign: TextAlign.center,
                      ))
                    : ElevatedButton(
                        onPressed: (() => widget.manager.addVote(
                            Vote(
                              voterID: user.id,
                              votes: _selected,
                              lastUpdate: DateTime.now(),
                            ),
                            widget.poll)),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (_) {
                              return RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadiusSmall),
                              );
                            },
                          ),
                        ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClosedPoll() {
    var theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: theme.colorScheme.secondaryContainer,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(kBorderRadiusNormal),
            child: Text(
              widget.poll.name,
              style: theme.textTheme.headline2!
                  .copyWith(color: theme.colorScheme.surface),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.poll.question,
                style: theme.textTheme.subtitle1!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kPaddingNormal),
              Text(
                widget.poll.description ?? '',
                style: theme.textTheme.subtitle1!.copyWith(
                  color: theme.colorScheme.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Divider(
                thickness: 2,
                color: theme.colorScheme.secondary,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _buildClosedAnswerItems(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAnswerItems() {
    var theme = Theme.of(context);
    var userID = Provider.of<AuthManager>(context, listen: false).user!.id;
    var hasVoted = widget.manager.hasVoted(userID: userID, poll: widget.poll);
    return widget.poll.answerOptions.map<ListTile>(
      (item) {
        var disabled = hasVoted;
        if (widget.poll.isMultipleChoice) {
          disabled = hasVoted ||
              (_selected.length >= widget.poll.maxSelectableOptions &&
                  !_selected.contains(item));
        }
        return ListTile(
          title: Text(
            item,
            style: theme.textTheme.subtitle1!.copyWith(
              color: disabled
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.primaryContainer,
              fontStyle: FontStyle.italic,
            ),
          ),
          leading: widget.poll.isMultipleChoice
              ? Checkbox(
                  value: _selected.isEmpty ? false : _selected.contains(item),
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
                              var index = _selected.indexOf(item);
                              (index == -1)
                                  ? _selected.add(item)
                                  : _selected.removeAt(index);
                            },
                          ),
                )
              : Radio<String>(
                  value: item,
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
                              _selected.removeWhere((element) => true);
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
      (item) {
        var votesPercent = results['allVoteCount'] == 0
            ? 0
            : (results[item]['voteCount'] / results['allVoteCount'] * 100)
                .round();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item,
                style: theme.textTheme.subtitle1!.copyWith(
                  color: theme.colorScheme.primaryContainer,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Column(
                children: [
                  Text(
                    '${votesPercent.toString()}%',
                    style: theme.textTheme.headline2!.copyWith(
                      color: theme.colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'POLL_VOTE'.tr(
                      args: [results[item]['voteCount'].toString()],
                    ),
                    style: theme.textTheme.subtitle1!.copyWith(
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
