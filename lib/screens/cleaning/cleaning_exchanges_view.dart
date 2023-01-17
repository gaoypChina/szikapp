import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:uuid/uuid.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../models/models.dart';
import '../../navigation/app_state_manager.dart';
import '../../ui/themes.dart';

class CleaningExchangesView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningExchangesView({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<CleaningExchangesView> createState() => _CleaningExchangesViewState();
}

class _CleaningExchangesViewState extends State<CleaningExchangesView> {
  bool _userHasActiveExchange = false;
  List<CleaningExchange> exchanges = [];

  @override
  void initState() {
    super.initState();
    exchanges = _customSorted(widget.manager.exchanges);
    _userHasActiveExchange = exchanges.any((element) =>
        element.initiatorID ==
        Provider.of<AuthManager>(context, listen: false).user!.id);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _onManualRefresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
        child: Column(
          children: [
            if (!_userHasActiveExchange) _buildNewExchangeTile(),
            Expanded(
              child: ToggleList(
                divider: const SizedBox(height: 10),
                trailing: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kPaddingLarge),
                  child: CustomIcon(
                    CustomIcons.doubleArrowDown,
                    size: theme.textTheme.headline3!.fontSize!,
                    color: theme.colorScheme.primary,
                  ),
                ),
                children: exchanges
                    .map<ToggleListItem>(
                      (item) => _buildExchangeTile(exchange: item),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewExchangeTile() {
    var theme = Theme.of(context);
    var exchangableItem = widget.manager.tasks.firstWhere((element) => element
        .participantIDs
        .contains(Provider.of<AuthManager>(context, listen: false).user!.id));
    return Padding(
      padding: const EdgeInsets.all(kPaddingNormal),
      child: Container(
        padding: const EdgeInsets.all(kPaddingLarge),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(kBorderRadiusNormal),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      Provider.of<AuthManager>(context).user!.name,
                      style: theme.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.colorScheme.background,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('MM. dd.').format(exchangableItem.start),
                    style: theme.textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: theme.colorScheme.background,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2 * kPaddingLarge),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildExchangeOfferDialog(exchangableItem),
                  );
                },
                child: CustomIcon(
                  CustomIcons.plus,
                  size: theme.textTheme.headline3!.fontSize ?? 14,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ToggleListItem _buildExchangeTile({required CleaningExchange exchange}) {
    var isOwnItem =
        Provider.of<AuthManager>(context).user!.id == exchange.initiatorID;
    var theme = Theme.of(context);
    var itemDate = widget.manager.tasks
        .firstWhere((element) => element.id == exchange.taskID)
        .start;
    var backgroundColor = isOwnItem
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface;
    var foregroundColor = isOwnItem
        ? theme.colorScheme.surface
        : theme.colorScheme.primaryContainer;
    var strongFont = theme.textTheme.headline3!.copyWith(
      color: foregroundColor,
    );
    var weakFont = theme.textTheme.subtitle1!.copyWith(
      color: foregroundColor,
      fontStyle: FontStyle.italic,
    );
    return ToggleListItem(
      headerDecoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(kBorderRadiusNormal),
        ),
      ),
      expandedHeaderDecoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(kBorderRadiusNormal),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                Provider.of<SzikAppStateManager>(context)
                    .users
                    .firstWhere((element) => element.id == exchange.initiatorID)
                    .name,
                style: strongFont,
              ),
            ),
            Text(
              DateFormat('MM. dd.').format(itemDate),
              style: weakFont,
            ),
          ],
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(kBorderRadiusNormal),
          ),
        ),
        child: Column(
          children: [
            Divider(
              height: 1,
              thickness: 1,
              indent: kPaddingNormal,
              endIndent: kPaddingNormal,
              color: foregroundColor,
            ),
            Padding(
              padding: const EdgeInsets.all(kPaddingLarge),
              child: isOwnItem
                  ? _buildOwnItemBody(
                      exchange: exchange,
                      backgroundColor: backgroundColor,
                      foregroundColor: foregroundColor,
                      strongFont: strongFont,
                      weakFont: weakFont,
                    )
                  : _buildOtherItemBody(
                      exchange: exchange,
                      backgroundColor: backgroundColor,
                      foregroundColor: foregroundColor,
                      strongFont: strongFont,
                      weakFont: weakFont,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnItemBody({
    required CleaningExchange exchange,
    required Color backgroundColor,
    required Color foregroundColor,
    required TextStyle strongFont,
    required TextStyle weakFont,
  }) {
    var theme = Theme.of(context);
    return Column(
      children: [
        ...exchange.replacements.map((replacement) {
          var replacementTask = widget.manager.tasks
              .firstWhere((element) => element.id == replacement['task_id']);
          var replacerName = Provider.of<SzikAppStateManager>(context)
              .users
              .firstWhere(
                (element) => element.id == replacement['replacer_id'],
              )
              .name;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              border: Border.all(color: foregroundColor),
            ),
            padding: const EdgeInsets.all(kPaddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(kPaddingNormal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              replacerName,
                              style: strongFont,
                            ),
                            Text(
                              DateFormat('MM. dd.').format(
                                replacementTask.start,
                              ),
                              style: weakFont,
                            ),
                          ],
                        ),
                        const SizedBox(height: kPaddingNormal),
                        _buildTexts(
                          replacementTask: replacementTask,
                          font: weakFont,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildExchangeRefuseDialog(
                                  exchange, replacement['task_id']),
                        );
                      },
                      icon: const CustomIcon(CustomIcons.closeOutlined),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildExchangeAcceptDialog(
                            exchange,
                            replacement['task_id'],
                          ),
                        );
                      },
                      icon: const CustomIcon(CustomIcons.done),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: kPaddingNormal),
            child: OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildExchangeDeleteDialog(
                    exchange,
                  ),
                );
              },
              style: theme.outlinedButtonTheme.style!.copyWith(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => backgroundColor),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(color: foregroundColor),
                ),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                  (Set<MaterialState> states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                  ),
                ),
              ),
              child: Text(
                'CLEANING_BUTTON_DELETE'.tr(),
                style: theme.textTheme.subtitle1!.copyWith(
                  color: foregroundColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherItemBody({
    required exchange,
    required backgroundColor,
    required foregroundColor,
    required strongFont,
    required weakFont,
  }) {
    var replacementTask = widget.manager.tasks
        .firstWhere((element) => element.id == exchange.taskID);
    var userOfferedTaskIDs = widget.manager.exchanges
        .where((element) => element.replacements.any((element) =>
            element['replacer_id'].toString() ==
            Provider.of<AuthManager>(context).user!.id))
        .map((e) => e.taskID)
        .toList();

    Widget iconButton;
    if (userOfferedTaskIDs.isEmpty) {
      iconButton = IconButton(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.bottomRight,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildExchangeExchangeDialog(
              exchange,
              replacementTask.id,
            ),
          );
        },
        icon: CustomIcon(
          CustomIcons.done,
          color: foregroundColor,
        ),
      );
    } else if (userOfferedTaskIDs.contains(exchange.id)) {
      iconButton = IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildExchangeWithdrawDialog(
              exchange,
              replacementTask.id,
            ),
          );
        },
        icon: CustomIcon(
          CustomIcons.close,
          color: foregroundColor,
        ),
      );
    } else {
      iconButton = Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _buildTexts(
            replacementTask: replacementTask,
            font: weakFont,
          ),
        ),
        iconButton,
        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
          child: iconButton,
        ),
        */
      ],
    );
  }

  Future<void> _onManualRefresh() async {
    await widget.manager.refreshExchanges();
    setState(() {
      _customSorted(widget.manager.exchanges);
    });
  }

  List<CleaningExchange> _customSorted(List<CleaningExchange> list) {
    list = List.from(list);
    var ownItems = list.where((element) =>
        element.initiatorID ==
        Provider.of<AuthManager>(context, listen: false).user!.id);
    if (ownItems.isNotEmpty) {
      for (var ownItem in ownItems) {
        list.remove(ownItem);
        list.insert(0, ownItem);
      }
    }
    return list;
  }

  String userIDSToString(List<String> userIDs) {
    return userIDs
        .map(
          (e) => Provider.of<SzikAppStateManager>(context)
              .users
              .firstWhere((element) => element.id == e)
              .name,
        )
        .join(', ');
  }

  Widget _buildTexts({replacementTask, font}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${'CLEANING_LABEL_EXTRA_TASK'.tr()}: ',
            style: font.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: replacementTask.description,
            style: font,
          ),
          const TextSpan(text: '\n\n'),
          TextSpan(
            text: '${'CLEANING_LABEL_WITH'.tr()}: ',
            style: font.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: userIDSToString(
              replacementTask.participantIDs,
            ),
            style: font,
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeOfferDialog(CleaningTask exchangableItem) {
    var uuid = const Uuid();
    var exchange = CleaningExchange(
      id: uuid.v4().toUpperCase(),
      taskID: exchangableItem.id,
      initiatorID: Provider.of<AuthManager>(context).user!.id,
      replacements: [],
      lastUpdate: DateTime.now(),
    );
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_OFFER_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE').format(exchangableItem.start),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () =>
          widget.manager.createCleaningExchangeOccasion(exchange),
    );
  }

  Widget _buildExchangeExchangeDialog(
      CleaningExchange exchange, String replaceUID) {
    var replacementTask =
        widget.manager.tasks.firstWhere((element) => element.id == replaceUID);
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_EXCHANGE_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE').format(replacementTask.start),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () =>
          widget.manager.offerCleaningExchangeOccasion(exchange, replaceUID),
    );
  }

  Widget _buildExchangeWithdrawDialog(
      CleaningExchange exchange, String replaceUID) {
    var replacementTask =
        widget.manager.tasks.firstWhere((element) => element.id == replaceUID);
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_WITHDRAW_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE').format(replacementTask.start),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () =>
          widget.manager.withdrawCleaningExchangeOccasion(exchange, replaceUID),
    );
  }

  Widget _buildExchangeAcceptDialog(
      CleaningExchange exchange, String replaceUID) {
    var replacementTask =
        widget.manager.tasks.firstWhere((element) => element.id == replaceUID);
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_ACCEPT_TITLE'.tr(),
      bodytext:
          '${DateFormat('MM. dd. - EEEE').format(replacementTask.start)}\n${'CLEANING_DIALOG_WITH'.tr()} ${userIDSToString(replacementTask.participantIDs)}',
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () =>
          widget.manager.acceptCleaningExchangeOccasion(exchange),
    );
  }

  Widget _buildExchangeRefuseDialog(
      CleaningExchange exchange, String replaceUID) {
    var replacementTask =
        widget.manager.tasks.firstWhere((element) => element.id == replaceUID);

    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_REFUSE_TITLE'.tr(),
      bodytext:
          '${DateFormat('MM. dd. - EEEE').format(replacementTask.start)}\n${'CLEANING_DIALOG_WITH'.tr()} ${userIDSToString(replacementTask.participantIDs)}',
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () =>
          widget.manager.rejectCleaningExchangeOccasion(exchange),
    );
  }

  Widget _buildExchangeDeleteDialog(CleaningExchange exchange) {
    var task = widget.manager.tasks
        .firstWhere((element) => element.id == exchange.taskID);

    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_DELETE_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE').format(task.start),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () =>
          widget.manager.deleteCleaningExchangeOccasion(exchange),
    );
  }
}
