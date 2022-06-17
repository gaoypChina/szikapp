import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/resource.dart';
import '../ui/themes.dart';
import '../utils/methods.dart';

class ArticleCard extends StatelessWidget {
  final Article data;

  const ArticleCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      margin: const EdgeInsets.all(kPaddingNormal),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(kBorderRadiusNormal),
              ),
              child: Image.network(data.imageUrl),
            ),
            const SizedBox(height: kPaddingNormal),
            Text(
              data.name,
              style: theme.textTheme.headline2!,
            ),
            const SizedBox(height: kPaddingNormal),
            Text(
              data.description ?? '',
              style: theme.textTheme.caption,
            ),
            const SizedBox(height: kPaddingNormal),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy.MM.dd.').format(data.lastUpdate),
                  style: theme.textTheme.caption,
                ),
                OutlinedButton(
                  onPressed: () => openUrl(data.url),
                  child: Text(
                    'BUTTON_SEE_MORE'.tr(),
                    style: theme.textTheme.button!.copyWith(fontSize: 12),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
