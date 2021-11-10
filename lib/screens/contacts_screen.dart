import 'package:accordion/accordion.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../business/contacts_manager.dart';
import '../components/search_bar.dart';
import '../components/searchable_options.dart';
import '../main.dart';
import '../models/group.dart';
import '../models/user_data.dart';
import '../utils/exceptions.dart';
import 'error_screen.dart';

///Telefonkönyv képernyő.
///Állapota a privát [_ContactsScreenState].
///Adatszinkronizáció alatt egy `FutureBuilder` segítségével töltőképernyőt
///jelenít meg; majd ennek végeztével buildeli az adatokat ténylegesen
///tartalmazó [ContactsListView] widgetet.
class ContactsScreen extends StatefulWidget {
  ///Navigátor útvonal a képernyőhöz
  static const String route = '/contacts';

  const ContactsScreen({Key key = const Key('ContactsScreen')})
      : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

///A [ContactsScreen] képernyő állapota. Tartalmazza a [Contacts] signleton
///egy példányát.
class _ContactsScreenState extends State<ContactsScreen> {
  late ContactsManager contacts;

  ///Létrehozza a [Contacts] singleton egy példányát és betölti a
  ///csoportadatokat a csoportok szerint való szűréshez, amennyiben ez
  ///még nem történt meg.
  @override
  void initState() {
    super.initState();
    contacts = ContactsManager();
    if (SZIKAppState.groups.isEmpty) SZIKAppState.loadEarlyData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: contacts.refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ContactsListViewShimmer();
        } else if (snapshot.hasError) {
          Object? message;
          if (SZIKAppState.connectionStatus == ConnectivityResult.none) {
            message = 'ERROR_NO_INTERNET'.tr();
          } else {
            message = snapshot.error;
          }
          return ErrorScreen(error: message ?? 'ERROR_UNKNOWN'.tr());
        } else {
          return const ContactsListView();
        }
      },
    );
  }
}

///A kontaktlistát és funkcionalitásait megjelenítő widget.
///Állapota a privát [_ContactsListViewState].
class ContactsListView extends StatefulWidget {
  const ContactsListView({Key? key}) : super(key: key);

  @override
  _ContactsListViewState createState() => _ContactsListViewState();
}

///A [ContactsListView] állapota. Tartalmazza a funkcionalitást támogató
///[Contacts] singletont.
class _ContactsListViewState extends State<ContactsListView> {
  late ContactsManager contacts;

  ///Megjelenített kontaktok
  late List<UserData> items;

  ///Szűrőmező aktuális magassága
  double filterExpandableHeight = 0;

  ///Szűrőmező maximális magassága
  final double kFilterExpandableHeight = 80;

  ///Létrehozásnál lekéri a [Contacts] singletont és megjeleníti az összes
  ///adatbázisban szereplő kontaktot.
  @override
  void initState() {
    super.initState();
    contacts = ContactsManager();
    items = contacts.contacts;
  }

  ///A keresőmező tartalmának változásakor végigkeresi a kontaktlistát
  ///és megjeleníti a találatokat.
  void _onSearchFieldChanged(String query) {
    var newItems = contacts.search(query);
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
    var newItems = contacts.filter(group!.id);
    SZIKAppState.analytics.logSearch(searchTerm: group.name);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            duration: const Duration(seconds: 1),
            margin: EdgeInsets.fromLTRB(20, filterExpandableHeight / 16, 20, 0),
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: filterExpandableHeight,
            decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(20)),
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
                            items: SZIKAppState.groups,
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
          const SizedBox(height: 20),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr(),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => contacts.refresh(forceRefresh: true),
                    child: Accordion(
                      headerBorderRadius: 0,
                      headerBackgroundColor: theme.colorScheme.background,
                      contentBackgroundColor: theme.colorScheme.background,
                      headerPadding: const EdgeInsets.all(20),
                      //contentHorizontalPadding: 20,
                      //contentBorderRadius: 10,
                      headerTextStyle: theme.textTheme.headline3!.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                      rightIcon: ColorFiltered(
                        child: Image.asset('assets/icons/down_light_72.png',
                            height: theme.textTheme.headline3!.fontSize),
                        colorFilter: ColorFilter.mode(
                            theme.colorScheme.primaryVariant, BlendMode.srcIn),
                      ),
                      children: items.map<AccordionSection>((item) {
                        var names = item.name.split(' ');
                        var initials = '${names[0][0]}${names[1][0]}';
                        return AccordionSection(
                          headerText: item.name,
                          leftIcon: CircleAvatar(
                            radius: theme.textTheme.headline3!.fontSize! * 1.5,
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
                              borderRadius: BorderRadius.circular(20),
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
                                        contacts.makePhoneCall(item.phone!);
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
                                      Text(
                                        item.phone ?? 'PHONE_NOT_FOUND'.tr(),
                                        style: theme.textTheme.bodyText1
                                            ?.copyWith(
                                                color: theme.colorScheme
                                                    .primaryVariant),
                                      ),
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
                                      contacts.makeEmail(item.email);
                                    } on NotSupportedEmailFunctionalityException catch (e) {
                                      _showSnackBar(e.message);
                                    }
                                  },
                                  onLongPress: () => _copyToClipBoard(
                                      item.email, 'MESSAGE_CLIPBOARD'.tr()),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          item.email,
                                          style: theme.textTheme.bodyText1
                                              ?.copyWith(
                                                  color: theme.colorScheme
                                                      .primaryVariant),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      ColorFiltered(
                                        child: Image.asset(
                                          'assets/icons/at_light_72.png',
                                          height: theme.textTheme.bodyText1!
                                                  .fontSize! *
                                              1.5,
                                        ),
                                        colorFilter: ColorFilter.mode(
                                            theme.colorScheme.primaryVariant,
                                            BlendMode.srcIn),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.birthday != null
                                          ? DateFormat('yyyy. MM. dd.')
                                              .format(item.birthday!)
                                          : 'BIRTHDAY_NOT_FOUND'.tr(),
                                      style: theme.textTheme.bodyText1
                                          ?.copyWith(
                                              color: theme
                                                  .colorScheme.primaryVariant),
                                    ),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ContactsListViewShimmer extends StatelessWidget {
  const ContactsListViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var searchBarIconSize = 30.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Shimmer.fromColors(
            baseColor: theme.colorScheme.secondaryVariant.withOpacity(0.2),
            highlightColor: theme.colorScheme.secondaryVariant.withOpacity(0.5),
            child: Container(
              decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(30)),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: searchBarIconSize,
                    height: searchBarIconSize,
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                10,
                (index) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor:
                            theme.colorScheme.secondaryVariant.withOpacity(0.2),
                        highlightColor:
                            theme.colorScheme.secondaryVariant.withOpacity(0.5),
                        child: CircleAvatar(
                          radius: theme.textTheme.headline3!.fontSize! * 1.5,
                          backgroundColor: theme.colorScheme.primaryVariant,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor:
                            theme.colorScheme.secondaryVariant.withOpacity(0.2),
                        highlightColor:
                            theme.colorScheme.secondaryVariant.withOpacity(0.5),
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          height: theme.textTheme.headline3!.fontSize! * 1.5,
                          width: theme.textTheme.headline3!.fontSize! * 10,
                          decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
