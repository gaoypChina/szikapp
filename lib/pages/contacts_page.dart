import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:szikapp/main.dart';

import '../business/contacts.dart';
import '../models/user_data.dart';
import '../ui/screens/error_screen.dart';

class ContactsPage extends StatefulWidget {
  static const String route = '/contacts';

  ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Contacts contacts;

  @override
  void initState() {
    super.initState();
    contacts = Contacts();
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
            //contactsData = contacts.contacts;
            return ContactsListView(contacts.contacts!);
          }
        });
  }
}

class ContactsListView extends StatefulWidget {
  ContactsListView(this.contactsData);

  final List<UserData> contactsData;

  @override
  _ContactsListViewState createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> {
  int expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                expandedIndex = index;
              });
            },
            children: widget.contactsData.map<ExpansionPanel>((item) {
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  var names = item.name.split(' ');
                  var initials = '${names[0][0]}${names[1][0]}';
                  return ListTile(
                    shape: Border.all(style: BorderStyle.none),
                    /*contentPadding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.05,
                      MediaQuery.of(context).size.width * 0.1,
                      MediaQuery.of(context).size.width * 0.05,
                      MediaQuery.of(context).size.width * 0.1,
                    ),
                    */
                    contentPadding: EdgeInsets.all(18),
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 60,
                        minHeight: 60,
                        maxWidth: 60,
                        maxHeight: 60,
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryVariant,
                        child: Text(
                          initials,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                color: Theme.of(context).colorScheme.background,
                                fontStyle: FontStyle.normal,
                              ),
                        ),
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 20,
                          ),
                    ),
                  );
                },
                body: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.phone ?? 'ERROR', //TODO
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant),
                          ),
                          Text(
                            item.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant),
                          ),
                          Text(
                            //TODO
                            '${item.birthday?.year.toString() ?? ""}. ${item.birthday?.month.toString() ?? ""}. ${item.birthday?.day.toString() ?? ""}.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColorFiltered(
                            child: Image.asset(
                              'assets/icons/phone_light_72.png',
                              height: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .fontSize! *
                                  1.5,
                            ),
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primaryVariant,
                                BlendMode.srcIn),
                          ),
                          ColorFiltered(
                            child: Image.asset(
                              'assets/icons/at_light_72.png',
                              height: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .fontSize! *
                                  1.5,
                            ),
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primaryVariant,
                                BlendMode.srcIn),
                          ),
                          ColorFiltered(
                            child: Image.asset(
                              'assets/icons/gift_light_72.png',
                              height: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .fontSize! *
                                  1.5,
                            ),
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primaryVariant,
                                BlendMode.srcIn),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isExpanded: widget.contactsData.indexOf(item) == expandedIndex,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
