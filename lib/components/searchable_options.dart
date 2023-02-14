import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../ui/themes.dart';
import 'components.dart';

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
                    return (v == null || v.isEmpty)
                        ? 'ERROR_REQUIRED_FIELD'.tr()
                        : null;
                  }
                : null,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            compareFn: compare,
            clearButtonProps: const ClearButtonProps(
              isVisible: true,
              icon: CustomIcon(CustomIcons.close),
            ),
            items: items,
            selectedItems: selectedItems,
            onChanged: onItemsChanged,
            enabled: !readonly,
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              showSelectedItems: true,
              menuProps: MenuProps(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              searchFieldProps: TextFieldProps(
                style: theme.textTheme.displaySmall!.copyWith(
                  fontSize: 14,
                  color: theme.colorScheme.primaryContainer,
                  fontStyle: FontStyle.italic,
                ),
                decoration: InputDecoration(
                  hintText: 'PLACEHOLDER_SEARCH'.tr(),
                  hintStyle: theme.textTheme.bodySmall,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(kPaddingSmall),
                ),
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: theme.textTheme.displaySmall!.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primaryContainer,
                fontStyle: FontStyle.italic,
              ),
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                  gapPadding: 2,
                ),
                contentPadding: const EdgeInsets.all(kPaddingSmall),
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
            items: items,
            selectedItem: selectedItems.first,
            onChanged: (item) => onItemsChanged(item == null ? [] : [item]),
            enabled: !readonly,
            clearButtonProps: const ClearButtonProps(
              icon: CustomIcon(CustomIcons.close),
            ),
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              showSelectedItems: true,
              menuProps: MenuProps(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              searchFieldProps: TextFieldProps(
                style: theme.textTheme.displaySmall!.copyWith(
                  fontSize: 14,
                  color: theme.colorScheme.primaryContainer,
                  fontStyle: FontStyle.italic,
                ),
                decoration: InputDecoration(
                  hintText: 'PLACEHOLDER_SEARCH'.tr(),
                  hintStyle: theme.textTheme.bodySmall,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(kPaddingSmall),
                ),
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: theme.textTheme.displaySmall!.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primaryContainer,
                fontStyle: FontStyle.italic,
              ),
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                  gapPadding: 2,
                ),
                contentPadding: const EdgeInsets.all(kPaddingSmall),
              ),
            ),
          );
  }
}
