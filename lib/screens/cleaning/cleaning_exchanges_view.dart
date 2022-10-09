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
      lastUpdate: DateTime.now(),
    ),
    /*CleaningExchange(
      id: 'test003',
      taskID: 'test004',
      initiatorID: 'u066',
      lastUpdate: DateTime.now(),
    ),*/
  ];

  @override
  void initState() {
    super.initState();
    _userHasActiveExchange = exchanges.any((element) =>
        element.initiatorID == Provider.of<AuthManager>(context).user!.id);
    exchanges = _customSorted(testData);
    //exchanges = _customSorted(widget.manager.exchanges);  //TODO: uncomment
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
                            DateFormat('MM. dd.').format(DateTime.now()), //TODO
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
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    'body',
                                    style: TextStyle(
                                      color: isOwnItem
                                          ? theme.colorScheme.background
                                          : theme.colorScheme.primaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
    return Container(
      height: 100,
      color: Colors.red,
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
}
