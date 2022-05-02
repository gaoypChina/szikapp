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
  final ValueChanged<List<T>> onItemsChanged;

  ///Kiválasztott elemek
  final List<T> selectedItems;

  ///Compare függvény a megadott generikus típusra
  final bool Function(T?, T?)? compare;

  ///Törlés gomb mutatása
  final bool showClearButton;

  ///Választott érték nullitásvizsgálatának bekapcsolása
  final bool nullValidated;

  final bool allowMultiSelection;

  final bool readonly;

  SearchableOptions({
    Key? key,
    this.hint,
    required this.items,
    required void Function(T?) onItemChanged,
    T? selectedItem,
    required this.compare,
    this.readonly = false,
    this.showClearButton = false,
    this.nullValidated = true,
  })  : allowMultiSelection = false,
        selectedItems = selectedItem == null ? const [] : [selectedItem],
        onItemsChanged = ((value) => onItemChanged(value.first)),
        super(key: key);

  const SearchableOptions.multiSelection({
    Key? key,
    this.hint,
    required this.items,
    required this.onItemsChanged,
    this.selectedItems = const [],
    required this.compare,
    this.readonly = false,
    this.showClearButton = false,
    this.nullValidated = true,
  })  : allowMultiSelection = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return allowMultiSelection
        ? DropdownSearch<T>.multiSelection(
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
            selectedItems: selectedItems,
            onChanged: onItemsChanged,
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
          )
        : DropdownSearch<T>(
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
            selectedItem: selectedItems.first,
            onChanged: (item) => onItemsChanged(item == null ? [] : [item]),
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
