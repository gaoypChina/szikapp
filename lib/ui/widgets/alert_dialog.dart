import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? content;
  final String? onAcceptText;
  final String? onCancelText;
  final void Function()? onAccept;
  final void Function()? onCancel;
  final Color? color;
  final Color? backgroundColor;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    this.content,
    this.onAcceptText,
    this.onCancelText,
    this.onAccept,
    this.onCancel,
    this.color,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AlertDialog(
      title: Text(title),
      titleTextStyle: theme.textTheme.headline3!.copyWith(
        fontSize: 20,
        color: color ?? theme.colorScheme.background,
      ),
      content: content == null ? null : Text(content!),
      contentTextStyle: theme.textTheme.headline3!.copyWith(
        fontSize: 16,
        fontStyle: FontStyle.normal,
        color: color ?? theme.colorScheme.background,
      ),
      backgroundColor:
          backgroundColor ?? theme.colorScheme.secondary.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: color ?? theme.colorScheme.background),
              borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: onCancel,
            child: Text(
              onCancelText ?? 'BUTTON_CANCEL'.tr(),
              style: theme.textTheme.headline6!.copyWith(
                fontSize: 20,
                color: color ?? theme.colorScheme.background,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: color?.withOpacity(0.5) ??
                  theme.colorScheme.background.withOpacity(0.5),
              border: Border.all(color: color ?? theme.colorScheme.background),
              borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: onAccept,
            child: Text(
              onAcceptText ?? 'BUTTON_OK'.tr(),
              style: theme.textTheme.headline6!.copyWith(
                fontSize: 20,
                color: color ?? theme.colorScheme.background,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
