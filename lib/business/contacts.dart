import 'dart:core';

import 'package:url_launcher/url_launcher.dart';

import '../models/user_data.dart';
import '../utils/io.dart';

class Contacts {
  late List<UserData> contacts;
  Contacts() {
    refresh();
  }

  List<UserData> search(String text) {
    if (text == '') {
      return contacts;
    } else {
      var results = <UserData>[];
      contacts.forEach((item) {
        if (item.name.contains(text)) results.add(item);
      });
      return results;
    }
  }

  List<UserData> filter(String groupIDs) {
    if (groupIDs == '') {
      return contacts;
    } else {
      var results = <UserData>[];
      contacts.forEach((item) {
        if (item.name.contains(groupIDs)) results.add(item);
      });
      return results;
    }
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      /*await = aszinkron fgv-ben olyan rész, amit meg kell várni*/
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> makeEmail(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> refresh() async {
    var io = IO();
    contacts = await io.getContacts(null);
  }
}
