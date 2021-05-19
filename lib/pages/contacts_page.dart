import 'package:accordion/accordion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../business/contacts.dart';
import '../main.dart';
import '../models/group.dart';
import '../models/user_data.dart';
import '../ui/screens/error_screen.dart';
import '../ui/widgets/searchable_options.dart';

class ContactsPage extends StatefulWidget {
  static const String route = '/contacts';

  ContactsPage({Key key = const Key('ContactsPage')}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Contacts contacts;

  @override
  void initState() {
    super.initState();
    contacts = Contacts();
    if (SZIKAppState.groups.isEmpty) SZIKAppState.loadEarlyData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: contacts.refresh(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Shrimmer
            return Scaffold();
          } else if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
          } else {
            return ContactsListView();
          }
        });
  }
}

class ContactsListView extends StatefulWidget {
  ContactsListView();

  @override
  _ContactsListViewState createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> {
  late Contacts contacts;
  late List<UserData> items;
  double filterExpandableHeight = 0;
  final double kFilterExpandableHeight = 80;

  @override
  void initState() {
    super.initState();
    contacts = Contacts();
    items = contacts.contacts;
  }

  void _onSearchFieldChanged(String query) {
    var newItems = contacts.search(query);
    setState(() {
      items = newItems;
    });
  }

  void _onToggleFilterExpandable() {
    filterExpandableHeight == 0
        ? setState(() {
            filterExpandableHeight = kFilterExpandableHeight;
          })
        : setState(() {
            filterExpandableHeight = 0;
          });
  }

  void _onFilterChanged(Group? group) {
    var newItems = contacts.filter(group!.id);
    setState(() {
      items = newItems;
    });
  }

  void _copyToClipBoard(String? text, String message) {
    if (text == null) return;
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });
  }

  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

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
          Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.background,
                border: Border.all(color: theme.colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(30)),
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: searchBarIconSize,
                  height: searchBarIconSize,
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: ColorFiltered(
                    child: Image.asset('assets/icons/search_light_72.png'),
                    colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary, BlendMode.srcIn),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    //initialValue: '',
                    validator: _validateTextField,
                    autofocus: false,
                    style: theme.textTheme.headline3!.copyWith(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'PLACEHOLDER_SEARCH'.tr(),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                    onChanged: _onSearchFieldChanged,
                  ),
                ),
                GestureDetector(
                  onTap: _onToggleFilterExpandable,
                  child: Container(
                    width: searchBarIconSize,
                    height: searchBarIconSize,
                    margin: EdgeInsets.only(right: 8),
                    child: ColorFiltered(
                      child: Image.asset('assets/icons/sliders_light_72.png'),
                      colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary, BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            margin: EdgeInsets.fromLTRB(20, filterExpandableHeight / 16, 20, 0),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: filterExpandableHeight,
            decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      'CONTACTS_FILTER_GROUP'.tr(),
                      style: theme.textTheme.caption!
                          .copyWith(fontSize: 14, fontStyle: FontStyle.normal),
                    ),
                    margin: EdgeInsets.only(right: 5),
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
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr(),
                    ),
                  )
                : Accordion(
                    headerBorderRadius: 0,
                    headerBackgroundColor: theme.colorScheme.background,
                    contentBackgroundColor: theme.colorScheme.background,
                    headerPadding: EdgeInsets.all(20),
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
                          padding: EdgeInsets.all(20),
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
                                      contacts.makePhoneCall(item.phone!);
                                    } on Exception {
                                      //TODO
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
                                              color: theme
                                                  .colorScheme.primaryVariant),
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
                                    contacts.makeEmail(item.email);
                                  } on Exception {
                                    //TODO
                                  }
                                },
                                onLongPress: () => _copyToClipBoard(
                                    item.email, 'MESSAGE_CLIPBOARD'.tr()),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                                    style: theme.textTheme.bodyText1?.copyWith(
                                        color:
                                            theme.colorScheme.primaryVariant),
                                  ),
                                  ColorFiltered(
                                    child: Image.asset(
                                      'assets/icons/gift_light_72.png',
                                      height:
                                          theme.textTheme.bodyText1!.fontSize! *
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
        ],
      ),
    );
  }
}
