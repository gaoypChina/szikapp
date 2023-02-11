import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../ui/themes.dart';

class GDPRWidget extends StatelessWidget {
  final VoidCallback onAgreePressed;
  final VoidCallback onDisagreePressed;

  const GDPRWidget({
    Key? key,
    required this.onAgreePressed,
    required this.onDisagreePressed,
  }) : super(key: key);

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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'GDPR_AGREEMENT'.tr(),
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
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
