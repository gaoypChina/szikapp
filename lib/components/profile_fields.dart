import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../ui/themes.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const ProfileTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.readOnly = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: kPaddingLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.displaySmall!
                    .copyWith(color: theme.colorScheme.primary),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: kPaddingNormal),
                  child: TextFormField(
                    initialValue: initialValue,
                    controller: controller,
                    onChanged: onChanged,
                    readOnly: readOnly,
                    textAlign: TextAlign.end,
                    maxLines: 5,
                    minLines: 1,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 2,
          color: theme.colorScheme.secondary,
        ),
      ],
    );
  }
}

class ProfileDateField extends StatelessWidget {
  final String label;
  final DateTime? initialValue;
  final bool readOnly;
  final void Function(DateTime) onChanged;

  const ProfileDateField({
    super.key,
    required this.label,
    this.initialValue,
    required this.onChanged,
    this.readOnly = false,
  });

  Future<void> _selectDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialValue ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2099),
      confirmText: 'BUTTON_OK'.tr().toUpperCase(),
      cancelText: 'BUTTON_CANCEL'.tr().toUpperCase(),
      helpText: 'DATE_PICKER_HELP'.tr().toUpperCase(),
    );
    if (newDate != null) {
      onChanged(newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.fromLTRB(0, kPaddingXLarge, 0, kPaddingNormal),
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.displaySmall!
                      .copyWith(color: theme.colorScheme.primary),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: kPaddingNormal),
                    child: Text(
                      initialValue != null
                          ? DateFormat('MMMM dd.', context.locale.toString())
                              .format(initialValue!)
                          : '',
                      textAlign: TextAlign.end,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 2,
          color: theme.colorScheme.secondary,
        ),
      ],
    );
  }
}
