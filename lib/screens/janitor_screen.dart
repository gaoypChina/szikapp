import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../components/feature_link_page.dart';

class JanitorScreen extends StatelessWidget {
  static const String route = '/janitor';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: JanitorScreen(),
    );
  }

  const JanitorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'JANITOR_TITLE'.tr(),
      body: FeatureLinkPage(
        icon: CustomIcons.wrench,
        url:
            'https://docs.google.com/spreadsheets/d/1v-g9gMaGB9En4YVNiWaa-cnYq5ehp-HMM_iDwNlrln0/edit',
        urlText: 'JANITOR_TITLE_SPREADSHEET'.tr(),
        description: Text(
          'JANITOR_DESCRIPTION'.tr(),
          style: theme.textTheme.headline2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
