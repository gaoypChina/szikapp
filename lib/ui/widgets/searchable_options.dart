import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';

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
  final bool Function(T, T?) compare;

  ///Törlés gomb mutatása
  final bool showClearButton;

  ///Választott érték nullitásvizsgálatának bekapcsolása
  final bool nullValidated;

  const SearchableOptions({
    Key? key,
    this.hint,
    required this.items,
    required this.onItemChanged,
    this.selectedItem,
    required this.compare,
    this.showClearButton = false,
    this.nullValidated = true,
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
      hint: hint,
      mode: Mode.MENU,
      showSelectedItem: true,
      showClearButton: showClearButton,
      items: items,
      selectedItem: selectedItem,
      onChanged: onItemChanged,
      showSearchBox: true,
      searchBoxDecoration: InputDecoration(
        hintText: 'PLACEHOLDER_SEARCH'.tr(),
        hintStyle: theme.textTheme.caption,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
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
