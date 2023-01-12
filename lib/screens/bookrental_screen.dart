import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../components/feature_link_page.dart';
import '../ui/themes.dart';

class BookRentalScreen extends StatelessWidget {
  static const String route = '/bookrental';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: BookRentalScreen(),
    );
  }

  const BookRentalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      appBarTitle: 'BOOKRENTAL_TITLE'.tr(),
      body: Padding(
          padding: const EdgeInsets.all(kPaddingNormal),
          child: FeatureLinkPage(
            urls: const [
              'https://katalogus.jezsu.hu/kozoskatalogus/kerestargy2krovid.php',
              'https://docs.google.com/spreadsheets/d/1bbumbRPY0pf-3zQI3I3eH5c4_dYu4QsM2IoJoMPiLmI/edit?usp=sharing'
            ],
            urlTexts: [
              'BOOKRENTAL_LINK_COMMON_REF'.tr(),
              'BOOKRENTAL_LINK_OWN_REF'.tr()
            ],
            icon: CustomIcons.library,
            description: Text(
              'BOOKRENTAL_HELP_TEXT'.tr(),
              style: theme.textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
