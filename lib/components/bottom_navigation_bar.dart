import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';

class SzikAppBottomNavigationBar extends StatelessWidget {
  final int selectedTab;
  const SzikAppBottomNavigationBar({
    Key? key,
    required this.selectedTab,
  }) : super(key: key);

  Color _getSelectionColor(
    int selectedTab,
    int currentIndex,
    Color defaultColor,
  ) {
    return selectedTab == currentIndex
        ? defaultColor
        : defaultColor.withOpacity(0.7);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BottomNavigationBar(
      selectedItemColor: theme.colorScheme.onPrimary,
      backgroundColor: theme.colorScheme.primary,
      enableFeedback: true,
      currentIndex: selectedTab,
      showUnselectedLabels: false,
      onTap: (index) {
        Provider.of<SzikAppStateManager>(context, listen: false)
            .selectTab(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: ColorFiltered(
            child: Image.asset(
              'assets/icons/feed_light_72.png',
              width: kIconSizeNormal,
            ),
            colorFilter: ColorFilter.mode(
              _getSelectionColor(selectedTab, 0, Colors.white),
              BlendMode.srcIn,
            ),
          ),
          label: 'MENU_FEED'.tr(),
        ),
        BottomNavigationBarItem(
          icon: ColorFiltered(
            child: Image.asset(
              'assets/icons/cedar_light_72.png',
              width: kIconSizeNormal,
            ),
            colorFilter: ColorFilter.mode(
              _getSelectionColor(selectedTab, 1, Colors.white),
              BlendMode.srcIn,
            ),
          ),
          label: 'MENU_HOME'.tr(),
        ),
        BottomNavigationBarItem(
          icon: ColorFiltered(
            child: Image.asset(
              'assets/icons/gear_light_72.png',
              width: kIconSizeNormal,
            ),
            colorFilter: ColorFilter.mode(
              _getSelectionColor(selectedTab, 2, Colors.white),
              BlendMode.srcIn,
            ),
          ),
          label: 'MENU_SETTINGS'.tr(),
        )
      ],
    );
  }
}
