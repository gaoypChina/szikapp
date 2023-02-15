import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../ui/themes.dart';
import 'components.dart';

enum DialogType {
  alert,
  confirmation,
  feedback,
}

class CustomDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String bodytext;
  final VoidCallback onWeakButtonClick;
  final VoidCallback onStrongButtonClick;

  const CustomDialog.alert({
    super.key,
    required this.title,
    required this.onWeakButtonClick,
    required this.onStrongButtonClick,
  })  : type = DialogType.alert,
        bodytext = '';

  const CustomDialog.confirmation({
    super.key,
    required this.title,
    required this.bodytext,
    required this.onWeakButtonClick,
    required this.onStrongButtonClick,
  }) : type = DialogType.confirmation;

  CustomDialog.feedback({
    super.key,
    required this.title,
  })  : type = DialogType.feedback,
        bodytext = '',
        onWeakButtonClick = (() => (null)),
        onStrongButtonClick = (() => (null));

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var weakButtonLabel = '';
    var strongButtonLabel = '';
    switch (type) {
      case DialogType.alert:
        weakButtonLabel = 'BUTTON_NO'.tr();
        strongButtonLabel = 'BUTTON_YES'.tr();
        break;
      case DialogType.confirmation:
        weakButtonLabel = 'BUTTON_CANCEL'.tr();
        strongButtonLabel = 'BUTTON_YES'.tr();
        break;
      case DialogType.feedback:
        break;
    }
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      insetPadding: const EdgeInsets.all(kPaddingLarge),
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == DialogType.feedback)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: Navigator.of(context, rootNavigator: true).pop,
                    child: CustomIcon(
                      CustomIcons.close,
                      color: theme.colorScheme.secondaryContainer,
                    ),
                  )
                ],
              ),
            const SizedBox(height: kPaddingNormal),
            Padding(
              padding: const EdgeInsets.only(bottom: kPaddingNormal),
              child: Text(
                title,
                style: theme.textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
            ),
            if (bodytext.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(kPaddingNormal),
                child: Text(
                  bodytext,
                  style: theme.textTheme.displaySmall!.copyWith(
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ),
            const SizedBox(height: kPaddingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (weakButtonLabel.isNotEmpty)
                  OutlinedButton(
                    onPressed: onWeakButtonClick,
                    style: theme.outlinedButtonTheme.style!.copyWith(
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => type == DialogType.alert
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.primaryContainer),
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(
                            color: type == DialogType.alert
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.primaryContainer),
                      ),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (Set<MaterialState> states) => RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kBorderRadiusSmall),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: kPaddingNormal,
                        horizontal: kPaddingLarge,
                      ),
                      child: Text(
                        weakButtonLabel,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: type == DialogType.alert
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                  ),
                if (strongButtonLabel.isNotEmpty)
                  ElevatedButton(
                    onPressed: onStrongButtonClick,
                    style: theme.outlinedButtonTheme.style!.copyWith(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => type == DialogType.alert
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.primaryContainer),
                      side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide.none),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (Set<MaterialState> states) => RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kBorderRadiusSmall),
                        ),
                      ),
                      elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) => 0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: kPaddingNormal,
                        horizontal: kPaddingLarge,
                      ),
                      child: Text(
                        strongButtonLabel,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: theme.colorScheme.surface,
                        ),
                      ),
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
