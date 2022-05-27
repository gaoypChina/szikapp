import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_list/toggle_list.dart';

import '../business/contacts_manager.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/models.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';

///Telefonkönyv képernyő.
///Állapota a privát [_ContactsScreenState].
///Adatszinkronizáció alatt egy `FutureBuilder` segítségével töltőképernyőt
///jelenít meg; majd ennek végeztével buildeli az adatokat ténylegesen
///tartalmazó [ContactsListView] widgetet.
class ContactsScreen extends StatefulWidget {
  ///Navigátor útvonal a képernyőhöz
  static const String route = '/contacts';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: ContactsScreen(),
    );
  }

  const ContactsScreen({Key key = const Key('ContactsScreen')})
      : super(key: key);

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

///A [ContactsScreen] képernyő állapota. Tartalmazza a [Contacts] signleton
///egy példányát.
class ContactsScreenState extends State<ContactsScreen> {
  late ContactsManager manager;

  ///Létrehozza a [Contacts] singleton egy példányát és betölti a
  ///csoportadatokat a csoportok szerint való szűréshez, amennyiben ez
  ///még nem történt meg.
  @override
  void initState() {
    super.initState();
    manager = ContactsManager();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refresh(),
      shimmer: const ListScreenShimmer(),
      child: ContactsListView(manager: manager),
    );
  }
}

///A kontaktlistát és funkcionalitásait megjelenítő widget.
///Állapota a privát [_ContactsListViewState].
class ContactsListView extends StatefulWidget {
  final ContactsManager manager;

  const ContactsListView({Key? key, required this.manager}) : super(key: key);

  @override
  ContactsListViewState createState() => ContactsListViewState();
}

