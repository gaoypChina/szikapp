import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? filter;
  final String placeholder;
  final double searchBarIconSize;

  const SearchBar({
    Key? key,
    required this.onChanged,
    this.validator,
    this.filter,
    required this.placeholder,
    this.searchBarIconSize = 30.0,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
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
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border.all(color: theme.colorScheme.primary, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: widget.searchBarIconSize,
                height: widget.searchBarIconSize,
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: ColorFiltered(
                  child: Image.asset('assets/icons/search_light_72.png'),
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  validator: widget.validator,
                  autofocus: false,
                  style: theme.textTheme.headline3!.copyWith(
                    fontSize: 14,
                    color: theme.colorScheme.primary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
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
                  child: Container(
                    width: widget.searchBarIconSize,
                    height: widget.searchBarIconSize,
                    margin: const EdgeInsets.only(right: 8),
                    child: ColorFiltered(
                      child: Image.asset('assets/icons/sliders_light_72.png'),
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: _heightFactor,
          child: widget.filter,
        ),
      ],
    );
  }
}
