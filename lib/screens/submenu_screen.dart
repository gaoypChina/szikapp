import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/auth_manager.dart';
import '../components/components.dart';
import '../navigation/navigation.dart';
import '../ui/themes.dart';

final List<SubMenuItemData> subMenuDataListItems = [
  SubMenuItemData(
    name: 'CONTACTS_TITLE'.tr(),
    picture: 'assets/icons/users_light_72.png',
    feature: SzikAppFeature.contacts,
  ),
  SubMenuItemData(
    name: 'DOCUMENTS_TITLE'.tr(),
    picture: 'assets/icons/book_light_72.png',
    feature: SzikAppFeature.documents,
  ),
];

final List<SubMenuItemData> subMenuCommunityListItems = [
  SubMenuItemData(
    name: 'HELP_ME_TITLE'.tr(),
    picture: 'assets/icons/helpme_light_72.png',
    feature: SzikAppFeature.error,
  ),
  SubMenuItemData(
    name: 'BEER_WITH_ME_TITLE'.tr(),
    picture: 'assets/icons/beer_light_72.png',
    feature: SzikAppFeature.error,
  ),
  SubMenuItemData(
    name: 'SPIRITUAL_TITLE'.tr(),
    picture: 'assets/icons/fire_light_72.png',
    feature: SzikAppFeature.error,
  ),
];

final List<SubMenuItemData> subMenuEverydayListItems = [
  SubMenuItemData(
    name: 'CLEANING_TITLE'.tr(),
    picture: 'assets/icons/knife_light_72.png',
    feature: SzikAppFeature.cleaning,
  ),
  SubMenuItemData(
    name: 'RESERVATION_TITLE'.tr(),
    picture: 'assets/icons/hourglass_light_72.png',
    feature: SzikAppFeature.reservation,
  ),
  SubMenuItemData(
    name: 'JANITOR_TITLE'.tr(),
    picture: 'assets/icons/wrench_light_72.png',
    feature: SzikAppFeature.janitor,
  ),
  SubMenuItemData(
    name: 'FORMS_TITLE'.tr(),
    picture: 'assets/icons/pencil_light_72.png',
    feature: SzikAppFeature.error,
  ),
  SubMenuItemData(
    name: 'POLL_TITLE'.tr(),
    picture: 'assets/icons/handpalm_light_72.png',
    feature: SzikAppFeature.poll,
  ),
  SubMenuItemData(
    name: 'BOOKRENTAL_TITLE'.tr(),
    picture: 'assets/icons/bank_light_72.png',
    feature: SzikAppFeature.error,
  ),
];

final List<List<SubMenuItemData>> subMenus = [
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
    return CustomScaffold(
      appBarTitle: subMenuTitles[selectedSubMenu],
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pictures/background_1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(
            kPaddingLarge,
            kPaddingLarge,
            kPaddingLarge,
            0,
          ),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: kPaddingNormal,
            mainAxisSpacing: kPaddingNormal,
            children: _buildGridItems(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGridItems(BuildContext context) {
    var items = <Widget>[];
    var user = Provider.of<AuthManager>(context, listen: false).user;
    for (var item in subMenus[selectedSubMenu]) {
      if (user!.hasPermissionToAccess(
        SzikAppLink(currentFeature: item.feature),
      )) {
        items.add(SubMenuItem(data: item));
      }
    }
    return items;
  }
}
