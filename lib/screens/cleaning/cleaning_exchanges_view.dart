import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:uuid/uuid.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

class CleaningExchangesView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningExchangesView({
    super.key,
    required this.manager,
  });

  @override
  State<CleaningExchangesView> createState() => _CleaningExchangesViewState();
}

class _CleaningExchangesViewState extends State<CleaningExchangesView> {
  bool _userHasActiveExchange = false;
  bool _userHasAppliedCurrentTask = false;
  bool _usersAppliedTaskNotInThePast = false;
  List<CleaningExchange> _exchanges = [];

  @override
  void initState() {
    super.initState();
    var user = Provider.of<AuthManager>(context, listen: false).user!;
    _exchanges = _customSorted(list: widget.manager.exchanges);
    _userHasActiveExchange =
        widget.manager.userHasActiveExchange(userID: user.id);
    _userHasAppliedCurrentTask =
        widget.manager.userHasAppliedCurrentTask(userID: user.id);
    _usersAppliedTaskNotInThePast =
        widget.manager.usersAppliedCurrentTaskIsNotInThePast(userID: user.id);
  }

  Future<void> refreshWidget() async {
    await widget.manager.refreshExchanges(status: TaskStatus.created);
    setState(() {
      var user = Provider.of<AuthManager>(context, listen: false).user!;
      _userHasActiveExchange =
          widget.manager.userHasActiveExchange(userID: user.id);
      _exchanges = _customSorted(list: widget.manager.exchanges);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var tasks = Provider.of<KitchenCleaningManager>(context).tasks;
    var filteredExchanges = _exchanges
        .where(
          (exchange) => tasks
              .firstWhere((task) => task.id == exchange.taskID)
              .end
              .isAfter(DateTime.now()),
        )
        .toList();
    return RefreshIndicator(
      onRefresh: _onManualRefresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
        child: Column(
          children: [
            if (!_userHasAppliedCurrentTask)
              _buildInfoTile(text: 'CLEANING_INFO_NO_CURRENT_TASK'.tr())
            else if (!_userHasActiveExchange && _usersAppliedTaskNotInThePast)
              _buildNewExchangeTile()
            else
              _buildInfoTile(text: 'CLEANING_INFO_TASK_IN_THE_PAST'.tr()),
            Expanded(
              child: ToggleList(
                divider: const SizedBox(height: kPaddingNormal),
                trailing: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kPaddingLarge),
                  child: CustomIcon(
                    CustomIcons.doubleArrowDown,
                    size: theme.textTheme.displaySmall!.fontSize!,
                    color: theme.colorScheme.primary,
                  ),
                ),
                children: filteredExchanges
                    .map<ToggleListItem>(
                      (exchange) => _buildExchangeTile(exchange: exchange),
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
    var user = Provider.of<AuthManager>(context).user!;
    var exchangableItem = widget.manager.getUserCurrentTask(userID: user.id);
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
                      user.name,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.colorScheme.background,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('MM. dd.').format(exchangableItem.start),
                    style: theme.textTheme.bodyLarge!.copyWith(
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
                        _buildExchangeOfferDialog(
                      exchangableItem: exchangableItem,
                    ),
                  );
                },
                child: CustomIcon(
                  CustomIcons.plus,
                  size: theme.textTheme.displaySmall!.fontSize ?? 14,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({required String text}) {
    var theme = Theme.of(context);
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
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: theme.colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }

  ToggleListItem _buildExchangeTile({required CleaningExchange exchange}) {
    var user = Provider.of<AuthManager>(context).user;
    var isOwnItem = user!.id == exchange.initiatorID;
    var theme = Theme.of(context);
    var userHasCurrentTask =
        widget.manager.userHasAppliedCurrentTask(userID: user.id);
    var backgroundColor = isOwnItem
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface;
    var foregroundColor = isOwnItem
        ? theme.colorScheme.surface
        : theme.colorScheme.primaryContainer;
    var strongFont = theme.textTheme.displaySmall!.copyWith(
      color: foregroundColor,
    );
    var weakFont = theme.textTheme.titleMedium!.copyWith(
      color: foregroundColor,
      fontStyle: FontStyle.italic,
    );
    return ToggleListItem(
      headerDecoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(kBorderRadiusNormal),
        ),
        border: Border.all(color: theme.colorScheme.primaryContainer),
      ),
      expandedHeaderDecoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(kBorderRadiusNormal),
        ),
        border: Border.all(color: theme.colorScheme.primaryContainer),
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
            if (userHasCurrentTask)
              Flexible(
                child: Text(
                  DateFormat('MM. dd.').format(
                    widget.manager.tasks
                        .firstWhere((task) => task.id == exchange.taskID)
                        .start,
                  ),
                  style: weakFont,
                ),
              ),
          ],
        ),
      ),
      content: userHasCurrentTask
          ? Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(kBorderRadiusNormal),
                    bottomLeft: Radius.circular(kBorderRadiusNormal)),
                border: Border.all(color: theme.colorScheme.primaryContainer),
              ),
              child: Padding(
                padding: const EdgeInsets.all(kPaddingLarge),
                child: userHasCurrentTask
                    ? isOwnItem
                        ? _buildOwnItemBody(
                            exchange: exchange,
                            backgroundColor: backgroundColor,
                            foregroundColor: foregroundColor,
                            strongFont: strongFont,
                            weakFont: weakFont,
                          )
                        : _buildOtherItemBody(
                            exchange: exchange,
                            ownTaskID: widget.manager
                                .getUserCurrentTask(userID: user.id)
                                .id,
                            backgroundColor: backgroundColor,
                            foregroundColor: foregroundColor,
                            strongFont: strongFont,
                            weakFont: weakFont,
                          )
                    : _buildNoTaskItemBody(
                        font: weakFont,
                        textColor: foregroundColor,
                      ),
              ),
            )
          : Container(),
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
              .firstWhere((task) => task.id == replacement.taskID);
          var replacerName = Provider.of<SzikAppStateManager>(context)
              .users
              .firstWhere((user) => user.id == replacement.replacerID)
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
                if (replacement.status != TaskStatus.refused)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildExchangeRefuseDialog(
                              exchange: exchange,
                              replaceUid: replacement.taskID,
                            ),
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
                              exchange: exchange,
                              replaceUid: replacement.taskID,
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
                    exchange: exchange,
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
                'CLEANING_BUTTON_WITHDRAW'.tr(),
                style: theme.textTheme.titleMedium!.copyWith(
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
    required CleaningExchange exchange,
    required String ownTaskID,
    required backgroundColor,
    required foregroundColor,
    required strongFont,
    required weakFont,
  }) {
    var user = Provider.of<AuthManager>(context).user;
    var replacementTask =
        widget.manager.tasks.firstWhere((task) => task.id == exchange.taskID);
    var userOfferedExchangeIDs = widget.manager.exchanges
        .where((exchange) => exchange.replacements.any((replacement) =>
            replacement.replacerID == user!.id &&
            replacement.status != TaskStatus.refused))
        .map((exchange) => exchange.id)
        .toList();

    Widget iconButton;
    if (userOfferedExchangeIDs.isEmpty && _usersAppliedTaskNotInThePast) {
      iconButton = IconButton(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.bottomRight,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildExchangeExchangeDialog(
              exchange: exchange,
              replaceUid: ownTaskID,
            ),
          );
        },
        icon: CustomIcon(
          CustomIcons.done,
          color: foregroundColor,
        ),
      );
    } else if (userOfferedExchangeIDs.contains(exchange.id)) {
      iconButton = IconButton(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.bottomRight,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildExchangeWithdrawDialog(
              exchange: exchange,
              replaceUid: ownTaskID,
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
      ],
    );
  }

  Widget _buildNoTaskItemBody(
      {required TextStyle font, required Color textColor}) {
    return Center(
      child: Text(
        'CLEANING_EXCHANGE_VANISHEDTASK'.tr(),
        style: font.copyWith(color: textColor),
      ),
    );
  }

  Future<void> _onManualRefresh() async {
    await widget.manager.refreshExchanges(status: TaskStatus.created);
    setState(() {
      _exchanges = _customSorted(list: widget.manager.exchanges);
    });
  }

  List<CleaningExchange> _customSorted({required List<CleaningExchange> list}) {
    var tasks = Provider.of<KitchenCleaningManager>(context, listen: false)
        .getCurrentTasks();
    if (tasks.isEmpty) return list;
    var copiedList = List<CleaningExchange>.from(list);
    copiedList.sort((a, b) {
      var aTask = tasks.firstWhere((task) => task.id == a.taskID);
      var bTask = tasks.firstWhere((task) => task.id == b.taskID);
      return aTask.start.compareTo(bTask.start);
    });
    var ownItems = copiedList.where((exchange) =>
        exchange.initiatorID ==
        Provider.of<AuthManager>(context, listen: false).user!.id);
    if (ownItems.isNotEmpty) {
      for (var ownItem in ownItems) {
        copiedList.remove(ownItem);
        copiedList.insert(0, ownItem);
      }
    }
    return copiedList;
  }

  Widget _buildTexts({
    required CleaningTask replacementTask,
    required TextStyle font,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${'CLEANING_LABEL_EXTENSION'.tr()}: ',
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
            text: userIDsToString(
              context,
              replacementTask.participantIDs,
            ),
            style: font,
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeOfferDialog({required CleaningTask exchangableItem}) {
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
      bodytext: DateFormat('MM. dd. - EEEE', context.locale.toString())
          .format(exchangableItem.start),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await widget.manager.createCleaningExchangeOccasion(exchange: exchange);
        SzikAppState.analytics.logEvent(name: 'cleaning_exchange_create');
        refreshWidget();
      },
    );
  }

  Widget _buildExchangeExchangeDialog(
      {required CleaningExchange exchange, required String replaceUid}) {
    var replacementTask =
        widget.manager.tasks.firstWhere((task) => task.id == replaceUid);
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_EXCHANGE_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE', context.locale.toString())
          .format(replacementTask.start),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await widget.manager.offerCleaningExchangeOccasion(
            exchange: exchange, replaceUid: replaceUid);
        SzikAppState.analytics.logEvent(name: 'cleaning_exchange_offer');
        refreshWidget();
      },
    );
  }

  Widget _buildExchangeWithdrawDialog(
      {required CleaningExchange exchange, required String replaceUid}) {
    var replacementTask =
        widget.manager.tasks.firstWhere((task) => task.id == replaceUid);
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_WITHDRAW_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE', context.locale.toString())
          .format(replacementTask.start),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await widget.manager.withdrawCleaningExchangeOccasion(
            exchange: exchange, replaceUid: replaceUid);
        SzikAppState.analytics.logEvent(name: 'cleaning_exchange_withdraw');
        refreshWidget();
      },
    );
  }

  Widget _buildExchangeAcceptDialog(
      {required CleaningExchange exchange, required String replaceUid}) {
    var replacementTask =
        widget.manager.tasks.firstWhere((task) => task.id == replaceUid);
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_ACCEPT_TITLE'.tr(),
      bodytext:
          '${DateFormat('MM. dd. - EEEE', context.locale.toString()).format(replacementTask.start)}\n${'CLEANING_DIALOG_WITH'.tr()} ${userIDsToString(context, replacementTask.participantIDs)}',
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await widget.manager.acceptCleaningExchangeOccasion(
            exchange: exchange, replaceUid: replaceUid);
        SzikAppState.analytics.logEvent(name: 'cleaning_exchange_accept');
        refreshWidget();
      },
    );
  }

  Widget _buildExchangeRefuseDialog(
      {required CleaningExchange exchange, required String replaceUid}) {
    var replacementTask =
        widget.manager.tasks.firstWhere((task) => task.id == replaceUid);

    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_REFUSE_TITLE'.tr(),
      bodytext:
          '${DateFormat('MM. dd. - EEEE', context.locale.toString()).format(replacementTask.start)}\n${'CLEANING_DIALOG_WITH'.tr()} ${userIDsToString(context, replacementTask.participantIDs)}',
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await widget.manager.rejectCleaningExchangeOccasion(
            exchange: exchange, replaceUid: replaceUid);
        SzikAppState.analytics.logEvent(name: 'cleaning_exchange_refuse');
        refreshWidget();
      },
    );
  }

  Widget _buildExchangeDeleteDialog({required CleaningExchange exchange}) {
    var task = widget.manager.tasks
        .firstWhere((element) => element.id == exchange.taskID);

    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_DELETE_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE', context.locale.toString())
          .format(task.start),
      onWeakButtonClick: () => Navigator.of(context, rootNavigator: true).pop(),
      onStrongButtonClick: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await widget.manager.deleteCleaningExchangeOccasion(exchange: exchange);
        SzikAppState.analytics.logEvent(name: 'cleaning_exchange_delete');
        refreshWidget();
      },
    );
  }
}
