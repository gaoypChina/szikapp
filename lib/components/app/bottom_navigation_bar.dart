import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business/business.dart';
import '../../navigation/app_state_manager.dart';
import '../../ui/themes.dart';
import '../components.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedTab;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedTab,
  });

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
        var appStateManager =
            Provider.of<SzikAppStateManager>(context, listen: false);
        if (appStateManager.selectedFeature == SzikAppFeature.reservation) {
          Provider.of<ReservationManager>(context, listen: false).clear();
        } else if (appStateManager.selectedFeature == SzikAppFeature.poll) {
          Provider.of<PollManager>(context, listen: false)
              .performBackButtonPressed();
        } else if (appStateManager.selectedFeature == SzikAppFeature.cleaning) {
          Provider.of<KitchenCleaningManager>(context, listen: false)
              .performBackButtonPressed();
        }
        appStateManager.selectTab(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIcon(
            CustomIcons.feed,
            color: _getSelectionColor(
              selectedTab,
              0,
              theme.colorScheme.onPrimary,
            ),
          ),
          label: 'MENU_FEED'.tr(),
        ),
        BottomNavigationBarItem(
          icon: CustomIcon(
            CustomIcons.cedar,
            size: kIconSizeLarge,
            color: _getSelectionColor(
              selectedTab,
              1,
              theme.colorScheme.onPrimary,
            ),
          ),
          label: 'MENU_HOME'.tr(),
        ),
        BottomNavigationBarItem(
          icon: CustomIcon(
            CustomIcons.settings,
            color: _getSelectionColor(
              selectedTab,
              2,
              theme.colorScheme.onPrimary,
            ),
          ),
          label: 'MENU_SETTINGS'.tr(),
        )
      ],
    );
  }
}
