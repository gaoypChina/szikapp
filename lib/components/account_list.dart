import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/business.dart';
import '../ui/themes.dart';
import 'components.dart';

class AccountList extends StatelessWidget {
  final ReservationManager manager;
  final String title;
  final bool isReservation;

  AccountList.reservation({super.key, required this.manager})
      : title = 'RESERVATION_TITLE_ACCOUNT_LIST'.tr(),
        isReservation = true;
  AccountList.passwords({super.key, required this.manager})
      : title = 'PASSWORDS_TITLE'.tr(),
        isReservation = false;

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refreshAccounts(),
      shimmer: const ListScreenShimmer(type: ShimmerListType.card),
      child: AccountListView(
        manager: manager,
        title: title,
        isReservation: isReservation,
      ),
    );
  }
}

class AccountListView extends StatelessWidget {
  const AccountListView({
    super.key,
    required this.manager,
    required this.title,
    required this.isReservation,
  });

  final ReservationManager manager;
  final String title;
  final bool isReservation;

  @override
  Widget build(BuildContext context) {
    var accounts = isReservation
        ? manager.accounts.where((element) => element.reservable).toList()
        : manager.accounts;
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: title,
      body: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: ListView(
          children: accounts
              .map<AccountCard>(
                (account) => AccountCard(
                  account: account,
                  showReservationButton: isReservation,
                  onReservationTap: () => manager.selectAccount(
                    manager.accounts
                        .indexWhere((item) => item.id == account.id),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
