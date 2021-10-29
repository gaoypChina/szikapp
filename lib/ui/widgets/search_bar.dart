import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final void Function()? onToggleFilterExpandable;
  final String placeholder;
  final double searchBarIconSize;

  const SearchBar({
    Key? key,
    required this.onChanged,
    this.validator,
    this.onToggleFilterExpandable,
    required this.placeholder,
    this.searchBarIconSize = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border.all(color: theme.colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: searchBarIconSize,
            height: searchBarIconSize,
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: ColorFiltered(
              child: Image.asset('assets/icons/search_light_72.png'),
              colorFilter:
                  ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: TextFormField(
              validator: validator,
              autofocus: false,
              style: theme.textTheme.headline3!.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primary,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
          GestureDetector(
            onTap: onToggleFilterExpandable,
            child: Container(
              width: searchBarIconSize,
              height: searchBarIconSize,
              margin: const EdgeInsets.only(right: 8),
              child: ColorFiltered(
                child: Image.asset('assets/icons/sliders_light_72.png'),
                colorFilter: ColorFilter.mode(
                    theme.colorScheme.primary, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
