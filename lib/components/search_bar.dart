import 'package:flutter/material.dart';

import '../ui/themes.dart';
import 'components.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final Widget? filter;
  final String placeholder;
  final double searchBarIconSize;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.filter,
    required this.placeholder,
    this.searchBarIconSize = kSearchBarIconSize,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  late AnimationController _filterToggleController;
  late Animation<double> _heightFactor;

  bool _isFilterExpanded = false;

  @override
  void initState() {
    _filterToggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _heightFactor = _filterToggleController.drive(_easeInTween);
    if (_isFilterExpanded) _filterToggleController.value = 1.0;
    super.initState();
  }

  @override
  void dispose() {
    _filterToggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kPaddingLarge,
        kPaddingLarge,
        kPaddingLarge,
        kPaddingSmall,
      ),
      child: Column(
        children: [
          SearchBar(
            leading: CustomIcon(
              CustomIcons.search,
              color: theme.colorScheme.primary,
              size: widget.searchBarIconSize,
            ),
            onChanged: widget.onChanged,
            hintText: widget.placeholder,
            elevation: const MaterialStatePropertyAll(0),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (Set<MaterialState> states) => RoundedRectangleBorder(
                side: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(kBorderRadiusLarge),
              ),
            ),
            trailing: [
              if (widget.filter != null)
                GestureDetector(
                  onTap: () => setState(
                    () {
                      _isFilterExpanded = !_isFilterExpanded;
                      _isFilterExpanded
                          ? _filterToggleController.forward()
                          : _filterToggleController.reverse();
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kPaddingNormal),
                    child: CustomIcon(
                      CustomIcons.filter,
                      color: theme.colorScheme.primary,
                      size: widget.searchBarIconSize,
                    ),
                  ),
                ),
            ],
          ),
          SizeTransition(
            sizeFactor: _heightFactor,
            child: Padding(
              padding: const EdgeInsets.only(top: kPaddingNormal),
              child: widget.filter,
            ),
          ),
        ],
      ),
    );
  }
}
