import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../business/business.dart';
import '../components/menu/menu_item.dart';
import '../navigation/navigation.dart';

class MenuScreen extends StatelessWidget {
  static const String route = '/menu';

  const MenuScreen({Key key = const Key('MenuScreen')}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Az alábbi sor az easy_localization package hibája
    // https://github.com/aissat/easy_localization/issues/370#issuecomment-920807924
    context.locale;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    var fifth =
        (MediaQuery.of(context).size.height - kBottomNavigationBarHeight) * 0.2;
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
            picture: 'assets/icons/bookopen_light_72.png',
            onTap: () =>
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .selectSubMenu(SzikAppSubMenu.data),
            height: fifth,
            reversed: true,
          ),
          CustomMenuItem(
            name: 'SUBMENU_COMMUNITY_TITLE'.tr(),
            picture: 'assets/icons/smiley_light_72.png',
            onTap: () =>
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .selectSubMenu(SzikAppSubMenu.community),
            height: fifth,
          ),
          CustomMenuItem(
            name: 'SUBMENU_EVERYDAY_TITLE'.tr(),
            picture: 'assets/icons/house_light_72.png',
            onTap: () =>
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .selectSubMenu(SzikAppSubMenu.everyday),
            height: fifth,
            reversed: true,
          ),
          Provider.of<AuthManager>(context, listen: false)
                  .user!
                  .hasPermissionToAccess(
                    SzikAppLink(currentFeature: SzikAppFeature.calendar),
                  )
              ? CustomMenuItem(
                  name: 'MENU_CALENDAR'.tr(),
                  picture: 'assets/icons/calendar_light_72.png',
                  onTap: () =>
                      Provider.of<SzikAppStateManager>(context, listen: false)
                          .selectFeature(SzikAppFeature.calendar),
                  height: fifth,
                )
              : Container(),
          CustomMenuItem(
            name: 'MENU_SETTINGS'.tr(),
            picture: 'assets/icons/gear_light_72.png',
            onTap: () =>
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .selectFeature(SzikAppFeature.settings),
            height: fifth,
            reversed: true,
          ),
        ],
      ),
    );
  }
}
