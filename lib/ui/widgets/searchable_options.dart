import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchableOptions<T> extends StatelessWidget {
  final List<T> items;
  final String? hint;
  final ValueChanged onItemChanged;

  const SearchableOptions({
    Key? key,
    this.hint,
    required this.items,
    required this.onItemChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      validator: (v) => v == null ? 'ERROR_REQUIRED_FIELD'.tr() : null,
      hint: hint,
      mode: Mode.MENU,
      showSelectedItem: true,
      showClearButton: true,
      items: items,
      selectedItem: items.first,
      onChanged: onItemChanged,
    );
  }
}