///A [ContactsListView] állapota. Tartalmazza a funkcionalitást támogató
///[Contacts] singletont.
class ContactsListViewState extends State<ContactsListView>
    with SingleTickerProviderStateMixin {
  ///Megjelenített kontaktok
  List<UserData> _items = [];
  List<Group> _groups = [];

  int _selectedTab = 0;

  ///Létrehozásnál lekéri a [Contacts] singletont és megjeleníti az összes
  ///adatbázisban szereplő kontaktot.
  @override
  void initState() {
    _items = widget.manager.contacts;
    _groups = widget.manager.groups;
    super.initState();
  }

  ///A keresőmező tartalmának változásakor végigkeresi a kontaktlistát
  ///és megjeleníti a találatokat.
  void _onSearchFieldChanged(String query) {
    if (_selectedTab == 0) {
      var newItems = widget.manager.search(query);
      setState(() {
        _items = newItems;
      });
    } else {
      var newItems = widget.manager.findGroup(query);
      setState(() {
        _groups = newItems;
      });
    }
  }

  void _onTabChanged(int? newTab) {
    setState(() {
      _selectedTab = newTab ?? 0;
    });
  }

  ///A szűrőmező tartalmának változásakor szűri a kontaktlistát
  ///és megjeleníti a találatokat.
  void _onMembersTapped(Group? group) {
    var newItems = widget.manager.findMembers(group?.id ?? '');
    SZIKAppState.analytics.logSearch(searchTerm: group?.name ?? 'no_search');
    setState(() {
      _items = newItems;
      _selectedTab = 0;
    });
  }

  ///Segédfüggvény, ami a rendszer vágólapjára másolja a megadott üzenetet
  ///és visszajelzést küld a felhasználónak.
  void _copyToClipBoard(String? text, String message) {
    if (text == null) return;
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      SZIKAppState.analytics.logEvent(
        name: 'copy_to_clipboard',
        parameters: <String, dynamic>{'message': message},
      );
      _showSnackBar(message);
    });
  }

  ///Segédfüggvény, ami megjelenít egy [SnackBar]-t.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  ///Segédfüggvény [TextField]-ekhez, ami ellenőrzi, hogy üres-e az elküldött
  ///mező.
  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'CONTACTS_TITLE'.tr(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchBar(
            onChanged: _onSearchFieldChanged,
            validator: _validateTextField,
            placeholder: 'PLACEHOLDER_SEARCH'.tr(),
            filter: TabChoice(
              labels: [
                'CONTACTS_TITLE'.tr(),
                'GROUPS_TITLE'.tr(),
              ],
              onChanged: _onTabChanged,
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text('PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr()),
                  )
                : RefreshIndicator(
                    onRefresh: () => widget.manager.refresh(forceRefresh: true),
                    child: ToggleList(
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kPaddingNormal,
                          horizontal: kPaddingLarge,
                        ),
                        child: CustomIcon(
                          CustomIcons.doubleArrowDown,
                          color: theme.colorScheme.primaryContainer,
                        ),
                      ),
                      children: _selectedTab == 0
                          ? _buildPeopleView()
                          : _buildGroupsView(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<ToggleListItem> _buildPeopleView() {
    var theme = Theme.of(context);
    return _items.map<ToggleListItem>(
      (item) {
        return ToggleListItem(
          leading: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kPaddingNormal,
              horizontal: kPaddingLarge,
            ),
            child: CircleAvatar(
              radius: theme.textTheme.headline3!.fontSize! * 1.5,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                item.initials,
                style: theme.textTheme.headline4!.copyWith(
                  color: theme.colorScheme.background,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
          title: Text(
            item.name,
            textAlign: TextAlign.start,
            style: theme.textTheme.headline3!.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.all(kPaddingLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              color: theme.colorScheme.primaryContainer.withOpacity(0.15),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (item.phone != null) {
                      try {
                        SZIKAppState.analytics.logEvent(
                          name: 'phone_call',
                          parameters: <String, dynamic>{
                            'country': item.phone!.padLeft(5)
                          },
                        );
                        widget.manager.makePhoneCall(item.phone!);
                      } on NotSupportedCallFunctionalityException catch (e) {
                        _showSnackBar(e.message);
                      }
                    }
                  },
                  onLongPress: () =>
                      _copyToClipBoard(item.phone, 'MESSAGE_CLIPBOARD'.tr()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(
                        CustomIcons.phone,
                        size: theme.textTheme.bodyText1!.fontSize! * 1.5,
                        color: theme.colorScheme.primaryContainer,
                      ),
                      Text(
                        item.phone ?? 'PHONE_NOT_FOUND'.tr(),
                        style: theme.textTheme.bodyText1?.copyWith(
                          color: theme.colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    try {
                      SZIKAppState.analytics.logEvent(
                        name: 'make_email',
                        parameters: <String, dynamic>{
                          'domain': item.email.split('@').last
                        },
                      );
                      widget.manager.makeEmail(item.email);
                    } on NotSupportedEmailFunctionalityException catch (e) {
                      _showSnackBar(e.message);
                    }
                  },
                  onLongPress: () =>
                      _copyToClipBoard(item.email, 'MESSAGE_CLIPBOARD'.tr()),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kPaddingNormal),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: kPaddingSmall),
                          child: CustomIcon(
                            CustomIcons.email,
                            size: theme.textTheme.bodyText1!.fontSize! * 1.5,
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            item.email.useCorrectEllipsis(),
                            style: theme.textTheme.bodyText1?.copyWith(
                                color: theme.colorScheme.primaryContainer),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIcon(
                      CustomIcons.gift,
                      size: theme.textTheme.bodyText1!.fontSize! * 1.5,
                      color: theme.colorScheme.primaryContainer,
                    ),
                    Text(
                      item.birthday != null
                          ? DateFormat('yyyy. MM. dd.').format(item.birthday!)
                          : 'BIRTHDAY_NOT_FOUND'.tr(),
                      style: theme.textTheme.bodyText1?.copyWith(
                        color: theme.colorScheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  List<ToggleListItem> _buildGroupsView() {
    var theme = Theme.of(context);
    return _groups.map<ToggleListItem>(
      (item) {
        var members = <UserData>[];
        for (var memberID in item.memberIDs) {
          members.add(_items.where((element) => element.id == memberID).first);
        }
        return ToggleListItem(
          leading: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kPaddingNormal,
              horizontal: kPaddingLarge,
            ),
            child: CircleAvatar(
              radius: theme.textTheme.headline3!.fontSize! * 1.5,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                item.initials,
                style: theme.textTheme.headline4!.copyWith(
                  color: theme.colorScheme.background,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
          title: Text(
            item.name,
            textAlign: TextAlign.start,
            style: theme.textTheme.headline3!.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width - 2 * kPaddingLarge,
            padding: const EdgeInsets.all(kPaddingLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              color: theme.colorScheme.primaryContainer.withOpacity(0.15),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (item.email != null) {
                      try {
                        SZIKAppState.analytics.logEvent(
                          name: 'make_email',
                          parameters: <String, dynamic>{
                            'domain': item.email!.split('@').last
                          },
                        );
                        widget.manager.makeEmail(item.email!);
                      } on NotSupportedEmailFunctionalityException catch (e) {
                        _showSnackBar(e.message);
                      }
                    }
                  },
                  onLongPress: () =>
                      _copyToClipBoard(item.email, 'MESSAGE_CLIPBOARD'.tr()),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kPaddingNormal),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: kPaddingSmall),
                          child: CustomIcon(
                            CustomIcons.email,
                            size: theme.textTheme.bodyText1!.fontSize! * 1.5,
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            item.email?.useCorrectEllipsis() ??
                                'EMAIL_NOT_FOUND'.tr(),
                            style: theme.textTheme.bodyText1?.copyWith(
                                color: theme.colorScheme.primaryContainer),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _onMembersTapped(item),
                  child: Column(
                    children: members.map(
                      (item) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomIcon(
                              CustomIcons.user,
                              size: theme.textTheme.bodyText1!.fontSize! * 1.5,
                              color: theme.colorScheme.primaryContainer,
                            ),
                            Flexible(
                              child: Text(
                                item.name,
                                textAlign: TextAlign.end,
                                style: theme.textTheme.bodyText1?.copyWith(
                                  color: theme.colorScheme.primaryContainer,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }
}
