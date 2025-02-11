import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../business/business.dart';
import '../components/components.dart';
import '../navigation/navigation.dart';

class MenuScreen extends StatelessWidget {
  static const String route = '/menu';

  const MenuScreen({super.key = const Key('MenuScreen')});

  @override
  Widget build(BuildContext context) {
    //Az alábbi sor az easy_localization package hibája
    // https://github.com/aissat/easy_localization/issues/370#issuecomment-920807924
    context.locale;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Provider.of<AuthManager>(context).isUserGuest
        ? _buildGuestMenu(context)
        : _buildMenu(context);
  }

  Widget _buildGuestMenu(BuildContext context) {
    var fifth =
        (MediaQuery.of(context).size.height - kBottomNavigationBarHeight) * 0.2;
    var appStateManager =
        Provider.of<SzikAppStateManager>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/pictures/background_1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomMenuItem(
            name: 'ARTICLE_TITLE'.tr(),
            picture: CustomIcons.article,
            onTap: () =>
                appStateManager.selectFeature(feature: SzikAppFeature.article),
            height: fifth,
            reversed: true,
          ),
          CustomMenuItem(
            name: 'INVITATION_TITLE'.tr(),
            picture: CustomIcons.envelope,
            onTap: () => appStateManager.selectFeature(
                feature: SzikAppFeature.invitation),
            height: fifth,
          ),
          CustomMenuItem(
            name: 'MENU_SETTINGS'.tr(),
            picture: CustomIcons.settings,
            onTap: () =>
                appStateManager.selectFeature(feature: SzikAppFeature.settings),
            height: fifth,
            reversed: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    var fifth =
        (MediaQuery.of(context).size.height - kBottomNavigationBarHeight) * 0.2;
    var appStateManager =
        Provider.of<SzikAppStateManager>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/pictures/background_1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomMenuItem(
            name: 'SUBMENU_DATA_TITLE'.tr(),
            picture: CustomIcons.bookOpen,
            onTap: () =>
                appStateManager.selectSubMenu(index: SzikAppSubMenu.data),
            height: fifth,
            reversed: true,
          ),
          CustomMenuItem(
            name: 'SUBMENU_COMMUNITY_TITLE'.tr(),
            picture: CustomIcons.smiley,
            onTap: () =>
                appStateManager.selectSubMenu(index: SzikAppSubMenu.community),
            height: fifth,
          ),
          CustomMenuItem(
            name: 'SUBMENU_EVERYDAY_TITLE'.tr(),
            picture: CustomIcons.house,
            onTap: () =>
                appStateManager.selectSubMenu(index: SzikAppSubMenu.everyday),
            height: fifth,
            reversed: true,
          ),
          if (Provider.of<AuthManager>(context, listen: false)
                  .user
                  ?.hasPermissionToAccess(
                    link: SzikAppLink(
                      currentFeature: SzikAppFeature.calendar,
                    ),
                  ) ??
              false)
            CustomMenuItem(
              name: 'MENU_CALENDAR'.tr(),
              picture: CustomIcons.calendar,
              onTap: () => appStateManager.selectFeature(
                  feature: SzikAppFeature.calendar),
              height: fifth,
            ),
          CustomMenuItem(
            name: 'MENU_SETTINGS'.tr(),
            picture: CustomIcons.settings,
            onTap: () =>
                appStateManager.selectFeature(feature: SzikAppFeature.settings),
            height: fifth,
            reversed: true,
          ),
        ],
      ),
    );
  }
}
