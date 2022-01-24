import 'package:accordion/accordion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  _ContactsScreenState createState() => _ContactsScreenState();
}

///A [ContactsScreen] képernyő állapota. Tartalmazza a [Contacts] signleton
///egy példányát.
class _ContactsScreenState extends State<ContactsScreen> {
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
  _ContactsListViewState createState() => _ContactsListViewState();
}

///A [ContactsListView] állapota. Tartalmazza a funkcionalitást támogató
///[Contacts] singletont.
class _ContactsListViewState extends State<ContactsListView>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  late AnimationController _filterToggleController;
  late Animation<double> _heightFactor;

  ///Megjelenített kontaktok
  List<UserData> _items = [];
  List<Group> _groups = [];

  bool _filterIsExpanded = false;
  int _selectedTab = 0;

  ///Létrehozásnál lekéri a [Contacts] singletont és megjeleníti az összes
  ///adatbázisban szereplő kontaktot.
  @override
  void initState() {
    _items = widget.manager.contacts;
    _groups = widget.manager.groups;
    _filterToggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _heightFactor = _filterToggleController.drive(_easeInTween);
    if (_filterIsExpanded) _filterToggleController.value = 1.0;
    super.initState();
  }

  @override
  void dispose() {
    _filterToggleController.dispose();
    super.dispose();
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

  ///A szűrés gomb megnyomásakor megjeleníti / eltünteti a szűrőmezőt a
  ///mező magasságának változtatásával.
  void _onToggleFilterExpandable() {
    setState(() {
      _filterIsExpanded = !_filterIsExpanded;
      if (_filterIsExpanded) {
        _filterToggleController.forward();
      } else {
        _filterToggleController.reverse();
      }
    });
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
            onToggleFilterExpandable: _onToggleFilterExpandable,
            placeholder: 'PLACEHOLDER_SEARCH'.tr(),
          ),
          SizeTransition(
            sizeFactor: _heightFactor,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                  kPaddingLarge, kPaddingSmall, kPaddingLarge, 0),
              child: TabChoice(
                labels: [
                  'CONTACTS_TITLE'.tr(),
                  'GROUPS_TITLE'.tr(),
                ],
                onChanged: _onTabChanged,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text('PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr()),
                  )
                : RefreshIndicator(
                    onRefresh: () => widget.manager.refresh(forceRefresh: true),
                    child: Accordion(
                      headerBorderRadius: 0,
                      headerBackgroundColor: theme.colorScheme.background,
                      contentBackgroundColor: theme.colorScheme.background,
                      headerPadding: const EdgeInsets.all(20),
                      headerTextStyle: theme.textTheme.headline3!.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                      rightIcon: ColorFiltered(
                        child: Image.asset('assets/icons/down_light_72.png',
                            height: theme.textTheme.headline3!.fontSize),
                        colorFilter: ColorFilter.mode(
                            theme.colorScheme.primaryVariant, BlendMode.srcIn),
                      ),
                      children: _items.map<AccordionSection>(
                        (item) {
                          return AccordionSection(
                            headerText: item.name,
                            leftIcon: CircleAvatar(
                              radius:
                                  theme.textTheme.headline3!.fontSize! * 1.5,
                              backgroundColor: theme.colorScheme.primaryVariant,
                              child: Text(
                                item.initials,
                                style: theme.textTheme.headline4!.copyWith(
                                  color: theme.colorScheme.background,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            content: Container(
                              width: MediaQuery.of(context).size.width - 40,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadiusNormal),
                                color: theme.colorScheme.primaryVariant
                                    .withOpacity(0.15),
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
                                          widget.manager
                                              .makePhoneCall(item.phone!);
                                        } on NotSupportedCallFunctionalityException catch (e) {
                                          _showSnackBar(e.message);
                                        }
                                      }
                                    },
                                    onLongPress: () => _copyToClipBoard(
                                        item.phone, 'MESSAGE_CLIPBOARD'.tr()),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ColorFiltered(
                                          child: Image.asset(
                                            'assets/icons/phone_light_72.png',
                                            height: theme.textTheme.bodyText1!
                                                    .fontSize! *
                                                1.5,
                                          ),
                                          colorFilter: ColorFilter.mode(
                                              theme.colorScheme.primaryVariant,
                                              BlendMode.srcIn),
                                        ),
                                        Text(
                                          item.phone ?? 'PHONE_NOT_FOUND'.tr(),
                                          style: theme.textTheme.bodyText1
                                              ?.copyWith(
                                            color: theme
                                                .colorScheme.primaryVariant,
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
                                    onLongPress: () => _copyToClipBoard(
                                        item.email, 'MESSAGE_CLIPBOARD'.tr()),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: ColorFiltered(
                                              child: Image.asset(
                                                'assets/icons/at_light_72.png',
                                                height: theme.textTheme
                                                        .bodyText1!.fontSize! *
                                                    1.5,
                                              ),
                                              colorFilter: ColorFilter.mode(
                                                  theme.colorScheme
                                                      .primaryVariant,
                                                  BlendMode.srcIn),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              item.email.useCorrectEllipsis(),
                                              style: theme.textTheme.bodyText1
                                                  ?.copyWith(
                                                      color: theme.colorScheme
                                                          .primaryVariant),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ColorFiltered(
                                        child: Image.asset(
                                          'assets/icons/gift_light_72.png',
                                          height: theme.textTheme.bodyText1!
                                                  .fontSize! *
                                              1.5,
                                        ),
                                        colorFilter: ColorFilter.mode(
                                            theme.colorScheme.primaryVariant,
                                            BlendMode.srcIn),
                                      ),
                                      Text(
                                        item.birthday != null
                                            ? DateFormat('yyyy. MM. dd.')
                                                .format(item.birthday!)
                                            : 'BIRTHDAY_NOT_FOUND'.tr(),
                                        style:
                                            theme.textTheme.bodyText1?.copyWith(
                                          color:
                                              theme.colorScheme.primaryVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
