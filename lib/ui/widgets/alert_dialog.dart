import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

///Személyre szabott [AlertDialog] widget.
///Két standard akciót támogat (elfogadás és elutasítás), lehetséges
///címet, tartalomszöveget, színsémát és saját akció callbackeket megadni.
class CustomAlertDialog extends StatelessWidget {
  ///Widget címe
  final String title;

  ///A cím alatt olvasható bővebb leírás
  final String? content;

  ///Elfogadás gomb felirata
  final String? onAcceptText;

  ///Elutasítás gomb felirata
  final String? onCancelText;

  ///Elfogadás gomb akció callback
  final void Function()? onAccept;

  ///Elutasítás gomb akció callback
  final void Function()? onCancel;

  ///Szöveg és keretek színe
  final Color? color;

  ///Háttérszín
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
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: color ?? theme.colorScheme.background),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                  border:
                      Border.all(color: color ?? theme.colorScheme.background),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
        )
      ],
    );
  }
}
