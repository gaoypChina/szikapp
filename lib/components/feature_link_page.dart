import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../ui/themes.dart';
import 'custom_icon.dart';

class FeatureLinkPage extends StatelessWidget {
  final List<String> urls;
  final List<String> urlTexts;
  final String icon;
  final Widget? description;

  const FeatureLinkPage({
    Key? key,
    required this.urls,
    required this.urlTexts,
    required this.icon,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIcon(
            icon,
            size: kIconSizeXLarge,
            color: theme.colorScheme.primary,
          ),
          description ?? Container(),
          const SizedBox(height: kPaddingNormal),
          ...urls.map((url) {
            return Link(
              uri: Uri.parse(url),
              target: LinkTarget.defaultTarget,
              builder: (context, followLink) {
                return InkWell(
                  onTap: followLink,
                  child: Text(
                    urlTexts[urls.indexOf(url)],
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
