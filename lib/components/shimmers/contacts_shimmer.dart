import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../components.dart';

class ContactsListViewShimmer extends StatelessWidget {
  const ContactsListViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var searchBarIconSize = 30.0;
    return SzikAppScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'CONTACTS_TITLE'.tr(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Shimmer.fromColors(
            baseColor: theme.colorScheme.secondaryVariant.withOpacity(0.2),
            highlightColor: theme.colorScheme.secondaryVariant.withOpacity(0.5),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: searchBarIconSize,
                    height: searchBarIconSize,
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                10,
                (index) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor:
                            theme.colorScheme.secondaryVariant.withOpacity(0.2),
                        highlightColor:
                            theme.colorScheme.secondaryVariant.withOpacity(0.5),
                        child: CircleAvatar(
                          radius: theme.textTheme.headline3!.fontSize! * 1.5,
                          backgroundColor: theme.colorScheme.primaryVariant,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor:
                            theme.colorScheme.secondaryVariant.withOpacity(0.2),
                        highlightColor:
                            theme.colorScheme.secondaryVariant.withOpacity(0.5),
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          height: theme.textTheme.headline3!.fontSize! * 1.5,
                          width: theme.textTheme.headline3!.fontSize! * 10,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryVariant,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
