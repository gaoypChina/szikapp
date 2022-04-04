import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../business/reservation_manager.dart';
import '../components/components.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';

class ReservationAccountsListScreen extends StatelessWidget {
  final ReservationManager manager;

  static const String route = '/reservation/accounts';

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationAccountsListScreen(manager: manager),
    );
  }

  const ReservationAccountsListScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refreshAccounts(),
      shimmer: const ListScreenShimmer(type: ShimmerListType.card),
      child: ReservationAccountList(manager: manager),
    );
  }
}

class ReservationAccountList extends StatelessWidget {
  final ReservationManager manager;

  const ReservationAccountList({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'RESERVATION_TITLE_ACCOUNT_LIST'.tr(),
      body: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: ListView(
          children: manager.accounts
              .map<Container>(
                (item) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                    border: Border.all(color: theme.colorScheme.primary),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        Provider.of<ReservationManager>(context, listen: false)
                            .selectAccount(
                      manager.accounts.indexOf(item),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(kPaddingNormal),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(kPaddingLarge),
                            child: Text(
                              item.name,
                              style: theme.textTheme.headline3!.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(kPaddingLarge),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                kBorderRadiusNormal,
                              ),
                              color: theme.colorScheme.primaryContainer
                                  .withOpacity(0.15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ColorFiltered(
                                      child: Icon(
                                        Icons.account_box,
                                        size: theme.textTheme.bodyText1!
                                                .fontSize! *
                                            1.5,
                                      ),
                                      colorFilter: ColorFilter.mode(
                                          theme.colorScheme.primaryContainer,
                                          BlendMode.srcIn),
                                    ),
                                    Text(
                                      item.username,
                                      style:
                                          theme.textTheme.bodyText1?.copyWith(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: kPaddingSmall),
                                      child: ColorFiltered(
                                        child: Icon(
                                          Icons.password,
                                          size: theme.textTheme.bodyText1!
                                                  .fontSize! *
                                              1.5,
                                        ),
                                        colorFilter: ColorFilter.mode(
                                          theme.colorScheme.primaryContainer,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        item.credential,
                                        style: theme.textTheme.bodyText1
                                            ?.copyWith(
                                                color: theme.colorScheme
                                                    .primaryContainer),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton(
                                      onPressed: (() => _launchUrl(item.url)),
                                      child: Text(
                                        'RESERVATION_ACCOUNT_BUTTON_URL'.tr(),
                                        style:
                                            theme.textTheme.overline!.copyWith(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => manager.selectAccount(
                                        manager.accounts.indexOf(item),
                                      ),
                                      child: Text(
                                        'RESERVATION_ACCOUNT_BUTTON_LIST'.tr(),
                                        style:
                                            theme.textTheme.overline!.copyWith(
                                          color: theme.colorScheme.surface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw NotSupportedBrowserFunctionalityException(url);
    }
  }
}
