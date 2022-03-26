import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../models/models.dart';
import '../ui/themes.dart';

class PollWidget extends StatefulWidget {
  final PollTask poll;
  const PollWidget({Key? key, required this.poll}) : super(key: key);

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  List<String> _selected = [];

  @override
  void initState() {
    _selected = widget.poll.answers
        .firstWhere((element) =>
            element.voterID ==
            Provider.of<AuthManager>(context, listen: false).user!.id)
        .votes;
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
    var i;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: theme.colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(kBorderRadiusNormal),
            child: Text(
              widget.poll.question,
              style: theme.textTheme.headline2!
                  .copyWith(color: theme.colorScheme.surface),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kPaddingNormal),
          child: Column(
            children: [
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
              ..._buildAnswerItems(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: (() {}),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      kPaddingNormal,
                      kBorderRadiusSmall,
                      kPaddingNormal,
                      kBorderRadiusSmall,
                    ),
                    child: Text('BUTTON_SEND'.tr()),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (_) {
                        return RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kBorderRadiusSmall),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
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
          child: Padding(
            padding: const EdgeInsets.all(kBorderRadiusNormal),
            child: Text(
              widget.poll.question,
              style: theme.textTheme.headline2!
                  .copyWith(color: theme.colorScheme.surface),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kPaddingNormal),
          child: Column(
            children: [
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
              ..._buildClosedAnswerItems(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAnswerItems() {
    var theme = Theme.of(context);
    return widget.poll.answerOptions.map<ListTile>(
      (item) {
        return ListTile(
          title: Text(
            item,
            style: theme.textTheme.subtitle1!.copyWith(
              color: theme.colorScheme.primaryContainer,
              fontStyle: FontStyle.italic,
            ),
          ),
          leading: widget.poll.isMultipleChoice
              ? Checkbox(
                  value: _selected.contains(item),
                  activeColor: theme.colorScheme.primaryContainer,
                  fillColor: MaterialStateProperty.all(
                    theme.colorScheme.primaryContainer,
                  ),
                  onChanged: (bool? value) => setState(
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
                  groupValue: _selected.first,
                  activeColor: theme.colorScheme.primaryContainer,
                  fillColor: MaterialStateProperty.all(
                    theme.colorScheme.primaryContainer,
                  ),
                  onChanged: (String? value) => setState(
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
    var results = <String, int>{};
    Provider.of<PollManager>(context, listen: false)
        .getResults(widget.poll)
        .then((value) => results = value.cast<String, int>());

    return widget.poll.answerOptions.map<Padding>(
      (item) {
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '100%',
                    style: theme.textTheme.headline2!.copyWith(
                      color: theme.colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'POLL_VOTE'.tr(args: ['0']),
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
