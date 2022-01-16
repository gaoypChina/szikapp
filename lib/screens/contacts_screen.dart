import 'package:accordion/accordion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../business/contacts_manager.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/models.dart';
import '../navigation/app_state_manager.dart';
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
class _ContactsListViewState extends State<ContactsListView> {
  ///Megjelenített kontaktok
  List<UserData> items = [];

  ///Szűrőmező aktuális magassága
  double filterExpandableHeight = 0;

  ///Szűrőmező maximális magassága
  final double kFilterExpandableHeight = 80;

  ///Létrehozásnál lekéri a [Contacts] singletont és megjeleníti az összes
  ///adatbázisban szereplő kontaktot.
  @override
  void initState() {
    items = widget.manager.contacts;
    super.initState();
  }

  ///A keresőmező tartalmának változásakor végigkeresi a kontaktlistát
  ///és megjeleníti a találatokat.
  void _onSearchFieldChanged(String query) {
    var newItems = widget.manager.search(query);
    setState(() {
      items = newItems;
    });
  }

  ///A szűrés gomb megnyomásakor megjeleníti / eltünteti a szűrőmezőt a
  ///mező magasságának változtatásával.
  void _onToggleFilterExpandable() {
    filterExpandableHeight == 0
        ? setState(() {
            filterExpandableHeight = kFilterExpandableHeight;
          })
        : setState(() {
            filterExpandableHeight = 0;
          });
  }

  ///A szűrőmező tartalmának változásakor szűri a kontaktlistát
  ///és megjeleníti a találatokat.
  void _onFilterChanged(Group? group) {
    var newItems = widget.manager.filter(group?.id ?? '');
    SZIKAppState.analytics.logSearch(searchTerm: group?.name ?? 'no_search');
    setState(() {
      items = newItems;
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
    return SzikAppScaffold(
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: EdgeInsets.fromLTRB(20, filterExpandableHeight / 16, 20, 0),
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: filterExpandableHeight,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      'CONTACTS_FILTER_GROUP'.tr(),
                      style: theme.textTheme.caption!
                          .copyWith(fontSize: 14, fontStyle: FontStyle.normal),
                    ),
                    margin: const EdgeInsets.only(right: 5),
                  ),
                  filterExpandableHeight == 0
                      ? Container()
                      : Expanded(
                          child: SearchableOptions<Group>(
                            items: Provider.of<SzikAppStateManager>(
                              context,
                              listen: false,
                            ).groups,
                            onItemChanged: _onFilterChanged,
                            selectedItem: null,
                            compare: (i, s) => i.isEqual(s),
                            showClearButton: true,
                            nullValidated: false,
                          ),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty
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
                      children: items.map<AccordionSection>(
                        (item) {
                          var names = item.name.split(' ');
                          var initials = '${names[0][0]}${names[1][0]}';
                          return AccordionSection(
                            headerText: item.name,
                            leftIcon: CircleAvatar(
                              radius:
                                  theme.textTheme.headline3!.fontSize! * 1.5,
                              backgroundColor: theme.colorScheme.primaryVariant,
                              child: Text(
                                initials,
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
