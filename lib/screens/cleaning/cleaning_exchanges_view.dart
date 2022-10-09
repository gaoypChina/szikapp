import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_list/toggle_list.dart';

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
  List<CleaningExchange> testData = [
    CleaningExchange(
      id: 'test001',
      taskID: 'test002',
      initiatorID: 'u067',
      replaceTaskID: 'test003',
      responderID: 'u069',
      lastUpdate: DateTime.now(),
    ),
    CleaningExchange(
      id: 'test003',
      taskID: 'test004',
      initiatorID: 'u066',
      lastUpdate: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    exchanges = _customSorted(testData);
    //exchanges = _customSorted(widget.manager.exchanges);  //TODO: uncomment
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
                    size: theme.textTheme.headline3!.fontSize ?? 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
                children: testData.map<ToggleListItem>((item) {
                  /* TODO: uncomment
                  var itemDate = widget.manager.tasks
                      .firstWhere((element) => element.id == item.taskID)
                      .start;
                  */
                  var isOwnItem = Provider.of<AuthManager>(context).user!.id ==
                      item.initiatorID;
                  return ToggleListItem(
                    headerDecoration: BoxDecoration(
                      color: isOwnItem
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surface,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(kBorderRadiusNormal),
                      ),
                    ),
                    expandedHeaderDecoration: BoxDecoration(
                      color: isOwnItem
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surface,
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
                                  .firstWhere((element) =>
                                      element.id == item.initiatorID)
                                  .name,
                              style: theme.textTheme.bodyText1!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isOwnItem
                                    ? theme.colorScheme.background
                                    : theme.colorScheme.primaryContainer,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('MM. dd.')
                                .format(DateTime.now()), //TODO: itemDate
                            style: theme.textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isOwnItem
                                  ? theme.colorScheme.background
                                  : theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        color: isOwnItem
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surface,
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
                            color: isOwnItem
                                ? theme.colorScheme.surface
                                : theme.colorScheme.primaryContainer,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(kPaddingLarge),
                            child: isOwnItem
                                ? _buildOwnItemBody(item)
                                : _buildOtherItemBody(item),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewExchangeTile() {
    var theme = Theme.of(context);

    /*
    var exchangableItem = widget.manager.tasks.firstWhere((element) => element
        .participantIDs
        .contains(Provider.of<AuthManager>(context, listen: false).user!.id));
*/
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
                    DateFormat('MM. dd.')
                        .format(DateTime.now()), //TODO: exchangableItem.start
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
                        _buildExchangeOfferDialog(
                      DateTime.now(),
                    ), //TODO: exchangableItem.start
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

  Widget _buildOwnItemBody(CleaningExchange exchange) {
    var theme = Theme.of(context);
    var responses = exchanges.where((element) =>
        element.initiatorID == Provider.of<AuthManager>(context).user!.id);
    return Column(
      children: [
        ...responses.map((e) {
          /*
        var offeredItem =
            widget.manager.tasks.firstWhere((element) => element.id == e.id);
        */
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(kPaddingNormal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<SzikAppStateManager>(context)
                              .users
                              .firstWhere((element) =>
                                  element.id == exchange.initiatorID)
                              .name,
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                        ),
                        Text(
                          'Teszt vézna szövegecske, de hosszú',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color: Theme.of(context).colorScheme.surface,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                        /* TODO: uncomment + string literals
                      Text(
                        '${'Ekkor'}: ${DateFormat('MM. dd.').format(offeredItem.start)}',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                      Text(
                        '${'Plusz feladat'}: ${offeredItem.description}',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontStyle: FontStyle.italic,
                            ),
                      ), 
                      */
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
                            DateTime.now(), //TODO: exchangableItem.start
                            /*
                          Provider.of<SzikAppStateManager>(context)
                              .users
                              .firstWhere(
                                  (element) => element.id == e.initiatorID)
                              .name,
                          */
                            'abc', //TODO: ^^^^
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
                            DateTime.now(), //TODO: exchangableItem.start
                            /*
                          Provider.of<SzikAppStateManager>(context)
                              .users
                              .firstWhere(
                                  (element) => element.id == e.initiatorID)
                              .name,
                          */
                            'abc', //TODO: ^^^^
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
                  builder: (BuildContext context) =>
                      _buildExchangeWithdrawDialog(
                    DateTime.now(),
                  ), //TODO: exchangableItem.start
                );
              },
              style: theme.outlinedButtonTheme.style!.copyWith(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => theme.colorScheme.primaryContainer),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(color: theme.colorScheme.surface),
                ),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                  (Set<MaterialState> states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                  ),
                ),
              ),
              child: Text(
                'abc', //TODO: string literal
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherItemBody(CleaningExchange exchange) {
    return const Center(
      child: Text('Other'),
    );
  }

  Future<void> _onManualRefresh() async {
    await widget.manager.refreshExchanges();
    setState(() {
      //exchanges = List.from(widget.manager.exchanges); //TODO: uncomment
      exchanges = testData;
      _customSorted(exchanges);
    });
  }

  List<CleaningExchange> _customSorted(List<CleaningExchange> list) {
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

  Widget _buildExchangeOfferDialog(DateTime date) {
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_OFFER_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE').format(date),
      onWeakButtonClick: () => {}, //TODO: logic
      onStrongButtonClick: () => {}, //TODO: logic
    );
  }

  Widget _buildExchangeExchangeDialog(DateTime date) {
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_EXCHANGE_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE').format(date),
      onWeakButtonClick: () => {}, //TODO: logic
      onStrongButtonClick: () => {}, //TODO: logic
    );
  }

  Widget _buildExchangeWithdrawDialog(DateTime date) {
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_WITHDRAW_TITLE'.tr(),
      bodytext: DateFormat('MM. dd. - EEEE').format(date),
      onWeakButtonClick: () => {}, //TODO: logic
      onStrongButtonClick: () => {}, //TODO: logic
    );
  }

  Widget _buildExchangeAcceptDialog(DateTime date, String name) {
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_ACCEPT_TITLE'.tr(),
      bodytext:
          '${DateFormat('MM. dd. - EEEE').format(date)}\n${'CLEANING_DIALOG_WITH'.tr()}: $name',
      onWeakButtonClick: () => {}, //TODO: logic
      onStrongButtonClick: () => {}, //TODO: logic
    );
  }

  Widget _buildExchangeRefuseDialog(DateTime date, String name) {
    return CustomDialog.confirmation(
      title: 'CLEANING_DIALOG_REFUSE_TITLE'.tr(),
      bodytext:
          '${DateFormat('MM. dd. - EEEE').format(date)}\n${'CLEANING_DIALOG_WITH'.tr()} $name',
      onWeakButtonClick: () => {}, //TODO: logic
      onStrongButtonClick: () => {}, //TODO: logic
    );
  }
}
