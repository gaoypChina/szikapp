import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_list/toggle_list.dart';

import '../business/business.dart';
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

  const ContactsScreen({super.key = const Key('ContactsScreen')});

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

  const ContactsListView({super.key, required this.manager});

  @override
  ContactsListViewState createState() => ContactsListViewState();
}

///A [ContactsListView] állapota. Tartalmazza a funkcionalitást támogató
///[Contacts] singletont.
class ContactsListViewState extends State<ContactsListView>
    with SingleTickerProviderStateMixin {
  ///Megjelenített kontaktok
  List<User> _users = [];

  ///Megjelenített csoportok
  List<Group> _groups = [];

  ///A kiválasztott tab
  int _selectedTab = 0;

  ///A szűrt csoportok
  List<String> _groupFilter = [];

  ///Létrehozásnál lekéri a [Contacts] singletont és megjeleníti az összes
  ///adatbázisban szereplő kontaktot.
  @override
  void initState() {
    _users = widget.manager.contacts;
    _groups = widget.manager.groups;
    super.initState();
  }

  ///A keresőmező tartalmának változásakor végigkeresi a kontaktlistát
  ///és megjeleníti a találatokat.
  void _onSearchFieldChanged(String query) {
    if (_selectedTab == 0) {
      var newItems = widget.manager.search(text: query);
      setState(() {
        _users = newItems;
        _groupFilter = [];
      });
    } else {
      var newItems = widget.manager.findGroup(text: query);
      setState(() {
        _groups = newItems;
        _groupFilter = [];
      });
    }
  }

  void _onTabChanged(int? newTab) {
    _groupFilter = [];
    _users = widget.manager.contacts;
    setState(() {
      _selectedTab = newTab ?? 0;
    });
  }

  void _onMembersFilterChanged(bool? newValue, String group) {
    if (newValue != null && newValue) {
      _groupFilter.add(group);
    } else {
      _groupFilter.remove(group);
    }
    var newItems = widget.manager.findMembers(groupIDs: _groupFilter);
    setState(() {
      _users = newItems;
      _selectedTab = 0;
    });
  }

  void _onMembersFilterCleared() {
    setState(() {
      _groupFilter = [];
      _users = widget.manager.contacts;
    });
  }

  ///A szűrőmező tartalmának változásakor szűri a kontaktlistát
  ///és megjeleníti a találatokat.
  void _onMembersTapped(Group? group) {
    var newItems = widget.manager.findMembers(groupIDs: [group?.id]);
    SzikAppState.analytics.logSearch(searchTerm: group?.name ?? 'no_search');
    setState(() {
      _users = newItems;
      _selectedTab = 0;
    });
  }

  ///Segédfüggvény, ami a rendszer vágólapjára másolja a megadott üzenetet
  ///és visszajelzést küld a felhasználónak.
  void _copyToClipBoard(String? text, String message) {
    if (text == null) return;
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      SzikAppState.analytics.logEvent(name: 'copy_to_clipboard');
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
          CustomSearchBar(
            onChanged: _onSearchFieldChanged,
            validator: _validateTextField,
            placeholder: 'PLACEHOLDER_SEARCH'.tr(),
            filter: _buildFilter(),
          ),
          Expanded(
            child: _users.isEmpty
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

  Widget _buildFilter() {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      child: Column(
        children: [
          TabChoice(
            labels: [
              'CONTACTS_TITLE'.tr(),
              'GROUPS_TITLE'.tr(),
            ],
            onChanged: _onTabChanged,
          ),
          if (_selectedTab == 0)
            Row(
              children: [
                Checkbox(
                  activeColor: theme.colorScheme.primary,
                  value: _groupFilter
                      .contains(ContactsManager.collegeMembersGroupID),
                  onChanged: (value) => _onMembersFilterChanged(
                    value,
                    ContactsManager.collegeMembersGroupID,
                  ),
                ),
                Text(
                  'CONTACTS_GROUP_MEMBERS'.tr(),
                  style: theme.textTheme.displaySmall!.copyWith(
                    fontSize: 14,
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          if (_selectedTab == 0)
            Row(
              children: [
                Checkbox(
                  activeColor: theme.colorScheme.primary,
                  value: _groupFilter.contains(ContactsManager.tenantsGroupID),
                  onChanged: (value) => _onMembersFilterChanged(
                    value,
                    ContactsManager.tenantsGroupID,
                  ),
                ),
                Text(
                  'CONTACTS_GROUP_TENANTS'.tr(),
                  style: theme.textTheme.displaySmall!.copyWith(
                    fontSize: 14,
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          if (_selectedTab == 0)
            Row(
              children: [
                Checkbox(
                  activeColor: theme.colorScheme.primary,
                  value: _groupFilter.isEmpty,
                  onChanged: (value) => _onMembersFilterCleared(),
                ),
                Text(
                  'CONTACTS_GROUP_ALL'.tr(),
                  style: theme.textTheme.displaySmall!.copyWith(
                    fontSize: 14,
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<ToggleListItem> _buildPeopleView() {
    var theme = Theme.of(context);
    return _users.map<ToggleListItem>(
      (user) {
        return ToggleListItem(
          leading: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kPaddingNormal,
              horizontal: kPaddingLarge,
            ),
            child: CircleAvatar(
              foregroundImage: user.profilePicture != null
                  ? NetworkImage(user.profilePicture!)
                  : null,
              radius: theme.textTheme.displaySmall!.fontSize! * 1.5,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user.initials,
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: theme.colorScheme.background,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
          title: Text(
            user.name,
            textAlign: TextAlign.start,
            style: theme.textTheme.displaySmall!.copyWith(
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
                    if (user.phone != null) {
                      try {
                        SzikAppState.analytics.logEvent(name: 'phone_call');
                        widget.manager.makePhoneCall(phoneNumber: user.phone!);
                      } on NotSupportedCallFunctionalityException catch (exception) {
                        _showSnackBar(exception.message);
                      }
                    }
                  },
                  onLongPress: () =>
                      _copyToClipBoard(user.phone, 'MESSAGE_CLIPBOARD'.tr()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(
                        CustomIcons.phone,
                        size: theme.textTheme.bodyLarge!.fontSize! * 1.5,
                        color: theme.colorScheme.primaryContainer,
                      ),
                      Text(
                        user.phone ?? 'PHONE_NOT_FOUND'.tr(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    try {
                      SzikAppState.analytics.logEvent(name: 'make_email');
                      widget.manager.makeEmail(address: user.email);
                    } on NotSupportedEmailFunctionalityException catch (exception) {
                      _showSnackBar(exception.message);
                    }
                  },
                  onLongPress: () =>
                      _copyToClipBoard(user.email, 'MESSAGE_CLIPBOARD'.tr()),
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
                            size: theme.textTheme.bodyLarge!.fontSize! * 1.5,
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            user.email.useCorrectEllipsis(),
                            style: theme.textTheme.bodyLarge?.copyWith(
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
                      size: theme.textTheme.bodyLarge!.fontSize! * 1.5,
                      color: theme.colorScheme.primaryContainer,
                    ),
                    Text(
                      user.birthday != null
                          ? DateFormat('MMMM dd.', context.locale.toString())
                              .format(user.birthday!)
                          : 'BIRTHDAY_NOT_FOUND'.tr(),
                      style: theme.textTheme.bodyLarge?.copyWith(
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
      (group) {
        var members = <User>[];
        for (var memberID in group.memberIDs) {
          members.add(_users.where((user) => user.id == memberID).first);
        }
        return ToggleListItem(
          leading: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kPaddingNormal,
              horizontal: kPaddingLarge,
            ),
            child: CircleAvatar(
              radius: theme.textTheme.displaySmall!.fontSize! * 1.5,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                group.initials,
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: theme.colorScheme.background,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
          title: Text(
            group.name,
            textAlign: TextAlign.start,
            style: theme.textTheme.displaySmall!.copyWith(
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
                    if (group.email != null) {
                      try {
                        SzikAppState.analytics.logEvent(name: 'make_email');
                        widget.manager.makeEmail(address: group.email!);
                      } on NotSupportedEmailFunctionalityException catch (exception) {
                        _showSnackBar(exception.message);
                      }
                    }
                  },
                  onLongPress: () =>
                      _copyToClipBoard(group.email, 'MESSAGE_CLIPBOARD'.tr()),
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
                            size: theme.textTheme.bodyLarge!.fontSize! * 1.5,
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            group.email?.useCorrectEllipsis() ??
                                'EMAIL_NOT_FOUND'.tr(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primaryContainer),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _onMembersTapped(group),
                  child: Column(
                    children: members.map(
                      (member) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomIcon(
                              CustomIcons.user,
                              size: theme.textTheme.bodyLarge!.fontSize! * 1.5,
                              color: theme.colorScheme.primaryContainer,
                            ),
                            Flexible(
                              child: Text(
                                member.name,
                                textAlign: TextAlign.end,
                                style: theme.textTheme.bodyLarge?.copyWith(
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
