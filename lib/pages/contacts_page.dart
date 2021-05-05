import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../business/contacts.dart';
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
            return Scaffold(
                //Ide
                );
          }
        });
  }
}
