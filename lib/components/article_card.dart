import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/resource.dart';
import '../ui/themes.dart';
import '../utils/methods.dart';

class ArticleCard extends StatelessWidget {
  final Article data;

  const ArticleCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: kPaddingNormal,
        horizontal: kPaddingLarge,
      ),
      padding: const EdgeInsets.all(kPaddingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(kBorderRadiusNormal),
        ),
        border: Border.all(color: theme.colorScheme.primary),
      ),
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
            style: theme.textTheme.displayMedium!,
          ),
          const SizedBox(height: kPaddingNormal),
          Text(
            data.description ?? '',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: kPaddingNormal),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy.MM.dd.').format(data.lastUpdate),
                style: theme.textTheme.bodySmall,
              ),
              OutlinedButton(
                onPressed: () {
                  SzikAppState.analytics.logEvent(name: 'article_open');
                  openUrl(data.url);
                },
                child: Text(
                  'BUTTON_SEE_MORE'.tr(),
                  style: theme.textTheme.labelLarge!.copyWith(fontSize: 12),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
