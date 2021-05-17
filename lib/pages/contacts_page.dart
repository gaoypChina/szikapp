import 'package:accordion/accordion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
            return ContactsListView(contacts.contacts);
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
  late Contacts contacts;

  @override
  void initState() {
    super.initState();
    contacts = Contacts();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Accordion(
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
        children: widget.contactsData.map<AccordionSection>((item) {
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
                color: theme.colorScheme.primaryVariant.withOpacity(0.15),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.phone ?? 'PHONE_NOT_FOUND'.tr(),
                          style: theme.textTheme.bodyText1?.copyWith(
                              color: theme.colorScheme.primaryVariant),
                        ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            item.email,
                            style: theme.textTheme.bodyText1?.copyWith(
                                color: theme.colorScheme.primaryVariant),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.birthday != null
                            ? DateFormat('yyyy. MM. dd').format(item.birthday!)
                            : 'BIRTHDAY_NOT_FOUND'.tr(),
                        style: theme.textTheme.bodyText1
                            ?.copyWith(color: theme.colorScheme.primaryVariant),
                      ),
                      ColorFiltered(
                        child: Image.asset(
                          'assets/icons/gift_light_72.png',
                          height:
                              Theme.of(context).textTheme.bodyText1!.fontSize! *
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
          );
        }).toList(),
      ),
    );
  }
}
