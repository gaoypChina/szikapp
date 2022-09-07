import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../components/components.dart';
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomIcon(
                CustomIcons.library,
                size: kIconSizeXLarge,
                color: theme.colorScheme.primary,
              ),
              Text(
                'BOOKRENTAL_HELP_TEXT'.tr(),
                style: theme.textTheme.headline3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: kPaddingLarge),
              Link(
                uri: Uri.parse(
                  'https://katalogus.jezsu.hu/kozoskatalogus/kerestargy2krovid.php',
                ),
                target: LinkTarget.defaultTarget,
                builder: (context, followLink) {
                  return InkWell(
                    onTap: followLink,
                    child: Text(
                      'BOOKRENTAL_LINK_COMMON_REF'.tr(),
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: kPaddingSmall),
              Link(
                uri: Uri.parse(
                  'https://docs.google.com/spreadsheets/d/1bbumbRPY0pf-3zQI3I3eH5c4_dYu4QsM2IoJoMPiLmI/edit?usp=sharing',
                ),
                target: LinkTarget.defaultTarget,
                builder: (context, followLink) {
                  return InkWell(
                    onTap: followLink,
                    child: Text(
                      'BOOKRENTAL_LINK_OWN_REF'.tr(),
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
