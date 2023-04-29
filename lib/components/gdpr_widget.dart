import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../ui/themes.dart';

class GDPRWidget extends StatelessWidget {
  final VoidCallback onAgreePressed;
  final VoidCallback onDisagreePressed;

  const GDPRWidget({
    super.key,
    required this.onAgreePressed,
    required this.onDisagreePressed,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.all(kPaddingLarge),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusNormal),
      ),
      backgroundColor: theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          kPaddingLarge,
          kPaddingLarge,
          kPaddingLarge,
          kPaddingNormal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GDPR_AGREEMENT'.tr(),
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: kPaddingNormal),
            Link(
              uri: Uri.parse('https://szikapp.netlify.app/privacy_policy.html'),
              target: LinkTarget.defaultTarget,
              builder: (context, followLink) {
                return InkWell(
                  onTap: followLink,
                  child: Text(
                    'PRIVACY_POLICY_LINK'.tr(),
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                );
              },
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: onDisagreePressed,
                  child: Text(
                    'BUTTON_DISAGREE'.tr(),
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onAgreePressed,
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text(
                    'BUTTON_AGREE'.tr(),
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
