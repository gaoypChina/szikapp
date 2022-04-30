import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../ui/themes.dart';

///Kereshető lenyíló lista beviteli mező.
///A [DropdownSearch] widget személyre szabott változata.
class SearchableOptions<T> extends StatelessWidget {
  ///Listaelemek
  final List<T> items;

  ///Súgószöveg
  final String? hint;

  ///Választott elem jelzésére szolgáló callback
  final ValueChanged<T?> onItemChanged;

  ///Kiválasztott elem
  final T? selectedItem;

  ///Compare függvény a megadott generikus típusra
  final bool Function(T?, T?)? compare;

  ///Törlés gomb mutatása
  final bool showClearButton;

  ///Választott érték nullitásvizsgálatának bekapcsolása
  final bool nullValidated;

  final bool readonly;

  const SearchableOptions({
    Key? key,
    this.hint,
    required this.items,
    required this.onItemChanged,
    this.selectedItem,
    required this.compare,
    this.showClearButton = false,
    this.nullValidated = true,
    this.readonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DropdownSearch<T>(
      validator: nullValidated
          ? (v) {
              return v == null ? 'ERROR_REQUIRED_FIELD'.tr() : null;
            }
          : null,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      compareFn: compare,
      mode: Mode.MENU,
      showSelectedItems: true,
      showClearButton: showClearButton,
      items: items,
      selectedItem: selectedItem,
      onChanged: onItemChanged,
      showSearchBox: true,
      enabled: !readonly,
      searchFieldProps: TextFieldProps(
        style: Theme.of(context).textTheme.headline3!.copyWith(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primaryContainer,
              fontStyle: FontStyle.italic,
            ),
        decoration: InputDecoration(
          hintText: 'PLACEHOLDER_SEARCH'.tr(),
          hintStyle: theme.textTheme.caption,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadiusSmall),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          contentPadding: const EdgeInsets.all(kPaddingSmall),
        ),
      ),
      dropdownSearchDecoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusSmall),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
            style: BorderStyle.solid,
          ),
          gapPadding: 6,
        ),
        contentPadding: const EdgeInsets.all(kPaddingSmall),
      ),
      popupShape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusSmall),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
