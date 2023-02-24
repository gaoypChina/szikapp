import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';
import 'components.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.account,
    this.showReservationButton = true,
    this.onReservationTap,
  });

  final Account account;
  final bool showReservationButton;
  final VoidCallback? onReservationTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          border: Border.all(color: theme.colorScheme.primary),
          color: theme.colorScheme.surface,
        ),
        child: Container(
          padding: const EdgeInsets.all(kPaddingNormal),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(kPaddingLarge),
                child: Text(
                  account.name,
                  style: theme.textTheme.displaySmall!.copyWith(
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
                  color: theme.colorScheme.primaryContainer.withOpacity(0.15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: kPaddingLarge),
                          child: CustomIcon(
                            CustomIcons.userName,
                            size: theme.textTheme.bodyLarge!.fontSize! * 1.5,
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            account.username,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: kPaddingLarge),
                          child: CustomIcon(
                            CustomIcons.password,
                            size: theme.textTheme.bodyLarge!.fontSize! * 1.5,
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            account.credential,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primaryContainer),
                          ),
                        ),
                      ],
                    ),
                    if (account.description != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: kPaddingLarge),
                            child: CustomIcon(
                              CustomIcons.description,
                              size: theme.textTheme.bodyLarge!.fontSize! * 1.5,
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              account.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primaryContainer),
                            ),
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: (() => openUrl(account.url)),
                          child: Text(
                            'ACCOUNT_CARD_BUTTON_LOGIN'.tr(),
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        if (account.reservable && showReservationButton)
                          ElevatedButton(
                            onPressed: onReservationTap,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                            ),
                            child: Text(
                              'ACCOUNT_CARD_BUTTON_RESERVE'.tr(),
                              style: theme.textTheme.labelSmall!.copyWith(
                                color: theme.colorScheme.surface,
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
