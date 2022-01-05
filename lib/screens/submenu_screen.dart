import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/components.dart';
import '../navigation/app_state_manager.dart';

class SubMenuButton {
  final String picture;
  final String name;
  final int feature;

  SubMenuButton({
    required this.picture,
    required this.name,
    required this.feature,
  });
}

final List<SubMenuButton> subMenuDataListItems = [
  SubMenuButton(
    name: 'SUBMENU_DATA_CONTACTS'.tr(),
    picture: 'assets/icons/users_light_72.png',
    feature: SzikAppFeature.contacts,
  ),
  SubMenuButton(
    name: 'SUBMENU_DATA_DOCUMENTS'.tr(),
    picture: 'assets/icons/book_light_72.png',
    feature: SzikAppFeature.documents,
  ),
];

final List<SubMenuButton> subMenuCommunityListItems = [
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_HELPME'.tr(),
    picture: 'assets/icons/helpme_light_72.png',
    feature: SzikAppFeature.error,
  ),
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_BEERWITHME'.tr(),
    picture: 'assets/icons/beer_light_72.png',
    feature: SzikAppFeature.error,
  ),
  SubMenuButton(
    name: 'SUBMENU_COMMUNITY_SPIRITUAL'.tr(),
    picture: 'assets/icons/fire_light_72.png',
    feature: SzikAppFeature.error,
  ),
];

final List<SubMenuButton> subMenuEverydayListItems = [
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_CLEANING'.tr(),
    picture: 'assets/icons/knife_light_72.png',
    feature: SzikAppFeature.error,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_RESERVATION'.tr(),
    picture: 'assets/icons/hourglass_light_72.png',
    feature: SzikAppFeature.reservation,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_JANITOR'.tr(),
    picture: 'assets/icons/wrench_light_72.png',
    feature: SzikAppFeature.janitor,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_FORMS'.tr(),
    picture: 'assets/icons/pencil_light_72.png',
    feature: SzikAppFeature.error,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_POLL'.tr(),
    picture: 'assets/icons/handpalm_light_72.png',
    feature: SzikAppFeature.error,
  ),
  SubMenuButton(
    name: 'SUBMENU_EVERYDAY_BOOKLOAN'.tr(),
    picture: 'assets/icons/bank_light_72.png',
    feature: SzikAppFeature.error,
  ),
];

final List<List<SubMenuButton>> subMenus = [
  subMenuDataListItems,
  subMenuCommunityListItems,
  subMenuEverydayListItems,
];

final List<String> subMenuTitles = [
  'SUBMENU_DATA_TITLE'.tr(),
  'SUBMENU_COMMUNITY_TITLE'.tr(),
  'SUBMENU_EVERYDAY_TITLE'.tr(),
];

class SubMenuScreen extends StatelessWidget {
  final int selectedSubMenu;
  static const String route = '/submenu';

  static MaterialPage page({required int selectedSubMenu}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: SubMenuScreen(
        selectedSubMenu: selectedSubMenu,
      ),
    );
  }

  const SubMenuScreen({
    Key key = const Key('SubMenuScreen'),
    required this.selectedSubMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/pictures/background_1.jpg'),
                fit: BoxFit.cover),
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    subMenuTitles[selectedSubMenu].toUpperCase(),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 25,
                        ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 4
                        : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: subMenus[selectedSubMenu]
                        .map((item) => Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Provider.of<SzikAppStateManager>(context,
                                          listen: false)
                                      .selectFeature(item.feature);
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(0.7),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      SizedBox(
                                        height: 55,
                                        width: 55,
                                        child: ColorFiltered(
                                          child: Image.asset(item.picture),
                                          colorFilter: ColorFilter.mode(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.name,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 16,
                                                ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SzikBottomNavigationBar(
          selectedTab: Provider.of<SzikAppStateManager>(context, listen: false)
              .selectedTab,
        ),
      ),
    );
  }
}
