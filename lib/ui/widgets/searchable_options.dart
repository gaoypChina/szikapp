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
      showClearButton: false,
      items: items,
      selectedItem: items.first,
      onChanged: onItemChanged,
      showSearchBox: true,
      searchBoxDecoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        contentPadding: EdgeInsets.all(5),
      ),
      dropdownSearchDecoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
            style: BorderStyle.solid,
          ),
          gapPadding: 6,
        ),
        contentPadding: EdgeInsets.all(5),
      ),
      searchBoxStyle: Theme.of(context).textTheme.headline3!.copyWith(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primaryVariant,
            fontStyle: FontStyle.italic,
          ),
      popupShape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
