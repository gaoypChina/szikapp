import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/auth_manager.dart';
import '../components/components.dart';
import '../navigation/navigation.dart';
import '../ui/themes.dart';

class SubMenuScreen extends StatefulWidget {
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
    super.key = const Key('SubMenuScreen'),
    required this.selectedSubMenu,
  });

  @override
  State<SubMenuScreen> createState() => _SubMenuScreenState();
}

class _SubMenuScreenState extends State<SubMenuScreen> {
  List<SubMenuItemData> subMenuDataListItems = [
    SubMenuItemData(
      name: 'CONTACTS_TITLE'.tr(),
      picture: CustomIcons.users,
      feature: SzikAppFeature.contacts,
    ),
    SubMenuItemData(
      name: 'DOCUMENTS_TITLE'.tr(),
      picture: CustomIcons.bookClosed,
      feature: SzikAppFeature.documents,
    ),
    SubMenuItemData(
      name: 'PASSWORDS_TITLE'.tr(),
      picture: CustomIcons.password,
      feature: SzikAppFeature.passwords,
    )
  ];

  List<SubMenuItemData> subMenuCommunityListItems = [
    SubMenuItemData(
      name: 'HELP_ME_TITLE'.tr(),
      picture: CustomIcons.shield,
      feature: SzikAppFeature.error,
    ),
    SubMenuItemData(
      name: 'BEER_WITH_ME_TITLE'.tr(),
      picture: CustomIcons.beer,
      feature: SzikAppFeature.error,
    ),
    SubMenuItemData(
      name: 'SPIRITUAL_TITLE'.tr(),
      picture: CustomIcons.fire,
      feature: SzikAppFeature.error,
    ),
  ];

  List<SubMenuItemData> subMenuEverydayListItems = [
    SubMenuItemData(
      name: 'CLEANING_TITLE'.tr(),
      picture: CustomIcons.knife,
      feature: SzikAppFeature.cleaning,
    ),
    SubMenuItemData(
      name: 'RESERVATION_TITLE'.tr(),
      picture: CustomIcons.hourglass,
      feature: SzikAppFeature.reservation,
    ),
    SubMenuItemData(
      name: 'JANITOR_TITLE'.tr(),
      picture: CustomIcons.wrench,
      feature: SzikAppFeature.janitor,
    ),
    SubMenuItemData(
      name: 'FORMS_TITLE'.tr(),
      picture: CustomIcons.pencilAndPaper,
      feature: SzikAppFeature.error,
    ),
    SubMenuItemData(
      name: 'POLL_TITLE'.tr(),
      picture: CustomIcons.handpalm,
      feature: SzikAppFeature.poll,
    ),
    SubMenuItemData(
      name: 'BOOKRENTAL_TITLE'.tr(),
      picture: CustomIcons.library,
      feature: SzikAppFeature.bookrental,
    ),
  ];

  List<List<SubMenuItemData>> subMenus = [];

  List<String> subMenuTitles = [
    'SUBMENU_DATA_TITLE'.tr(),
    'SUBMENU_COMMUNITY_TITLE'.tr(),
    'SUBMENU_EVERYDAY_TITLE'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    subMenus = [
      subMenuDataListItems,
      subMenuCommunityListItems,
      subMenuEverydayListItems,
    ];
  }

  List<Widget> _buildGridItems(BuildContext context) {
    var items = <Widget>[];
    var user = Provider.of<AuthManager>(context, listen: false).user;
    for (var item in subMenus[widget.selectedSubMenu]) {
      if (user!.hasPermissionToAccess(
        SzikAppLink(currentFeature: item.feature),
      )) {
        items.add(SubMenuItem(data: item));
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: subMenuTitles[widget.selectedSubMenu],
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
}
