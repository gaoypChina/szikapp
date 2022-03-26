import 'package:flutter/material.dart';

import '../ui/themes.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const ProfileTextField({
    Key? key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.readOnly = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: kPaddingLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
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
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
