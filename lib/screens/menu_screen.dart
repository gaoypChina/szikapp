import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../navigation/app_state_manager.dart';

import 'submenu_screen.dart';

class MenuScreen extends StatelessWidget {
  static const String route = '/menu';

  const MenuScreen({Key key = const Key('MenuScreen')}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    var fifth =
        (MediaQuery.of(context).size.height - kBottomNavigationBarHeight) * 0.2;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/pictures/background_1.jpg'),
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubMenuScreen(
                  listItems: subMenuDataListItems,
                  title: 'SUBMENU_DATA_TITLE'.tr(),
                ),
              ),
            ),
            child: SizedBox(
              height: fifth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Center(
                    child: Container(
                      width: fifth * 0.5,
                      height: fifth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(fifth * 0.1),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(fifth * 0.05),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/icons/bookopen_light_72.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'SUBMENU_DATA_TITLE'.tr(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: fifth * 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubMenuScreen(
                  listItems: subMenuCommunityListItems,
                  title: 'SUBMENU_COMMUNITY_TITLE'.tr(),
                ),
              ),
            ),
            child: Container(
              height: fifth,
              margin: EdgeInsets.only(top: fifth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'SUBMENU_COMMUNITY_TITLE'.tr(),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: fifth * 0.1),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: fifth * 0.5,
                      height: fifth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(fifth * 0.1),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(fifth * 0.05),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/icons/smiley_light_72.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubMenuScreen(
                  listItems: subMenuEverydayListItems,
                  title: 'SUBMENU_EVERYDAY_TITLE'.tr(),
                ),
              ),
            ),
            child: Container(
              height: fifth,
              margin: EdgeInsets.only(top: fifth * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Center(
                    child: Container(
                      width: fifth * 0.5,
                      height: fifth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(fifth * 0.1),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(fifth * 0.05),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/icons/house_light_72.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'SUBMENU_EVERYDAY_TITLE'.tr(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: fifth * 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .selectFeature(SzikAppFeature.calendar),
            child: Container(
              height: fifth,
              margin: EdgeInsets.only(top: fifth * 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'MENU_CALENDAR'.tr(),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: fifth * 0.1),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: fifth * 0.5,
                      height: fifth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(fifth * 0.1),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(fifth * 0.05),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/icons/calendar_light_72.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .selectFeature(SzikAppFeature.settings),
            child: Container(
              height: fifth,
              margin: EdgeInsets.only(top: fifth * 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Center(
                    child: Container(
                      width: fifth * 0.5,
                      height: fifth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(fifth * 0.1),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(fifth * 0.05),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/gear_light_72.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'MENU_SETTINGS'.tr(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: fifth * 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
